//
//  WeatherIconFetcher.m
//  Weather
//
//  Created by Danny Flax on 8/25/23.
//

#import "WeatherIconFetcher.h"
#import "RestAPIFetcher.h"

#import <UIKit/UIKit.h>

NSString *const IMAGE_ENDPOINT = @"img/wn/";
NSString *const IMAGE_SUFFIX = @"@2x.png";
NSString *const API_NAME = @"https://openweathermap.org/";

@implementation WeatherIconFetcher

+ (void)fetchIconWithName:(NSString *)iconName completionBlock:(void(^)(UIImage *))completionBlock
{
  [RestAPIFetcher fetchFromUrlDirectly:[NSString stringWithFormat:@"%@%@%@%@", API_NAME, IMAGE_ENDPOINT, iconName, IMAGE_SUFFIX]
                            completionBlock:^(NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
    if (error || !data) {
      completionBlock(nil);
      return;
    }
    completionBlock([UIImage imageWithData:data]);
  }];
}

@end
