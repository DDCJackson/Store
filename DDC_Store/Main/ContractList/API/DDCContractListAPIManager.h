//
//  DDCContractListAPIManager.h
//  DDC_Store
//
//  Created by Christopher Wood on 10/21/17.
//  Copyright © 2017 DDC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDCContractListAPIManager : NSObject

+ (void)downloadContractListForPage:(NSUInteger)page status:(NSUInteger)status successHandler:(void(^)(NSArray *contractList))successHandler failHandler:(void(^)(NSError * err))failHandler;

@end
