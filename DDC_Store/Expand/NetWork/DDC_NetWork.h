//
//  DDC_NetWork.h
//  DayDayCook
//
//  Created by 张秀峰 on 2017/2/14.
//  Copyright © 2017年 GFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDC_NetWork : NSObject

+ (NSString *)getCellularProvider;
+(NSString *)getNetWorkState;
+ (NSString *)getMacAddress;

@end
