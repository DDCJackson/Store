//
//  DDCEditClientInfoAPIManager.m
//  DDC_Store
//
//  Created by Christopher Wood on 10/20/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import "DDCEditClientInfoAPIManager.h"
#import "DDCW_APICallManager.h"
#import "DDCCustomerModel.h"


@implementation DDCEditClientInfoAPIManager

+ (void)uploadClientInfo:(DDCCustomerModel *)model successHandler:(void (^)(void))successHandler failHandler:(void (^)(NSError *))failHandler
{
    NSString * url = [NSString stringWithFormat:@"%@/server/user/updateLineUser.do", DDC_Share_BaseUrl];
    NSDictionary * params = [model toJSONDict];
    
    [DDCW_APICallManager callWithURLString:url type:@"POST" params:params andCompletionHandler:^(BOOL isSuccess, NSNumber *code, id responseObj, NSError *err) {
        if (isSuccess && !err && [code isEqual:@200])
        {
            successHandler();
        }
        else
        {
            failHandler(err);
        }
    }];
}

@end
