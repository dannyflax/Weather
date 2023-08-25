//
//  GeoData.h
//  Weather
//
//  Created by Danny Flax on 8/24/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GeoData : NSObject

- (instancetype)initWithName:(NSString *)name latitude:(double)latitude longitude:(double)longitude country:(NSString *)country state:(NSString *)state;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) double latitude;
@property (nonatomic, readonly) double longitude;
@property (nonatomic, readonly) NSString *country;
@property (nonatomic, readonly) NSString *state;

@end

NS_ASSUME_NONNULL_END
