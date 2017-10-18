//
//  DDCPhoneCheckAPIManager.m
//  DDC_Store
//
//  Created by Christopher Wood on 10/18/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import "DDCPhoneCheckAPIManager.h"
#import "DDCW_APICallManager.h"

@implementation DDCPhoneCheckAPIManager

/**
 406 验证码错误
 415 验证码超时
 200 成功 data为用户信息
 */

+ (void)checkPhoneNumber:(NSString *)phone code:(NSString *)code successHandler:(void (^)(BOOL, DDCCustomerModel *))successHandler failHandler:(void (^)(NSError *))failHandler
{
    NSString * url = [NSString stringWithFormat:@"%@server/user/CheckUserByPhone.do?", DDC_CN_Url];
    NSDictionary * params = @{@"phone":phone, @"type":@"2", @"code":code};
//    [DDCW_APICallManager callWithURLString:url type:@"POST" params:params andCompletionHandler:^(BOOL isSuccess, NSNumber *code, id responseObj, NSError *err) {
//        if (isSuccess && !err)
//        {
//
//    }]
}

@end
