//
//  DDCSecurity.h
//  DayDayCook
//
//  Created by Christopher Wood on 4/14/17.
//  Copyright © 2017 GFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDCSecurity : NSObject

// 保存后台返回的公钥
+(BOOL)savePublicKey:(NSString*)key;

// 获取已被加密过的私钥
+(NSString*)encryptedPrivateKey;

// 生成密钥，加密，返回密钥和加密过的数据
+(BOOL)secretKeyEncryptedBodyDict:(NSDictionary **)bodyDict headerDict:(NSDictionary **)headerDict key:(NSString **)key;

// 给请求body加密
+(NSString*)privateKeySymmetricallyEncryptString:(NSString*)string;

// 给请求返回的数据解密
+(NSString*)privateKeySymmetricallyDecryptString:(NSString*)string;

@end
