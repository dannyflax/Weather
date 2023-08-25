//
//  ViewController.m
//  Weather
//
//  Created by Danny Flax on 8/24/23.
//

#import "ViewController.h"

#import <Foundation/Foundation.h>

#import "WeatherDataFetcher.h"
#import "GeoDataFetcher.h"

@interface ViewController ()

@end

@implementation ViewController
{
  UIView *_subView;
  UIView *_searchBarView;
  UITextField *_searchTextField;
  UIButton *_searchButton;
}

static CGRect GetFrameCentered(CGRect frame, int width, int height)
{
  return CGRectMake((frame.size.width / 2) - (width / 2), (frame.size.height / 2) - (height / 2), width, height);
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
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
  [_searchBarView addSubview:_searchTextField];
  
  _searchButton = [UIButton new];
  [_searchBarView addSubview:_searchButton];
  
  self.view = mainView;
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
  _searchTextField.placeholder = @"Enter a City Name";
  _searchTextField.frame = CGRectMake(5, centeredSearch.origin.y, 200, 50);
  
  [_searchButton setConfiguration:[UIButtonConfiguration grayButtonConfiguration]];
  [_searchButton setTitle:@"Search" forState:UIControlStateNormal];
  [_searchButton sizeToFit];
  CGRect centeredButton = GetFrameCentered(_searchBarView.frame, _searchButton.frame.size.width + 10, _searchButton.frame.size.height);
  _searchButton.frame = CGRectMake(_searchTextField.frame.size.width + _searchTextField.frame.origin.x + 10, centeredButton.origin.y, centeredButton.size.width, centeredButton.size.height);
}

@end
