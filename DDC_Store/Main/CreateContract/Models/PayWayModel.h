//
//  PayWayModel.h
//  DayDayCook
//
//  Created by 张秀峰 on 16/9/2.
//  Copyright © 2016年 GFeng. All rights reserved.
//

#import "GJObject.h"
#import "MJExtension.h"

@interface PayWayModel : GJObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *updateDate;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *Description;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *urlSting;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, assign) BOOL isLoaded;
@property (nonatomic, assign) BOOL isEnable;
@property (nonatomic, assign) BOOL isSelected;

@end
