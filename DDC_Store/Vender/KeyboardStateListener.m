//
//  KeyboardStateListener.m
//  DayDayCook
//
//  Created by Christopher Wood on 7/21/16.
//  Copyright © 2016 GFeng. All rights reserved.
//

#import "KeyboardStateListener.h"

@interface KeyboardStateListener() {
    BOOL _isVisible;
}

@end

static KeyboardStateListener *sharedInstance;

@implementation KeyboardStateListener

+(instancetype)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (BOOL)isVisible
{
    return _isVisible;
}

- (void)didShow
{
    _isVisible = YES;
}

- (void)didHide
{
    _isVisible = NO;
}

- (id)init
{
    if ((self = [super init])) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(didShow) name:UIKeyboardDidShowNotification object:nil];
        [center addObserver:self selector:@selector(didHide) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

@end