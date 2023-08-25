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
}

- (void)empty:(void(^)(void))emptyBlock hasWeather:(void(^)(CompositeWeatherData *))hasWeatherBlock loading:(void(^)(void))loadingBlock error:(void(^)(void))errorBlock
{
  switch (_internalState) {
    case WeatherUIStateValueEmpty:
      emptyBlock();
      break;
    case WeatherUIStateValueHasWeather:
      hasWeatherBlock(_weatherData);
      break;
    case WeatherUIStateValueLoading:
      loadingBlock();
      break;
    case WeatherUIStateValueError:
      errorBlock();
      break;
  }
}

+ (instancetype)newWithEmpty
{
  WeatherUIState *state = [WeatherUIState new];
  state->_internalState = WeatherUIStateValueEmpty;
  return state;
}

+ (instancetype)newWithHasWeather:(CompositeWeatherData *)weather
{
  WeatherUIState *state = [WeatherUIState new];
  state->_internalState = WeatherUIStateValueHasWeather;
  state->_weatherData = weather;
  return state;
}

+ (instancetype)newWithLoading
{
  WeatherUIState *state = [WeatherUIState new];
  state->_internalState = WeatherUIStateValueLoading;
  return state;
}

+ (instancetype)newWithError
{
  WeatherUIState *state = [WeatherUIState new];
  state->_internalState = WeatherUIStateValueError;
  return state;
}

@end
