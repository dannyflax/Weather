//
//  LocationManager.h
//  Weather
//
//  Created by Danny Flax on 8/25/23.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocationManager : NSObject<CLLocationManagerDelegate>

- (void)getLocation:(void(^)(double lat, double lon))successBlock errorBlock:(void(^)(void))errorBlock;

@end

NS_ASSUME_NONNULL_END
