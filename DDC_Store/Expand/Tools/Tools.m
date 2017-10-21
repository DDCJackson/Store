//
//  Tools.m
//  iCarCenter
//
//  Created by Storm on 14-4-28.
//  Copyright (c) 2014年 Storm. All rights reserved.
//

#import "Tools.h"
#if !TARGET_OS_WATCH
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import "sys/utsname.h"
#endif

static float screenWidth = 0;
static float screenHeight = 0;

@implementation Tools

//数字千位分割符
+ (NSString *)separatedDigitStringWithString:(NSString *)digitString
{
    NSNumber *number = [NSNumber numberWithInteger:digitString.integerValue];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *clickCount = [numberFormatter stringFromNumber:number];
    return clickCount;
}

//获取Library/Caches路径
+(NSString *)getLibraryCachesPath:(NSString*)fileName fileGroup:(NSString*)fileGroup
{
    NSArray *paths =  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *filePath = [paths lastObject];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    fileGroup=[filePath stringByAppendingPathComponent:fileGroup];
    if(![fileManager fileExistsAtPath:fileGroup])
    {
        [fileManager createDirectoryAtPath:fileGroup withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    filePath=[fileGroup stringByAppendingPathComponent:fileName];
    return  filePath;
}

//邮箱
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


+(BOOL)isPhoneNumber:(NSString *)phoneString
{
    NSString * MOBILE = @"^1[34578]{1}\\d{9}$";//@"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:phoneString];
}

+ (BOOL)isLegalPassword:(NSString *)password
{
    //验证密码是否合法
    NSString * regular = @"^[0-9A-Za-z]{6,20}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    return [predicate evaluateWithObject:password];
}

+ (BOOL)validateDecimalValueNumber:(NSString*)number
{
    NSString *decimalNumberRule = @"(([1-9][0-9]*.[0-9]+)|(0.[0-9]*))$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",decimalNumberRule];
    return [predicate evaluateWithObject:number];
}

+ (BOOL)validateIntValueNumber:(NSString*)number
{
    NSString *intNumberRule = @"[1-9][0-9]*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",intNumberRule];
    return [predicate evaluateWithObject:number];
}

+ (BOOL)validateNumber:(NSString*)number
{
    NSString *numberRule = @"^[0-9]+$";//至少一个数字
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numberRule];
    return [predicate evaluateWithObject:number];
//    BOOL res =YES;
//    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
//    int i =0;
//    while (i < number.length) {
//        NSString * string = [number substringWithRange:NSMakeRange(i,1)];
//        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
//        if (range.length ==0) {
//            res =NO;
//            break;
//        }
//        i++;
//    }
//    return res;
}

//+(NSString*)regionNameForCode:(NSString*)code
//{
//    for (int i=0; i<DDC_RegionPlist.count; i++)
//    {
//        if ([DDC_RegionPlist[i][@"code"] isEqualToString:code])
//        {
//            return (NSString*)DDC_RegionPlist[i][DDC_Share_LanguageId];//Language_Id
//        }
//    }
//    return NSLocalizedString(@"其他", @"RegionPlistOption");
//}
//
//+(NSString*)regionCodeForName:(NSString*)name
//{
//    for (int i=0; i<DDC_RegionPlist.count; i++)
//    {
//        if ([DDC_RegionPlist[i][DDC_Share_LanguageId] isEqualToString:name])//Language_Id
//        {
//            return (NSString*)DDC_RegionPlist[i][@"code"];
//        }
//    }
//    return @"156";
//}

#if !TARGET_OS_WATCH

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
    
}

+ (NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents * comp = [calendar components:NSCalendarUnitDay fromDate:fromDate                                                                                 toDate:toDate options:NSCalendarWrapComponents];
    return comp.day;
}

