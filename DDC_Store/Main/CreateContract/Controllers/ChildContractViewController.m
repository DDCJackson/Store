//
//  ChildContractViewController.m
//  DDC_Store
//
//  Created by DAN on 2017/10/14.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "ChildContractViewController.h"

@interface ChildContractViewController ()

@end

@implementation ChildContractViewController

- (instancetype)initWithDelegate:(id<ChildContractViewControllerDelegate>)delegate
{
    if (!(self = [super init])) return nil;
    
    self.delegate = delegate;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.bottomBar];
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([DDCBottomBar height]);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (FuctionOption)fuctionOptionOfDDCBottomBar
{
    return FuctionOptionDefault;
}

- (void)forwardNextPage
{
    if (self.delegate) {
        [self.delegate nextPage];
    }
}

- (void)backwardPreviousPage
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(previousPage)]) {
        [self.delegate previousPage];
    }
}


- (DDCBottomBar *)bottomBar
{
    if(!_bottomBar)
    {
        _bottomBar = [DDCBottomBar showDDCBottomBarWithPreferredStyle:DDCBottomBarStyleWithLine];
        FuctionOption fOption = [self fuctionOptionOfDDCBottomBar];

        if (fOption == FuctionOptionOnlyNextPageOperation) {
        
            [_bottomBar addBtn:self.nextPageBtn];
            [self.nextPageBtn setClickable:NO];
        }else{
            [_bottomBar addBtn:self.previousPageBtn];
            [_bottomBar addBtn:self.nextPageBtn];
            [self.nextPageBtn setClickable:NO];
        }
    }
    return _bottomBar;
}


- (DDCBottomButton *)nextPageBtn
{
    if (!_nextPageBtn) {
        __weak typeof(self) weakSelf = self;
        _nextPageBtn = [[DDCBottomButton alloc]initWithTitle:@"下一步" style:DDCBottomButtonStylePrimary handler:^{
            DLog(@"下一步");
            [weakSelf forwardNextPage];
        }];
    }
    return _nextPageBtn;
}

- (DDCBottomButton *)previousPageBtn
{
    if (!_previousPageBtn) {
           __weak typeof(self) weakSelf = self;
       _previousPageBtn =  [[DDCBottomButton alloc]initWithTitle:@"上一步" style:DDCBottomButtonStyleSecondary handler:^{
            DLog(@"上一步");
            [weakSelf backwardPreviousPage];
        }];
    }
   return  _previousPageBtn;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
