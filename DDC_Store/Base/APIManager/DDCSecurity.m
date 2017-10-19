//
//  DDCSecurity.m
//  DayDayCook
//
//  Created by Christopher Wood on 4/14/17.
//  Copyright © 2017 GFeng. All rights reserved.
//

#import "DDCSecurity.h"
#import <CommonCrypto/CommonCrypto.h>
#import "MF_Base64Additions.h"

// 私钥tag
static NSString * const kPrivateStringTagRef = @"DDC_PrivateStringTag";
// 公钥tag
static NSString * const kPublicStringTagRef  = @"DDC_PublicStringTag";

static NSString * const x509PublicHeader = @"-----BEGIN PUBLIC KEY-----";
static NSString * const x509PublicFooter = @"-----END PUBLIC KEY-----";
static NSString * const pKCS1PublicHeader = @"-----BEGIN RSA PUBLIC KEY-----";
static NSString * const pKCS1PublicFooter = @"-----END RSA PUBLIC KEY-----";

typedef NS_ENUM(NSUInteger, EncryptionBehavior)
{
    EncryptionBehaviorDecrypt = 0,
    EncryptionBehaviorEncrypt = 1
};

@implementation DDCSecurity

#pragma mark - public - 
// 保存公钥
+(BOOL)savePublicKey:(NSString*)key
{
    NSData * dataTag = [kPublicStringTagRef dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary * publicKey = [self defaultDictionaryForPublicKeyWithTag:dataTag];
    SecItemDelete((CFDictionaryRef)publicKey);
    
    BOOL isX509 = NO;
    
    NSString *strippedKey = nil;
    if (([key rangeOfString:x509PublicHeader].location != NSNotFound) &&
        ([key rangeOfString:x509PublicFooter].location != NSNotFound))
    {
        strippedKey = [[key stringByReplacingOccurrencesOfString:x509PublicHeader withString:@""] stringByReplacingOccurrencesOfString:x509PublicFooter withString:@""];
        strippedKey = [[strippedKey stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        isX509 = YES;
    }
    else if (([key rangeOfString:pKCS1PublicHeader].location != NSNotFound) &&
             ([key rangeOfString:pKCS1PublicFooter].location != NSNotFound))
    {
        strippedKey = [[key stringByReplacingOccurrencesOfString:pKCS1PublicHeader withString:@""] stringByReplacingOccurrencesOfString:pKCS1PublicFooter withString:@""];
        strippedKey = [[key stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        isX509 = NO;
    }
    else
    {
        strippedKey = [[key stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        // Assume is x509
        isX509 = YES;
    }
    
    NSData *strippedKeyData = [NSData dataWithBase64String:strippedKey];
    
    if (isX509)
    {
        // 确认数据格式没问题
        strippedKeyData = [self preparePublicKeyDataForX509:strippedKeyData];
        if (!strippedKeyData)
        {
            DLog(@"Error: 保存公钥失败了");
            return NO;
        }
    }
    
    CFTypeRef persistKey = nil;
    [publicKey setObject:strippedKeyData forKey:(id)kSecValueData];
    [publicKey setObject:(id)kSecAttrKeyClassPublic forKey:(id)kSecAttrKeyClass];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(id)kSecReturnPersistentRef];
    
    OSStatus secStatus = SecItemAdd((CFDictionaryRef)publicKey, &persistKey);
    
    if (persistKey != nil) CFRelease(persistKey);
    
    if ((secStatus != noErr) && (secStatus != errSecDuplicateItem))
    {
        DLog(@"Error: 保存公钥失败了");
        return NO;
    }
    
    if ([self fetchPublicKeyWithTag:kPublicStringTagRef])
    {
        return YES;
    }
    else
    {
        DLog(@"Error: 保存公钥失败了");
        return NO;
    }
}

// 用公钥给私钥非对称加密
+(NSString*)encryptedPrivateKey
{
    NSString * privateKey = [self createAndSavePrivateKey];
    
    DLog(@"KEY: %@, %ld", privateKey, (unsigned long)privateKey.length);
    SecKeyRef publicKeyRef = [self fetchPublicKeyWithTag:kPublicStringTagRef];
    
    return [self asymetricallyEncryptString:privateKey withPublicKeyRef:publicKeyRef];
}

+(BOOL)secretKeyEncryptedBodyDict:(NSDictionary **)bodyDict headerDict:(NSDictionary **)headerDict key:(NSString**)key
{
    NSMutableDictionary * mutBodyDict = [NSMutableDictionary dictionaryWithDictionary:*bodyDict];
    NSMutableDictionary * mutHeaderDict = [NSMutableDictionary dictionaryWithDictionary:*headerDict];
    NSArray * mutDictArray = @[mutBodyDict, mutHeaderDict];
    
    NSString * rawKey = [[self createPrivateKey] base64String];
    DLog(@"secretKey: %@", rawKey);
    NSString * encryptedKey = [self privateKeySymmetricallyEncryptString:rawKey];
    
    if (encryptedKey)
    {
        for (NSMutableDictionary * mutDict in mutDictArray)
        {
            for (NSString * dictKey in mutDict.allKeys)
            {
                mutDict[dictKey] = [self symmetric:EncryptionBehaviorEncrypt dataString:mutDict[dictKey] key:rawKey];
            }
        }
        
//        [mutBodyDict setObject:encryptedKey forKey:@"key"];
        *bodyDict = mutBodyDict;
        *headerDict = mutHeaderDict;
        *key = encryptedKey;
        return YES;
    }
    return NO;
}

// 用私钥对称加密
+(NSString *)privateKeySymmetricallyEncryptString:(NSString *)string
{
    NSString * secretKey = [self fetchPrivateKeyWithTag:kPrivateStringTagRef];
    
    return [self symmetric:EncryptionBehaviorEncrypt dataString:string key:secretKey];
}

// 用私钥对称解密
+(NSString*)privateKeySymmetricallyDecryptString:(NSString *)string
{
    NSString * secretKey = [self fetchPrivateKeyWithTag:kPrivateStringTagRef];
    
    return [self symmetric:EncryptionBehaviorDecrypt dataString:string key:secretKey];
}

#pragma mark - private -
#pragma mark - 公钥 -

#pragma mark - 保存公钥

// 存读公钥默认参数
+(NSMutableDictionary*)defaultDictionaryForPublicKeyWithTag:(NSData*)tag
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
     (__bridge id)kSecClassKey, (__bridge id)kSecClass,
     (__bridge id)kSecAttrKeyTypeRSA, (__bridge id)kSecAttrKeyType,
     tag, (__bridge id)kSecAttrApplicationTag,
     nil];
}

// 准备好钥匙的数据（去掉头部）
+(NSData *)preparePublicKeyDataForX509:(NSData*)keyData
{
    unsigned char * bytes = (unsigned char *)[keyData bytes];
    size_t bytesLen = [keyData length];
    
    size_t i = 0;
    if (bytes[i++] != 0x30)
    {
        return nil;
    }
    
    // Skip size bytes
    if (bytes[i] > 0x80)
    {
        i += bytes[i] - 0x80 + 1;
    }
    else
    {
        i++;
    }
    
    if (i >= bytesLen)
    {
        return nil;
    }
    
    if (bytes[i] != 0x30)
    {
        return nil;
    }
    
    // skip oid
    i += 15;
    
    if (i >= bytesLen -2)
    {
        return nil;
    }
    
    if (bytes[i++] != 0x03)
    {
        return nil;
    }
    
    // skip length and null
    if (bytes[i] > 0x80)
    {
        i += bytes[i] - 0x80 + 1;
    }
    else
    {
        i++;
    }
    
    if (i >= bytesLen)
    {
        return nil;
    }
    
    if (bytes[i++] != 0x00)
    {
        return nil;
    }
    
    if (i >= bytesLen)
    {
        return nil;
    }
    
    return [NSData dataWithBytes:&bytes[i] length:bytesLen - i];
}

#pragma mark - 获取公钥

// 获取公钥
+(SecKeyRef)fetchPublicKeyWithTag:(NSString*)tag
{
    if (!tag) return nil;
    
    NSData * dataTag = [tag dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary * publicKey = [self defaultDictionaryForPublicKeyWithTag:dataTag];
    
    SecKeyRef keyRef = nil;
    [publicKey removeObjectForKey:(id)kSecValueData];
    [publicKey removeObjectForKey:(id)kSecReturnPersistentRef];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(id)kSecReturnRef];
    [publicKey setObject:(id)kSecAttrKeyTypeRSA forKey:(id)kSecAttrKeyType];
    
    OSStatus sanityCheck = SecItemCopyMatching((CFDictionaryRef)publicKey, (CFTypeRef*)&keyRef);
    
    if (!keyRef || (sanityCheck != noErr))
    {
        return nil;
        DLog(@"Error: 获取公钥失败了");
    }
    
    return keyRef;
}

#pragma mark - 私钥 -
#pragma mark - 生成私钥
// 生成私钥
+(NSData *)createPrivateKey
{
    uint8_t buf[16];
    if (SecRandomCopyBytes(nil, sizeof(buf), buf) == -1)
    {
        return nil;
    }
    
    NSData * key = [NSMutableData dataWithBytes:buf length:sizeof(buf)];
    
    return key;
}

#pragma mark - 保存私钥

// 保存私钥
+(NSString*)createAndSavePrivateKey
{
    NSData * dataTag = [kPrivateStringTagRef dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary * privateKey = [self defaultDictionaryForPrivateKeyWithTag:dataTag];
    
    SecItemDelete((CFDictionaryRef)privateKey);
    
    CFTypeRef persistKey = nil;
    
    NSData * privateKeyData = [self createPrivateKey];
    
    [privateKey setObject:privateKeyData forKey:(id)kSecValueData];
    [privateKey setObject:(id)kSecAttrKeyClassSymmetric forKey:(id)kSecAttrKeyClass];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(id)kSecReturnPersistentRef];
    
    OSStatus secStatus = SecItemAdd((CFDictionaryRef)privateKey, &persistKey);
    
    if (persistKey != nil) CFRelease(persistKey);
    
    if ((secStatus != noErr) && (secStatus != errSecDuplicateItem))
    {
        return nil;
    }
    
    NSString * privateKeyStr = [self fetchPrivateKeyWithTag:kPrivateStringTagRef];
    if (privateKeyStr)
    {
        return privateKeyStr;
    }
    else
    {
        DLog(@"Error: 获取私钥失败了");
        return nil;
    }
}

// 存读私钥默认参数
+(NSMutableDictionary*)defaultDictionaryForPrivateKeyWithTag:(NSData*)data
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassKey, (__bridge id)kSecClass,
            data, (__bridge id)kSecAttrApplicationTag,
            nil];
}

#pragma mark - 获取私钥

// 获取私钥
+(NSString *)fetchPrivateKeyWithTag:(NSString*)tag
{
    if (!tag) return nil;
    
    NSData * dataTag = [tag dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary * privateKey = [self defaultDictionaryForPrivateKeyWithTag:dataTag];
    
    CFDataRef dataRef = nil;
    [privateKey removeObjectForKey:(id)kSecValueData];
    [privateKey removeObjectForKey:(id)kSecReturnPersistentRef];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(id)kSecReturnData];
    
    OSStatus sanityCheck = SecItemCopyMatching((CFDictionaryRef)privateKey, (CFTypeRef*)&dataRef);
    
    if (!dataRef || (sanityCheck != noErr))
    {
        return nil;
    }
    
    NSData * data = (__bridge NSData*)dataRef;
    
    CFRelease(dataRef);
    
    NSString * key = [data base64String];
    return key;
}

#pragma mark - 加密／解密 -

#pragma mark - 非对称加密
// 非对称加密
+(NSString*)asymetricallyEncryptString:(NSString*)originalString withPublicKeyRef:(SecKeyRef)publicKeyRef
{
    if (!originalString || !publicKeyRef) return nil;
    
    size_t cipherBufferSize = SecKeyGetBlockSize(publicKeyRef);
    uint8_t *cipherBuffer = malloc(cipherBufferSize);
    
    uint8_t *nonce = (uint8_t *)[originalString UTF8String];
    
    // Ordinarily, you would split the data up into blocks
    // equal to cipherBufferSize, with the last block being
    // shorter. For simplicity, this example assumes that
    // the data is short enough to fit.
    if (cipherBufferSize < sizeof(nonce))
    {
        if(publicKeyRef) CFRelease(publicKeyRef);
        free(cipherBuffer);
        
        return nil;
    }
    
    SecKeyEncrypt(publicKeyRef, kSecPaddingPKCS1, nonce, strlen( (char*)nonce ), &cipherBuffer[0], &cipherBufferSize);
    
    NSData *encryptedData = [NSData dataWithBytes:cipherBuffer length:cipherBufferSize];
    
    if(publicKeyRef) CFRelease(publicKeyRef);
    free(cipherBuffer);
    
    NSString * encryptedStr = [encryptedData base64String];
    DLog(@"%@", encryptedStr);
    return encryptedStr;
}

#pragma mark - 对称加密／解密

+(NSString*)symmetric:(EncryptionBehavior)encryptionBehavior dataString:(NSString*)dataStr key:(NSString*)key
{
    if ([dataStr isKindOfClass:[NSNumber class]])
    {
        dataStr = ((NSNumber*)dataStr).stringValue;
    }
    
    NSData * keyData = [NSData dataWithBase64String:key];
    NSData * contentData;
    
    size_t numBytesEncrypted = 0;
    size_t bufferSize = 0;
    
    uint32_t mode = 0;
    uint32_t options = 0;
    
    if (encryptionBehavior == EncryptionBehaviorDecrypt)
    {
        contentData = [NSData dataWithBase64String:dataStr];
        bufferSize = contentData.length;
        mode = kCCDecrypt;
        options = kCCOptionECBMode | kCCOptionPKCS7Padding;
    }
    else
    {
        contentData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        bufferSize = contentData.length + kCCBlockSizeAES128;
        mode = kCCEncrypt;
        options = kCCOptionECBMode | kCCOptionPKCS7Padding;
    }
    
    void *buffer = malloc(bufferSize);
    
    if (!keyData)
    {
        DLog(@"Error: 对称加密失败了，没有keyData");
        return nil;
    }
    
    CCCryptorStatus result = CCCrypt(mode, kCCAlgorithmAES128, options, keyData.bytes, kCCKeySizeAES128, NULL, contentData.bytes, contentData.length, buffer, bufferSize, &numBytesEncrypted);
    
    NSData * output = [NSData dataWithBytes:buffer length:numBytesEncrypted];
    free(buffer);
    if (result == kCCSuccess)
    {
        if (encryptionBehavior == EncryptionBehaviorDecrypt)
        {
            NSString * decryptedString = [[NSString alloc] initWithData:output encoding:NSUTF8StringEncoding];
            DLog(@"Decryption Successful: %@", decryptedString);
            return decryptedString;
        }
        else
        {
            return [output base64String];
        }
    }
    else
    {
        NSLog(@"Error: 对称加密失败了");
        return nil;
    }
}

@end
