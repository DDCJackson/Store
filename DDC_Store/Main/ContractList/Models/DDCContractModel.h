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
    DDCContractStatusAll = 0,
    DDCContractStatusInProgress,
    DDCContractStatusIncomplete,
    DDCContractStatusComplete
};

@interface DDCContractModel : GJObject

+ (instancetype)randomInit;

@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * date;
@property (nonatomic, assign) DDCContractStatus status;

+ (NSArray *)displayStatusArray;
+ (NSArray *)backendStatusArray;

@end

@interface DDCContractInfoModel : GJObject

@property (nonatomic, copy) NSString  * contractNum;
@property (nonatomic, copy) NSString  * purchasContent;
@property (nonatomic, copy) NSString  * stateDate;
@property (nonatomic, copy) NSString  * endDate;
@property (nonatomic, copy) NSString  * validDate;
@property (nonatomic, copy) NSString  * validStore;
@property (nonatomic, copy) NSString  * money;

@end
