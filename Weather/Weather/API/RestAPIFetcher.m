//
//  RestAPIFetcher.m
//  Weather
//
//  Created by Danny Flax on 8/24/23.
//

#import "RestAPIFetcher.h"
#import "Utils.h"

NSString *const API_KEY = @"c2dd6aae1a49da88d25c8ad38688666b";
NSString *const WEATHER_URL = @"https://api.openweathermap.org/";

@implementation RestAPIFetcher

+ (void)fetchFromEndpoint:(NSString *)endpoint withParams:(NSDictionary<NSString *, NSString *> *)params completionBlock:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionBlock
{
  NSString *paramsString = @"";
  for (NSString *key in params) {
    paramsString = [paramsString stringByAppendingFormat:@"&%@=%@", key, params[key]];
  }
  paramsString = [paramsString stringByAppendingFormat:@"&appid=%@", API_KEY];
  NSString *urlString = [[WEATHER_URL stringByAppendingFormat:@"%@?", endpoint] stringByAppendingString:UrlEncodeQueryString(paramsString)];
  [self fetchFromUrlDirectly:urlString completionBlock:completionBlock];
}

+ (void)fetchFromUrlDirectly:(NSString *)urlString completionBlock:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionBlock
{
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
  [request setURL:[NSURL URLWithString:urlString]];
  [request setHTTPMethod:@"GET"];

  NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];

  NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];

  NSURLSessionDataTask *sessionPostDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    completionBlock(data, response, error);
  }];
  [sessionPostDataTask resume];
}

@end
