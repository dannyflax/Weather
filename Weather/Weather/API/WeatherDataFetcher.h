//
//  WeatherDataFetcher.h
//  Weather
//
//  Created by Danny Flax on 8/25/23.
//

#import <Foundation/Foundation.h>

@class WeatherData;

NS_ASSUME_NONNULL_BEGIN

@interface WeatherDataFetcher : NSObject

// Return nil on failure.
// Since errors won't be user-facing and we would want to use them mostly for diagnostics, keep the error code out of the top-level.
+ (void)fetchWeatherWithLatitude:(double)latitude longitude:(double)longitude completionBlock:(void(^)(WeatherData *weatherData))completionBlock;

@end

NS_ASSUME_NONNULL_END
