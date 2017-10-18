//
//  DDCUserDefaults.m
//  DayDayCook
//
//  Created by 张秀峰 on 2017/6/6.
//  Copyright © 2017年 GFeng. All rights reserved.
//

#import "DDCUserDefaults.h"

@implementation DDCUserDefaults

+ (void)setObject:(id)object forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    DDC_UserDefaults_SetObject(object, key);
}

+ (void)setValue:(id)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    DDC_UserDefaults_SetValue(value, key);
}

+ (void)setValue:(id)value forKeyPath:(NSString *)keyPath
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKeyPath:keyPath];
    [DDC_UserDefaults setValue:value forKeyPath:keyPath];
}

+ (void)setBool:(BOOL)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    DDC_UserDefaults_SetBool(value, key);
}

+ (void)setInteger:(NSInteger)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
    DDC_UserDefaults_SetInteger(value, key);
}
     

+ (NSString *)stringForKey:(NSString *)key
{
    return DDC_UserDefaults_GetString(key);
}

+ (id)objectForKey:(NSString *)key
{
    return DDC_UserDefaults_GetObject(key);
}

+ (id)valueForKey:(NSString *)key
{
    return DDC_UserDefaults_GetValue(key);
}

+ (NSArray *)arrayForKey:(NSString *)key
{
    return DDC_UserDefaults_GetArray(key);
}


+ (void)removeObjectForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    DDC_UserDefaults_RemoveObject(key);
}

+ (void)removeAllUserDefaults
{
//    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
//    NSDictionary *dict = [defs dictionaryRepresentation];
//    for (id key in dict) {
//        [defs removeObjectForKey:key];
//    }
//    [defs synchronize];
    
    NSDictionary *dict = [DDC_UserDefaults dictionaryRepresentation];
    for (NSString *key in dict) {
        [DDC_UserDefaults removeObjectForKey:key];
    }
    [DDC_UserDefaults synchronize];
}

+ (void)synchronize
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [DDC_UserDefaults synchronize];
}

+ (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    [[NSUserDefaults standardUserDefaults] addObserver:observer forKeyPath:keyPath options:options context:context];
#if !TARGET_OS_WATCH
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.30) {
        [DDC_UserDefaults addObserver:observer forKeyPath:keyPath options:options context:context];
    }
#endif
}

+ (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context
{
    [[NSUserDefaults standardUserDefaults] removeObserver:observer forKeyPath:keyPath context:context];
#if !TARGET_OS_WATCH
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.30) {
        [DDC_UserDefaults removeObserver:observer forKeyPath:keyPath context:context];
    }
#endif
}

+ (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    [[NSUserDefaults standardUserDefaults] removeObserver:observer forKeyPath:keyPath];
#if !TARGET_OS_WATCH
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.30) {
        [DDC_UserDefaults removeObserver:observer forKeyPath:keyPath];
    }
#endif
}


@end