+ (NSString *)dateWithTimeInterval:(NSString *)timeInterval
{
    NSTimeInterval seconds = [timeInterval floatValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter *format = [[NSDateFormatter alloc] init] ;
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [format stringFromDate:date];
}

+ (NSString *)dateWithTimeInterval:(NSString *)timeInterval andDateFormatter:(NSString *)formatter
{
    NSTimeInterval seconds = [timeInterval floatValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter *format = [[NSDateFormatter alloc] init] ;
    format.dateFormat = formatter;
    return [format stringFromDate:date];
}


+ (NSString *)timeIntervalWithDateStr:(NSString *)dateStr andDateFormatter:(NSString *)formatter
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init] ;
    [format setDateStyle:NSDateFormatterMediumStyle];
    [format setTimeStyle:NSDateFormatterShortStyle];
    [format setDateFormat:formatter];
    NSDate* dateTodo = [format dateFromString:dateStr];
    NSString *timeSp = [NSString stringWithFormat:@"%ld000", (long)[dateTodo timeIntervalSince1970]];
    return timeSp;
}

+(NSString *)dateInComentsWithTimeInterval:(NSString *)timeIntervalString
{
    NSTimeInterval timeInterval = [timeIntervalString doubleValue]/1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitDayFlags = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComps = [gregorian components:unitDayFlags fromDate:date toDate:[NSDate date] options:0];
    int days = (int)[dateComps day];
    NSString *timeStr = @"";
    
    if (days >= 3) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm";
        timeStr = [dateFormatter stringFromDate:date];
        
    }else if (days >=2){
        timeStr = NSLocalizedString(@"前天", @"时间格式");
    }else if(days >= 1){
        timeStr = NSLocalizedString(@"昨天", @"时间格式");//[NSString stringWithFormat:@"%d天前",days];
        
    }else {
        int hours = (int)[dateComps hour];
        
        if (hours >= 1) {
            timeStr = [NSString stringWithFormat:@"%d %@",hours,NSLocalizedString(@"小时前", @"时间格式")];
            
        }else{
            int minutes = (int)[dateComps minute];
            
            if (minutes >= 1) {
                timeStr = [NSString stringWithFormat:@"%d %@",minutes,NSLocalizedString(@"分钟前", @"时间格式")];
                
            }else{
                timeStr = NSLocalizedString(@"刚刚", @"时间格式");
            }
        }
    }
    return timeStr;
}


+ (CGSize)sizeOfText:(NSString *)text andMaxLabelSize:(CGSize)size andFont:(UIFont *)font
{
    CGRect f = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
    return f.size;
}

+ (CGSize)sizeOfText:(NSString *)text andMaxLabelSize:(CGSize)size andFont:(UIFont *)font andLineSpace:(CGFloat)lineSpace andTargetLabel:(UILabel *)label
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = lineSpace;
    NSDictionary *attributes = @{ NSFontAttributeName:font,
                                  NSParagraphStyleAttributeName:paragraphStyle};
    if (label) {
        label.attributedText = [[NSAttributedString alloc]initWithString:label.text
                                                              attributes:attributes];
    }
    CGRect f = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:attributes context:nil];
    return f.size;
}



+ (NSMutableAttributedString *)setAttributeStringForDiffentAttributesWithStr:(NSString *)str color:(UIColor *)color font:(UIFont *)font lineSpace:(CGFloat)lineSpace miniStr:(NSString *)miniStr miniColor:(UIColor *)miniColor miniFont:(UIFont *)miniFont
{
    NSMutableParagraphStyle * pStyle = [[NSMutableParagraphStyle alloc] init];
    pStyle.lineSpacing = lineSpace;
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:str attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color,NSParagraphStyleAttributeName:pStyle}];

    NSRange miniRange = [str rangeOfString:miniStr];
    if (miniRange.location != NSNotFound) {
        [attributeStr addAttributes:@{NSForegroundColorAttributeName:miniColor,NSFontAttributeName:miniFont} range:miniRange];
    }
    
    return attributeStr;
}


/**
 *  屏幕的宽度
 *
 *  @return 屏幕的宽度
 */

