//
//  DDCScanViewController.m
//  DDC_Store
//
//  Created by DAN on 2017/10/19.
//  Copyright © 2017年 DDC. All rights reserved.
//

#import "DDCScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "DDCScanView.h"
#import "DDCNavigationBar.h"

@interface DDCScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong , nonatomic) AVCaptureDevice * device; //捕获设备，默认后置摄像头
@property (strong , nonatomic) AVCaptureDeviceInput * input; //输入设备
@property (strong , nonatomic) AVCaptureMetadataOutput * output;//输出设备，需要指定他的输出类型及扫描范围
@property (strong , nonatomic) AVCaptureSession * session; //AVFoundation框架捕获类的中心枢纽，协调输入输出设备以获得数据
@property (strong , nonatomic) AVCaptureVideoPreviewLayer * previewLayer;//展示捕获图像的图层，是CALayer的子类
@property (strong , nonatomic)DDCNavigationBar *navBar;

@end

@implementation DDCScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self startScan];
}

- (void)createUI
{
    [self.view addSubview:self.navBar];
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(NAVBAR_HI+STATUSBAR_HI);
    }];
    //设置扫描界面（包括扫描界面之外的部分置灰，扫描边框等的设置）,后面设置
    DDCScanView *scanView = [[DDCScanView alloc]initWithFrame:CGRectMake(0, NAVBAR_HI+STATUSBAR_HI, DEVICE_WIDTH, DEVICE_HEIGHT-(NAVBAR_HI+STATUSBAR_HI))];
    [self.view addSubview:scanView];
}

- (void)startScan
{
    // 1.判断输入能否添加到会话中
    if (![self.session canAddInput:self.input]) return;
    [self.session addInput:self.input];
    
    
    // 2.判断输出能够添加到会话中
    if (![self.session canAddOutput:self.output]) return;
    [self.session addOutput:self.output];
    
    // 4.设置输出能够解析的数据类型
    // 注意点: 设置数据类型一定要在输出对象添加到会话之后才能设置
    //设置availableMetadataObjectTypes为二维码、条形码等均可扫描，如果想只扫描二维码可设置为
    // [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    self.output.metadataObjectTypes = self.output.availableMetadataObjectTypes;
    
    // 5.设置监听监听输出解析到的数据
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 6.添加预览图层
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    self.previewLayer.frame = self.view.bounds;
    
    // 8.开始扫描
    [self.session startRunning];
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [self.session stopRunning];   //停止扫描
    //我们捕获的对象可能不是AVMetadataMachineReadableCodeObject类，所以要先判断，不然会崩溃
    if (![[metadataObjects lastObject] isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
        [self.session startRunning];
        return;
    }
    // id 类型不能点语法,所以要先去取出数组中对象
    AVMetadataMachineReadableCodeObject *object = [metadataObjects lastObject];
    if ( object.stringValue == nil ){
        [self.session startRunning];
    }
}

#pragma mark - getters -

- (CGRect)containerRect
{
    return  CGRectMake((DEVICE_WIDTH-400)/2, (DEVICE_HEIGHT-400)/2, 400, 400);
}

- (DDCNavigationBar *)navBar
{
    if(!_navBar)
    {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"条形码•二维码";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitle:@"相册倒入" forState:UIControlStateNormal];
        _navBar = [[DDCNavigationBar alloc]initWithFrame:CGRectZero titleView:titleLabel leftButton:backBtn rightButton:rightBtn];
        _navBar.bottomLineHidden = NO;
        _navBar = [DDCNavigationBar defaultNavBarWithAlternateTitleView:titleLabel buttonTarget:self leftButtonSelector:@selector(back) rightButtonSelector:@selector(intoPhotoAlbum)];
    }
    return _navBar;
}

- (AVCaptureMetadataOutput *)output
{
    if (_output == nil) {
        //初始化输出设备
        _output = [[AVCaptureMetadataOutput alloc] init];
        // 1.获取屏幕的frame
        CGRect viewRect = self.view.frame;
        // 2.获取扫描容器的frame
        CGRect containerRect = [self containerRect];
        
        CGFloat x = containerRect.origin.y / viewRect.size.height;
        CGFloat y = containerRect.origin.x / viewRect.size.width;
        CGFloat width = containerRect.size.height / viewRect.size.height;
        CGFloat height = containerRect.size.width / viewRect.size.width;
        //rectOfInterest属性设置设备的扫描范围
        _output.rectOfInterest = CGRectMake(x, y, width, height);
    }
    return _output;
}

- (AVCaptureDevice *)device
{
    if (_device == nil) {
        // 设置AVCaptureDevice的类型为Video类型
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}

- (AVCaptureDeviceInput *)input
{
    if (_input == nil) {
        //输入设备初始化
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    }
    return _input;
}

- (AVCaptureSession *)session
{
    if (_session == nil) {
        _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}

- (AVCaptureVideoPreviewLayer *)previewLayer
{
    if (_previewLayer == nil) {
        //负责图像渲染出来
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _previewLayer;
}

@end
