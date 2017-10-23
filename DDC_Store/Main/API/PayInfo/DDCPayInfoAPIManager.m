//
//  DDCPayInfoAPIManager.m
//  DDC_Store
//
//  Created by 张秀峰 on 2017/10/19.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "DDCPayInfoAPIManager.h"
#import "DDCW_APICallManager+AsynchronousGroup.h"

@implementation DDCPayInfoAPIManager

#pragma mark -获取支付消息

+ (void)getAliPayPayInfoWithProductId:(NSString *)productId totalAmount:(NSString *)totalAmount requestGroup:(id)requestGroup successHandler:(void(^)(NSString *qrCodeUrl, NSString *tradeNO))successHandler failHandler:(void(^)(NSError* error))failHandler
{
    if (!productId || !productId.isValidStringValue || !totalAmount || !totalAmount.isValidStringValue) return;
    //http://dev.daydaycook.com.cn/daydaycook/server/payment/alipaySign.do  支付宝拿二维码接口
    NSString *url = [NSString stringWithFormat:@"%@/server/payment/alipaySign.do",DDC_Share_BaseUrl];
      NSDictionary *para = @{@"payMethodId":kAliPayPayID, @"productId":productId, @"totalAmount":totalAmount};
    [DDCW_APICallManager dispatchCallWithURLString:url type:@"POST" params:para requestGroup:requestGroup andCompletionHandler:^(BOOL isSuccess, NSNumber *code, id responseObj, NSError *err) {
        if (responseObj && [responseObj isKindOfClass:[NSDictionary class]] && [[responseObj allKeys] containsObject:@"code"] && [responseObj[@"code"] integerValue] == 200) {
            DLog(@"pay______> :%@",responseObj);
            if (successHandler) {
                NSDictionary *result = responseObj[@"data"][@"alipay_trade_precreate_response"];
                successHandler(result[@"qr_code"], result[@"out_trade_no"]);
                return ;
            }
          }
        if (failHandler) {
            failHandler(err);
        }
    }];
}


+ (void)getWeChatPayInfoWithProductId:(NSString *)productId totalAmount:(NSString *)totalAmount requestGroup:(id)requestGroup successHandler:(void(^)(NSString *qrCodeUrl, NSString *tradeNO))successHandler failHandler:(void(^)(NSError* error))failHandler
{
   if (!productId || !productId.isValidStringValue || !totalAmount || !totalAmount.isValidStringValue) return;
    //http://dev.daydaycook.com.cn/daydaycook/server/payment/wxPaySign.do  微信拿二维码接口
    NSString *url = [NSString stringWithFormat:@"%@/server/payment/wxPaySign.do",DDC_Share_BaseUrl];
    NSDictionary *para = @{@"payMethodId":kWeChatPayID, @"productId":productId, @"totalAmount":totalAmount};
    [DDCW_APICallManager dispatchCallWithURLString:url type:@"POST" params:para requestGroup:requestGroup andCompletionHandler:^(BOOL isSuccess, NSNumber *code, id responseObj, NSError *err) {
        if (responseObj && [responseObj isKindOfClass:[NSDictionary class]] && [[responseObj allKeys] containsObject:@"code"] && [responseObj[@"code"] integerValue] == 200) {
            DLog(@"pay______> :%@",responseObj);
            if (successHandler) {
                NSDictionary *result = responseObj[@"data"];
                successHandler(result[@"code_url"], result[@"out_trade_no"]);
                return ;
            }
            if (failHandler) {
                failHandler(err);
            }
        }
    }];
}


#pragma mark -获取支付状态
+ (void)getAliPayPayStateWithTradeNO:(NSString *)tradeNO successHandler:(void(^)(void))successHandler failHandler:(void(^)(NSError* error))failHandler
{
    if (!tradeNO || !tradeNO.isValidStringValue) return;
    ///server/paymentQuery/alipayTradeQuery.do?tradeNo=    支付宝查询定单接口
    NSString *url = [NSString stringWithFormat:@"%@/server/paymentQuery/alipayTradeQuery.do",DDC_Share_BaseUrl];
    NSDictionary *para = @{@"tradeNo":tradeNO};
    [DDCW_APICallManager callWithURLString:url type:@"POST" params:para andCompletionHandler:^(BOOL isSuccess, NSNumber *code, id responseObj, NSError *err) {
        if (responseObj && [responseObj isKindOfClass:[NSDictionary class]] && [[responseObj allKeys] containsObject:@"code"] && [responseObj[@"code"] integerValue] == 200) {
            DLog(@"AliPay______> :%@",responseObj);
            NSDictionary *result = responseObj[@"data"];
            NSString *status = result[@"trade_status"];
            if (status && status.isValidStringValue && [status isEqualToString:@"TRADE_SUCCESS"] && successHandler) {
                successHandler();
                return ;
            }
        }
        if (failHandler) {
            failHandler(err);
        }
    }];
}


+ (void)getWeChatPayStateWithTradeNO:(NSString *)tradeNO successHandler:(void(^)(void))successHandler failHandler:(void(^)(NSError* error))failHandler
{
    if (!tradeNO || !tradeNO.isValidStringValue) return;
    ///server/paymentQuery/wxpayTradeQuery.do?tradeNo=    微信查询定单接口
    NSString *url = [NSString stringWithFormat:@"%@/server/paymentQuery/wxpayTradeQuery.do",DDC_Share_BaseUrl];
    NSDictionary *para = @{@"tradeNo":tradeNO};
    [DDCW_APICallManager callWithURLString:url type:@"POST" params:para andCompletionHandler:^(BOOL isSuccess, NSNumber *code, id responseObj, NSError *err) {
        if (responseObj && [responseObj isKindOfClass:[NSDictionary class]] && [[responseObj allKeys] containsObject:@"code"] && [responseObj[@"code"] integerValue] == 200) {
            DLog(@"WeChatPay______> :%@",responseObj);
            NSDictionary *result = responseObj[@"data"];
            NSString *status = result[@"trade_state"];
            if (status && status.isValidStringValue && [status isEqualToString:@"SUCCESS"] && successHandler) {//@"FAIL"
                successHandler();
                return ;
            }
        }
        if (failHandler) {
            failHandler(err);
        }
    }];
}


+ (void)updateOfflinePayStateWithContractId:(NSString *)contractId  successHandler:(void(^)(void))successHandler failHandler:(void(^)(NSError* error))failHandler
{
    if (!contractId || !contractId.isValidStringValue) return;
    ///server/contract/updateStatusUnderLine.do?id=&payMethod=3 更新线下支付状态
    NSString *url = [NSString stringWithFormat:@"%@/server/contract/updateStatusUnderLine.do",DDC_Share_BaseUrl];
    NSDictionary *para = @{@"id":contractId, @"payMethod":kOfflinePayID};
    [DDCW_APICallManager callWithURLString:url type:@"POST" params:para andCompletionHandler:^(BOOL isSuccess, NSNumber *code, id responseObj, NSError *err) {
        if (responseObj && [responseObj isKindOfClass:[NSDictionary class]] && [[responseObj allKeys] containsObject:@"code"] && [responseObj[@"code"] integerValue] == 200) {
            if (successHandler) {
                successHandler();
                return ;
            }
        }
        if (failHandler) {
            failHandler(err);
        }
    }];
}



@end