+ (float)screenWidth
{
    if (screenWidth != 0)
    {
        return screenWidth;
    }
    BOOL isPortrait = NO;
#ifndef TARGET_IS_EXTENSION
    isPortrait = UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
#else
    isPortrait = [UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height;
#endif
    if (isPortrait)
    {
            //竖屏
        if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
        {
            //系统版本号 >= 8.0
            screenWidth = [UIScreen mainScreen].nativeBounds.size.width / [UIScreen mainScreen].nativeScale;
        }
        else
        {
            screenWidth = [UIScreen mainScreen].bounds.size.width;
        }
    }
    else
    {
        //横屏
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
        {
            screenWidth = [UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale;
        }
        else
        {
            screenWidth = [UIScreen mainScreen].bounds.size.height;
        }
    }
    
    return screenWidth;
}


/**
 *  屏幕的高度
 *
 *  @return 屏幕的高度
 */
+ (float)screenHeight
{
    if (screenHeight != 0)
    {
        return screenHeight;
    }
    BOOL isLandscape = NO;
#ifndef TARGET_IS_EXTENSION
    isLandscape = UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
#else
    isLandscape = [UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height;
#endif
    if (isLandscape)
    {
        if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0) {
            //            if ([UIApplication sharedApplication].statusBarFrame.size.width>20) {
            //                return [UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale;20;
            //            }
            screenHeight = [UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale;
        } else {
#ifndef TARGET_IS_EXTENSION
            if ([UIApplication sharedApplication].statusBarFrame.size.width>20) {
                screenHeight = [UIScreen mainScreen].bounds.size.width-20;
            }
#endif
            screenHeight = [UIScreen mainScreen].bounds.size.width;
        }
    } else {
        if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0) {
            //            if ([UIApplication sharedApplication].statusBarFrame.size.height>20) {
            //                return [UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale-20;
            //            }
            //            UIScreen *SCR = [UIScreen mainScreen];
            screenHeight = [UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale;
        } else {
#ifndef TARGET_IS_EXTENSION
            if ([UIApplication sharedApplication].statusBarFrame.size.height>20) {
                screenHeight = [UIScreen mainScreen].bounds.size.height-20;
            }
#endif
            screenHeight = [UIScreen mainScreen].bounds.size.height;
        }
    }
    return screenHeight;
}

+ (NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (model A1456, A1532 | GSM)";
    
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (model A1507, A1516, A1526 (China), A1529 | Global)";
    
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (model A1433, A1533 | GSM)";
    
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (model A1457, A1518, A1528 (China), A1530 | Global)";
    
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"])    return @"iPhone 7 plus";
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch (1 Gen)";
    
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch (2 Gen)";
    
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch (3 Gen)";
    
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch (4 Gen)";
    
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([platform isEqualToString:@"iPod7,1"])      return @"iPod Touch (6 Gen)";
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    
    if ([platform isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPad4,1"])      return  @"iPad Air - Wifi";
    
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air - Cellular";
    
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])      return  @"iPad Mini2 - Wifi";
    
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini2 - Cellular";
    
    if ([platform isEqualToString:@"iPad4,6"])      return  @"iPad Mini2";
    
    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad Mini3";
    
    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad Mini3";
    
    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad Mini3";
    
    if ([platform isEqualToString:@"iPad5,1"])      return  @"iPad Mini4";
    
    if ([platform isEqualToString:@"iPad5,2"])      return @"iPad Mini4";
    
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air2";
    
    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air2";
    
    if ([platform isEqualToString:@"iPad6,7"])      return @"iPad Pro";
    
    if ([platform isEqualToString:@"iPad6,8"])      return @"iPad Pro";
    
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    
    return platform;
}

+(NSArray *)regionPlist
{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"regions" ofType:@"plist"];
    NSArray * pList = (NSArray*)[NSPropertyListSerialization propertyListWithData:[[NSFileManager defaultManager] contentsAtPath:path] options:NSPropertyListImmutable format:nil error:nil];
    return pList;
}

+(UIView *)showHUDAddedTo:(UIView *)view animated:(BOOL)animated
{
    if (animated == NO) {
        [[LoadingView sharedLoading] removeFromSuperview];
    }else{
        if (view) {
            [view addSubview:[LoadingView sharedLoading]];
            [[LoadingView sharedLoading] runAnimation];
            [[LoadingView sharedLoading] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(view);
            }];
        }
    }
    return view;
}

+(void)showHUDAddedTo:(UIView *)view
{
    if (view) {
        LoadingView *load = [LoadingView sharedLoading];
        if(load.constraints.count){
            [load removeFromSuperview];
        }
        [view addSubview:load];
        [load mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        [load runAnimation];
    }
}

+(void)hiddenHUDFromSuperview
{
    [[LoadingView sharedLoading] removeFromSuperview];
}

// 是否wifi
+ (BOOL) IsEnableWIFI {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

// 是否3G
+ (BOOL) IsEnable3G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}
//判断网络是否存在
+(BOOL)isExistenceNetwork
{
    BOOL isExistenceNetwork = YES;
    Reachability * network = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    switch ([network currentReachabilityStatus])
    {
        case NotReachable:
            isExistenceNetwork=NO;
            break;
        case ReachableViaWWAN:

            isExistenceNetwork=YES;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork=YES;
            break;
    }

    return isExistenceNetwork;

}


//获取设备xib
+ (id)loadNibName:(NSString *)name
{
#ifdef UNIVERSAL_DEVICES
    return [[[NSBundle mainBundle] loadNibNamed:[self deviceNibName:name] owner:NULL options:NULL] objectAtIndex:0];
#else
    return [[[NSBundle mainBundle] loadNibNamed:name owner:NULL options:NULL] objectAtIndex:0];
#endif
}

+ (id)loadStoryboardName:(NSString *)name ViewName:(NSString*)viewname
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:name bundle:nil];
    return  [storyBoard instantiateViewControllerWithIdentifier:viewname];
}

