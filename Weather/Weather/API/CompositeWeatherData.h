//
//  CompositeWeatherData.h
//  Weather
//
//  Created by Danny Flax on 8/25/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CompositeWeatherData : NSObject

- (instancetype)initWithLocationName:(NSString *)locationName country:(NSString *)country state:(NSString *)state weatherStatusTitle:(NSString *)weatherStatusTitle weatherDescription:(NSString *)weatherDescription;

@property (nonatomic, readonly) NSString *locationName;
@property (nonatomic, readonly) NSString *country;
@property (nonatomic, readonly) NSString *state;
@property (nonatomic, readonly) NSString *weatherStatusTitle;
@property (nonatomic, readonly) NSString *weatherDescription;

@end

NS_ASSUME_NONNULL_END
