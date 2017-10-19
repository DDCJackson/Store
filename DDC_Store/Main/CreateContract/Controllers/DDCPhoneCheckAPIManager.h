//
//  DDCPhoneCheckAPIManager.h
//  DDC_Store
//
//  Created by Christopher Wood on 10/18/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import "DDCCustomerModel.h"

@interface DDCPhoneCheckAPIManager : NSObject

+ (void)checkPhoneNumber:(NSString *)phone code:(NSString *)code successHandler:(void(^)(DDCCustomerModel * customerModel))successHandler failHandler:(void(^)(NSError * err))failHandler;

+ (void)getVerificationCodeWithSuccessHandler:(void(^)(void))successHandler failHandler:(void(^)(NSError * err))failHandler;

@end
