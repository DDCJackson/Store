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
    if(!detailsID||!detailsID.length)return;
    
    NSString *url = [NSString stringWithFormat:@"%@/server/contract/detail.do",kHaoRanURL];
    NSDictionary *param = @{@"id":detailsID};
    [DDCW_APICallManager callWithURLString:url type:@"POST" params:param andCompletionHandler:^(BOOL isSuccess, NSNumber *code, id responseObj, NSError *err) {
        if (isSuccess && [code isEqual:@200])
        {
            if(responseObj[@"data"]&&[responseObj[@"data"] isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dict = responseObj[@"data"];
                DDCContractDetailsModel *model = [[DDCContractDetailsModel alloc]init];
                if(dict&&[dict[@"userContract"] isKindOfClass:[NSDictionary class]])
                {
                    model = [DDCContractDetailsModel mj_objectWithKeyValues:dict[@"userContract"]];
                    DDCContractInfoModel *infoModel = [DDCContractInfoModel mj_objectWithKeyValues:dict[@"userContract"]];
                    if(dict[@"userContract"][@"effectiveCourseAddress"]&&[dict[@"userContract"][@"effectiveCourseAddress"] isKindOfClass:[NSDictionary class]])
                    {
                        infoModel.effectiveAddress = dict[@"userContract"][@"effectiveCourseAddress"][@"name"];
                    }
                    //线下课程
                    if(dict[@"userContractCategoryList"]&&[dict[@"userContractCategoryList"] isKindOfClass:[NSArray class]])
                    {
                        NSArray<OffLineCourseModel *> *courseArr = [OffLineCourseModel mj_objectArrayWithKeyValuesArray:dict[@"userContractCategoryList"]];
                        infoModel.course = courseArr;
                    }
                    model.infoModel = infoModel;
                    successHandler(model);
                    return;
                }
            }
        }
        failHandler(err);
    }];
}
@end
