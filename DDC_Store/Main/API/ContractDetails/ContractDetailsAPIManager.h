//
//  ContractDetailsAPIManager.h
//  DDC_Store
//
//  Created by DAN on 2017/10/20.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "GJObject.h"

@class DDCContractModel;
@interface ContractDetailsAPIManager : GJObject

+ (void)getContractDetailsWithSuccessHandler:(void(^)(DDCContractModel *model))successHandler failHandler:(void(^)(NSError* error))failHandler;

@end
