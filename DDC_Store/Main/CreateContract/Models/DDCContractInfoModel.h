//
//  DDCContractInfoModel.h
//  DDC_Store
//
//  Created by DAN on 2017/10/21.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "GJObject.h"

@interface DDCContractInfoModel : GJObject

@property (nonatomic, copy) NSString  * ID;
@property (nonatomic, copy) NSString  * contractNo;
@property (nonatomic, copy) NSArray   * courseCategory;
@property (nonatomic, copy) NSArray   * buyCount;
@property (nonatomic, copy) NSString  * startTime;
@property (nonatomic, copy) NSString  * endTime;
@property (nonatomic, copy) NSString  * effectiveTime;
@property (nonatomic, copy) NSString  * courseAddressId;
@property (nonatomic, copy) NSString  * contractPrice;
@property (nonatomic, copy) NSString * createDate;

@end
