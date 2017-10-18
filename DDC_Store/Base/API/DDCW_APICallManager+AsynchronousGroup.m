//
//  DDCW_APICallManager+AsynchronousGroup.m
//  DayDayCook
//
//  Created by sunlimin on 2017/5/24.
//  Copyright © 2017年 GFeng. All rights reserved.
//

#import "DDCW_APICallManager+AsynchronousGroup.h"

@implementation DDCW_APICallManager (AsynchronousGroup)

+(void)dispatchSecurityCallWithURLString:(NSString*)url
                            type:(NSString*)type
                          params:(NSDictionary*)params
                  securityStatus:(RequestSecurityStatus)secStatus
                    requestGroup:(id)requestGroup
              andCompletionHandler:(void(^)(BOOL isSuccess, NSNumber *code, id responseObj, NSError *error))completionHandler
{
    if (requestGroup) {
        dispatch_group_async(requestGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            
            [DDCW_APICallManager securityCallWithURLString:url type:type params:params securityStatus:secStatus andCompletionHandler:^(BOOL isSuccess, NSNumber *code, id responseObj, NSError *error)
             {
                 completionHandler(isSuccess, code, responseObj, error);
                 dispatch_semaphore_signal(semaphore);
             }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        });
    } else {
        [DDCW_APICallManager securityCallWithURLString:url type:type params:params securityStatus:secStatus andCompletionHandler:^(BOOL isSuccess, NSNumber *code, id responseObj, NSError *error)
         {
             completionHandler(isSuccess, code, responseObj, error);
         }];
    }
    

}

+(void)dispatchCallWithURLString:(NSString*)url
                    type:(NSString*)type
                  params:(NSDictionary*)params
            requestGroup:(id)requestGroup
      andCompletionHandler:(void(^)(BOOL isSuccess, NSNumber *code, id responseObj, NSError *error))completionHandler
{
    if (requestGroup) {
        dispatch_group_async(requestGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            
            [DDCW_APICallManager callWithURLString:url type:type params:params andCompletionHandler:^(BOOL isSuccess, NSNumber *code, id responseObj, NSError *error) {
                completionHandler(isSuccess, code, responseObj, error);
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        });

    } else {
        [DDCW_APICallManager callWithURLString:url type:type params:params andCompletionHandler:^(BOOL isSuccess, NSNumber *code, id responseObj, NSError *error) {
            completionHandler(isSuccess, code, responseObj, error);
        }];
    }
    
}

+ (void)dispatchCallWithURLString:(NSString*)url
                     type:(NSString*)type
                   params:(NSDictionary*)params
              cacheParams:(NSDictionary*)cacheParams
             requestGroup:(id)requestGroup
       andCompletionHandler:(void(^)(BOOL isSuccess, NSNumber *code, id responseObj, NSError *error))completionHandler
{
    if (requestGroup) {
        dispatch_group_async(requestGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            
            [DDCW_APICallManager callWithURLString:url type:type params:params cacheParams:cacheParams andCompletionHandler:^(BOOL isSuccess, NSNumber *code, id responseObj, NSError *error) {
                completionHandler(isSuccess, code, responseObj, error);
                dispatch_semaphore_signal(semaphore);
            }];
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        });
    } else {
        [DDCW_APICallManager callWithURLString:url type:type params:params cacheParams:cacheParams andCompletionHandler:^(BOOL isSuccess, NSNumber *code, id responseObj, NSError *error) {
            completionHandler(isSuccess, code, responseObj, error);
        }];
    }
    

}

@end
