//
//  WeatherUIState.m
//  Weather
//
//  Created by Danny Flax on 8/25/23.
//

#import "WeatherUIState.h"

#import "CompositeWeatherData.h"

typedef NS_ENUM(NSInteger, WeatherUIStateValue) {
    WeatherUIStateValueEmpty,
    WeatherUIStateValueHasWeather,
    WeatherUIStateValueLoading,
    WeatherUIStateValueError
};

@implementation WeatherUIState
{
  WeatherUIStateValue _internalState;
  CompositeWeatherData *_weatherData;
  NSString *_searchText;
}

- (void)empty:(void(^)(NSString *searchText))emptyBlock hasWeather:(void(^)(CompositeWeatherData *, NSString *searchText))hasWeatherBlock loading:(void(^)(NSString *searchText))loadingBlock error:(void(^)(NSString *searchText))errorBlock
{
  switch (_internalState) {
    case WeatherUIStateValueEmpty:
      emptyBlock(_searchText);
      break;
    case WeatherUIStateValueHasWeather:
      hasWeatherBlock(_weatherData, _searchText);
      break;
    case WeatherUIStateValueLoading:
      loadingBlock(_searchText);
      break;
    case WeatherUIStateValueError:
      errorBlock(_searchText);
      break;
  }
}

- (NSString *)searchText
{
  return _searchText;
}

+ (instancetype)newWithEmpty:(NSString *)searchText
{
  WeatherUIState *state = [WeatherUIState new];
  state->_internalState = WeatherUIStateValueEmpty;
  state->_searchText = searchText;
  return state;
}

+ (instancetype)newWithHasWeather:(CompositeWeatherData *)weather searchText:(NSString *)searchText
{
  WeatherUIState *state = [WeatherUIState new];
  state->_internalState = WeatherUIStateValueHasWeather;
  state->_weatherData = weather;
  state->_searchText = searchText;
  return state;
}

+ (instancetype)newWithLoading:(NSString *)searchText
{
  WeatherUIState *state = [WeatherUIState new];
  state->_internalState = WeatherUIStateValueLoading;
  state->_searchText = searchText;
  return state;
}

+ (instancetype)newWithError:(NSString *)searchText
{
  WeatherUIState *state = [WeatherUIState new];
  state->_internalState = WeatherUIStateValueError;
  state->_searchText = searchText;
  return state;
}

@end
