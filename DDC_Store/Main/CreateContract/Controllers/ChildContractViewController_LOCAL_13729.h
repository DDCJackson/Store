//
//  ChildContractViewController.h
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "BaseViewController.h"
#import "DDCBottomBar.h"

@protocol ChildContractViewControllerDelegate <NSObject>

- (void)nextPage;

@optional
- (void)previousPage;

@end


typedef NS_ENUM(NSUInteger, FuctionOption) {
    FuctionOptionDefault,//Two operations
    FuctionOptionOnlyNextPageOperation
};

@interface ChildContractViewController : BaseViewController

-(instancetype) initWithDelegate:(id<ChildContractViewControllerDelegate>)delegate;
@property (nonatomic,assign)int  index;
@property (nonatomic, weak) id<ChildContractViewControllerDelegate> delegate;

- (FuctionOption)fuctionOptionOfDDCBottomBar;
- (void)forwardNextPage;
- (void)backwardPreviousPage;
@property (nonatomic,strong)DDCBottomBar *bottomBar;
@property (nonatomic,strong)DDCBottomButton *nextPageBtn;
@property (nonatomic,strong)DDCBottomButton *previousPageBtn;

@end