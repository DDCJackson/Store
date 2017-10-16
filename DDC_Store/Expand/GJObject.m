//
//  GJObject.m
//  QCGJ
//
//  Created by Ring on 16/5/3.
//  Copyright © 2016年 zab. All rights reserved.
//

#import "GJObject.h"

@implementation GJObject



-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (id)valueForUndefinedKey:(NSString *)key{
    return nil;
}


- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    
    if (oldValue == nil) return nil;
    if ([oldValue isKindOfClass:[NSNull class]]) return nil;
    if ([oldValue isKindOfClass:[NSString class]])
    {
        NSString * stringValue = (NSString*)oldValue;
        if (!stringValue.isValidStringValue) return nil;
        
        // 过滤乱码
        while (stringValue.length > 1 && ([[stringValue substringToIndex:1] isEqualToString:@"\u200D"] || [[stringValue substringToIndex:1] isEqualToString:@"\uFEFF"]))
        {
            stringValue = [stringValue substringFromIndex:1];
        }
        return stringValue;
    }
    
    if (property.type.typeClass == [NSString class]) {
        if ([oldValue isKindOfClass:[NSNumber class]])  return ((NSNumber*)oldValue).stringValue;
    }
    
    if (property.type.typeClass == [NSDictionary class]) {
        if ([oldValue isKindOfClass:[NSDictionary class]]) {
            return oldValue;
        }
    }
    
    if (property.type.typeClass == [NSArray class]) {
        if ([oldValue isKindOfClass:[NSArray class]]) {
            return oldValue;
        }
    }
    
//    if (property.type.typeClass == [NSDate class]) {
//        NSDate *d = [NSDate dateWithTimeIntervalSince1970:[oldValue doubleValue]];
//        return d;
//    }
    return oldValue;
}

@end


