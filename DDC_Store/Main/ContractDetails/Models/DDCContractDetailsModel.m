//
//  ContractDetailsModel.m
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "DDCContractDetailsModel.h"

@implementation DDCContractDetailsModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}

+ (NSArray *)statusArr
{
    return @[@"",NSLocalizedString(@"生效中", @""),NSLocalizedString(@"未生效", @""),NSLocalizedString(@"未完成", @""),NSLocalizedString(@"已结束", @""),NSLocalizedString(@"已解除", @"")];
}

+ (NSArray *)payMethodArr
{
    return @[@"",NSLocalizedString(@"微信支付", @""), NSLocalizedString(@"支付宝支付", @""), NSLocalizedString(@"现金支付", @"")];
}

@end
