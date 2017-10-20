//
//  ContractDetailsAPIManager.m
//  DDC_Store
//
//  Created by DAN on 2017/10/20.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "ContractDetailsAPIManager.h"
#import "DDCW_APICallManager.h"
#import "DDCContractModel.h"

@implementation ContractDetailsAPIManager

#define  kHaoRanURL  @"http://192.168.1.132:8080/daydaycook"

+ (void)getContractDetailsWithSuccessHandler:(void(^)(DDCContractModel *model))successHandler failHandler:(void(^)(NSError* error))failHandler
{
    NSString *url = [NSString stringWithFormat:@"%@/server/offline/webcourse/categorylist.do",kHaoRanURL];
    [DDCW_APICallManager callWithURLString:url type:@"POST" params:nil andCompletionHandler:^(BOOL isSuccess, NSNumber *code, id responseObj, NSError *err) {
        if (isSuccess && [code isEqual:@200])
        {
            if(responseObj[@"data"]&&[responseObj[@"data"] isKindOfClass:[NSDictionary class]])
            {
               DDCContractModel *model = [DDCContractModel mj_objectWithKeyValues:responseObj[@"data"]];
                successHandler(model);
                return;
            }
        }
        failHandler(err);
    }];
}
@end
