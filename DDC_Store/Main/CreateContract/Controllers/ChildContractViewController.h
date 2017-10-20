//
//  ChildContractViewController.h
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "BaseViewController.h"

@class GJObject;

@protocol ChildContractViewControllerDelegate <NSObject>

- (void)nextPageWithModel:(GJObject *)model;
- (void)previousPage;

@end

@interface ChildContractViewController : BaseViewController

-(instancetype) initWithDelegate:(id<ChildContractViewControllerDelegate>)delegate;

@property (nonatomic,assign)int  index;
@property (nonatomic, weak) id<ChildContractViewControllerDelegate> delegate;
@property (nonatomic, strong) GJObject * model;

@end
