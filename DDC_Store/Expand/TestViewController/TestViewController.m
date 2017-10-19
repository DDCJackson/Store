//
//  TestViewController.m
//  DayDayCook
//
//  Created by Christopher Wood on 8/3/16.
//  Copyright © 2016 GFeng. All rights reserved.
//

#import "TestViewController.h"
#import "DDCButton.h"

@interface TestViewController()<UITextFieldDelegate>
{
    UILabel * _serverLabel;
    UITextField *_tf;
    UILabel *_ecommerceLabel;
    DDCButton *_lastBtn;
}

@end

@implementation TestViewController

- (BOOL)showIpadMenuBar
{
    return YES;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"环境配置";
    
    [self buildUserInterface];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}


-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}


- (void)buildUserInterface
{
    [self setLeftNaviBtnTitle:@"<"];

//    _ipLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 50, 20)];
//    _ipLabel.text = [NSString stringWithFormat:@"%@ %@",DDC_Share_MainlandOfChina, (DDC_Share_IsMainlandOfChina?@"大陆":@"海外")];
//    [self.view addSubview:_ipLabel];
    
    UIButton *secBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    secBtn.frame = CGRectMake(150, 20, 100, 20);
    [secBtn setTitle:@"未加密" forState:UIControlStateNormal];
    [secBtn setTitle:@"加密🔐" forState:UIControlStateSelected];
    [secBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [secBtn addTarget:self action:@selector(secBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:secBtn];
    secBtn.selected = DDC_Share.urlConfig.isAuth;
    secBtn.userInteractionEnabled = NO;
    
    NSArray *cmsTitles = @[@"生产", @"测试", @"开发",@"切换环境"];
    CGFloat space = 20;
    CGFloat w_btn = (DEVICE_WIDTH-4*space)/3.0f;
    for (int i=0; i<cmsTitles.count; i++) {
        DDCButton * btn = [DDCButton buttonWithType:UIButtonTypeCustom];
       if (i != cmsTitles.count-1) {
            btn.frame = CGRectMake(10+w_btn*i, 110, w_btn, 30);
        }else{
            btn.frame = CGRectMake(DEVICE_WIDTH-space-w_btn, 150, w_btn, 30);
        }
        btn.tag = 1000+i;
        [btn setTitle:cmsTitles[i] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setBackgroundColor:[UIColor blackColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(ulrChangedAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setEnlargeEdge:20];
        [self.view addSubview:btn];
        
        if (i == DDC_Share.urlConfig.eType) {
            btn.selected = YES;
        }
    }
 
    _tf = [[UITextField alloc]initWithFrame:CGRectMake(space, 150, 2*w_btn + space, 30)];
    _tf.layer.masksToBounds = YES;
    _tf.layer.borderWidth = 1.0;
    _tf.layer.borderColor = [UIColor blackColor].CGColor;
    _tf.delegate = self;
    [self.view addSubview:_tf];
    
    _serverLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 200, DEVICE_WIDTH-10, 25)];
    _serverLabel.font = [UIFont systemFontOfSize:15.0f weight:UIFontWeightMedium];
    _serverLabel.text =   [NSString stringWithFormat:@"CMS地址:%@",DDC_Share_BaseUrl];
    [self.view addSubview:_serverLabel];
    [_serverLabel sizeToFit];

    _ecommerceLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 230, DEVICE_WIDTH-10, 25)];
    _ecommerceLabel.font = [UIFont systemFontOfSize:15.0f weight:UIFontWeightMedium];
    _ecommerceLabel.text =  [NSString stringWithFormat:@"电商地址:%@",DDC_Share_EcomUrl];
;//ECOMMERCE_BASE_URL
    [self.view addSubview:_ecommerceLabel];
    [_ecommerceLabel sizeToFit];
    
//    NSArray *ecomTitles = @[@"生产", @"测试", @"开发"];
//    for (int i=0; i<ecomTitles.count; i++) {
//        DDCButton *ecomBtn = [DDCButton buttonWithType:UIButtonTypeCustom];
//        ecomBtn.tag = 2000 + i;
//        ecomBtn.frame = CGRectMake(space, 240, 75, 30);
//        [ecomBtn setTitle:ecomTitles[i] forState:UIControlStateNormal];
//        [ecomBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [ecomBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [ecomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//        [ecomBtn setBackgroundColor:[UIColor blackColor] forState:UIControlStateSelected];
//        [ecomBtn addTarget:self action:@selector(ecomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:ecomBtn];
//    }
    if (DDC_Share.urlConfig.eType == DDC_EType_Dev && ![DDC_Share_BaseUrl isEqualToString:DDC_Base_Dev_Url]) {
        _tf.text = DDC_Share_BaseUrl;
    }
}

//- (void)ecomBtnAction:(DDCButton *)btn
//{
//    
//}

- (void)ulrChangedAction:(DDCButton *)btn
{
    if ((_lastBtn && btn == _lastBtn && btn.tag != 1003) || (btn.tag == 1003 && !_tf.text.length && [DDC_Share_BaseUrl isEqualToString:_tf.text])) return;
    
    for (int i=0; i< 4; i++) {
        DDCButton *b = [self.view viewWithTag:1000+i];
        b.selected = NO;
    }
    btn.selected = YES;
    _lastBtn = btn;
    DDC_EType eType;
    switch (btn.tag-1000) {
        case 0:
            eType = DDC_EType_Realse;
            break;
            
        case 1:
             eType = DDC_EType_Test;
            break;
            
        case 2:
             eType = DDC_EType_Dev;
            break;
            
        default:
             eType = DDC_EType_Dev;
            break;
    }
    if (eType != DDC_Share.urlConfig.eType) {
        DDC_Share.urlConfig = DDC_EConfigTypeMake(eType, DDC_Share.urlConfig.isAuth);
        _serverLabel.text =   [NSString stringWithFormat:@"CMS:%@",DDC_Share_BaseUrl];
        _ecommerceLabel.text =  [NSString stringWithFormat:@"电商:%@",DDC_Share_EcomUrl];
    }
    
    if(btn.tag == 1003){
//       if(DDC_Share_BaseUrl != _tf.text){
            DDCButton *b = [self.view viewWithTag:1002];
            b.selected = YES;
            _serverLabel.text =   [NSString stringWithFormat:@"CMS:%@",DDC_Share_BaseUrl = _tf.text];
//        }d
    }else{
        _tf.text = @"";
    }
}

- (void)secBtnAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if ( DDC_Share.urlConfig.isAuth != btn.selected) {
        DDC_Share.urlConfig = DDC_EConfigTypeMake(DDC_Share.urlConfig.eType, btn.selected);
    }
}

@end
