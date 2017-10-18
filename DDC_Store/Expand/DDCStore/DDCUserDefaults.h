//
//  DDCUserDefaults.h
//  DayDayCook
//
//  Created by 张秀峰 on 2017/6/6.
//  Copyright © 2017年 GFeng. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "DDCStore.h"

#define DDC_UserDefaults [[NSUserDefaults alloc] initWithSuiteName:@"group.com.daydaycook.com"]
#define DDC_UserDefaults_SetObject(object, key) [DDC_UserDefaults setObject:object forKey:key]
#define DDC_UserDefaults_SetValue(value, key) [DDC_UserDefaults setValue:value forKey:key]
#define DDC_UserDefaults_SetBool(value, key) [DDC_UserDefaults setBool:value forKey:key]
#define DDC_UserDefaults_SetInteger(value, key) [DDC_UserDefaults setInteger:value forKey:key]
#define DDC_UserDefaults_GetObject(key) ([DDC_UserDefaults objectForKey:key]&&(![[DDC_UserDefaults objectForKey:key] isKindOfClass:[NSNull class]]))?[DDC_UserDefaults objectForKey:key]:[[NSUserDefaults standardUserDefaults] objectForKey:key]
#define DDC_UserDefaults_GetValue(key) ([DDC_UserDefaults valueForKey:key]&&(![[DDC_UserDefaults valueForKey:key] isKindOfClass:[NSNull class]]))?[DDC_UserDefaults valueForKey:key]:[[NSUserDefaults standardUserDefaults] valueForKey:key]
#define DDC_UserDefaults_GetString(key) ([DDC_UserDefaults stringForKey:key]&&(![[DDC_UserDefaults stringForKey:key] isKindOfClass:[NSNull class]]))?[DDC_UserDefaults stringForKey:key]:[[NSUserDefaults standardUserDefaults] stringForKey:key]
#define DDC_UserDefaults_GetArray(key) ([DDC_UserDefaults arrayForKey:key]&&(![[DDC_UserDefaults arrayForKey:key] isKindOfClass:[NSNull class]]))?[DDC_UserDefaults arrayForKey:key]:[[NSUserDefaults standardUserDefaults] arrayForKey:key]
#define DDC_UserDefaults_RemoveObject(key) [DDC_UserDefaults removeObjectForKey:key]

@interface DDCUserDefaults : NSObject

+ (void)setObject:(id)object forKey:(NSString *)key;

+ (void)setValue:(id)value forKey:(NSString *)key;

+ (void)setValue:(id)value forKeyPath:(NSString *)keyPath;

+ (void)setBool:(BOOL)value forKey:(NSString *)key;

+ (void)setInteger:(NSInteger)value forKey:(NSString *)key;

+ (NSString *)stringForKey:(NSString *)key;

+ (id)objectForKey:(NSString *)key;

+ (id)valueForKey:(NSString *)key;

+ (NSArray *)arrayForKey:(NSString *)key;

+ (void)removeObjectForKey:(NSString *)key;

+ (void)synchronize;

+ (void)removeAllUserDefaults;

+ (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;

+ (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context;

+ (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

@end
