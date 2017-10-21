//
//  DDCStore.h
//  DayDayCook
//
//  Created by sunlimin on 2017/5/22.
//  Copyright © 2017年 GFeng. All rights reserved.
//

#import "DDCUserModel.h"

typedef NS_ENUM(NSInteger, DDC_EType){
    DDC_EType_Realse  = 0,
    DDC_EType_Test       = 1,
    DDC_EType_Dev       = 2
};

struct DDC_EConfigType{
    DDC_EType eType;
    BOOL isAuth;
};

struct DDC_EConfigType DDC_EConfigTypeMake(DDC_EType eType, BOOL isAuth);

#define DDC_E_RELEASE  DDC_EConfigTypeMake(DDC_EType_Realse, DDC_SEC)
#define DDC_E_TEST  DDC_EConfigTypeMake(DDC_EType_Test, DDC_SEC)
#define DDC_E_DEV  DDC_EConfigTypeMake(DDC_EType_Dev, DDC_SEC)

@interface DDCStore : NSObject

+ (DDCStore *)sharedStore;

@property (nonatomic, assign) BOOL isLogined;
@property (nonatomic, strong) DDCUserModel * user;

@property (nonatomic, copy) NSString *device_IDFA;//@"deviceId"
@property (nonatomic, copy) NSString *device_platform;//@"device"

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *uuid;//@"cid"/OpenUUID
@property (nonatomic, copy) NSString *app_version;//@"version"

@property (nonatomic, copy) NSString *base_url;
@property (nonatomic, copy) NSString *ecom_url;
@property (nonatomic, copy) NSString *ad_url;
@property (nonatomic, copy) NSString *auth_url;

@property (nonatomic, assign) struct DDC_EConfigType urlConfig;

- (void)appLaunchWithLocalConfiguration;

@end
