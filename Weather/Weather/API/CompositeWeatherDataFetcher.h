//
//  CompositeWeatherDataFetcher.h
//  Weather
//
//  Created by Danny Flax on 8/25/23.
//

#import <Foundation/Foundation.h>

@class CompositeWeatherData;

NS_ASSUME_NONNULL_BEGIN

@interface CompositeWeatherDataFetcher : NSObject

+ (void)fetchWeatherWithKey:(NSString *)key completionBlock:(void(^)(CompositeWeatherData *))completionBlock;

+ (void)fetchWeatherWithLat:(double)lat lon:(double)lon completionBlock:(void(^)(CompositeWeatherData *))completionBlock;

@end

NS_ASSUME_NONNULL_END
