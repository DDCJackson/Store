 
//
//  DDCQRCodeHelperTool.m
//  DDCQRCodeExample
//
//  Created by 张秀峰 on 2016/10/19.
//  Copyright © 2017年 DayDayCook. All rights reserved.
//

#import "DDCQRCodeHelperTool.h"
#import <AVFoundation/AVFoundation.h>

@implementation DDCQRCodeHelperTool
/** 打开手电筒 */
+ (void)DDC_openFlashlight {
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    if ([captureDevice hasTorch]) {
        BOOL locked = [captureDevice lockForConfiguration:&error];
        if (locked) {
            captureDevice.torchMode = AVCaptureTorchModeOn;
            [captureDevice unlockForConfiguration];
        }
    }
}
/** 关闭手电筒 */
+ (void)DDC_closeFlashlight {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode: AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
}


@end
