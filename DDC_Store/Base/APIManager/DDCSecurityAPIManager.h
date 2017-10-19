//
//  DDCSecurityAPIManager.h
//  DayDayCook
//
//  Created by Christopher Wood on 4/14/17.
//  Copyright © 2017 GFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDCSecurity.h"

@interface DDCSecurityAPIManager : NSObject

+(void)refreshSecurityWithCompletionHandler:(void(^)(BOOL success))completionHandler;

+(void)requestPublicKeyWithSuccessHandler:(void(^)(NSString * publicKey))successHandler failHandler:(void(^)(NSError * err))failHandler;

+(void)requestAccessTokenWithEncryptedKey:(NSString*)encryptedKey successHandler:(void(^)(NSString * accessToken))successHandler failHandler:(void(^)(NSError * err))failHandler;

@end
