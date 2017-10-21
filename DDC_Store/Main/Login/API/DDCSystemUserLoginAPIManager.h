//
//  DDCSystemUserLoginAPIManager.h
//  DDC_Store
//
//  Created by Christopher Wood on 10/21/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDCSystemUserLoginAPIManager : NSObject

+ (void)loginWithUsername:(NSString *)username password:(NSString *)password successHandler:(void(^)(DDCUserModel * user))successHandler failHandler:(void(^)(NSError *err))failHandler;

@end
