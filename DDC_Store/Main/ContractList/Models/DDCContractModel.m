//
//  DDCContractModel.m
//  DDC_Store
//
//  Created by Christopher Wood on 10/17/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import "DDCContractModel.h"

#include <stdlib.h>

@interface DDCContractModel()

@end

@implementation DDCContractModel

+ (instancetype)randomInit
{
    DDCContractModel * m = [[DDCContractModel alloc] init];
    
    NSArray * nameArray = @[@"张雪", @"菠菜", @"宝宝", @"大卫", @"苦苦", @"张久", @"吴西", @"喜乐"];
    NSArray * phoneArray = @[@"124020239281", @"15602382390", @"12234235234", @"123235234", @"1232349896", @"345982374928"];
    NSArray * dateArray = @[@"2017/08/09", @"2018/12/14", @"2016/06/03", @"2015/09/09", @"2017/05/04", @"2017/02/14", @"2016/09/16"];
    
    int r = arc4random_uniform(10000);
    int rr = arc4random_uniform(10000);
    int rrr = arc4random_uniform(10000);
    m.ID = @(r).stringValue;
    m.name = nameArray[@(r%nameArray.count).integerValue];
    m.phone = phoneArray[@(rr%phoneArray.count).integerValue];
    m.date = dateArray[@(rrr%dateArray.count).integerValue];
    m.status = @(((r%3)+1)).integerValue;
    return m;
}

@end

@interface DDCContractInfoModel()

@end

@implementation DDCContractInfoModel

//- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
//{
//    oldValue = [super mj_newValueFromOldValue:oldValue property:property];
//    if([property.name isEqualToString:@"kcal"]||[property.name isEqualToString:@"protein"]||[property.name isEqualToString:@"carbohydrate"]||[property.name isEqualToString:@"fat"])
//    {
//        if ([oldValue isKindOfClass:[NSNumber class]])
//        {
//            NSNumber * value = (NSNumber*)oldValue;
//            return [Tools stringFloat:value.stringValue decimalPlace:2];
//        }
//        else if ([oldValue isKindOfClass:[NSString class]])
//        {
//            NSString * value = (NSString*)oldValue;
//            return [Tools stringFloat:value decimalPlace:2];
//        }
//    }
//    return oldValue;
//}

@end
