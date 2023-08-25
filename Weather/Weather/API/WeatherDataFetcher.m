//
//  WeatherDataFetcher.m
//  Weather
//
//  Created by Danny Flax on 8/25/23.
//

#import "WeatherDataFetcher.h"
#import "RestAPIFetcher.h"
#import "WeatherData.h"
#import "Utils.h"

@implementation WeatherDataFetcher

+ (void)fetchWeatherWithLatitude:(double)latitude longitude:(double)longitude completionBlock:(void(^)(WeatherData *weatherData))completionBlock
{
  NSDictionary<NSString *, NSString *> *params = @{
    @"lat" : [NSString stringWithFormat:@"%f", latitude],
    @"lon" : [NSString stringWithFormat:@"%f", longitude],
  };
  [RestAPIFetcher fetchFromEndpoint:@"data/2.5/weather"
                         withParams:params completionBlock:^(NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
    if (error) {
      completionBlock(nil);
      return;
    }
    [self _parseNSDataToWeather:data completionBlock:completionBlock];
  }];
}

+ (void)_parseNSDataToWeather:(NSData *)weatherData completionBlock:(void(^)(WeatherData *weatherData))completionBlock
{
  if (!weatherData) {
    completionBlock(nil);
    return;
  }
  NSError *error = nil;
  id jsonObject = [NSJSONSerialization JSONObjectWithData:weatherData options:kNilOptions error:&error];
  NSDictionary<NSString *, NSString *> *jsonDictionary = CastToClassOrNil(jsonObject, NSDictionary.class);
  if (error != nil || !jsonDictionary) {
    completionBlock(nil);
    return;
  }
  NSArray *weather = CastToClassOrNil(jsonDictionary[@"weather"], NSArray.class);
  if (!weather || weather.count <= 0) {
    completionBlock(nil);
  }
  // Simplify by taking the first weather object.
  NSDictionary<NSString *, NSString *> *weatherFirst = CastToClassOrNil(weather[0], NSDictionary.class);
  if (!weatherFirst) {
    completionBlock(nil);
    return;
  }
  NSString *mainTitle = CastToClassOrNil(weatherFirst[@"main"], NSString.class);
  NSString *weatherDescription = CastToClassOrNil(weatherFirst[@"description"], NSString.class);
  NSString *iconName = CastToClassOrNil(weatherFirst[@"icon"], NSString.class);
  
  // Could potentially make this more robust in the future to handle partial responses.
  if (!mainTitle || !weatherDescription || !iconName) {
    completionBlock(nil);
    return;
  }
  
  completionBlock([[WeatherData alloc] initWithMainTitle:mainTitle weatherDescription:weatherDescription iconName:iconName]);
}

@end
