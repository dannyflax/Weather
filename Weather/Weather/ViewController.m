//
//  ViewController.m
//  Weather
//
//  Created by Danny Flax on 8/24/23.
//

#import "ViewController.h"

#import <Foundation/Foundation.h>

#import "CompositeWeatherDataFetcher.h"
#import "CompositeWeatherData.h"
#import "WeatherUIState.h"
#import "LocationManager.h"

NSString *const LAST_SEARCH_KEY = @"last_search_key";

@interface ViewController ()

@end

@implementation ViewController
{
  UIView *_subView;
  UIView *_searchBarView;
  UITextField *_searchTextField;
  UIButton *_searchButton;
  WeatherUIState *_uiState;
  UIView *_weatherDisplayView;
  UILabel *_locationTitle;
  UIImageView *_icon;
  UILabel *_description;
  UILabel *_locationDetails;
  UILabel *_errorLabel;
  
  LocationManager *_locationManager;
}

static CGRect GetFrameCentered(CGRect frame, int width, int height)
{
  return CGRectMake((frame.size.width / 2) - (width / 2), (frame.size.height / 2) - (height / 2), width, height);
}

#pragma mark - Last Search

// Keep last search very simple.
// Just user NSUserDefaults and overwrite each time there's a new search.

- (void)_storeLastSearch:(NSString *)lastSearch
{
  if (lastSearch != nil) {
    [[NSUserDefaults standardUserDefaults] setObject:lastSearch forKey:LAST_SEARCH_KEY];
  }
}

- (NSString *)_retrieveLastSearch
{
  return [[NSUserDefaults standardUserDefaults] objectForKey:LAST_SEARCH_KEY];
}

#pragma mark - View

- (void)viewDidLoad {
  [super viewDidLoad];
  [self _setUIState:^WeatherUIState *(WeatherUIState *currentState) {
    return [WeatherUIState newWithLoading:currentState.searchText];
  }];
  _locationManager = [LocationManager new];
  __weak __typeof(self) weakSelf = self;
  [_locationManager getLocation:^(double lat, double lon) {
    [CompositeWeatherDataFetcher fetchWeatherWithLat:lat lon:lon completionBlock:^(CompositeWeatherData * _Nonnull weatherData) {
      [weakSelf _handleLocationBasedWeatherLoaded:weatherData];
    }];
  } errorBlock:^{
    [weakSelf _handleLocationRequestFailed];
  }];
}

- (void)_handleLocationBasedWeatherLoaded:(CompositeWeatherData *)weatherData
{
  if (weatherData) {
    [self _setUIState:^WeatherUIState *(WeatherUIState *currentState) {
      return [WeatherUIState newWithHasWeather:weatherData searchText:weatherData.locationName];
    }];
    [self _storeLastSearch:weatherData.locationName];
  } else {
    [self _setUIState:^WeatherUIState *(WeatherUIState *currentState) {
      return [WeatherUIState newWithEmpty:currentState.searchText];
    }];
    [self _handleLocationRequestFailed];
  }
}

- (void)_handleLocationRequestFailed
{
  // As a backup, retrieve last search.
  NSString *key = [self _retrieveLastSearch];
  [self _setUIState:^WeatherUIState *(WeatherUIState *currentState) {
    return [WeatherUIState newWithEmpty:key];
  }];
  [self _performSearch:key];
}

