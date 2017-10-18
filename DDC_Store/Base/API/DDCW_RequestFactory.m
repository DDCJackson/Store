//
//  DDCW_RequestFactory.m
//  DayDayCook
//
//  Created by Christopher Wood on 7/31/17.
//  Copyright © 2017 DayDayCook. All rights reserved.
//

#import "DDCW_RequestFactory.h"
#import "DDCSecurityAPIManager.h"
#import "SecurityUtil.h"
#import "DDCUserModel.h"

static NSString * const kParamStringKey = @"ParamStringKey";
static NSString * const kHeaderDictKey = @"HeaderDictKey";

@implementation DDCW_RequestFactory

#pragma mark - Create Request
+(NSURLRequest *)createRequestForUrl:(NSString *)urlString type:(NSString *)type params:(NSDictionary *)params cacheParams:(NSDictionary *)cacheParams useSafety:(BOOL)useSafety
{
    NSMutableDictionary * headerDict = [self requestHeaderParamDict];
    NSMutableDictionary * bodyDict = [self standardParamDictionary];
    [bodyDict addEntriesFromDictionary:params];
    
    [self printPreEncryptionDebugLogForUrlString:urlString params:params];
    
    NSDictionary * dataDict = [self prepareParams:bodyDict headerDict:headerDict useSafety:useSafety];
    
    NSString * paramStr = dataDict[kParamStringKey];
    headerDict = dataDict[kHeaderDictKey];
    
    [self printPostEncryptionDebugLogForUrlString:urlString paramString:paramStr headerDict:headerDict];
    NSData * paramData = [paramStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString * cacheUrlString = [self cacheUrlStringForParams:cacheParams];
    
    // 暂时就支持Post类型
    NSParameterAssert([type isEqualToString:@"POST"]);
    NSMutableURLRequest * request = [self preparePostRequestWithUrlString:urlString cacheUrlString:cacheUrlString headerParamDict:headerDict bodyData:paramData];
    
    return request;
}

#pragma mark 加密， url encode
+(NSDictionary *)prepareParams:(NSDictionary *)params headerDict:(NSMutableDictionary *)headerDict useSafety:(BOOL)useSafety
{
    // 加密
    BOOL encrypted = NO;
    NSString * key = @"";
    
#if DDC_SEC == 1
    if (useSafety)
    {
        encrypted = [DDCSecurity secretKeyEncryptedBodyDict:&params headerDict:&headerDict key:&key];
    }
#endif
    
    if (encrypted)
    {
        // CID 不要加密
        headerDict[@"cid"] = DDC_Share_UUID;//OpenUUID?OpenUUID:@"";
        [headerDict setObject:key forKey:@"key"];
        DLog(@"preURLEncoded,EncryptedDict: %@", params);
    }
    else
    {
#if DDC_SEC == 1
        DLog(@"Error: 给请求加密失败了");
#endif
    }
    
    // url encoding
    NSString * paramStr = [self encodedParamStringFromDict:params isUsingSecurity:encrypted];
    
    // 确认不会把nil加入字典
    if (paramStr == nil)
    {
        paramStr = @"";
    }
    
    if (headerDict == nil)
    {
        headerDict = [NSMutableDictionary dictionary];
    }
    return @{kParamStringKey: paramStr, kHeaderDictKey: headerDict};
}

#pragma mark url encode
+(NSString *)encodedParamStringFromDict:(NSDictionary *)paramDict isUsingSecurity:(BOOL)security
{
    if (security)
    {
        return [self urlEncodedKeyValueString:paramDict usingCharacterSetForValues:[NSCharacterSet alphanumericCharacterSet] encodeTwice:YES];
    }
    else
    {
        return [self urlEncodedKeyValueString:paramDict usingCharacterSetForValues:[NSCharacterSet URLQueryAllowedCharacterSet] encodeTwice:NO];
    }
}

#pragma mark - Cache
+(NSString *)cacheUrlStringForParams:(NSDictionary *)cacheParams
{
    NSString * cacheUrlString;
    //    if (cacheParams)
    //    {
    //        cacheUrlString = [urlString stringByAppendingString:@"?"];
    //        for (NSString *key in [cacheParams allKeys]) {
    //            cacheUrlString=[cacheUrlString stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",[NSString stringWithFormat:@"cache-%@",key],[cacheParams objectForKey:key]]];
    //        }
    //    }
    return cacheUrlString;
}

#pragma mark Logging
+(void)printPreEncryptionDebugLogForUrlString:(NSString *)url params:(NSDictionary *)params
{
#ifdef DEBUG
    NSString * rawParamStr = [self paramDictToString:params];
    NSString *debugURLString=[NSString stringWithFormat:@"%@?%@",url, rawParamStr];
    DLog(@"未加密的Url--------%@",debugURLString);
#endif
}

+(void)printPostEncryptionDebugLogForUrlString:(NSString *)url paramString:(NSString *)paramStr headerDict:(NSDictionary *)headerDict
{
#ifdef DEBUG
    NSString *headerDictStr =[NSString string];
    headerDictStr = [NSString stringWithFormat:@"accessTokenId:%@\ncid:%@\ndevice:%@\nkey:%@\nsignature:%@\ntimestamp:%@",[headerDict objectForKey:@"accessTokenId"],[headerDict objectForKey:@"cid"],[headerDict objectForKey:@"device"],[headerDict objectForKey:@"key"],[headerDict objectForKey:@"signature"],[headerDict objectForKey:@"timestamp"]];
    DLog(@"headerDictStr:%@",headerDictStr);
    
    NSString *encryptedURL = [NSString stringWithFormat:@"%@?%@",url, paramStr];
    DLog(@"完整的Url--------%@",encryptedURL);
#endif
}

#pragma mark Default Request Header
// 默认的请求头部
+(NSMutableDictionary *)requestHeaderParamDict
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    [dict setValue:DDC_Share_DevicePlatform forKey:@"device"];
    [dict setValue:DDC_Share_UUID forKey:@"cid"];//OpenUUID?OpenUUID:@""
    
#if DDC_SEC == 1
    [dict setValue:DDC_Share_AccessToken forKey:@"accessTokenId"];
#endif
    
    //时间戳
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%llu",(unsigned long long)timeInterval];
    NSString *signature = [SecurityUtil encryptMD5String:[NSString stringWithFormat:@"%@%@",MD5_AUTH_KEY,timestamp]];
    [dict setValue:signature forKey:@"signature"];
    [dict setValue:timestamp forKey:@"timestamp"];
    
    DLog(@"Header: %@", dict);
    
    return dict;
}