//评论中用户的名字会调这个方法，1，列表展示的时候  2，点击发送按钮，产生一个本地的评论数据展示的时候  3，真正发送成功之后展示的时候
+ (NSString*)usernameForNickname:(NSString*)nickname userName:(NSString*)userName
{
    if (nickname && nickname.length)
    {
        return nickname;
    }
    else
    {
        if (userName && userName.length)
        {
            if ([Tools isValidateEmail:userName])
            {
                return [userName substringToIndex:[userName rangeOfString:@"@"].location];
            }
            else if (userName.length >= 5)
            {
                return [NSString stringWithFormat:@"%@****%@", [userName substringToIndex:3], [userName substringFromIndex:userName.length-4]];
            }
            else
            {
                return NSLocalizedString(@"煮米", @"Nickname");
            }
        }
    }
    
    return NSLocalizedString(@"煮米", @"Tools");
}

//+(NSDate *)currentDate
//{
//    NSDate *currentDate = [NSDate date];
//    if([DDCUserDefaults valueForKey:@"timeGap"]&&[[DDCUserDefaults valueForKey:@"timeGap"] length])
//    {
//        float timeGap = [[DDCUserDefaults valueForKey:@"timeGap"] doubleValue];
//        return [currentDate dateByAddingTimeInterval:timeGap];
//    }
//    else
//    {
//        return currentDate;
//    }
//}

#ifndef TARGET_IS_EXTENSION

//获取MAC地址
+ (NSString *)getMacAddress
{
    return [DDC_NetWork getMacAddress];
}

//获取网络运营商的名称
+ (NSString *)getCellularProvider
{
    return [DDC_NetWork getCellularProvider];
}

//判断当前连接的网络状态
+(NSString *)getNetWorkState
{
    return [DDC_NetWork getNetWorkState];
}

// 获取应用在本机设置中是否关闭通知
+(BOOL)isAllowedNotification {
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (UIUserNotificationTypeNone != setting.types) {
        return YES;
    }
    return NO;
}
#endif
#endif

