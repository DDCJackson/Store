//
//  Tools.h
//  iCarCenter
//
//  Created by Peter on 15/2/4.
//  Copyright (c) 2015年 机锋科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#if !TARGET_OS_WATCH
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "DDC_NetWork.h"
#import "Toast+UIView.h"
#import "LoadingView.h"
#import "Reachability.h"
#endif

@interface Tools : NSObject

/**
 数字千位分割符

 @param digitString 数字字符串
 @return 字符串
 */
+ (NSString *)separatedDigitStringWithString:(NSString *)digitString;

//获取Library/Caches路径
+(NSString *)getLibraryCachesPath:(NSString*)fileName fileGroup:(NSString*)fileGroup;

// 毫秒转化成日期格式
+(NSString *)getConversionTime:(NSString *)timeStr;
//从一段字符串中截取指定字数的字符串
+ (NSString *)getSubString:(NSString *)strSource WithCharCounts:(NSInteger)number;
//将数组转变成以指定字符隔开的字符串
+(NSString *) getStringFromArray:(NSArray *)srcArray byCharacter:(NSString *)character;
//传入时间查看时候间隔 如1天前，  58分钟前
+(NSString*)timestamp:(NSString*)dateTimeStr lastDateTimeStr:(NSString *)lastDateTime;
//从时间串中 根据时间差 在同一天的时候显示 小时分钟，超过一天就显示时间
+(NSString*)getDaysFromDates:(NSString*)dateTimeStr lastDateTimeStr:(NSString *)lastDateTime;
//获取当前系统时区的时间
+(NSString*)getCurrentDateWithSystemLocalZone;

//判断是否是同一天
+(BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2;
//字符串中是否含有emoji表情
+ (BOOL)stringContainsEmoji:(NSString *)string;

//获取当前设备号
+(NSString*)getUuid;

//判断是否为邮箱
+ (BOOL)isEmail:(NSString *)email;

+(BOOL)isBlankString:(NSString*)string;

//小数点后几位取舍 （四舍五入）
+ (NSDecimalNumber *)roundFloat:(NSString *)num decimalPlace:(int)decimalPlace;

//返回的是字符串类型，小数点后几位取舍（四舍五入),是整数的时候,也会有两位
+ (NSString *)stringFloat:(NSString *)num decimalPlace:(int)decimalPlace;

//（NSRoundPlain取整 ／NSRoundDown只舍不入／NSRoundUp只入不舍／NSRoundBankers四舍五入）
+ (NSDecimalNumber *)roundFloat:(NSString *)num withRoundingMode:(NSRoundingMode)mode decimalPlace:(int)decimalPlace;

/** 判断是否为Url*/
+ (BOOL)isValidUrl:(NSString *)string;

+ (NSString *)convertPlayTime:(NSTimeInterval)second;

/**过滤Html标签*/
+(NSString *)filterHTML:(NSString *)html;

//邮箱
+ (BOOL)isValidateEmail:(NSString *)email;

//手机号
+(BOOL)isPhoneNumber:(NSString *)phoneString;

//密码
+ (BOOL)isLegalPassword:(NSString *)password;

//匹配整数(待验证)
+ (BOOL)validateIntValueNumber:(NSString*)number;
//匹配小数(待验证)
+ (BOOL)validateDecimalValueNumber:(NSString*)number;

//只能是数字
+ (BOOL)validateNumber:(NSString*)number;


#if !TARGET_OS_WATCH

+(NSArray *)regionPlist;

//设备型号
+ (NSString*)deviceString;

//屏宽
+ (float)screenWidth;

//屏高
+ (float)screenHeight;

//计算字符串大小
+ (CGSize)sizeOfText:(NSString *)text andMaxLabelSize:(CGSize)size andFont:(UIFont *)font;

//设置属性字符串
+ (NSMutableAttributedString *)setAttributeStringForDiffentAttributesWithStr:(NSString *)str color:(UIColor *)color font:(UIFont *)font lineSpace:(CGFloat)lineSpace miniStr:(NSString *)miniStr miniColor:(UIColor *)miniColor miniFont:(UIFont *)miniFont;

//转化时间格式
+ (NSString *)dateStringWithDate:(NSDate *)date;
+ (NSDate *)dateWithDateString:(NSString *)dateStr;
/****两个日期之前相差多少天****/
+ (NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
+ (NSString *)dateWithTimeInterval:(NSString *)timeInterval;
+ (NSString *)dateWithTimeInterval:(NSString *)timeInterval andDateFormatter:(NSString *)formatter;
+ (NSString *)dateInComentsWithTimeInterval:(NSString *)timeIntervalString;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


+ (NSString*)usernameForNickname:(NSString*)nickname userName:(NSString*)userName;

+ (id)loadNibName:(NSString *)name;
//获取UIStoryboard
+ (id)loadStoryboardName:(NSString *)name ViewName:(NSString*)viewname;

// 是否wifi
+ (BOOL) IsEnableWIFI;
// 是否3G
+ (BOOL) IsEnable3G;

//判断网络是否存在
+(BOOL)isExistenceNetwork;

+ (CGSize)sizeOfText:(NSString *)text andMaxLabelSize:(CGSize)size andFont:(UIFont *)font andLineSpace:(CGFloat)lineSpace andTargetLabel:(UILabel *)label;

//HUD 提示
+(UIView *)showHUDAddedTo:(UIView *)view animated:(BOOL)animated;
+(void)showHUDAddedTo:(UIView *)view;
+(void)hiddenHUDFromSuperview;


#ifndef TARGET_IS_EXTENSION
// 获取应用在本机设置中是否关闭通知
+(BOOL)isAllowedNotification;

//获取MAC地址
+ (NSString *)getMacAddress;
//获取网络运营商的名称
+ (NSString *)getCellularProvider;
//判断当前连接的网络状态
+(NSString *)getNetWorkState;

#endif

#endif


@end
