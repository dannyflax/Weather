//
//  WeatherData.m
//  Weather
//
//  Created by Danny Flax on 8/24/23.
//

#import "WeatherData.h"

@implementation WeatherData


- (instancetype)initWithMainTitle:(NSString *)mainTitle weatherDescription:(NSString *)weatherDescription iconName:(NSString *)iconName
{
  if (self = [super init]) {
    _mainTitle = mainTitle;
    _weatherDescription = weatherDescription;
    _iconName = iconName;
  }
  return self;
}

@end
