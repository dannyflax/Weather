//
//  GeoDataFetcher.h
//  Weather
//
//  Created by Danny Flax on 8/25/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GeoData;

@interface GeoDataFetcher : NSObject

+ (void)fetchGeoDataWithKey:(NSString *)key completionBlock:(void(^)(GeoData *geoData))completionBlock;

+ (void)fetchGeoDataWithLat:(double)lat lon:(double)lon completionBlock:(void(^)(GeoData *geoData))completionBlock;

@end

NS_ASSUME_NONNULL_END
