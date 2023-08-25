//
//  WeatherUIState.h
//  Weather
//
//  Created by Danny Flax on 8/25/23.
//

#import <Foundation/Foundation.h>

@class CompositeWeatherData;

NS_ASSUME_NONNULL_BEGIN

@interface WeatherUIState : NSObject

- (void)empty:(void(^)(void))emptyBlock hasWeather:(void(^)(CompositeWeatherData *))hasWeatherBlock loading:(void(^)(void))loadingBlock error:(void(^)(void))errorBlock;

+ (instancetype)newWithEmpty;

+ (instancetype)newWithHasWeather:(CompositeWeatherData *)weather;

+ (instancetype)newWithLoading;

+ (instancetype)newWithError;

@end

NS_ASSUME_NONNULL_END