// 毫秒转化成日期格式
+(NSString *)getConversionTime:(NSString *)timeStr{
    
    NSTimeInterval timeInterval = [timeStr doubleValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return  [formatter stringFromDate:date];
    
}

// 从字符串中获取字数个数为N的字符串，单字节字符占半个字数，双字节占一个字数
+ (NSString *)getSubString:(NSString *)strSource WithCharCounts:(NSInteger)number
{
    // 一个字符以内，不处理
    if (strSource == nil || [strSource length] <= 1) {
        return strSource;
    }
    char *pchSource = (char *)[strSource cStringUsingEncoding:NSUTF8StringEncoding];
    NSInteger sourcelen = strlen(pchSource);
    int nCharIndex = 0;		// 字符串中字符个数,取值范围[0, [strSource length]]
    int nCurNum = 0;		// 当前已经统计的字数
    for (int n = 0; n < sourcelen; ) {
        if( *pchSource & 0x80 ) {
            if ((nCurNum + 2) > number * 2) {
                break;
            }
            pchSource += 3;		// NSUTF8StringEncoding编码汉字占３字节
            n += 3;
            nCurNum += 2;
        }
        else {
            if ((nCurNum + 1) > number * 2) {
                break;
            }
            pchSource++;
            n += 1;
            nCurNum += 1;
        }
        nCharIndex++;
    }
    assert(nCharIndex > 0);
    return [strSource substringToIndex:nCharIndex];
}

+(NSString *) getStringFromArray:(NSArray *)srcArray byCharacter:(NSString *)character
{
    NSMutableString *mutabString = [[NSMutableString alloc] init];
    int i = 0;
    if (srcArray.count > 0)
    {
        for (i = 0; i < srcArray.count-1; i++)
        {
            [mutabString appendFormat:@"%@%@",[srcArray objectAtIndex:i],character];
        }
        [mutabString appendString:[srcArray objectAtIndex:i]];
    }
    return mutabString;
}

// 比较两个时间差
+(NSString*)timestamp:(NSString*)dateTimeStr lastDateTimeStr:(NSString *)lastDateTime
{
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSCalendar *cal=[NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)] ? [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] : [NSCalendar currentCalendar];
    unsigned int unitFlags=NSCalendarUnitYear| NSCalendarUnitMonth| NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *d = [cal components:unitFlags fromDate:[date dateFromString:dateTimeStr] toDate:[date dateFromString:lastDateTime] options:0];
    DLog(@"*****************----------------%ld 年%ld 月%ld天%ld小时%ld分钟%ld秒",(long)[d year],(long)[d month],(long)[d day],(long)[d hour],(long)[d minute],(long)[d second]);
    
    //    //将传入时间转化成需要的格式
    //    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    //    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSDate *fromdate = [format dateFromString:dateTimeStr];
    //    NSDate *lfromdate = [format dateFromString:lastDateTime];
    //
    //    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    //
    //    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    //    NSInteger lfrominterval = [fromzone secondsFromGMTForDate:lfromdate];
    //
    //    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    //    NSDate *localeDate = [lfromdate  dateByAddingTimeInterval: lfrominterval];
    //
    //    double intervalTime = [localeDate timeIntervalSinceReferenceDate] - [fromDate timeIntervalSinceReferenceDate];
    //
    //    long lTime = (long)intervalTime;
    //    NSInteger iSeconds = lTime % 60;
    //    NSInteger iMinutes = (lTime / 60) % 60;
    //    NSInteger iHours = (lTime / 3600);
    //    NSInteger iDays = lTime/86400;///60/60/24
    //    NSInteger iMonth = lTime/1036800;//60/60/24/12
    //    NSInteger iYears = lTime/60/60/24/384;
    //
    //     DLog(@"相差%ld年%ld月 %ld日%ld时%ld分%ld秒", (long)iYears,(long)iMonth,(long)iDays,(long)iHours,(long)iMinutes,(long)iSeconds);
    
    //    if(){
    //
    //        return [NSString stringWithFormat:@"%ld年前",(long)[d year]];
    //
    //    }else if(){
    //        return [NSString stringWithFormat:@"%ld个月前",(long)[d month]];
    //    }else if([d day]>=7){
    //        if ([d day] ==7) {
    //            return @"1周前";
    //        }
    //        return [NSString  stringWithFormat:@"%ld周前",(long)[d day]/7];
    //    }else
    if([d month]>0 || [d day]>=7 || [d day]>0){
        NSArray *ary1 = [dateTimeStr componentsSeparatedByString:@" "];
        NSArray *ary2 = [[ary1 objectAtIndex:0] componentsSeparatedByString:@"-"];
        NSArray *ary3 = [[ary1 objectAtIndex:1] componentsSeparatedByString:@":"];
        NSString *timeStr = [NSString stringWithFormat:@"%@/%@ %@:%@",[ary2 objectAtIndex:1],[ary2 objectAtIndex:2],[ary3 objectAtIndex:0],[ary3 objectAtIndex:1]];
        return timeStr;
    }else
        if([d hour]>0){
            //        if ([d hour] <= 24) {
            return [NSString  stringWithFormat:@"%ld %@",(long)[d hour],NSLocalizedString(@"小时前", @"时间格式")];
            //        }
            //        else{
            
            //        }
        }else if([d minute]>0){
            return [NSString  stringWithFormat:@"%ld ",(long)[d minute],NSLocalizedString(@"分钟前", @"时间格式")];
        }else{
            
            //        if([d second] > 0){
            //        return [NSString  stringWithFormat:@"%ld秒前",(long)[d second]];
            //    }else {
            return NSLocalizedString(@"刚刚", @"时间格式");
        }
    
    return nil;
}
+(NSString*)getDaysFromDates:(NSString*)dateTimeStr lastDateTimeStr:(NSString *)lastDateTime{
    //将传入时间转化成需要的格式
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *fromdate = [format dateFromString:dateTimeStr];
    NSDate *lfromdate = [format dateFromString:lastDateTime];
    
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSInteger lfrominterval = [fromzone secondsFromGMTForDate:lfromdate];
    
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    NSDate *localeDate = [lfromdate  dateByAddingTimeInterval: lfrominterval];
    
    double intervalTime = [localeDate timeIntervalSinceReferenceDate] - [fromDate timeIntervalSinceReferenceDate];
    
    long lTime = (long)intervalTime;
    NSInteger iDays = lTime/60/60/24;
    
    // DLog(@"相差%d年%d月 %d日%d时%d分%d秒", iYears,iMonth,iDays,iHours,iMinutes,iSeconds);
    if(iDays>0){
        return [NSString  stringWithFormat:@"%ld",(long)(long)iDays];
    }
    return nil;
    
}
+ (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

+(NSString*)getCurrentDateWithSystemLocalZone{
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}


+(NSString*)getUuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString); return result;
}

