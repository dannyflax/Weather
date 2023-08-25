//
//  RestAPIFetcher.h
//  Weather
//
//  Created by Danny Flax on 8/24/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 * Keep this as a static method for now, since this class doesn't require any state.
 * Later we might want to introduce state to handle things like request throttling.
 */
@interface RestAPIFetcher : NSObject

+ (void)fetchFromEndpoint:(NSString *)endpoint withParams:(NSDictionary<NSString *, NSString *> *)params completionBlock:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionBlock;

+ (void)fetchFromUrlDirectly:(NSString *)endpoint completionBlock:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionBlock;

@end

NS_ASSUME_NONNULL_END
