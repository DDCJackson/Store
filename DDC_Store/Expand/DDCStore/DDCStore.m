//
//  DDCStore.m
//  DDC_Store
//
//  Created by Christopher Wood on 10/16/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import "DDCStore.h"

static NSString * const kUser = @"User";

@implementation DDCStore

@synthesize user = _user;

+ (instancetype)sharedInstance
{
    static dispatch_once_t token;
    static DDCStore *store;
    dispatch_once(&token, ^() {
        store = [[DDCStore alloc] init];
    });
    return store;
}

- (DDCUserModel *)user
{
    if (!_user)
    {
        NSData * userData = [self objectForKey:kUser];
        if (userData)
        {
            _user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        }
    }
    
    return _user;
}

- (void)setUser:(DDCUserModel *)user
{
    _user = user;
    NSData * userData = [NSKeyedArchiver archivedDataWithRootObject:user];
    [self setObject:userData forKey:kUser];
}
    
#pragma mark - Private
- (id)objectForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)setObject:(id)object forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
}

@end
