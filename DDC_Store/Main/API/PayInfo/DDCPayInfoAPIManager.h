//
//  DDCPayInfoAPIManager.h
//  DDC_Store
//
//  Created by 张秀峰 on 2017/10/19.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DDCPayInfoAPIManager : NSObject

+ (void)getAliPayPayInfoWithContractNO:(NSString *)contractNO payMethodId:(NSString *)payMethodId productId:(NSString *)productId totalAmount:(NSString *)totalAmount requestGroup:(id)requestGroup successHandler:(void(^)(NSString *qrCodeUrl, NSString *tradeNO))successHandler failHandler:(void(^)(NSError* error))failHandler;

+ (void)getWeChatPayInfoWithContractNO:(NSString *)contractNO payMethodId:(NSString *)payMethodId productId:(NSString *)productId totalAmount:(NSString *)totalAmount requestGroup:(id)requestGroup successHandler:(void(^)(NSString *qrCodeUrl, NSString *tradeNO))successHandler failHandler:(void(^)(NSError* error))failHandler;

+ (void)getAliPayPayStateWithTradeNO:(NSString *)tradeNO successHandler:(void(^)(void))successHandler failHandler:(void(^)(NSError* error))failHandler;

+ (void)getWeChatPayStateWithTradeNO:(NSString *)tradeNO successHandler:(void(^)(void))successHandler failHandler:(void(^)(NSError* error))failHandler;
@end
