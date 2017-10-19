//
//  DDCW_APICallManager.m
//  DayDayCook
//
//  Created by Christopher Wood on 3/17/16.
//  Copyright © 2016 GFeng. All rights reserved.
//

#import "DDCW_APICallManager.h"
#import "AFURLSessionManager.h"
#import "DDCSecurityAPIManager.h"
#import "MF_Base64Additions.h"
#import "DDCW_RequestFactory.h"
#import "SecurityUtil.h"

#if !TARGET_OS_WATCH
#import <UIKit/UIKit.h>
#import "Tools.h"
#endif

#if DDC_SEC == 1
static dispatch_queue_t ddc_request_processing_queue()
{
    static dispatch_queue_t p;//ddc_request_processing_queue
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        p = dispatch_queue_create("com.daydaycook.networking.request.processing", DISPATCH_QUEUE_SERIAL);
    });
    return p;
}
#endif

#pragma mark - APICallManager -
@implementation DDCW_APICallManager


#pragma mark Calls
// 对外开放，默认tries等于2
+(void)callWithURLString:(NSString *)url
                    type:(NSString *)type
                  params:(NSDictionary *)params
    andCompletionHandler:(void (^)(BOOL, NSNumber *, id, NSError *))completionHandler
{
    [self callWithURLString:url type:type params:params cacheParams:nil tries:2 andCompletionHandler:completionHandler];
}

// 对外开放，使用缓存的请求方法
+(void)callWithURLString:(NSString*)url
                    type:(NSString*)type
                  params:(NSDictionary*)params
             cacheParams:(NSDictionary*)cacheParams
    andCompletionHandler:(void (^)(BOOL isSuccess, NSNumber * code, id responseObj, NSError *err))completionHandler
{
    [self callWithURLString:url type:type params:params cacheParams:cacheParams tries:2 andCompletionHandler:completionHandler];
}

// private (不对外开放）
+(void)callWithURLString:(NSString*)url
                    type:(NSString*)type
                  params:(NSDictionary*)params
             cacheParams:(NSDictionary *)cacheParams
                   tries:(int)tries
    andCompletionHandler:(void (^)(BOOL isSuccess, NSNumber * code, id responseObject, NSError *err))completionHandler
{

// 进入队列
#if DDC_SEC == 1
    dispatch_async(ddc_request_processing_queue(), ^{
        
        if (!DDC_Share_AccessToken)
        {
            // will block thread
            [self updateAccessToken];
        }
        
        NSURLRequest * request = [DDCW_RequestFactory createRequestForUrl:url type:type params:params cacheParams:cacheParams useSafety:YES];
        
        [self sendRequest:request withNumberOfTries:tries usingCache:(cacheParams != nil) securityStatus:RequestSecurityStatusNormal securityRecallFunc:^(){
            [self callWithURLString:url type:type params:params cacheParams:cacheParams tries:(tries-1) andCompletionHandler:completionHandler];
        } completionHandler:completionHandler];
    });
#else
    NSURLRequest * request = [DDCW_RequestFactory createRequestForUrl:url type:type params:params cacheParams:cacheParams useSafety:YES];
    [self sendRequest:request withNumberOfTries:tries usingCache:(cacheParams != nil) securityStatus:RequestSecurityStatusNormal securityRecallFunc:nil completionHandler:completionHandler];
#endif
}

#pragma mark - Send Request
+(void)sendRequest:(NSURLRequest*)request withNumberOfTries:(int)tries usingCache:(BOOL)usingCache securityStatus:(RequestSecurityStatus)secStatus securityRecallFunc:(void(^)())securityRecallFunc completionHandler:(void (^)(BOOL isSuccess, NSNumber * code, id responseObject, NSError *err))completionHandler
{
    if (tries <= 0)
    {
        DLog(@"No more tries %@", request.URL.absoluteString);
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(NO, @666, nil, [NSError errorWithDomain:NSURLErrorDomain code:666 userInfo:@{@"msg":@"网络异常"}]);
        });
        return;
    }
    
    __block int triesLeft = tries;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    ((AFHTTPResponseSerializer*)manager.responseSerializer).acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    
    // 缓存数据
    __block BOOL cacheReturned = NO;
    
    // 缓存
