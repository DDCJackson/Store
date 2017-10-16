//
//  GJObject.h
//  QCGJ
//
//  Created by Ring on 16/5/3.
//  Copyright © 2016年 zab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface GJObject : NSObject

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property NS_REQUIRES_SUPER;

@end
