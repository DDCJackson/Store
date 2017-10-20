//
//  ContractStateInfoViewModel.h
//  DDC_Store
//
//  Created by 张秀峰 on 2017/10/20.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContractStateInfoViewModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isLast;
@property (nonatomic, assign) BOOL isFirst;

@end