//    if (usingCache)
//    {
//        [self manager:manager returnCacheForRequest:request completionHandler:completionHandler cacheCallback:^(BOOL returnedCache) {
//            cacheReturned = returnedCache;
//        }];
//    }
    
    // 发请求
    __block NSURLSessionDataTask * dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        triesLeft -= 1;
        
        // 获取code
        NSNumber * code = [self codeForResponseObject:responseObject];
        // 确认请求没有失败
        if ([self hasAuthErrorCode:code securityRecallFunc:securityRecallFunc completionHandler:completionHandler])
        {
            [manager invalidateSessionCancelingTasks:YES];
            return;
        }
        else if ([self hasVersionErrorCode:code completionHandler:completionHandler])
        {
            [manager invalidateSessionCancelingTasks:YES];
            return;
        }
        
        if (error || !responseObject) {
            
            // 再试一遍
            if (triesLeft > 0)
            {
#if !TARGET_OS_WATCH
                if ([Tools isExistenceNetwork])
                {
                    [self sendRequest:request withNumberOfTries:triesLeft usingCache:usingCache securityStatus:secStatus securityRecallFunc:securityRecallFunc completionHandler:completionHandler];
                    return;
                }
#else
                [self sendRequest:request withNumberOfTries:triesLeft usingCache:usingCache securityStatus:secStatus securityRecallFunc:securityRecallFunc completionHandler:completionHandler];
                return;
#endif
            }
            
            // 如果缓存已经返回了数据，不返回空数据，避免有缓存但还显示没有网络页的情况
            if (cacheReturned)
            {
                [manager invalidateSessionCancelingTasks:YES];
                return;
            }
            
            // 请求失败了
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(false, code, nil, error);
                [manager invalidateSessionCancelingTasks:YES];
            });
            return;
        
        } else {
            
            // 请求成功，返回数据
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(true, code, responseObject, nil);
                [manager invalidateSessionCancelingTasks:YES];
            });
        }
    }];
    
    [dataTask resume];
}

//#if DDC_SEC == 1
// 更新安全机制的access token
+(void)updateAccessToken
{
    dispatch_semaphore_t ddc_security_sem = dispatch_semaphore_create(0);
    [DDCSecurityAPIManager refreshSecurityWithCompletionHandler:^(BOOL success) {
        dispatch_semaphore_signal(ddc_security_sem);
    }];
    dispatch_semaphore_wait(ddc_security_sem, DISPATCH_TIME_FOREVER);
}
//#endif

//// 返回缓存
//+(void)manager:(AFURLSessionManager*)manager returnCacheForRequest:(NSURLRequest*)request completionHandler:(void (^)(BOOL isSuccess, NSNumber * code, id responseObject, NSError *err))completionHandler cacheCallback:(void(^)(BOOL returnedCache))cacheCallback;
//{
//    [manager setDataTaskWillCacheResponseBlock:^NSCachedURLResponse * _Nonnull(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSCachedURLResponse * _Nonnull proposedResponse) {
//        
//        return [[NSCachedURLResponse alloc] initWithResponse:proposedResponse.response data:proposedResponse.data userInfo:proposedResponse.userInfo storagePolicy:NSURLCacheStorageAllowed];
//    }];
//    
//    NSMutableURLRequest * cachedRequest = [request mutableCopy];
//    cachedRequest.cachePolicy = NSURLRequestReturnCacheDataDontLoad;
//    
//    NSURLSessionTask * cachedTask = [manager dataTaskWithRequest:cachedRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        
//        // 获取code
//        NSNumber * code = [self codeForResponseObject:responseObject];
//        
//        if (error || !responseObject || [[self authErrorCodes] containsObject:code])
//        {
//#if !TARGET_OS_WATCH
//            // 没有网络
//            if (![Tools isExistenceNetwork]) {
//                
//                cacheCallback(YES);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    completionHandler(false, nil, nil, error);
//                });
//            }
//#endif
//            // 如果有网络但没有缓存，就直接return，不调用block，不改cacheReturned - 等数据请求返回
//            return;
//        }
//        else
//        {
//            // 返回缓存
//            cacheCallback(YES);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                completionHandler(true, code, responseObject, nil);
//            });
//        }
//    }];
//    
//    // 先返回缓存，后来发请求
//    [cachedTask resume];
//}

#pragma mark - Error Handling
// 获取code
+(NSNumber*)codeForResponseObject:(id)responseObject
{
    NSNumber * code;
    if ([responseObject isKindOfClass:[NSDictionary class]] && responseObject[@"code"])
    {
        if ([responseObject[@"code"] isKindOfClass:[NSString class]])
        {
            NSString * codeStr = responseObject[@"code"];
            code = @(codeStr.integerValue);
        }
        else if ([responseObject[@"code"] isKindOfClass:[NSNumber class]])
        {
            code = responseObject[@"code"];
        }
    }
    return code;
}

// 所有安全机制相关的错误编码
+(NSSet *)authErrorCodes
{
    return [NSSet setWithArray:@[@4010, // 已过期，请重新验证（30分钟）
                                 @4020, // 无效访问  注：如参数信息不完整
                                 @4050, // 无授权
                                 @4060  // 无法解析   注：无法解析请求参数信息
                                ]];
}

