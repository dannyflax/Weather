//
//  CompositeWeatherDataFetcher.m
//  Weather
//
//  Created by Danny Flax on 8/25/23.
//

#import "CompositeWeatherDataFetcher.h"
#import "CompositeWeatherData.h"
#import "GeoDataFetcher.h"
#import "GeoData.h"
#import "WeatherDataFetcher.h"
#import "WeatherData.h"
#import "WeatherIconFetcher.h"

@implementation CompositeWeatherDataFetcher

+ (void)fetchWeatherWithKey:(NSString *)key completionBlock:(void(^)(CompositeWeatherData *))completionBlock
{
  if (!key) {
    completionBlock(nil);
    return;
  }
  [GeoDataFetcher fetchGeoDataWithKey:key completionBlock:^(GeoData * _Nonnull geoData) {
    if (!geoData) {
      completionBlock(nil);
      return;
    }
    [WeatherDataFetcher fetchWeatherWithLatitude:geoData.latitude longitude:geoData.longitude completionBlock:^(WeatherData * _Nonnull weatherData) {
      if (!weatherData) {
        completionBlock(nil);
        return;
      }
      [WeatherIconFetcher fetchIconWithName:weatherData.iconName completionBlock:^(UIImage * _Nonnull icon) {
        if (!icon) {
          completionBlock(nil);
          return;
        }
        completionBlock([[CompositeWeatherData alloc] initWithLocationName:geoData.name country:geoData.country state:geoData.state weatherStatusTitle:weatherData.mainTitle weatherDescription:weatherData.weatherDescription icon:icon]);
      }];
    }];
  }];
}

@end
