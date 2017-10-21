//
//  DDCContractListAPIManager.m
//  DDC_Store
//
//  Created by Christopher Wood on 10/21/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import "DDCContractListAPIManager.h"
#import "DDCW_APICallManager.h"
#import "DDCStore.h"
#import "DDCContractModel.h"

@implementation DDCContractListAPIManager

+ (void)downloadContractListForPage:(NSUInteger)page status:(NSString *)status successHandler:(void(^)(NSArray *contractList))successHandler failHandler:(void(^)(NSError * err))failHandler
{
    NSString * url = [NSString stringWithFormat:@"%@/server/contract/list.do", DDC_Share_BaseUrl];
    NSString * uid = [DDCStore sharedStore].user.ID;
    NSDictionary * params = @{@"uid":uid, @"page":@(page).stringValue, @"status":status, @"pageSize":@"10"};
    
    [DDCW_APICallManager callWithURLString:url type:@"POST" params:params andCompletionHandler:^(BOOL isSuccess, NSNumber *code, id responseObj, NSError *err) {
        if (isSuccess && !err && [code isEqual: @200])
        {
            if (responseObj[@"data"])
            {
                NSArray<DDCContractModel *> * contractList = [DDCContractModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"]];
                successHandler(contractList);
                return;
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

@end
