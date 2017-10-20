//
//  DDCCustomerModel.m
//  DDC_Store
//
//  Created by Christopher Wood on 10/18/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import "DDCCustomerModel.h"

@implementation DDCCustomerModel

- (NSDictionary *)toJSONDict
{
    NSMutableDictionary * dict = self.mj_keyValues;
    
    for (NSDictionary * miniDict in @[@{@"sex":DDCCustomerModel.genderArray},
                                      @{@"career":DDCCustomerModel.occupationArray},
                                      @{@"channel":DDCCustomerModel.channelArray}])
    {
        NSString * key = miniDict.allKeys[0];
        NSArray * arr = miniDict[key];
        NSString * value = dict[key];
        if (value)
        {
            dict[key] = arr[value.integerValue];
        }
    }
    return dict;
}

- (NSString *)formattedBirthday
{
    if (self.birthday)
    {
        NSDateFormatter * f = [[NSDateFormatter alloc] init];
        f.dateFormat = @"YYYY/MM/dd";
        return [f stringFromDate:self.birthday];
    }
    return nil;
}

/**
 *
 注意：因为ViewModel需要text默认为一个空字符串，所以当enum等于0(未设置状态)我们返回一个空字符串
 *
 *
 */
+ (NSArray *)genderArray
{
    return @[@"", NSLocalizedString(@"女", @""), NSLocalizedString(@"男", @"")];
}

+ (NSArray *)occupationArray
{
    return @[@"", NSLocalizedString(@"公司职员", @""), NSLocalizedString(@"家庭主妇", @""), NSLocalizedString(@"自由职业者", @""), NSLocalizedString(@"私营企业主", @""), NSLocalizedString(@"企业高管", @""), NSLocalizedString(@"学生", @""), NSLocalizedString(@"其他", @"")];
}

+ (NSArray *)channelArray
{
    return @[@"", NSLocalizedString(@"会员介绍", @""), NSLocalizedString(@"路过门店", @""), NSLocalizedString(@"日日煮官微", @""), NSLocalizedString(@"小煮集市", @""), NSLocalizedString(@"日日煮APP", @""), NSLocalizedString(@"其他新媒体", @"")];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID":@"id", @"imgUrlStr":@"img"};
}

@end
