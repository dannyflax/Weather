//
//  GeoDataFetcher.m
//  Weather
//
//  Created by Danny Flax on 8/25/23.
//

#import "GeoDataFetcher.h"
#import "GeoData.h"
#import "RestAPIFetcher.h"
#import "Utils.h"

@implementation GeoDataFetcher

+ (void)fetchGeoDataWithKey:(NSString *)key completionBlock:(void(^)(GeoData *geoData))completionBlock
{
  NSDictionary<NSString *, id> *params = @{
    @"q" : key ?: [NSNull null],
    // In future iterations we could make the search smarter.
    // For now, assume the first answer is the best.
    @"limit" : @"1"
  };
  [RestAPIFetcher fetchFromEndpoint:@"geo/1.0/direct"
                         withParams:params completionBlock:^(NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
    if (error) {
      completionBlock(nil);
      return;
    }
    [self _parseNSDataToGeoData:data completionBlock:completionBlock];
  }];
}

+ (void)fetchGeoDataWithLat:(double)lat lon:(double)lon completionBlock:(void(^)(GeoData *geoData))completionBlock
{
  NSDictionary<NSString *, NSString *> *params = @{
    @"lat" : [NSString stringWithFormat:@"%f", lat],
    @"lon" : [NSString stringWithFormat:@"%f", lon],
    @"limit" : @"1"
  };
  [RestAPIFetcher fetchFromEndpoint:@"geo/1.0/reverse"
                         withParams:params completionBlock:^(NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
    if (error) {
      completionBlock(nil);
      return;
    }
    [self _parseNSDataToGeoData:data completionBlock:completionBlock];
  }];
}

+ (void)_parseNSDataToGeoData:(NSData *)geoData completionBlock:(void(^)(GeoData *geoData))completionBlock
{
  if (!geoData) {
    completionBlock(nil);
    return;
  }
  NSError *error = nil;
  id jsonObject = [NSJSONSerialization JSONObjectWithData:geoData options:kNilOptions error:&error];
  NSArray *jsonArray = CastToClassOrNil(jsonObject, NSArray.class);
  if (error != nil || !jsonArray || jsonArray.count <= 0) {
    completionBlock(nil);
    return;
  }
  // Simplify by taking the first geo object.
  NSDictionary *geoDict = CastToClassOrNil(jsonArray[0], NSDictionary.class);
  if (!geoDict) {
    completionBlock(nil);
    return;
  }
  
  NSString *name = CastToClassOrNil(geoDict[@"name"], NSString.class);
  NSNumber *latitude = CastToClassOrNil(geoDict[@"lat"], NSNumber.class);
  NSNumber *longitude = CastToClassOrNil(geoDict[@"lon"], NSNumber.class);
  NSString *country = CastToClassOrNil(geoDict[@"country"], NSString.class);
  NSString *state = CastToClassOrNil(geoDict[@"state"], NSString.class);
  
  // Could potentially make this more robust in the future to handle partial responses.
  // Note that state can be empty in non-US locations.
  if (!name || !latitude || !longitude || !country) {
    completionBlock(nil);
    return;
  }
  
  completionBlock([[GeoData alloc] initWithName:name latitude:latitude.doubleValue longitude:longitude.doubleValue country:country state:state]);
}

@end
