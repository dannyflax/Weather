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

- (void)empty:(void(^)(NSString *searchText))emptyBlock hasWeather:(void(^)(CompositeWeatherData *, NSString *searchText))hasWeatherBlock loading:(void(^)(NSString *searchText))loadingBlock error:(void(^)(NSString *searchText))errorBlock;

- (NSString *)searchText;

+ (instancetype)newWithEmpty:(NSString *)searchText;

+ (instancetype)newWithHasWeather:(CompositeWeatherData *)weather searchText:(NSString *)searchText;

+ (instancetype)newWithLoading:(NSString *)searchText;

+ (instancetype)newWithError:(NSString *)searchText;

@end

NS_ASSUME_NONNULL_END
