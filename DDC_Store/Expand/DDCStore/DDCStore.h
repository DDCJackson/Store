//
//  DDCStore.h
//  DDC_Store
//
//  Created by Christopher Wood on 10/16/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DDCUserModel;

@interface DDCStore : NSObject

+(instancetype) sharedInstance;

@property (nonatomic, strong) DDCUserModel * user;

@end
