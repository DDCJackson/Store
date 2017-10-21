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

+ (void)checkPhoneNumber:(NSString *)phone code:(NSString *)code successHandler:(void (^)(DDCCustomerModel *))successHandler failHandler:(void (^)(NSError *))failHandler
{
    NSString * url = [NSString stringWithFormat:@"%@/server/user/CheckUserByPhone.do?", DDC_Share_BaseUrl];
    NSDictionary * params = @{@"phone":phone, @"type":@"2", @"code":code};
    [DDCW_APICallManager callWithURLString:url type:@"POST" params:params andCompletionHandler:^(BOOL isSuccess, NSNumber *code, id responseObj, NSError *err) {
        if (isSuccess && !err)
        {
            if (code.integerValue == 200)
            {
                NSDictionary * dataDict = responseObj[@"data"];
                if (dataDict)
                {
                    DDCCustomerModel * model = [DDCCustomerModel mj_objectWithKeyValues:dataDict];
                    successHandler(model);
                    return;
                }
            }
        }
        if (!err)
        {
            NSString * failStr = responseObj[@"msg"];
            if (!failStr)
            {
                failStr = NSLocalizedString(@"您的网络不稳定，请稍后重试！", @"");
            }
            err = [[NSError alloc] initWithDomain:NSURLErrorDomain code:code.integerValue userInfo:@{NSLocalizedDescriptionKey:failStr}];
        }
        failHandler(err);
    }];
}

+ (void)getVerificationCodeWithPhoneNumber:(NSString *)phoneNumber successHandler:(void (^)(id responseObj))successHandler failHandler:(void (^)(NSError *))failHandler
{
    // 获取验证码  忘记密码type ＝ 1、注册type ＝ 0 、快速登录 = 2
    
    NSString *url =[NSString stringWithFormat:@"%@/server/utils/getRegCode.do",DDC_Share_BaseUrl];
    
    if(!phoneNumber || !phoneNumber.length) return;
    
    NSDictionary *params = @{@"username" : phoneNumber,
                             @"type" : @"2",
                             @"isNew" : @1//新版本都加
                             };
    
    [DDCW_APICallManager callWithURLString:url type:@"POST"  params:params andCompletionHandler:^(BOOL isSuccess, NSNumber * code, id responseObj, NSError *err) {
        if (isSuccess && responseObj)
        {
            if ([responseObj isKindOfClass:[NSDictionary class]])
            {
                successHandler(responseObj);
                return;
            }
        }
        failHandler(err);
    }];
}

@end
