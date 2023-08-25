//
//  WeatherIconFetcher.h
//  Weather
//
//  Created by Danny Flax on 8/25/23.
//

#import <Foundation/Foundation.h>

@class UIImage;

NS_ASSUME_NONNULL_BEGIN

@interface WeatherIconFetcher : NSObject

+ (void)fetchIconWithName:(NSString *)iconName completionBlock:(void(^)(UIImage *))completionBlock;

@end

NS_ASSUME_NONNULL_END
