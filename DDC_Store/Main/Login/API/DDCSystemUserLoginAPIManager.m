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
    NSString * url = [NSString stringWithFormat:@"%@/daydaycook/loginByLine.do", DDC_Share_BaseUrl];
    NSDictionary * params = @{@"username":username, @"password":[SecurityUtil encryptMD5String:password]};
    
    [DDCW_APICallManager callWithURLString:url type:@"POST" params:params andCompletionHandler:^(BOOL isSuccess, NSNumber *code, id responseObj, NSError *err) {
        if (isSuccess && !err && [code isEqual:@200])
        {
            if (responseObj[@"data"])
            {
                DDCUserModel * model = [DDCUserModel mj_objectWithKeyValues:responseObj[@"data"]];
                successHandler(model);
                return;
            }
        }
        if (!err)
        {
            NSString * failStr = responseObj[@"msg"];
            if (failStr)
            {
                err = [[NSError alloc] initWithDomain:NSURLErrorDomain code:code.integerValue userInfo:@{NSLocalizedDescriptionKey:failStr}];
            }
        }
        failHandler(err);
    }];
}

@end
