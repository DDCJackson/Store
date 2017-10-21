//
//  DDCQRCodeScanningController.h
//  DDC_Store
//
//  Created by 张秀峰 on 2017/10/19.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "UMAnalysisController.h"

@interface DDCQRCodeScanningController : UMAnalysisController

@property (nonatomic,copy)void(^identifyResults)(NSString *number);

@end
