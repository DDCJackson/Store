//
//  CreateContractInfoAPIManager.m
//  DDC_Store
//
//  Created by DAN on 2017/10/20.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "CreateContractInfoAPIManager.h"
#import "DDCW_APICallManager.h"

//model
#import "OffLineStoreModel.h"
#import "OffLineCourseModel.h"

@implementation CreateContractInfoAPIManager

+ (void)saveContractInfo:(NSDictionary *)infoDict successHandler:(void(^)(void))successHandler failHandler:(void(^)(NSError* error))failHandler
{
    NSString *url = [NSString stringWithFormat:@"%@/server/contract/save.do",DDC_Share_BaseUrl];
    [DDCW_APICallManager callWithURLString:url type:@"POST" params:infoDict andCompletionHandler:^(BOOL isSuccess, NSNumber *code, id responseObj, NSError *err) {
        if (isSuccess && [code isEqual:@200])
        {
            successHandler();
            return;
        }
        failHandler(err);
    }];
}

+ (void)getCategoryListWithSuccessHandler:(void(^)(NSArray<OffLineCourseModel *> *))successHandler failHandler:(void(^)(NSError* error))failHandler
{
    NSString *url = [NSString stringWithFormat:@"%@/server/offline/webcourse/categorylist.do",DDC_Share_BaseUrl];
    [DDCW_APICallManager callWithURLString:url type:@"POST" params:nil andCompletionHandler:^(BOOL isSuccess, NSNumber *code, id responseObj, NSError *err) {
        if (isSuccess && [code isEqual:@200])
        {
            if(responseObj[@"data"][@"datas"]&&[responseObj[@"data"][@"datas"] isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *datasDict = responseObj[@"data"][@"datas"];
                NSArray * dataArray = [OffLineCourseModel mj_objectArrayWithKeyValuesArray:datasDict[@"resultList"]];
                successHandler(dataArray);
                return;
            }
        }
        failHandler(err);
    }];
}

+ (void)getOffLineStoreListWithSuccessHandler:(void(^)(NSArray<OffLineStoreModel *> *))successHandler failHandler:(void(^)(NSError* error))failHandler
{
    NSString *url = [NSString stringWithFormat:@"%@/server/offline/address/list.do",DDC_Share_BaseUrl];
    [DDCW_APICallManager callWithURLString:url type:@"POST" params:nil andCompletionHandler:^(BOOL isSuccess, NSNumber *code, id responseObj, NSError *err) {
        if (isSuccess && [code isEqual:@200])
        {
            if(responseObj[@"data"]&&[responseObj[@"data"] isKindOfClass:[NSArray class]])
            {
                NSArray * dataArray = [OffLineStoreModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"]];
                successHandler(dataArray);
                return;
            }
        }
        failHandler(err);
    }];
}

@end
