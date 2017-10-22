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
#import "DDCContractDetailsModel.h"

@implementation DDCContractListAPIManager

+ (void)downloadContractListForPage:(NSUInteger)page status:(NSUInteger)status successHandler:(void(^)(NSArray *contractList))successHandler failHandler:(void(^)(NSError * err))failHandler
{
    NSString * url = [NSString stringWithFormat:@"%@/server/contract/list.do", DDC_Share_BaseUrl];
    NSString * uid = [DDCStore sharedStore].user.ID;
    NSDictionary * params = @{@"uid":uid, @"currentPage":@(page).stringValue, @"status":@(status).stringValue, @"pageSize":@"10"};
    
    [DDCW_APICallManager callWithURLString:url type:@"POST" params:params andCompletionHandler:^(BOOL isSuccess, NSNumber *code, id responseObj, NSError *err) {
        if (isSuccess && !err && [code isEqual: @200])
        {
            if (responseObj[@"data"])
            {
                NSMutableArray * returnArray = [NSMutableArray array];
                if ([responseObj[@"data"] isKindOfClass:[NSArray class]])
                {
                    NSArray * dataArray = responseObj[@"data"];
                    for (NSDictionary * dataDict in dataArray)
                    {
                        [returnArray addObject:[DDCContractListAPIManager parseDictionary:dataDict]];
                    }
                }
                else if ([responseObj[@"data"] isKindOfClass:[NSDictionary class]])
                {
                    [returnArray addObject:[DDCContractListAPIManager parseDictionary:responseObj[@"data"]]];
                }
                successHandler(returnArray);
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
     
+ (DDCContractDetailsModel *)parseDictionary:(NSDictionary *)dict
{
    DDCCustomerModel * user = [DDCCustomerModel mj_objectWithKeyValues:dict];
    
    [DDCContractInfoModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID":@"id"};
    }];
    DDCContractInfoModel * infoModel = [DDCContractInfoModel mj_objectWithKeyValues:dict];
    DDCContractDetailsModel * detailsModel = [DDCContractDetailsModel mj_objectWithKeyValues:dict];
    
    detailsModel.user = user;
    detailsModel.infoModel = infoModel;
    return detailsModel;
}

@end
