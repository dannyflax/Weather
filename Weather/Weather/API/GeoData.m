//
//  GeoData.m
//  Weather
//
//  Created by Danny Flax on 8/24/23.
//

#import "GeoData.h"

@implementation GeoData

- (instancetype)initWithName:(NSString *)name latitude:(double)latitude longitude:(double)longitude country:(NSString *)country state:(NSString *)state
{
  if (self = [super init]) {
    _name = name;
    _latitude = latitude;
    _longitude = longitude;
    _country = country;
    _state = state;
  }
  return self;
}

@end
