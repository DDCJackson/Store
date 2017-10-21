//
//  ContractStateInfoViewModel.h
//  DDC_Store
//
//  Created by 张秀峰 on 2017/10/20.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ContractState) {
    ContractStateDone,
    ContractStateDoing,
    ContractStateTodo
};

typedef NS_ENUM(NSUInteger, ContractStateNodePosition) {
    ContractStateNodePositionMiddle,
    ContractStateNodePositionLeft,
    ContractStateNodePositionRight
};

@interface ContractStateInfoViewModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) ContractState state;
@property (nonatomic, assign) ContractStateNodePosition position;

@end
