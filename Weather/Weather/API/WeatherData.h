//
//  WeatherData.h
//  Weather
//
//  Created by Danny Flax on 8/24/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherData : NSObject

- (instancetype)initWithMainTitle:(NSString *)mainTitle weatherDescription:(NSString *)weatherDescription iconName:(NSString *)iconName;

@property (nonatomic, readonly) NSString *mainTitle;
@property (nonatomic, readonly) NSString *weatherDescription;
@property (nonatomic, readonly) NSString *iconName;

@end

NS_ASSUME_NONNULL_END
