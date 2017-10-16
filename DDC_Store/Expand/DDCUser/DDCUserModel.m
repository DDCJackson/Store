//
//  DDCUserModel.m
//  DDC_Store
//
//  Created by Christopher Wood on 10/16/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import "DDCUserModel.h"

@implementation DDCUserModel

- (void)encodeWithCoder:(NSCoder *)enCoder
{
    [enCoder encodeObject:self.ID forKey:@"ID"];
    [enCoder encodeObject:self.username forKey:@"username"];
    [enCoder encodeObject:self.imgUrlStr forKey:@"imgUrlStr"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if (!(self = [super init])) return nil;
    
    _ID = [decoder decodeObjectForKey:@"ID"];
    _username = [decoder decodeObjectForKey:@"username"];
    _imgUrlStr = [decoder decodeObjectForKey:@"imgUrlStr"];
           
    return self;
}

@end
