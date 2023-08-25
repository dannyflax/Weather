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

@implementation CompositeWeatherDataFetcher

+ (void)fetchWeatherWithKey:(NSString *)key completionBlock:(void(^)(CompositeWeatherData *))completionBlock
{
  if (!key) {
    completionBlock(nil);
  }
  [GeoDataFetcher fetchGeoDataWithKey:key completionBlock:^(GeoData * _Nonnull geoData) {
    if (!geoData) {
      completionBlock(nil);
    }
    [WeatherDataFetcher fetchWeatherWithLatitude:geoData.latitude longitude:geoData.longitude completionBlock:^(WeatherData * _Nonnull weatherData) {
      if (!weatherData) {
        completionBlock(nil);
      }
      completionBlock([[CompositeWeatherData alloc] initWithLocationName:geoData.name country:geoData.country state:geoData.state weatherStatusTitle:weatherData.mainTitle weatherDescription:weatherData.description]);
    }];
  }];
}

@end