+(BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)] ? [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] : [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

//判断是否为邮箱
+ (BOOL)isEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(BOOL)isBlankString:(NSString *)string{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
    
}

+ (NSDecimalNumber *)roundFloat:(NSString *)num decimalPlace:(int)decimalPlace
{
    //    NSString *numStr = [NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:num]];
    
    return [Tools roundFloat:num withRoundingMode:NSRoundBankers decimalPlace:decimalPlace];
}

+ (NSDecimalNumber *)roundFloat:(NSString *)num withRoundingMode:(NSRoundingMode)mode decimalPlace:(int)decimalPlace
{
    NSDecimalNumber *numResult = [NSDecimalNumber decimalNumberWithString:num];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:mode
                                                                                             scale:decimalPlace
                                                                                  raiseOnExactness:NO
                                                                                   raiseOnOverflow:NO
                                                                                  raiseOnUnderflow:NO
                                                                               raiseOnDivideByZero:YES];
    return [numResult decimalNumberByRoundingAccordingToBehavior:roundUp];
}

+ (NSString *)stringFloat:(NSString *)num decimalPlace:(int)decimalPlace
{
    NSDecimalNumber *numResult = [NSDecimalNumber decimalNumberWithString:num];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                                                                             scale:decimalPlace
                                                                                  raiseOnExactness:NO
                                                                                   raiseOnOverflow:NO
                                                                                  raiseOnUnderflow:NO
                                                                               raiseOnDivideByZero:YES];
    NSDecimalNumber *roundedOunces = [numResult decimalNumberByRoundingAccordingToBehavior:roundUp];
    //如果是整数，小数点后也要保持两位
    NSString* string = [NSString stringWithFormat:@"%@",roundedOunces];
    if ([string rangeOfString:@"."].length==0) {
        string=  [string stringByAppendingString:@".00"];
    }else{
        NSRange range = [string rangeOfString:@"."];
        if (string.length-range.location-1==2) {
        }else{
            string = [string stringByAppendingString:@"0"];
        }
    }
    return string;
}

+ (BOOL)isThisVersionIdentifierFirstLaunch:(NSString *)identifier
{
    BOOL launched = [[DDCUserDefaults objectForKey:identifier] boolValue];
    if (!launched) {
        [DDCUserDefaults setBool:YES forKey:identifier];
        [DDCUserDefaults synchronize];
    }
    return !launched;
}

+ (BOOL)isValidUrl:(NSString *)string
{
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:string];
}

//转换成时间格式
+ (NSString *)convertPlayTime:(NSTimeInterval)second
{
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setDateFormat:@"mm:ss"];
    NSString *showTime = [formatter stringFromDate:currentDate];
    return showTime;
}

//过滤Html标签
+(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //替换双引号
    html= [html stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"\""];
    html= [html stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"\""];
    //替换空格占位符
    html= [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    
    return html;
}

@end
