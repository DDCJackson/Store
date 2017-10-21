//
//  ContractDetailsModel.h
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DDCContractInfoModel.h"
#import "DDCCustomerModel.h"

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
    DDCContractPayMethodWeiXin = 1,
    DDCContractPayMethodZhiFuBao,
    DDCContractPayMethodCrash
};

@interface DDCContractDetailsModel : NSObject

@property (nonatomic,assign)NSString              * ID;
@property (nonatomic,strong)DDCUserModel          * createUser;
@property (nonatomic,strong)DDCCustomerModel      * user;
@property (nonatomic,strong)DDCContractInfoModel  * infoModel;
@property (nonatomic,assign)DDCContractStatus       showStatus;
@property (nonatomic,assign)DDCContractPayMethod    payMethod;

+ (NSArray *)statusArr;
+ (NSArray *)payMethodArr;

@end


