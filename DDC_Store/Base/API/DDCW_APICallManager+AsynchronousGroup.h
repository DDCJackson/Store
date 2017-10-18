//
//  DDCW_APICallManager+AsynchronousGroup.h
//  DayDayCook
//
//  Created by sunlimin on 2017/5/24.
//  Copyright © 2017年 GFeng. All rights reserved.
//

#import "DDCW_APICallManager.h"

@interface DDCW_APICallManager (AsynchronousGroup)

/**
 特色安全需求 异步队列

 @param url 请求接口地址
 @param type HTTP请求类型
 @param params 请求参数
 @param secStatus 安全机制
 @param requestGroup 需要加入的队列
 @param completionHandler 回调方法
 */
+(void)dispatchSecurityCallWithURLString:(NSString*)url
                            type:(NSString*)type
                          params:(NSDictionary*)params
                  securityStatus:(RequestSecurityStatus)secStatus
                    requestGroup:(id)requestGroup
              andCompletionHandler:(void(^)(BOOL isSuccess, NSNumber * code, id responseObj, NSError *err))completionHandler;

/**
 不使用缓存的请求 异步队列

 @param url 请求接口地址
 @param type HTTP请求类型
 @param params 请求参数
 @param requestGroup 需要加入的队列
 @param completionHandler 回调方法
 */
+(void)dispatchCallWithURLString:(NSString*)url
                    type:(NSString*)type
                  params:(NSDictionary*)params
            requestGroup:(id)requestGroup
         andCompletionHandler:(void(^)(BOOL isSuccess, NSNumber * code, id responseObj, NSError *err))completionHandler;

/**
 使用缓存的请求方法 异步队列

 @param url 请求接口地址
 @param type HTTP请求类型
 @param params 请求参数
 @param cacheParams 缓存参数
 @param requestGroup 需要加入的队列
 @param completionHandler 回调方法
 */
+ (void)dispatchCallWithURLString:(NSString*)url
                    type:(NSString*)type
                  params:(NSDictionary*)params
             cacheParams:(NSDictionary*)cacheParams
            requestGroup:(id)requestGroup
       andCompletionHandler:(void(^)(BOOL isSuccess, NSNumber * code, id responseObj, NSError *err))completionHandler;

@end
