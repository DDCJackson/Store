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
    DDCContractStatusInProgress = 1,
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

@end

@interface DDCContractInfoModel : GJObject

@property (nonatomic, copy) NSString  * contractNo;
@property (nonatomic, copy) NSArray   * courseCategoryId;
@property (nonatomic, copy) NSArray   * buyCount;
@property (nonatomic, copy) NSString  * startTime;
@property (nonatomic, copy) NSString  * endTime;
@property (nonatomic, copy) NSString  * effectiveTime;
@property (nonatomic, copy) NSString  * courseAddressId;
@property (nonatomic, copy) NSString  * contractPrice;

@end
