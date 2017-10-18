//
//  ChildContractViewController.h
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "BaseViewController.h"

@protocol ChildContractViewControllerDelegate <NSObject>

- (void)nextPage;
- (void)previousPage;

@end

@interface ChildContractViewController : BaseViewController

@property (nonatomic,assign)int  index;
@property (nonatomic, weak) id<ChildContractViewControllerDelegate> delegate;

@end
