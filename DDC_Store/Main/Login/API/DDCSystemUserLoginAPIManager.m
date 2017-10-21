//
//  DDCSystemUserLoginAPIManager.m
//  DDC_Store
//
//  Created by Christopher Wood on 10/21/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import "DDCSystemUserLoginAPIManager.h"
#import "DDCW_APICallManager.h"
#import "SecurityUtil.h"

@implementation DDCSystemUserLoginAPIManager

+ (void)loginWithUsername:(NSString *)username password:(NSString *)password successHandler:(void(^)(DDCUserModel * user))successHandler failHandler:(void(^)(NSError *err))failHandler
{
    NSString * url = [NSString stringWithFormat:@"%@/loginByLine.do", DDC_Share_BaseUrl];
    NSDictionary * params = @{@"username":username, @"password":password};
    
    [DDCW_APICallManager securityCallWithURLString:url type:@"POST" params:params securityStatus:RequestSecurityStatusNoSecurity andCompletionHandler:^(BOOL isSuccess, NSNumber *code, id responseObj, NSError *err) {
        if (isSuccess && !err && [code isEqual:@200])
        {
            if (responseObj[@"data"])
            {
                [DDCUserModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"ID":@"id", @"imgUrlStr":@"imageUrl"};
                }];
                DDCUserModel * model = [DDCUserModel mj_objectWithKeyValues:responseObj[@"data"]];
                successHandler(model);
                return;
            }
        }
        if (!err || !err.userInfo[NSLocalizedDescriptionKey])
        {
            NSString * failStr = @"";
            switch (code.integerValue)
            {
                case 415:
                    failStr = NSLocalizedString(@"没有登录权限", @"");
                    break;
                case 999:
                    failStr = NSLocalizedString(@"用户名或密码错误", @"");
                    break;
                default:
                    break;
            }
            if (!failStr.length)
            {
                failStr = NSLocalizedString(@"您的网络不稳定，请稍后重试！", @"");
            }
            err = [[NSError alloc] initWithDomain:NSURLErrorDomain code:code.integerValue userInfo:@{NSLocalizedDescriptionKey:failStr}];
        }
        failHandler(err);
    }];
}

@end
