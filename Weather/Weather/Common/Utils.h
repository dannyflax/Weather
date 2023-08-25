//
//  Utils.h
//  Weather
//
//  Created by Danny Flax on 8/25/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern id CastToClassOrNil(id obj, Class className);

extern NSString *UrlEncodeQueryString(NSString *string);

NS_ASSUME_NONNULL_END
