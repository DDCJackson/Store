//
//  NSObject+DDCTypeCheck.h
//  DayDayCook
//
//  Created by sunlimin on 17/1/3.
//  Copyright © 2017年 GFeng. All rights reserved.
//
#import "NSObject+BXOperation.h"

@interface NSObject (DDCTypeCheck)

- (BOOL)boolValueForKey:(NSString *)key;

- (NSString *)stringValueForKey:(NSString *)key;

- (NSArray *)arrayValueForKey:(NSString *)key;

- (NSDictionary *)dictionaryValueForKey:(NSString *)key;

- (NSNumber *)numberValueForKey:(NSString *)key;

- (NSUInteger)integerValueForKey:(NSString *)key;

@end
