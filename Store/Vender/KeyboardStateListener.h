//
//  KeyboardStateListener.h
//  DayDayCook
//
//  Created by Christopher Wood on 7/21/16.
//  Copyright © 2016 GFeng. All rights reserved.
//

@interface KeyboardStateListener : NSObject

+(instancetype)sharedInstance;
@property (nonatomic, readonly, getter=isVisible) BOOL visible;

@end