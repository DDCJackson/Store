//
//  DDCCustomerModel.m
//  DDC_Store
//
//  Created by Christopher Wood on 10/18/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import "DDCCustomerModel.h"

@implementation DDCCustomerModel

+ (NSArray *)genderArray
{
    return @[NSLocalizedString(@"女", @""), NSLocalizedString(@"男", @"")];
}

+ (NSArray *)occupationArray
{
    return @[NSLocalizedString(@"公司职员", @""), NSLocalizedString(@"家庭主妇", @""), NSLocalizedString(@"自由职业者", @""), NSLocalizedString(@"私营企业主", @""), NSLocalizedString(@"企业高管", @""), NSLocalizedString(@"学生", @""), NSLocalizedString(@"其他", @"")];
}

+ (NSArray *)channelArray
{
    return @[NSLocalizedString(@"会员介绍", @""), NSLocalizedString(@"路过门店", @""), NSLocalizedString(@"日日煮官微", @""), NSLocalizedString(@"小煮集市", @""), NSLocalizedString(@"日日煮APP", @""), NSLocalizedString(@"其他新媒体", @"")];
}

@end
