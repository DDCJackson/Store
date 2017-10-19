//
//  DDC_OpenUUID.h
//  DayDayCook
//
//  Created by 张秀峰 on 2017/2/15.
//  Copyright © 2017年 GFeng. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kOpenUUIDErrorNone          0
//#define kOpenUUIDErrorOptedOut      1
//#define kOpenUUIDErrorCompromised   2

//#define kOpenUUID @"OpenUUID"

//#if TARGET_OS_WATCH
//#define OpenUUID [[DDCUserDefaults ] objectForKey:kOpenUUID]
//#else
//#define OpenUUID [DDCUserDefaults objectForKey:kOpenUUID]
//#endif

@interface DDC_OpenUUID : NSObject

+ (NSString *)value;

+ (NSString *)valueWithError:(NSError **)error;

+ (NSString *)userDefault;

//+ (void)uploadDeviceInfoData;

@end
