//
//  DDCPayInfoAPIManager.h
//  DDC_Store
//
//  Created by 张秀峰 on 2017/10/19.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DDCPayInfoAPIManager : NSObject

+ (void)getAliPayPayInfoWithProductId:(NSString *)productId totalAmount:(NSString *)totalAmount requestGroup:(id)requestGroup successHandler:(void(^)(NSString *qrCodeUrl, NSString *tradeNO))successHandler failHandler:(void(^)(NSError* error))failHandler;

+ (void)getWeChatPayInfoWithProductId:(NSString *)productId totalAmount:(NSString *)totalAmount requestGroup:(id)requestGroup successHandler:(void(^)(NSString *qrCodeUrl, NSString *tradeNO))successHandler failHandler:(void(^)(NSError* error))failHandler;

+ (void)getAliPayPayStateWithTradeNO:(NSString *)tradeNO successHandler:(void(^)(void))successHandler failHandler:(void(^)(NSError* error))failHandler;

+ (void)getWeChatPayStateWithTradeNO:(NSString *)tradeNO successHandler:(void(^)(void))successHandler failHandler:(void(^)(NSError* error))failHandler;

+ (void)updateOfflinePayStateWithContractId:(NSString *)contractId  successHandler:(void(^)(void))successHandler failHandler:(void(^)(NSError* error))failHandler;

@end
