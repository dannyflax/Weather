//
//  Utils.m
//  Weather
//
//  Created by Danny Flax on 8/25/23.
//

#import "Utils.h"

id CastToClassOrNil(id obj, Class className)
{
  return [(NSObject *)obj isKindOfClass:className] ? obj : nil;
}
