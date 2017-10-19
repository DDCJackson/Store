//
//  NSObject+DDC.m
//  DayDayCook
//
//  Created by 张秀峰 on 2017/7/20.
//  Copyright © 2017年 DayDayCook. All rights reserved.
//

#import "NSObject+DDC.h"

@implementation NSObject (DDC)

- (BOOL)isValidStringValue
{
    if ([self isKindOfClass:[NSString class]]) {
        NSString *stringSelf = (NSString *)self;
        if (stringSelf.length) {
            if ([@[DDC_Java_NullSting, DDC_Java_NullSting1, DDC_Java_NullSting2] containsObject:stringSelf]) {
                return NO;
            }
            return YES;
        }
    }
    return NO;
}

- (BOOL)isValidObjectValue
{
    if ([self isKindOfClass:[NSNull class] ]|| [self isMemberOfClass:[NSNull class]]) {
        return NO;
    }
    return YES;
}



@end
