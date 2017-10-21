//
//  DDCContractInfoModel.h
//  DDC_Store
//
//  Created by DAN on 2017/10/21.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "GJObject.h"
#import "OffLineCourseModel.h"
#import "OffLineStoreModel.h"

@interface DDCContractInfoModel : GJObject

@property (nonatomic, copy) NSString                      * ID;
@property (nonatomic, copy) NSString                      * contractNo;
@property (nonatomic, copy) NSArray<OffLineCourseModel *> * course;
@property (nonatomic, copy) NSString                      * startTime;
@property (nonatomic, copy) NSString                      * endTime;
@property (nonatomic, copy) NSString                      * effectiveTime;
@property (nonatomic, strong) OffLineStoreModel           * effectiveCourseAddress;
@property (nonatomic, copy) NSString                      * contractPrice;
@property (nonatomic, copy) NSString                      * createDate;
//购买课程（字符串类型,用于展示）
- (NSString *)courseString;

//有效门店(字符串类型，用于展示)
- (NSString *)effectiveAddressString;

@end