- (void)loadView
{
  UIView *mainView = [UIView new];
  [mainView setBackgroundColor:[UIColor blackColor]];
  
  _subView = [UIView new];
  [_subView setBackgroundColor:[UIColor whiteColor]];
  [mainView addSubview:_subView];
  
  _searchBarView = [UIView new];
  [_subView addSubview:_searchBarView];
  
  _searchTextField = [UITextField new];
  _searchTextField.borderStyle = UITextBorderStyleRoundedRect;
  _searchTextField.placeholder = @"Enter a City Name";
  [_searchBarView addSubview:_searchTextField];
  
  _searchButton = [UIButton new];
  [_searchBarView addSubview:_searchButton];
  [_searchButton addTarget:self action:@selector(_didTapSearchButton:) forControlEvents:UIControlEventTouchUpInside];
  
  _weatherDisplayView = [UIView new];
  [_subView addSubview:_weatherDisplayView];
  
  _locationTitle = [UILabel new];
  [_locationTitle setTextAlignment:NSTextAlignmentCenter];
  _icon = [UIImageView new];
  _description = [UILabel new];
  [_description setTextAlignment:NSTextAlignmentCenter];
  _locationDetails = [UILabel new];
  [_locationDetails setTextAlignment:NSTextAlignmentCenter];
  
  [_weatherDisplayView addSubview:_icon];
  [_weatherDisplayView addSubview:_description];
  [_weatherDisplayView addSubview:_locationTitle];
  [_weatherDisplayView addSubview:_locationDetails];
  
  _errorLabel = [UILabel new];
  [_errorLabel setText:@"The was an issue loading weather for this city."];
  [_subView addSubview:_errorLabel];
  
  self.view = mainView;
}

- (void)_setUIState:(WeatherUIState *(^)(WeatherUIState *currentState))uiStateBlock {
  // UIState is read on the main queue (UI Updates).
  // Make sure to write to it on the same queue.
  // (avoid potential retain cycle by not capturing self, even though technically this block isn't captured)
  __weak __typeof(self) weakSelf = self;
  dispatch_async(dispatch_get_main_queue(), ^{
    __strong __typeof(weakSelf) strongSelf = weakSelf;
    if (strongSelf) {
      strongSelf->_uiState = uiStateBlock(strongSelf->_uiState);
      [strongSelf.view setNeedsLayout];
    }
  });
}

- (void)_performSearch:(NSString *)searchKey
{
  [self _setUIState:^WeatherUIState *(WeatherUIState *currentState) {
    return [WeatherUIState newWithLoading:searchKey];
  }];
  [CompositeWeatherDataFetcher fetchWeatherWithKey:searchKey completionBlock:^(CompositeWeatherData * _Nonnull weatherData) {
    if (!weatherData) {
      [self _setUIState:^WeatherUIState *(WeatherUIState *currentState) {
        return [WeatherUIState newWithError:currentState.searchText];
      }];
      return;
    }
    [self _setUIState:^WeatherUIState *(WeatherUIState *currentState) {
      return [WeatherUIState newWithHasWeather:weatherData searchText:currentState.searchText];
    }];
  }];
}

- (void)_didTapSearchButton:(UIButton *)button
{
  NSString *key = _searchTextField.text;
  if (!key || key.length <= 0) {
    return;
  }
  [self _storeLastSearch:key];
  [self _performSearch:key];
}

- (void)viewDidLayoutSubviews
{
  _subView.frame = self.view.safeAreaLayoutGuide.layoutFrame;
  
  // Use static widths and heights / paddings.
  // If the view hierarchy were more complex and/or we wanted to support multiple device sizes, consider making this propery dynamic according to the view.
  // This implementation will at least be sensitive to the safe area + device orientation.
  CGRect centeredFrame = GetFrameCentered(_subView.frame, _subView.frame.size.width, 120);
  _searchBarView.frame = CGRectMake(centeredFrame.origin.x, 0, centeredFrame.size.width, centeredFrame.size.height);
  
  CGRect centeredSearch = GetFrameCentered(_searchBarView.frame, _searchTextField.frame.size.width, _searchTextField.frame.size.height);
  _searchTextField.frame = CGRectMake(5, centeredSearch.origin.y, 200, 50);
  
  [_searchButton setConfiguration:[UIButtonConfiguration grayButtonConfiguration]];
  [_searchButton setTitle:@"Search" forState:UIControlStateNormal];
  [_searchButton sizeToFit];
  CGRect centeredButton = GetFrameCentered(_searchBarView.frame, _searchButton.frame.size.width + 10, _searchButton.frame.size.height);
  _searchButton.frame = CGRectMake(_searchTextField.frame.size.width + _searchTextField.frame.origin.x + 10, centeredButton.origin.y, centeredButton.size.width, centeredButton.size.height);
  
  _weatherDisplayView.frame = CGRectMake(0, _searchBarView.frame.origin.y + _searchBarView.frame.size.height + 10, _subView.frame.size.width, 500);
  
  __block NSString *blockText = @"";
  [_uiState empty:^(NSString *searchText){
    [self layoutForEmpty];
    blockText = searchText;
  } hasWeather:^(CompositeWeatherData * _Nonnull weatherData, NSString *searchText) {
    [self layoutForWeatherData:weatherData];
    blockText = searchText;
  } loading:^(NSString *searchText){
    [self layoutForLoading];
    blockText = searchText;
  } error:^(NSString *searchText){
    [self layoutForError];
    blockText = searchText;
  }];
  [_searchTextField setText:blockText];
}

