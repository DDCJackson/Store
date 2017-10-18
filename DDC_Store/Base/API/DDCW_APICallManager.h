//
//  DDCW_APICallManager.h
//  DayDayCook
//
//  Created by Christopher Wood on 3/17/16.
//  Copyright © 2016 GFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RequestSecurityStatus)
{
    RequestSecurityStatusNormal,            // 正常的请求（会带安全部分，会进入请求队列）
    RequestSecurityStatusIsSecurityRequest, // 安全机制相关的请求 (会block请求队列)
    RequestSecurityStatusNoSecurity         // 不用access_token或加密的请求 (不判断有没有access token, 不加密，不进入请求队列)
};

#pragma mark - APICallManager - 
@interface DDCW_APICallManager : NSObject

// 没有使用缓存的请求方法
+(void)callWithURLString:(NSString*)url
                    type:(NSString*)type
                  params:(NSDictionary*)params
    andCompletionHandler:(void (^)(BOOL isSuccess, NSNumber * code, id responseObj, NSError *err))completionHandler;

// 使用缓存的请求方法
+(void)callWithURLString:(NSString*)url
                    type:(NSString*)type
                  params:(NSDictionary*)params
             cacheParams:(NSDictionary*)cacheParams
    andCompletionHandler:(void (^)(BOOL isSuccess, NSNumber * code, id responseObj, NSError *err))completionHandler;

@end

#pragma mark - Security -
@interface DDCW_APICallManager (Security)

// 只用获取accessTokenId
+(void)accessTokenCallWithURLString:(NSString*)url
                       encryptedKey:(NSString*)key
               andCompletionHandler:(void(^)(BOOL isSuccess, NSNumber * code, id responseObj, NSError *err))completionHandler;

// 特色安全需求
+(void)securityCallWithURLString:(NSString*)url
                            type:(NSString*)type
                          params:(NSDictionary*)params
                  securityStatus:(RequestSecurityStatus)secStatus
            andCompletionHandler:(void(^)(BOOL isSuccess, NSNumber * code, id responseObj, NSError *err))completionHandler;

@end

#pragma mark - Data -
@interface DDCW_APICallManager (Data)

// 加载NSData类型的数据 （需要UIImage类型可以用useImageSerializer等于YES或callForImageWithURL方法）
+(void)callForDataWithURL:(NSURL*)url
                     type:(NSString*)type
        completionHandler:(void(^)(BOOL isSuccess, id responseObject, NSError*err))completionHandler;

// 因为watch没有sd_image SDK，所以用这个方法获取所有的图片
// Deprecated
+(void)callForImageWithURL:(NSURL*)url
                      type:(NSString*)type
      andCompletionHandler:(void (^)(BOOL isSuccess, id responseObj, NSError *err))completionHandler;

@end
