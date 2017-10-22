//
//  DDCEditClientInfoAPIManager.h
//  DDC_Store
//
//  Created by Christopher Wood on 10/20/17.
//  Copyright © 2017 DDC. All rights reserved.
//

@class DDCCustomerModel;
@class DDCContractDetailsModel;

@interface DDCEditClientInfoAPIManager : NSObject

+ (void)uploadClientInfo:(DDCCustomerModel *)model successHandler:(void(^)(DDCContractDetailsModel * contractModel))successHandler failHandler:(void(^)(NSError *err))failHandler;

@end
