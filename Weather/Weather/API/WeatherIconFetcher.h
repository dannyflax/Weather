//
//  WeatherIconFetcher.h
//  Weather
//
//  Created by Danny Flax on 8/25/23.
//

#import <Foundation/Foundation.h>

@class UIImage;

NS_ASSUME_NONNULL_BEGIN

/*
 * Fetches icons from the weather service.
 * To include image caching, I would consider first in-memory caching.
 * I would make the fetcher into a concrete class instead of class methods, then store a lookup dictionary with previously fetched images.
 * Then disk cache could then follow.
 */
@interface WeatherIconFetcher : NSObject

+ (void)fetchIconWithName:(NSString *)iconName completionBlock:(void(^)(UIImage *))completionBlock;

@end

NS_ASSUME_NONNULL_END
