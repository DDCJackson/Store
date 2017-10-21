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

@interface DDCContractDetailsModel : NSObject

+ (instancetype)randomInit;

@property (nonatomic,strong)DDCUserModel          * createUser;
@property (nonatomic,strong)DDCCustomerModel      * user;
@property (nonatomic,strong)DDCContractInfoModel  * infoModel;
@property (nonatomic,assign)DDCContractStatus       state;
@property (nonatomic,strong)NSString              * payMethod;

+ (NSArray *)displayStatusArray;
+ (NSArray *)backendStatusArray;

@end
