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

+ (instancetype)randomInit
{
    DDCContractDetailsModel * m = [[DDCContractDetailsModel alloc] init];
    m.user = [[DDCCustomerModel alloc] init];
    m.infoModel = [[DDCContractInfoModel alloc] init];
    
    NSArray * nameArray = @[@"张雪", @"菠菜", @"宝宝", @"大卫", @"苦苦", @"张久", @"吴西", @"喜乐", @"Arki", @"丹丹", @"Pace", @"加盐"];
    NSArray * phoneArray = @[@"124020239281", @"15602382390", @"12234235234", @"123235234", @"1232349896", @"345982374928", @"124982342345", @"984592238472"];
    NSArray * dateArray = @[@"2017/08/09", @"2018/12/14", @"2016/06/03", @"2015/09/09", @"2017/05/04", @"2017/02/14", @"2016/09/16", @"2015/05/07", @"2013/04/23"];
    
    int r = arc4random_uniform(10000);
    int rr = arc4random_uniform(10000);
    int rrr = arc4random_uniform(10000);
    m.infoModel.ID = @(r).stringValue;
    m.user.nickName = nameArray[@(r%nameArray.count).integerValue];
    m.user.userName = phoneArray[@(rr%phoneArray.count).integerValue];
    m.infoModel.createDate = dateArray[@(rrr%dateArray.count).integerValue];
    m.state = @(((r%5)+1)).integerValue;
    return m;
}


+ (NSArray *)displayStatusArray
{
    return @[NSLocalizedString(@"全部", @""), NSLocalizedString(@"生效中", @""), NSLocalizedString(@"未生效", @""), NSLocalizedString(@"未完成", @""), NSLocalizedString(@"已结束", @""), NSLocalizedString(@"已解除", @"")];
}

+ (NSArray *)backendStatusArray
{
    return @[NSLocalizedString(@"", @""), NSLocalizedString(@"生效中", @""), NSLocalizedString(@"未生效", @""), NSLocalizedString(@"未完成", @""), NSLocalizedString(@"已结束", @""), NSLocalizedString(@"已解除", @"")];
}

+ (NSArray *)payMethodArr
{
    return @[@"",NSLocalizedString(@"微信支付", @""), NSLocalizedString(@"支付宝支付", @""), NSLocalizedString(@"现金支付", @"")];
}

@end
