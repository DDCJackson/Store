//
//  ContractDetailsModel.h
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DDCCustomerModel.h"
#import "DDCContractInfoModel.h"

typedef NS_ENUM(NSUInteger, DDCContractStatus)
{
    DDCContractStatusAll = 0,
    DDCContractStatusEffective,//生效中
    DDCContractStatusIneffective,//未生效
    DDCContractStatusInComplete,//未完成
    DDCContractStatusCompleted,//已结束
    DDCContractStatusRevoked//已解除
};

typedef NS_ENUM(NSUInteger, DDCContractPayMethod)
{
    DDCContractPayMethodCrash = 0,
    DDCContractPayMethodWeiXin,
    DDCContractPayMethodZhiFuBao,
};

@interface DDCContractDetailsModel : GJObject

+ (instancetype)randomInit;

@property (nonatomic,strong)DDCUserModel          * createUser;
@property (nonatomic,strong)DDCCustomerModel      * user;
@property (nonatomic,strong)DDCContractInfoModel  * infoModel;
@property (nonatomic,assign)DDCContractStatus       showStatus;
@property (nonatomic,assign)DDCContractPayMethod    payMethod;

+ (NSArray *)payMethodArr;
+ (NSArray *)displayStatusArray;
+ (NSArray *)backendStatusArray;

@end


