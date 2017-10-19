//
//  DDCPayInfoAPIManager.h
//  DDC_Store
//
//  Created by 张秀峰 on 2017/10/19.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDCPayInfoAPIManager : NSObject

+ (void)getAliPayPayInfoWithTradeNO:(NSString *)tradeNO payMethodId:(NSString *)payMethodId productId:(NSString *)productId totalAmount:(NSString *)totalAmount requestGroup:(id)requestGroup successHandler:(void(^)(id data))successHandler failHandler:(void(^)(NSError* error))failHandler;

@end
