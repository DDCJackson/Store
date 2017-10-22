//
//  CreateContractInfoAPIManager.h
//  DDC_Store
//
//  Created by DAN on 2017/10/20.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OffLineCourseModel;
@class OffLineStoreModel;

@interface CreateContractInfoAPIManager : NSObject

+ (void)saveContractInfo:(NSDictionary *)infoDict successHandler:(void(^)(void))successHandler failHandler:(void(^)(NSError* error))failHandler;

+ (void)getCategoryListWithSuccessHandler:(void(^)(NSArray<OffLineCourseModel *> *))successHandler failHandler:(void(^)(NSError* error))failHandler;

+ (void)getOffLineStoreListWithSuccessHandler:(void(^)(NSArray<OffLineStoreModel *> *))successHandler failHandler:(void(^)(NSError* error))failHandler;


@end
