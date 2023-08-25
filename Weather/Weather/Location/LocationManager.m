//
//  LocationManager.m
//  Weather
//
//  Created by Danny Flax on 8/25/23.
//

#import "LocationManager.h"

@implementation LocationManager
{
  // Could turn this into a state machine with more time.
  void (^_successBlock)(double lat, double lon);
  void (^_errorBlock)(void);
  CLLocationManager *_locationManager;
  BOOL _pendingLocation;
}

- (instancetype)init
{
  if (self = [super init]) {
    _locationManager = [CLLocationManager new];
    _locationManager.delegate = self;
  }
  return self;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
  _pendingLocation = NO;
  if (_errorBlock) {
    _errorBlock();
  }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
  _pendingLocation = NO;
  // Most recent update is at end of array.
  CLLocation *location = [locations lastObject];
  if (_successBlock) {
    _successBlock(location.coordinate.latitude, location.coordinate.longitude);
  }
}

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager
{
  if (manager.authorizationStatus == kCLAuthorizationStatusNotDetermined) {
    [manager requestWhenInUseAuthorization];
  } else if (manager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
    [_locationManager requestLocation];
  }
}

- (void)getLocation:(void(^)(double lat, double lon))successBlock errorBlock:(void(^)(void))errorBlock
{
  if (_pendingLocation) {
    return;
  }
  if (_locationManager.authorizationStatus == kCLAuthorizationStatusDenied) {
    if (_errorBlock) {
      _errorBlock();
    }
    return;
  }
  _pendingLocation = YES;
  _successBlock = successBlock;
  _errorBlock = errorBlock;
  if (_locationManager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
    [_locationManager requestLocation];
  }
}

@end
