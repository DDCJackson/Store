//
//  DDC_NetWork.m
//  DayDayCook
//
//  Created by 张秀峰 on 2017/2/14.
//  Copyright © 2017年 GFeng. All rights reserved.
//

#import "DDC_NetWork.h"

//网络
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
//MAC地址
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>

//#import <SystemConfiguration/CaptiveNetwork.h>

@implementation DDC_NetWork


+ (NSString *)getCellularProvider
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    return [carrier carrierName];
}

//判断当前连接的网络状态
+(NSString *)getNetWorkState
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state;
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                {
                    state = @"WIFI";
                }
                    break;
                default:
                    break;
            }
        }
        else if([child isKindOfClass:NSClassFromString(@"UIStatusBarSignalStrengthItemView")])
        {
            CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
            NSString *currentStatus = telephonyInfo.currentRadioAccessTechnology;
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]){
                //GPRS网络
                state = @"4G";
            }
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]){
                //2.75G的EDGE网络
                state = @"3G";
                
            }
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
                //3G WCDMA网络
                state = @"3G";
            }
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
                //3.5G网络
                state = @"4G";
            }
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
                //3.5G网络
                state = @"4G";
            }
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
                //CDMA2G网络
                state = @"2G";
            }
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
                //CDMA的EVDORev0(应该算3G吧?)
                state = @"3G";
            }
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
                //CDMA的EVDORevA(应该也算3G吧?)
                state = @"3G";
            }
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
                //CDMA的EVDORev0(应该还是算3G吧?)
                state = @"3G";
            }
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
                //HRPD网络
                state = @"4G";
            }
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
                //LTE4G网络
                state = @"4G";
            }
        }
    }
    //根据状态选择
    return state;
}


//+ (NSString *)getMacAddress
//{
//    NSDictionary *dict = [self SSIDInfo];
//    NSLog(@"dict:%@",dict);
////    NSString *SSID = dict[@"SSID"];//WiFi名称
//    NSString *BSSID = dict[@"BSSID"];//无线网的MAC地址
//    return BSSID;
//}
//
//+ (NSDictionary *)SSIDInfo
//
//{
//    
//    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
//    
//    NSDictionary *info = nil;
//    
//    for (NSString *ifnam in ifs) {
//        
//        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
//        
//        if (info && [info count]) {
//            
//            break;
//            
//        }
//        
//    }
//    
//    return info;
//    
//}

/*
+ (NSString *)getMacAddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    //    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    NSLog(@"outString:%@", outstring);
    
    free(buf);
    
    return [outstring uppercaseString];
}

*/





+ (NSString *)getMacAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        NSLog(@"Error: %@", errorFlag);
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    NSLog(@"Mac Address: %@", macAddressString);
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}


@end
