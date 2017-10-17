//
//  DDCContractModel.h
//  DDC_Store
//
//  Created by Christopher Wood on 10/17/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import "GJObject.h"

typedef NS_ENUM(NSUInteger, DDCContractStatus)
{
    DDCContractStatusIncomplete = 0,
    DDCContractStatusInProgress,
    DDCContractStatusComplete
};

@interface DDCContractModel : GJObject

+ (instancetype)randomInit;

@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * date;
@property (nonatomic, assign) DDCContractStatus status;

@end
