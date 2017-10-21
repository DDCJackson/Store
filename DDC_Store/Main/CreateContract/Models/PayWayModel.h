//
//  PayWayModel.h
//  DayDayCook
//
//  Created by 张秀峰 on 16/9/2.
//  Copyright © 2016年 GFeng. All rights reserved.
//

#import "GJObject.h"

@interface PayWayModel : GJObject

@property (nonatomic, copy) NSString *Description;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *urlSting;
@property (nonatomic, copy) NSString *totalAmount;
@property (nonatomic, copy) NSString *contractNO;
@property (nonatomic, copy) NSString *tradeNo;
@property (nonatomic, copy) NSString *payMethodId;
@property (nonatomic, copy) NSString *productId;

@property (nonatomic, assign) BOOL isLoaded;
@property (nonatomic, assign) BOOL isEnable;
@property (nonatomic, assign) BOOL isSelected;
//@property (nonatomic, assign) BOOL isFinished;
//@property (nonatomic, strong) NSNumber *timerState;//0开启，1关闭

@end
