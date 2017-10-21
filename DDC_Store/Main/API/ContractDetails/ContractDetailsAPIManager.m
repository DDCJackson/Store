//
//  ContractDetailsAPIManager.m
//  DDC_Store
//
//  Created by DAN on 2017/10/20.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "ContractDetailsAPIManager.h"
#import "DDCW_APICallManager.h"
#import "DDCContractDetailsModel.h"
#import "DDCContractInfoModel.h"
#import "DDCCustomerModel.h"
#import "DDCUserModel.h"
#import "OffLineCourseModel.h"

@implementation ContractDetailsAPIManager

#define  kHaoRanURL  @"http://192.168.1.132:8080/daydaycook"

+ (void)getContractDetailsID:(NSString *)detailsID withSuccessHandler:(void(^)(DDCContractDetailsModel *model))successHandler failHandler:(void(^)(NSError* error))failHandler
{
    NSString *url = [NSString stringWithFormat:@"%@/server/contract/detail.do",kHaoRanURL];
    NSDictionary *param = @{@"id":@"23"};
    [DDCW_APICallManager callWithURLString:url type:@"POST" params:param andCompletionHandler:^(BOOL isSuccess, NSNumber *code, id responseObj, NSError *err) {
        if (isSuccess && [code isEqual:@200])
        {
            if(responseObj[@"data"]&&[responseObj[@"data"] isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dict = responseObj[@"data"];
                DDCContractDetailsModel *model = [[DDCContractDetailsModel alloc]init];
                if(dict&&[dict[@"userContract"] isKindOfClass:[NSDictionary class]])
                {
                    model = [DDCContractDetailsModel mj_setKeyValues:dict[@"userContract"]];
                    DDCContractInfoModel *infoModel = [DDCContractDetailsModel mj_setKeyValues:dict[@"userContract"]];
                    model.infoModel = infoModel;

                    DDCUserModel *user = [[DDCUserModel alloc]init];
                    DDCCustomerModel *custom = [[DDCCustomerModel alloc]init];

                    if(dict[@"userContract"][@"user"]&&[dict[@"userContract"][@"user"] isKindOfClass:[NSDictionary class]])
                    {
                        user = [DDCUserModel mj_setKeyValues:dict[@"userContract"][@"user"]];
                        model.user = custom;
                    }
                    if(dict[@"userContract"][@"createUesr"]&&[dict[@"userContract"][@"createUesr"] isKindOfClass:[NSDictionary class]])
                    {
                        custom = [DDCCustomerModel mj_setKeyValues:dict[@"userContract"][@"createUesr"]];
                        model.createUser = user;
                    }
    
                    //线下课程
//                    if(dict&&[dict[@"userContractCateforyList"] isKindOfClass:[NSArray class]])
//                    {
//                        NSArray *course  = [OffLineCourseModel mj_setupObjectClassInArray:dict[@"userContractCateforyList"]];
//
//                    }
                    successHandler(model);
                    
                }
            }
        }
        failHandler(err);
    }];
}
@end
