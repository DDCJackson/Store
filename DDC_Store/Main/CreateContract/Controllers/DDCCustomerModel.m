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
    
    for (NSDictionary * miniDict in @[@{@"career":DDCCustomerModel.occupationArray},
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
    NSInteger sex = ((NSNumber*)dict[@"sex"]).integerValue;
    // 0：男 1：女
    sex -= 1;
    dict[@"sex"] = @(sex);
    
    NSString * ID = (dict[@"id"] ? dict[@"id"] : @"");
    [dict setValue:ID forKey:@"uid"];
    
    dict[@"birthday"] = @([self.birthday timeIntervalSince1970]*1000).stringValue;
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
    return @"";
}

/**
 *
 注意：因为ViewModel需要text默认为一个空字符串，所以当enum等于0(未设置状态)我们返回一个空字符串
 *
 *
 */
+ (NSArray *)genderArray
{
    return @[@"", NSLocalizedString(@"男", @""), NSLocalizedString(@"女", @"")];
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
    return @{@"ID":@"id", @"imgUrlStr":@"img", @"email":@"lineUserEmail", @"career":@"lineUserCareer"};
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    oldValue = [super mj_newValueFromOldValue:oldValue property:property];
    if (oldValue && [property.name isEqualToString:@"birthday"])
    {
        if ([oldValue isKindOfClass:[NSString class]])
        {
            NSString * value = (NSString *)oldValue;
            if (value.length)
            {
                NSDate * birthday = [NSDate dateWithTimeIntervalSince1970:(value.doubleValue/1000)];
                NSCalendarUnit unitFlags = NSCalendarUnitYear;
                NSDateComponents *breakdownInfo = [[NSCalendar currentCalendar] components:unitFlags fromDate:birthday  toDate:[NSDate date]  options:0];
                self.age = @(breakdownInfo.year).stringValue;
                return birthday;
            }
        }
        else if ([oldValue isKindOfClass:[NSNumber class]])
        {
            NSNumber * value = (NSNumber *)oldValue;
            NSDate * birthday = [NSDate dateWithTimeIntervalSince1970:(value.doubleValue/1000)];
            NSCalendarUnit unitFlags = NSCalendarUnitYear;
            NSDateComponents *breakdownInfo = [[NSCalendar currentCalendar] components:unitFlags fromDate:birthday  toDate:[NSDate date]  options:0];
            self.age = @(breakdownInfo.year).stringValue;
            return birthday;
        }
    }
    else if ([property.name isEqualToString:@"sex"])
    {
        if ([oldValue isKindOfClass:[NSString class]])
        {
            NSString * value = (NSString *)oldValue;
            if (value.length)
            {
                return @(value.integerValue + 1);
            }
        }
        else if ([oldValue isKindOfClass:[NSNumber class]])
        {
            NSNumber * value = (NSNumber *)oldValue;
            return @(value.integerValue + 1);
        }
    }
    else if ([property.name isEqualToString:@"career"])
    {
        if ([oldValue isKindOfClass:[NSString class]])
        {
            NSString * value = (NSString *)oldValue;
            if (value.length)
            {
                return @([DDCCustomerModel.occupationArray indexOfObject:value]);
            }
        }
    }
    else if ([property.name isEqualToString:@"channel"])
    {
        if ([oldValue isKindOfClass:[NSString class]])
        {
            NSString * value = (NSString *)oldValue;
            if (value.length)
            {
                return @([DDCCustomerModel.channelArray indexOfObject:value]);
            }
        }
    }
    return oldValue;
}

@end
