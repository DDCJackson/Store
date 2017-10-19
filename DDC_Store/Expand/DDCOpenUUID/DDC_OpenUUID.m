//
//  DDC_OpenUUID.m
//  DayDayCook
//
//  Created by 张秀峰 on 2017/2/15.
//  Copyright © 2017年 GFeng. All rights reserved.
//

#import "DDC_OpenUUID.h"
//#import "DDC_KeyChain.h"
//#if TARGET_OS_WATCH
//#import "DDCW_WatchSessionManager.h"
//#else
//#import "AppDelegeteAPIManager.h"
//#endif

static NSString * kOpenUUIDSessionCache = nil;
static NSString * const kUUIDInSerice = @"app.daydaycook.uuid.service";
//static NSString * const kAppService = @"app.daydaycook.service";
//static NSString * const kUUID = @"app.daydaycook.uuid";
static NSString * const kOpenUUIDDomain = @"app.daydaycook.OpenUDID";

@implementation DDC_OpenUUID


+ (NSString *)randomUUID {
    if(NSClassFromString(@"NSUUID")) { // only available in iOS >= 6.0
        return [[NSUUID UUID] UUIDString];
    }
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef cfuuid = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
    CFRelease(uuidRef);
    NSString *uuid = [((__bridge NSString *) cfuuid) copy];
    CFRelease(cfuuid);
    return uuid;
}


+ (NSString *)value
{
    return [DDC_OpenUUID valueWithError:nil];
}

+ (NSString *)valueWithError:(NSError **)error
{
    if (kOpenUUIDSessionCache && kOpenUUIDSessionCache.length) {
        if (error!=nil)
            *error = [NSError errorWithDomain:kOpenUUIDDomain
                                         code:kOpenUUIDErrorNone
                                     userInfo:@{@"description": @"OpenUUID in cache from first call"}];
        return kOpenUUIDSessionCache;
    }
    
//    DDCUserDefaults *userDefaults = [DDCUserDefaults ];
//    kOpenUUIDSessionCache = [userDefaults objectForKey:kUUID];
//    if (!kOpenUUIDSessionCache || !kOpenUUIDSessionCache.length) {
//        kOpenUUIDSessionCache = [[NSString alloc] initWithData:[DDC_KeyChain loadWithService:kAppService] encoding:NSUTF8StringEncoding];
//        if (!kOpenUUIDSessionCache || !kOpenUUIDSessionCache.length) {
//            kOpenUUIDSessionCache = [DDC_OpenUUID randomUUID];
//            [userDefaults setObject:kOpenUUIDSessionCache forKey:kUUID];
//            [userDefaults synchronize];
//            [DDC_KeyChain saveWithService:kAppService data:[kOpenUUIDSessionCache dataUsingEncoding:NSUTF8StringEncoding]];
//        }
//        [DDC_OpenUUID uploadDeviceInfoData];
//    }
    return [DDC_OpenUUID userDefault];
}


+ (NSString *)userDefault
{
    kOpenUUIDSessionCache =  [DDCUserDefaults objectForKey:DDC_Device_UUID_Key];//kOpenUUID
    if (!kOpenUUIDSessionCache || !kOpenUUIDSessionCache.length) {
        kOpenUUIDSessionCache = [DDC_OpenUUID randomUUID];
        [DDCUserDefaults setObject:kOpenUUIDSessionCache forKey:DDC_Device_UUID_Key];//kOpenUUID
        DDC_Share_UUID = kOpenUUIDSessionCache;

        [DDC_OpenUUID uploadDeviceInfoData];
    }else if(![DDCUserDefaults objectForKey:kUUIDInSerice]) {
         [DDC_OpenUUID uploadDeviceInfoData];
    }
    return kOpenUUIDSessionCache;
}


//+(NSUserDefaults *)uuid_standardUserDefaults
//{
//#if TARGET_OS_WATCH
//    return [NSUserDefaults standardUserDefaults];
//#else
//    return [[NSUserDefaults alloc] initWithSuiteName:@"group.com.daydaycook.com"];
//#endif
//}


+ (void)uploadDeviceInfoData
{
    static int i = 0;
//    if(!kOpenUUIDSessionCache){
//        [DDC_OpenUUID userDefault];
//        return;
//    }
//#if TARGET_OS_WATCH
//    [DDCW_WatchSessionManager uploadDeviceInfoDataWithSuccessHandler:^{
//        i = 0;
//        [DDCUserDefaults setObject:@"1" forKey:kUUIDInSerice];
//    } failHandler:^(NSError *error) {
//        [DDCUserDefaults setObject:nil forKey:kUUIDInSerice];
//        if (i< 3) {
//            [DDC_OpenUUID uploadDeviceInfoData];
//        }else if(i > 10){
//            return ;
//        }else{
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i*30 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//                [DDC_OpenUUID uploadDeviceInfoData];
//            });
//        }
//        i++;
//    }];
//#else
//    [AppDelegeteAPIManager uploadDeviceInfoDataWithSuccessHandler:^{
//        i = 0;
//        [DDCUserDefaults setObject:@"1" forKey:kUUIDInSerice];
//    } failHandler:^(NSError *error) {
//         [DDCUserDefaults setObject:nil forKey:kUUIDInSerice];
//        if (i< 3) {
//            [DDC_OpenUUID uploadDeviceInfoData];
//        }else if(i > 10){
//            return ;
//        }else{
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i*30 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//                 [DDC_OpenUUID uploadDeviceInfoData];
//            });
//        }
//        i++;
//    }];
//#endif
}




/*
 + (void)setValue:(NSString *)value forKey:(NSString *)key inService:(NSString *)service {
 NSMutableDictionary *keychainItem = [[NSMutableDictionary alloc] init];
 keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
 keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAlways;
 keychainItem[(__bridge id)kSecAttrAccount] = key;
 keychainItem[(__bridge id)kSecAttrService] = service;
 keychainItem[(__bridge id)kSecValueData] = [value dataUsingEncoding:NSUTF8StringEncoding];
 SecItemAdd((__bridge CFDictionaryRef)keychainItem, NULL);
 }
 */

/*
 + (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
 return [NSMutableDictionary dictionaryWithObjectsAndKeys:
 (id)kSecClassGenericPassword,(id)kSecClass,
 service, (id)kSecAttrService,
 service, (id)kSecAttrAccount,
 (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
 nil];
 }
 
 
 + (id)load:(NSString *)service {
 id ret = nil;
 NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
 //Configure the search setting
 //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
 [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
 [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
 CFDataRef keyData = NULL;
 if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
 @try {
 ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
 } @catch (NSException *e) {
 NSLog(@"Unarchive of %@ failed: %@", service, e);
 } @finally {
 }
 }
 if (keyData)
 CFRelease(keyData);
 return ret;
 }
 */

/*
 + (NSString *)valueForKey:(NSString *)key inService:(NSString *)service {
 
 id ret = nil;
 NSMutableDictionary *keychainQuery =  [NSMutableDictionary dictionaryWithObjectsAndKeys:
 (id)kSecClassGenericPassword,(id)kSecClass,
 service, (id)kSecAttrService,
 key, (id)kSecAttrAccount,
 (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
 nil];
 //Configure the search setting
 //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
 [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
 [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
 CFDataRef keyData = NULL;
 if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
 @try {
 ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
 } @catch (NSException *e) {
 NSLog(@"Unarchive of %@ failed: %@", service, e);
 } @finally {
 }
 }
 if (keyData)
 CFRelease(keyData);
 return ret;
 }
 */



@end