#pragma mark Create Post Request
// 创建request对象
+(NSMutableURLRequest*)preparePostRequestWithUrlString:(NSString*)urlString cacheUrlString:(NSString*)cacheUrlString headerParamDict:(NSDictionary*)headerParamDict bodyData:(NSData *)bodyData
{
    NSURL *URL = [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.f];
    
    NSURL * cacheURL = [NSURL URLWithString:[cacheUrlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headerParamDict];
    
    if (bodyData)
    {
        request.HTTPBody = bodyData;
        [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[bodyData length]] forHTTPHeaderField:@"Content-Length"];
    }
    return request;
}

#pragma mark Default Params
// 默认的参数词典
+(NSMutableDictionary*)standardParamDictionary
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@"1" forKey:@"mainland"];//IP?IP:@"1"
    
    NSString * uid = @"";
    if ([DDCStore sharedStore].user)
    {
        uid = [DDCStore sharedStore].user.ID;
    }
    [dict setObject:uid forKey:@"uid"];//UserId
    
    //    [dict setObject:DDC_Share_UserRegionCode forKey:@"regionCode"];//UserRegionCode?UserRegionCode:@"156"
    
    [dict setObject:DDC_APP_VERSION forKey:@"version"];//APP_VERSION
    
    [dict setObject:@"156" forKey:@"regionCode"];
    [dict setObject:@"3" forKey:@"languageId"];//languageID?languageID:@"3"
    [dict setObject:DDC_Share_IDFA forKey:@"deviceId"];
    return dict;
}

#pragma mark - Utils
#pragma mark Dict -> String
+(NSString*)paramDictToString:(NSDictionary*)dict
{
    NSString * rawParamStr = @"";
    for (NSString *key in [dict allKeys]) {
        rawParamStr=[rawParamStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,[dict objectForKey:key]]];
    }
    return rawParamStr;
}

#pragma mark url encoding
+(NSString*) urlEncodedKeyValueString:(NSDictionary *)sourceData usingCharacterSetForValues:(NSCharacterSet*)characterSet encodeTwice:(BOOL)twice
{
    
    NSMutableString *string = [NSMutableString string];
    //遍历
    for (NSString *key in sourceData) {
        
        NSObject *value = [sourceData valueForKey:key];
        if([value isKindOfClass:[NSString class]])
        {
            [string appendFormat:@"%@=%@&", [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]],twice ? [[((NSString*)value) stringByAddingPercentEncodingWithAllowedCharacters:characterSet] stringByAddingPercentEncodingWithAllowedCharacters:characterSet] : [((NSString*)value) stringByAddingPercentEncodingWithAllowedCharacters:characterSet]];
        }
        else
        {
            [string appendFormat:@"%@=%@&", [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], value];
        }
    }
    
    if([string length] > 0)
    {
        [string deleteCharactersInRange:NSMakeRange([string length] - 1, 1)];
    }
    
    return string;
}

@end

@implementation DDCW_RequestFactory (Security)

+(NSURLRequest *)createAccessTokenRequestForUrl:(NSString*)url key:(NSString *)key
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:[self standardParamDictionary]];
    [dict addEntriesFromDictionary:@{@"cid":DDC_Share_UUID}];//OpenUUID?OpenUUID:@""
    
    NSString * percentStr = [self urlEncodedKeyValueString:dict usingCharacterSetForValues:[NSCharacterSet URLQueryAllowedCharacterSet] encodeTwice:NO];
    
    NSString * k = @"&key=";
    percentStr = [percentStr stringByAppendingString:[k stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    percentStr = [percentStr stringByAppendingString:[key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]]];
    
    url = [url stringByAppendingString:@"?"];
    NSString * urlStr = [url stringByAppendingString:percentStr];
    return [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
}

@end