// 有安全机制错误编码
+(BOOL)hasAuthErrorCode:(NSNumber*)code securityRecallFunc:(void(^)())securityRecallFunc completionHandler:(void (^)(BOOL isSuccess, NSNumber * code, id responseObject, NSError *err))completionHandler
{
#if DDC_SEC == 1
    // 处理AUTH错误
    if ([[self authErrorCodes] containsObject:code])
    {
        // 每次发现accessToken过期了或没有accessToken会去更新accessToken 因为可能有很多请求都报错了，并且ddc_request_processing_queue会block，所以可能会有很多accessToken请求在这里排队 如果没有判断accessToken是否已经更新过，可能会有很多重复请求，accessToken不断的更新
        __block NSString * accessToken = DDC_Share_AccessToken;
        dispatch_async(ddc_request_processing_queue(), ^{
            if ([accessToken isEqualToString: DDC_Share_AccessToken])
            {
                // will block thread
                [self updateAccessToken];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (securityRecallFunc)
                {
                    securityRecallFunc();
                }
                else
                {
                    NSError * err = [NSError errorWithDomain:NSURLErrorDomain code:code.integerValue userInfo:@{@"msg":@"网络异常"}];
                    completionHandler(NO, code, nil, err);
                }
            });
        });
        return YES;
    }
#endif
    return NO;
}

 // 版本太低了
+(BOOL)hasVersionErrorCode:(NSNumber*)code completionHandler:(void (^)(BOOL isSuccess, NSNumber * code, id responseObject, NSError *err))completionHandler
{
    if ([code  isEqual: @402])
    {
        NSError * err = [NSError errorWithDomain:@"error" code:402 userInfo:@{@"error":@"Need Update!"}];
        completionHandler(false, @402, nil, err);
        return YES;
    }
    return NO;
}

@end


#pragma mark - Security -
@implementation DDCW_APICallManager (Security)
+(void)accessTokenCallWithURLString:(NSString*)url
                       encryptedKey:(NSString*)key
               andCompletionHandler:(void(^)(BOOL isSuccess, NSNumber * code, id responseObj, NSError *err))completionHandler
{
    NSURLRequest * request = [DDCW_RequestFactory createAccessTokenRequestForUrl:url key:key];
    [self sendRequest:request withNumberOfTries:2 usingCache:NO securityStatus:RequestSecurityStatusNoSecurity securityRecallFunc:nil completionHandler:completionHandler];
}

+(void)securityCallWithURLString:(NSString*)url
                            type:(NSString*)type
                          params:(NSDictionary*)params
                  securityStatus:(RequestSecurityStatus)secStatus
            andCompletionHandler:(void(^)(BOOL isSuccess, NSNumber * code, id responseObj, NSError *err))completionHandler
{
    
    NSURLRequest * request = [DDCW_RequestFactory createRequestForUrl:url type:type params:params cacheParams:nil useSafety:(secStatus == RequestSecurityStatusNormal)];
    [self sendRequest:request withNumberOfTries:2 usingCache:NO securityStatus:secStatus securityRecallFunc:nil completionHandler:completionHandler];
}

@end

#pragma mark - Data - 
// 图片和别的数据量比较大的请求方法
@implementation DDCW_APICallManager (Data)

+(void)callForDataWithURL:(NSURL*)url type:(NSString*)type completionHandler:(void(^)(BOOL isSuccess, id responseObject, NSError*err))completionHandler
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    AFHTTPResponseSerializer * serializer = [[AFHTTPResponseSerializer alloc] init];
    //    serializer.readingOptions = NSJSONReadingAllowFragments | NSJSONReadingMutableContainers;
    serializer.acceptableContentTypes = [NSSet setWithArray:@[@"image/jpeg", @"image/png",@"image/gif", @"video/mp4"]];
    manager.responseSerializer = serializer;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:type];
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%llu",(unsigned long long)timeInterval];
    NSString *signature = [SecurityUtil encryptMD5String:[NSString stringWithFormat:@"%@%@",MD5_AUTH_KEY,timestamp]];
    [request setValue:signature forHTTPHeaderField:@"signature"];
    [request setValue:timestamp forHTTPHeaderField:@"timestamp"];
    [request setValue:@"1" forHTTPHeaderField:@"device"];
    
    DLog(@"*** OBJECT FETCH **** %@", url.absoluteString);
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            completionHandler(false, nil, error);
        } else {
            if (!responseObject)
            {
                completionHandler(true, nil, nil);
            }
            else
            {
                completionHandler(true, responseObject, nil);
            }
        }
    }];
    [dataTask resume];
}

+(void)callForImageWithURL:(NSURL*)url
                      type:(NSString*)type
      andCompletionHandler:(void (^)(BOOL isSuccess, id responseObject, NSError *err))completionHandler
{
    [self callForDataWithURL:url type:type completionHandler:completionHandler];
}

@end