- (void)layoutForEmpty
{
  [_searchButton setEnabled:YES];
  [_weatherDisplayView setHidden:YES];
  [_errorLabel setHidden:YES];
}

- (void)layoutForLoading
{
  [_searchButton setEnabled:NO];
  [_weatherDisplayView setHidden:YES];
  [_errorLabel setHidden:YES];
}

- (void)layoutForWeatherData:(CompositeWeatherData *)weatherData
{
  [_searchButton setEnabled:YES];
  [_weatherDisplayView setHidden:NO];
  [_errorLabel setHidden:YES];
  
  [_locationTitle setText:weatherData.locationName];
  [_icon setImage:weatherData.icon];
  [_description setText:weatherData.weatherDescription];
  NSString *const locationDetails = weatherData.state ? [NSString stringWithFormat:@"%@, %@", weatherData.state, weatherData.country] : [NSString stringWithFormat:@"%@, %@", weatherData.locationName, weatherData.country];
  [_locationDetails setText:locationDetails];
  
  [_locationTitle sizeToFit];
  [_description sizeToFit];
  [_locationDetails sizeToFit];
  
  // Hack - For some reason sizeToFit is giving too small of a width. Multiply it x2.
  CGRect centeredLocation = GetFrameCentered(_weatherDisplayView.frame, _locationTitle.frame.size.width * 2, _locationTitle.frame.size.height);
  
  CGRect centeredIcon = GetFrameCentered(_weatherDisplayView.frame, 100, 100);
  
  CGRect centeredDescription = GetFrameCentered(_weatherDisplayView.frame, _description.frame.size.width * 2, _description.frame.size.height);
  
  CGRect centeredLocationDetails = GetFrameCentered(_weatherDisplayView.frame, _locationDetails.frame.size.width * 2, _locationDetails.frame.size.height);
  
  int currentY = 5;
  
  _locationTitle.frame = CGRectMake(centeredLocation.origin.x, currentY, centeredLocation.size.width, centeredLocation.size.height);
  currentY += _locationTitle.frame.size.height;
  
  _icon.frame = CGRectMake(centeredIcon.origin.x, currentY, centeredIcon.size.width, centeredIcon.size.height);
  currentY += _icon.frame.size.height;
  
  _description.frame = CGRectMake(centeredDescription.origin.x, currentY, centeredDescription.size.width, centeredDescription.size.height);
  currentY += _description.frame.size.height;
  
  _locationDetails.frame = CGRectMake(centeredLocationDetails.origin.x, currentY, centeredLocationDetails.size.width, centeredLocationDetails.size.height);
}

- (void)layoutForError
{
  [_searchButton setEnabled:YES];
  [_weatherDisplayView setHidden:YES];
  [_errorLabel setHidden:NO];
  
  [_errorLabel sizeToFit];
  CGRect centeredError = GetFrameCentered(_subView.frame, _errorLabel.frame.size.width, _errorLabel.frame.size.height);
  _errorLabel.frame = CGRectMake(centeredError.origin.x, _searchBarView.frame.origin.y + _searchBarView.frame.size.height + 10, centeredError.size.width, centeredError.size.height);
}

@end
