//
//  PayWayModel.m
//  DayDayCook
//
//  Created by 张秀峰 on 16/9/2.
//  Copyright © 2016年 GFeng. All rights reserved.
//

#import "PayWayModel.h"

@implementation PayWayModel

- (BOOL)isEnable
{
    return self.urlSting && self.urlSting.isValidStringValue;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID":@"id", @"Description":@"description"};
}

@end
