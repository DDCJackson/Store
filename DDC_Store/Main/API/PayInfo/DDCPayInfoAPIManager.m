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

+ (void)getAliPayPayInfoWithContractNO:(NSString *)contractNO payMethodId:(NSString *)payMethodId productId:(NSString *)productId totalAmount:(NSString *)totalAmount requestGroup:(id)requestGroup successHandler:(void(^)(NSString *qrCodeUrl))successHandler failHandler:(void(^)(NSError* error))failHandler
{
    if (!contractNO || !contractNO.isValidStringValue || !payMethodId || !payMethodId.isValidStringValue || !productId || !productId.isValidStringValue || !totalAmount || !totalAmount.isValidStringValue) return;
    //http://dev.daydaycook.com.cn/daydaycook/server/payment/alipaySign.do  支付宝拿二维码接口
    NSString *url = [NSString stringWithFormat:@"%@/server/payment/alipaySign.do",DDC_Share_BaseUrl];
      NSDictionary *para = @{@"contractNo":contractNO, @"payMethodId":payMethodId, @"productId":productId, @"totalAmount":totalAmount};
    [DDCW_APICallManager dispatchCallWithURLString:url type:@"POST" params:para requestGroup:requestGroup andCompletionHandler:^(BOOL isSuccess, NSNumber *code, id responseObj, NSError *err) {
        if (responseObj && [responseObj isKindOfClass:[NSDictionary class]] && [[responseObj allKeys] containsObject:@"code"] && [responseObj[@"code"] integerValue] == 200) {
            DLog(@"pay______> :%@",responseObj);
            if (successHandler) {
                successHandler(responseObj[@"data"][@"alipay_trade_precreate_response"][@"qr_code"]);
                return ;
            }
          }
        if (failHandler) {
            failHandler(err);
        }
    }];

}


+ (void)getWeChatPayInfoWithContractNO:(NSString *)contractNO payMethodId:(NSString *)payMethodId productId:(NSString *)productId totalAmount:(NSString *)totalAmount requestGroup:(id)requestGroup successHandler:(void(^)(NSString *qrCodeUrl))successHandler failHandler:(void(^)(NSError* error))failHandler
{
   if (!contractNO || !contractNO.isValidStringValue || !payMethodId || !payMethodId.isValidStringValue || !productId || !productId.isValidStringValue || !totalAmount || !totalAmount.isValidStringValue) return;
    //http://dev.daydaycook.com.cn/daydaycook/server/payment/wxPaySign.do  微信拿二维码接口
    NSString *url = [NSString stringWithFormat:@"%@/server/payment/wxPaySign.do",DDC_Share_BaseUrl];
    NSDictionary *para = @{@"contractNo":contractNO, @"payMethodId":payMethodId, @"productId":productId, @"totalAmount":totalAmount};
    [DDCW_APICallManager dispatchCallWithURLString:url type:@"POST" params:para requestGroup:requestGroup andCompletionHandler:^(BOOL isSuccess, NSNumber *code, id responseObj, NSError *err) {
        if (responseObj && [responseObj isKindOfClass:[NSDictionary class]] && [[responseObj allKeys] containsObject:@"code"] && [responseObj[@"code"] integerValue] == 200) {
            DLog(@"pay______> :%@",responseObj);
        }
    }];
}

//+ (void)getPayInfoWithUrl:(NSString *)url TradeNO:(NSString *)tradeNO payMethodId:(NSString *)payMethodId productId:(NSString *)productId totalAmount:(NSString *)totalAmount requestGroup:(id)requestGroup successHandler:(void(^)(id data))successHandler failHandler:(void(^)(NSError* error))failHandler
//{
//    if (!tradeNO || !tradeNO.isValidStringValue || !payMethodId || !payMethodId.isValidStringValue || !productId || !productId.isValidStringValue || !totalAmount || !totalAmount.isValidStringValue) return;
//
//
//    NSDictionary *para = @{@"tradeNo":tradeNO, @"payMethodId":payMethodId, @"productId":productId, @"totalAmount":totalAmount};
//
//    [DDCW_APICallManager dispatchCallWithURLString:url type:@"POST" params:para requestGroup:requestGroup andCompletionHandler:^(BOOL isSuccess, NSNumber *code, id responseObj, NSError *err) {
//        if (responseObj && [responseObj isKindOfClass:[NSDictionary class]] && [[responseObj allKeys] containsObject:@"code"] && [responseObj[@"code"] integerValue] == 200) {
//            DLog(@"pay______> :%@",responseObj);
//        }
//    }];
//}


@end
