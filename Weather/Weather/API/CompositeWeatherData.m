//
//  CompositeWeatherData.m
//  Weather
//
//  Created by Danny Flax on 8/25/23.
//

#import "CompositeWeatherData.h"

@implementation CompositeWeatherData

- (instancetype)initWithLocationName:(NSString *)locationName country:(NSString *)country state:(NSString *)state weatherStatusTitle:(NSString *)weatherStatusTitle weatherDescription:(NSString *)weatherDescription icon:(UIImage *)icon
{
  if (self = [super init]) {
    _locationName = locationName;
    _country = country;
    _state = state;
    _weatherStatusTitle = weatherStatusTitle;
    _weatherDescription = weatherDescription;
    _icon = icon;
  }
  return self;
}

@end
