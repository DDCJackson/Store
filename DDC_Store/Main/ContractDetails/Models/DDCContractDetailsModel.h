//
//  ContractDetailsModel.h
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DDCCustomerModel;
@class DDCContractInfoModel;

typedef NS_ENUM(NSUInteger, DDCContractStatus)
{
    DDCContractStatusInProgress = 1,
    DDCContractStatusIncomplete,
    DDCContractStatusComplete
};

@interface DDCContractDetailsModel : NSObject

@property (nonatomic,strong)DDCUserModel          * createUser;
@property (nonatomic,strong)DDCCustomerModel      * user;
@property (nonatomic,strong)DDCContractInfoModel  * infoModel;
@property (nonatomic,assign)DDCContractStatus       state;
@property (nonatomic,strong)NSString              * payMethod;

@end
