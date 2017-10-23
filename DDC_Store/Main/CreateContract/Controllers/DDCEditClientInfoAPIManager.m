//
//  DDCEditClientInfoAPIManager.m
//  DDC_Store
//
//  Created by Christopher Wood on 10/20/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import "DDCEditClientInfoAPIManager.h"
#import "DDCW_APICallManager.h"
#import "DDCContractDetailsModel.h"


@implementation DDCEditClientInfoAPIManager

+ (void)uploadClientInfo:(DDCCustomerModel *)model successHandler:(void (^)(DDCContractDetailsModel * contractModel))successHandler failHandler:(void (^)(NSError *))failHandler
{
    NSString * url = [NSString stringWithFormat:@"%@/server/user/updateLineUser.do", DDC_Share_BaseUrl];
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:[model toJSONDict]];
    [params setValue:params[@"lineUserEmail"] forKey:@"email"];
    [params removeObjectForKey:@"lineUserEmail"];
    [params setValue:params[@"lineUserCareer"] forKey:@"career"];
    [params removeObjectForKey:@"lineUserCareer"];
    [params setValue:params[@"lineUserName"] forKey:@"nickName"];
    [params removeObjectForKey:@"lineUserName"];
    [params removeObjectForKey:@"id"];
    
    [DDCW_APICallManager callWithURLString:url type:@"POST" params:params andCompletionHandler:^(BOOL isSuccess, NSNumber *code, id responseObj, NSError *err) {
        if (isSuccess && !err && [code isEqual:@200])
        {
            if ([responseObj[@"data"] isKindOfClass:[NSDictionary class]])
            {
                NSDictionary * dataDict = responseObj[@"data"];
                DDCContractDetailsModel * contractModel = [[DDCContractDetailsModel alloc] init];
                contractModel.infoModel = [[DDCContractInfoModel alloc] init];
                contractModel.infoModel.ID = [NSString stringWithFormat:@"%@",dataDict[@"contractId"]];
                contractModel.user = model;
                successHandler(contractModel);
                return;
            }
        }
        if (!err || !err.userInfo[NSLocalizedDescriptionKey])
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
