//
//  DDCSecurityAPIManager.m
//  DayDayCook
//
//  Created by Christopher Wood on 4/14/17.
//  Copyright © 2017 GFeng. All rights reserved.
//

#import "DDCSecurityAPIManager.h"
#import "DDCW_APICallManager.h"

@implementation DDCSecurityAPIManager

+(void)refreshSecurityWithCompletionHandler:(void(^)(BOOL success))completionHandler
{
//    NSDate * start = [NSDate date];
//    DLog(@"Start Time: %.2f", [start timeIntervalSinceNow]);
    [self requestPublicKeyWithSuccessHandler:^(NSString *publicKey) {
        
//        DLog(@"Got public key: %.2f", [start timeIntervalSinceNow]);
        if ([DDCSecurity savePublicKey:publicKey])
        {
            NSString * safePrivateKey = [DDCSecurity encryptedPrivateKey];
            if (!safePrivateKey)
            {
                DLog(@"Error: 获取私钥失败了");
                completionHandler(NO);
                return;
            }
            DLog(@"Private Key: %@", safePrivateKey);
            
//            DLog(@"Saved public key: %.2f", [start timeIntervalSinceNow]);
            [self requestAccessTokenWithEncryptedKey:safePrivateKey successHandler:^(NSString *accessToken) {
                
//                DLog(@"Got access token: %.2f", [start timeIntervalSinceNow]);
                NSString * decryptedToken = [DDCSecurity privateKeySymmetricallyDecryptString:accessToken];
                DLog(@"ACCESS_TOKEN: %@", decryptedToken);
                [DDCUserDefaults setObject:decryptedToken forKey:DDC_AccessToken_Key];
                [DDCUserDefaults synchronize];
                DDC_Share_AccessToken = decryptedToken;
//                DLog(@"Saved access token: %.2f", [start timeIntervalSinceNow]);
                completionHandler(YES);
                return;
                
            } failHandler:^(NSError *err) {
                
                switch (err.code)
                {
                    case 205:// 禁止访问
                    {
                        // TODO: 黑名单处理
                    }
                        break;
                    case 201:// cid不能为空、key不能为空
                    case 204:// 未获取公钥
                    case 208:// 验证失败
                    default:
                        break;
                }
                DLog(@"Error: 获取access token失败了 %@", err);
                completionHandler(NO);
                return;
            }];
        }
        else
        {
            DLog(@"Error: 保存公钥失败了");
            completionHandler(NO);
            return;
        }
        
    } failHandler:^(NSError *err) {
        DLog(@"Error: 获取公钥失败了 %@", err);
        completionHandler(NO);
        return;
    }];
}

+(void)requestPublicKeyWithSuccessHandler:(void(^)(NSString * publicKey))successHandler failHandler:(void(^)(NSError * err))failHandler
{
    NSString * url = [NSString stringWithFormat:@"%@/server/auth/key.do", DDC_Share_SecBaseUrl];//SECBASEURL
    NSDictionary * params = @{@"cid":DDC_Share_UUID};//OpenUUID?OpenUUID:@""
    
    [DDCW_APICallManager securityCallWithURLString:url type:@"POST" params:params securityStatus:RequestSecurityStatusIsSecurityRequest andCompletionHandler:^(BOOL isSuccess, NSNumber *code, id responseObj, NSError *err) {
        
        if (isSuccess && [code isEqual:@200])
        {
            successHandler(responseObj[@"data"][@"publickKey"]);
            return;
        }
        failHandler(err);
    }];
}

+(void)requestAccessTokenWithEncryptedKey:(NSString*)encryptedKey successHandler:(void(^)(NSString * accessToken))successHandler failHandler:(void(^)(NSError * err))failHandler
{
    NSString * url = [NSString stringWithFormat:@"%@/server/auth/authKey.do", DDC_Share_SecBaseUrl];
    
    [DDCW_APICallManager accessTokenCallWithURLString:url encryptedKey:encryptedKey andCompletionHandler:^(BOOL isSuccess, NSNumber * code, id responseObj, NSError *err) {
        
        if (isSuccess && !err)
        {
            if ([code isEqual:@200])
            {
                successHandler(responseObj[@"data"][@"accessTokenId"]);
                return;
            }
            else
            {
                err = [NSError errorWithDomain:@"com.daydaycook.auth" code:code.integerValue userInfo:nil];
            }
        }
        failHandler(err);
    }];
}

@end
