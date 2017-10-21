//
//  OffLineCourseModel.m
//  DDC_Store
//
//  Created by DAN on 2017/10/18.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "OffLineCourseModel.h"

@implementation OffLineCourseModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID":@"id",@"count":@"buyCount",@"categoryName":@"name"};
}

@end
