//
//  DDCW_RequestFactory.h
//  DayDayCook
//
//  Created by Christopher Wood on 7/31/17.
//  Copyright © 2017 DayDayCook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDCW_RequestFactory : NSObject

+(NSURLRequest *)createRequestForUrl:(NSString *)url type:(NSString *)type params:(NSDictionary *)params cacheParams:(NSDictionary *)cacheParams useSafety:(BOOL)useSafety;

@end

@interface DDCW_RequestFactory (Security)

+(NSURLRequest *)createAccessTokenRequestForUrl:(NSString *)url key:(NSString *)key;

@end
