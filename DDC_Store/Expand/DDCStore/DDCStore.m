//
//  DDCStore.m
//  DayDayCook
//
//  Created by sunlimin on 2017/5/22.
//  Copyright © 2017年 GFeng. All rights reserved.
//

#import "DDCStore.h"

static NSString * const kUser = @"User";

static void *DDCStoreUserIdObservationContext = &DDCStoreUserIdObservationContext;
static void *DDCStoreisInMainlandOfChinaContext = &DDCStoreisInMainlandOfChinaContext;
static void *DDCStoreUserRegionCodeContext = &DDCStoreUserRegionCodeContext;
static void *DDCStoreCurrentLanguageIdContext = &DDCStoreCurrentLanguageIdContext;
static void *DDCStoreAppRegionCodeContext = &DDCStoreAppRegionCodeContext;

struct DDC_EConfigType DDC_EConfigTypeMake(DDC_EType eType, BOOL isAuth)
{
    struct DDC_EConfigType eConfigType;
    eConfigType.eType = eType;
    eConfigType.isAuth = isAuth;
    return eConfigType;
}

#define DDC_URLConfig_EType_Key @"DDCUrlConfigLastedSaveEType"

@implementation DDCStore

@synthesize user = _user;

+ (DDCStore *)sharedStore
{
    static dispatch_once_t token;
    static DDCStore *store;
    dispatch_once(&token, ^() {
        store = [[DDCStore alloc] init];
        [store appLaunchWithLocalConfiguration];
    });
    return store;
}

- (void)appLaunchWithLocalConfiguration
{
    self.device_IDFA = DDC_UserDefaults_GetString(DDC_Device_IDFA_Key);
    self.app_version = DDC_APP_VERSION;
    
    self.accessToken = DDC_UserDefaults_GetString(DDC_AccessToken_Key);
    self.uuid = DDC_UserDefaults_GetValue(DDC_Device_UUID_Key);
    
    NSNumber *eType = [DDCUserDefaults valueForKey:DDC_URLConfig_EType_Key];
    if (eType) {
        self.urlConfig = DDC_EConfigTypeMake(eType.integerValue, DDC_SEC);
    }else{
#ifdef DEBUG
        self.urlConfig = DDC_E_DEV;
#elif defined(TEST)
        self.urlConfig = DDC_E_TEST;
#else
        self.urlConfig = DDC_E_RELEASE;
#endif
    }
    
}


- (void)setUrlConfig:(struct DDC_EConfigType)urlConfig
{
    if (self.base_url && self.base_url.length && urlConfig.eType == DDC_EType_Dev && self.urlConfig.eType == urlConfig.eType) return;
    
    _urlConfig = urlConfig;
    
    switch (urlConfig.eType) {
        case DDC_EType_Realse:
        {
            self.base_url = DDC_CN_Url;
            self.ecom_url = DDC_Ecom_Release_Url;
            self.ad_url = DDC_Ad_Release_Url;
            self.auth_url = DDC_Sec_CN_Url;
        }
            break;
            
        case DDC_EType_Test:
        {
            self.base_url = DDC_Base_Test_Url;
            self.ecom_url = DDC_Ecom_Test_Url;
            self.ad_url = DDC_Ad_Test_Url;
            self.auth_url = DDC_Sec_TestUrl;
        }
            break;
            
        default://DDC_EType_Dev
        {
            self.base_url = DDC_Base_Dev_Url;
            self.ecom_url = DDC_Ecom_Dev_Url;
            self.ad_url = DDC_Ad_Dev_Url;
            self.auth_url = DDC_Sec_Dev_Url;
        }
            break;
    }
    [DDCUserDefaults setValue:[NSNumber numberWithInt:urlConfig.eType] forKey:DDC_URLConfig_EType_Key];
    self.accessToken = nil;
}


- (DDCUserModel *)user
{
    if (!_user)
    {
        NSData * userData = [self objectForKey:kUser];
        if (userData)
        {
            _user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        }
    }
    
    return _user;
}

- (void)setUser:(DDCUserModel *)user
{
    _user = user;
    NSData * userData = [NSKeyedArchiver archivedDataWithRootObject:user];
    [self setObject:userData forKey:kUser];
}

#pragma mark - Private
- (id)objectForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)setObject:(id)object forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
}

@end
