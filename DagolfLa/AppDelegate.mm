//
//  AppDelegate.m
//  DagolfLa
//
//  Created by bhxx on 15/10/9.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"

#import "IQKeyboardManager.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"

#import "PageViewController.h"
#import <BaiduMapAPI/BMKMapComponent.h>//引入所有的头文件


#import "UserInformationModel.h"
#import "UserDataInformation.h"
//融云
#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RongIMLib.h>
#import <AddressBook/AddressBook.h>
#import <RongIMKit/RCIM.h>
#import "UITabBar+badge.h"
#import "RCDTabBarBtn.h"

#import "UIColor+RCColor.h"
#import "UIImageView+WebCache.h"
#import <AudioToolbox/AudioToolbox.h>

#import <AdSupport/AdSupport.h>

#import <TAESDK/TaeSDK.h>
#import <AlipaySDK/AlipaySDK.h>

#import "UMMobClick/MobClick.h"
#import "JGLAnimationViewController.h"

#define ImgUrlString2 @"http://res.dagolfla.com/h5/ad/app.jpg"
#import "JGHScoreAF.h"

//启动广告页
#import "AdvertiseView.h"


#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<CLLocationManagerDelegate, RCIMConnectionStatusDelegate>
{
    BMKMapManager* _mapManager;
    
    NSInteger _pushID;//双击Homde退出时，通过链接重新打开APP时openURL方法会调用，导致2次Push页面；
    
//    NSInteger _teamUnread;
//    NSInteger _systemUnread;
//    
//    NSInteger _newFriendUnread;
}
//@property (strong, nonatomic) UIView *lunchView;
//@property (strong, nonatomic) UIWebView* webView;
@property (strong, nonatomic) CLLocationManager* locationManager;
@end

@implementation AppDelegate

- (void)umengTrack {
    
    [MobClick setLogEnabled:YES];// 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    UMConfigInstance.appKey = @"574c75ed67e58ecb16003314";
    UMConfigInstance.secret = nil;
    //    UMConfigInstance.eSType = E_UM_GAME;
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick beginLogPageView:@""];
}

- (void)contanctUpload{
    //2017年03月29日11:43:11
    NSMutableDictionary *DataDic = [NSMutableDictionary dictionary];
    [DataDic setObject:DEFAULF_USERID forKey:@"userKey"];
    [DataDic setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]] forKey:@"md5"];
    [[JsonHttp jsonHttp] httpRequest:@"mobileContact/getLastUploadTime" JsonKey:nil withData:DataDic requestMethod:@"GET" failedBlock:^(id errType) {
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            // 是否允许同步通讯录
            if ([[data objectForKey:@"upLoadEnable"] boolValue]) {
                
                NSMutableArray *commitContactArray = [NSMutableArray array];
                
                ABAddressBookRef addresBook = ABAddressBookCreateWithOptions(NULL, NULL);
                //获取通讯录中的所有人
                CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addresBook);
                //通讯录中人数
                CFIndex nPeople = ABAddressBookGetPersonCount(addresBook);
                
                for (NSInteger i = 0; i < nPeople; i++)
                {
                    //获取个人
                    ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
                    
                    //电话
                    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
                    for (int k = 0; k<ABMultiValueGetCount(phone); k++)
                    {
                        
                        NSMutableDictionary *personDic = [NSMutableDictionary dictionary];
                        
                        NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
                        
                        if (personPhone) {
                            [personDic setObject:personPhone forKey:@"phone"];
                        }else{
                            continue;
                        }
                        
                        //名字
                        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
                        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
                        CFStringRef abFullName = ABRecordCopyCompositeName(person);
                        NSString *nameString = (__bridge NSString *)abName;
                        NSString *lastNameString = (__bridge NSString *)abLastName;
                        
                        if ((__bridge id)abFullName != nil) {
                            nameString = (__bridge NSString *)abFullName;
                        } else {
                            if ((__bridge id)abLastName != nil)
                            {
                                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
                            }
                        }
                        
                        if (nameString) {
                            [personDic setObject:nameString forKey:@"cName"];
                        }
                        // 公司
                        NSString *organization = (__bridge NSString*)ABRecordCopyValue(person, kABPersonOrganizationProperty);
                        //      工作         NSString *jobtitle = (__bridge NSString*)ABRecordCopyValue(person, kABPersonJobTitleProperty);
                        if (organization) {
                            [personDic setObject:organization forKey:@"workUnit"];
                        }
                        //第一次添加该条记录的时间
                        NSString *firstknow = (__bridge NSString*)ABRecordCopyValue(person, kABPersonCreationDateProperty);
                        NSLog(@"第一次添加该条记录的时间%@\n",firstknow);
                        //最后一次修改該条记录的时间
                        NSDate *lastknow = (__bridge NSDate*)ABRecordCopyValue(person, kABPersonModificationDateProperty);
                        NSLog(@"最后一次修改該条记录的时间%@\n",lastknow);
                        ;
                        // 最后一次上传的时间  如果第一次上传没有该参数
                        if ([data objectForKey:@"lastTime"]) {
                            // 最后一次修改的时间
                            CGFloat last = [[Helper getNowDateFromatAnDate:lastknow] timeIntervalSince1970];
                            // 最后一次上传的时间
                            NSString *current = [data objectForKey:@"lastTime"];
                            NSDateFormatter * dm = [[NSDateFormatter alloc]init];
                            [dm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                            NSDate * newdate = [dm dateFromString:current];
                            NSDate *lastDate = [Helper getNowDateFromatAnDate:newdate];
                            CGFloat currentDate = [lastDate timeIntervalSince1970];
                            if (last > currentDate) {
                                [commitContactArray addObject:personDic];
                            }
                            
                        }else{
                            [commitContactArray addObject:personDic];
                            
                        }
                    }
                }
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:DEFAULF_USERID forKey:@"userKey"];
                [dic setObject:commitContactArray forKey:@"contactList"];
                if ([commitContactArray count] != 0) {
                    [[JsonHttp jsonHttp] httpRequestWithMD5:@"mobileContact/doUploadContacts" JsonKey:nil withData:dic failedBlock:^(id errType) {
                        
                    } completionBlock:^(id data) {
                        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                            NSLog(@"mobileContact/doUploadContacts success");
                        }
                    }];
                }
            }
        }
    }];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _pushID = 0;
    
//    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
//    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    if (DEFAULF_USERID) {
        /*
         *2017年02月21日11:54:41
         *耗费性能
         */
        __weak typeof(self) weakself = self;

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself contanctUpload];
        });
//        [self contanctUpload];
    }
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:[NSNumber numberWithFloat:31.15] forKey:BDMAPLAT];//纬度
    [user setObject:[NSNumber numberWithFloat:121.56] forKey:BDMAPLNG];//经度
    [user setObject:@"上海" forKey:CITYNAME];//城市名
    [user synchronize];
    
    //设置状态栏字体颜色
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    //---------------------------友盟-------------------------------
    [self umengTrack];
    //-------------------------定位-------------------------
    [self getCurPosition];
    //-------------------------初始化趣拍-------------------------
    [[TaeSDK sharedInstance] asyncInit:^{
        
    } failedCallback:^(NSError *error) {
        NSLog(@"TaeSDK init failed!!!");
    }];
    //-------------------------友盟-------------------------
    //键盘自动收起
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [UMSocialData setAppKey:@"561e0d97e0f55a66640014e2"];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:@"http://www.umeng.com/social"];
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil
    [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"http://www.dagolfla.com"];
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"BvLmax5esQ8rSrLQbhkYZa1b"  generalDelegate:nil];
    if (!ret) {
        //NSLog(@"manager start failed!");
    }
    // Add the navigation controller's view to the window and display.
    [self.window makeKeyAndVisible];
    
    //-------------------------融云-------------------------
    //初始化融云SDK
//    [self connectRongTK];
    
    /**
     * 推送处理1
     */
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        //注册推送，用于iOS8之前的系统
//        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
//        UIRemoteNotificationTypeAlert |
//        UIRemoteNotificationTypeSound;
//        [application registerForRemoteNotificationTypes:myTypes];
    }
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveMessageNotification:)
     name:RCKitDispatchMessageNotification
     object:nil];
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    //-------------------------微信支付------------------------------
    [WXApi registerApp:@"wxdcdc4e20544ed728"];
    //------------------------处理启动事件----------------------------
    NSURL *url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    NSDictionary* pushInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (pushInfo)
    {
        [self getAdvertisingImageWithUrl];
        [self startApp];
        
        if ([pushInfo objectForKey:APPDATA]) {
           // [self pushData:[pushInfo objectForKey:APPDATA]];
            
//            [Helper alertViewWithTitle:@"22222" withBlock:^(UIAlertController *alertView) {
//                UIWindow   *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//                alertWindow.rootViewController = [[UIViewController alloc] init];
//                alertWindow.windowLevel = UIWindowLevelAlert + 1;
//                [alertWindow makeKeyAndVisible];
//                [alertWindow.rootViewController presentViewController:alertView animated:YES completion:nil];
//            }];
        }
        
        [self updateBadgeValueForTabBarItem];
        
    }else if (url != nil) {
        [self getAdvertisingImageWithUrl];
        if ([[url query] containsString:@"safepay"]) {
            [self startApp];
        }else{
            if ([[url scheme] isEqualToString:@"dagolfla"]) {
                NSLog(@"%@", self.window.rootViewController);
                [self startApp];
                
                [self updateBadgeValueForTabBarItem];
            }
        }
    }else{
        //    //取出新版本号
        NSString* versionKey = (NSString*)kCFBundleVersionKey;
        NSString* version = [NSBundle mainBundle].infoDictionary[versionKey];
        //取出老的版本号
        NSString* lastVerson = [[NSUserDefaults standardUserDefaults]valueForKey:versionKey];
        if(![version isEqualToString:lastVerson])
        {
            [self getAdvertisingImageWithUrl];

            PageViewController* pageview = [[PageViewController alloc]init];
            self.window.rootViewController = pageview;
            [pageview setCallBack:^{
                [[NSUserDefaults standardUserDefaults]setValue:version forKey:versionKey];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [self startApp];
            }];
        }else{
            //广告页
            [self getAdvertisingImage];

            
        }
    }
    //调用PHP登录
    [self phpLogin];
    
    //开启监听网络状态
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager ] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case -1:
                NSLog(@"未知网络");
                break;
            case 0:
                NSLog(@"网络不可达");
                break;
            case 1:
                NSLog(@"GPRS网络");
                break;
            case 2:
                NSLog(@"wifi网络");
                break;
            default:
                break;
        }
        
        if(status ==AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi)
        {
            NSLog(@"有网");
            [self submitLocalScoreData];
        }else
        {
            NSLog(@"没有网");
        }
    }];
    
    return YES;
}
/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        
    } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
        
    }
}
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    [UIApplication sharedApplication].applicationIconBadgeNumber =
    [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
}
- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo
              reply:(void (^)(NSDictionary *))reply {

}
- (void)phpLogin{
    NSString *url = [NSString stringWithFormat:@"http://www.dagolfla.com/app/api/client/api.php?Action=UserLoginUserid&uid=%@&url=dsadsa", DEFAULF_USERID];
    
    [[JsonHttp jsonHttp]httpRequest:url failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        //state - 1成功
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        if ([data objectForKey:@"state"]) {
            [userDef setObject:[data objectForKey:@"state"] forKey:PHPState];
        }
    }];
}
-(void)startApp
{
    self.window.rootViewController = [[TabBarController alloc]init];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    //这里判断是否发起的请求为微信支付，如果是的话，用WXApi的方法调起微信客户端的支付页面（://pay 之前的那串字符串就是你的APPID，）
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"wxdcdc4e20544ed728://pay"]].location != NSNotFound) {
        return  [WXApi handleOpenURL:url delegate:self];
        //不是上面的情况的话，就正常用shareSDK调起相应的分享页面
    }else if ([url.scheme isEqualToString:@"dagolfla"]){
//        NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
        NSLog(@"URL scheme:%@", [url scheme]);
        NSLog(@"URL query: %@", [url query]);
        if ([[url query] containsString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                NSLog(@"客户端支付");
            }];
        }else{
            if (_pushID != 1) {
                [self pushSpecifiedViewCtrl:[NSString stringWithFormat:@"%@", url]];
            }else{
                _pushID = 0;
            }
        }
        return YES;
    }else{
        return [UMSocialSnsService handleOpenURL:url wxApiDelegate:self];
    }
}
//新浪微博的
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"wxdcdc4e20544ed728://pay"]].location != NSNotFound) {
        return  [WXApi handleOpenURL:url delegate:self];
        //不是上面的情况的话，就正常用shareSDK调起相应的分享页面
    }else if ([url.scheme isEqualToString:@"dagolfla"]){
//        NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
        NSLog(@"URL scheme:%@", [url scheme]);
        NSLog(@"URL query: %@", [url query]);
        if ([[url query] containsString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                NSLog(@"客户端支付");
            }];
        }else{
            if (_pushID != 1) {
                [self pushSpecifiedViewCtrl:[NSString stringWithFormat:@"%@", url]];
            }else{
                _pushID = 0;
            }
        }
        return YES;
    }else{
        return [UMSocialSnsService handleOpenURL:url wxApiDelegate:self];
    }
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    if ([url.scheme isEqualToString:@"sina.561e0d97e0f55a66640014e2"])
    {
        return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    }else if ([url.scheme isEqualToString:@"wxdcdc4e20544ed728"]) {
//        BOOL result = [UMSocialSnsService handleOpenURL:url];
//        if (result == FALSE) {
//            //调用其他SDK，例如支付宝SDK等
//            return [WXApi handleOpenURL:url delegate:self];
//        }
//        return result;
        if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"wxdcdc4e20544ed728://pay"]].location != NSNotFound) {
            return  [WXApi handleOpenURL:url delegate:self];
            //不是上面的情况的话，就正常用shareSDK调起相应的分享页面
        }else{
            return [UMSocialSnsService handleOpenURL:url wxApiDelegate:self];
        }
    }else if ([url.scheme isEqualToString:@"dagolfla"]){
//        NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
//        NSLog(@"URL scheme:%@", [url scheme]);
//        NSLog(@"URL query: %@", [url query]);
        if ([[url query] containsString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                NSLog(@"客户端支付");
            }];
            
        }else{
            if (_pushID != 1) {
                [self pushSpecifiedViewCtrl:[NSString stringWithFormat:@"%@", url]];
            }else{
                _pushID = 0;
            }
        }
        
        return YES;
    }
    else
    {
        return YES;
    }
}

#pragma mark --消息推送
/**
 * 推送处理3
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //容云
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (DEFAULF_USERID) {
        [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    }else{
        [dict setObject:@-1 forKey:@"userKey"];
    }
    
    [dict setObject:token forKey:@"token"];
    
    [[JsonHttp jsonHttp]httpRequest:@"iosDevice/doCommitDeviceToken" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"data == %@", data);
    }];
}

-(void)onReq:(BaseReq *)req{
    
}

-(void)onResp:(BaseResp *)resp{
    NSInteger secessFlag = 0;// 0- 失败， 1- 成功, 2-取消
    NSString *strTitle;
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if ([resp isKindOfClass:[PayResp class]]) {
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
            {
                NSLog(@"支付结果: 成功!");
                secessFlag = 1;
            }
                break;
            case WXErrCodeCommon:
            { //签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
                
                NSLog(@"支付结果: 失败!");
                secessFlag = 0;
            }
                break;
            case WXErrCodeUserCancel:
            { //用户点击取消并返回
                secessFlag = 2;
            }
                break;
            case WXErrCodeSentFail:
            { //发送失败
                NSLog(@"发送失败");
                secessFlag = 0;
            }
                break;
            case WXErrCodeUnsupport:
            { //微信不支持
                NSLog(@"微信不支持");
                secessFlag = 0;
            }
                break;
            case WXErrCodeAuthDeny:
            { //授权失败
                NSLog(@"授权失败");
                secessFlag = 0;
            }
                break;
            default:
                break;
        }
        //------------------------
        //创建一个消息对象
        NSNotification * notice = [NSNotification notificationWithName:@"weChatNotice" object:nil userInfo:@{@"secess":@(secessFlag)}];
        //发送消息
        [[NSNotificationCenter defaultCenter]postNotification:notice];
    }
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    /**
     * 统计推送打开率2
     */
    [[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
    /**
     * 获取融云推送服务扩展字段2
     */
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient]
                                     getPushExtraFromRemoteNotification:userInfo];
    if (pushServiceData) {
        NSLog(@"该远程推送包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"key = %@, value = %@", key, pushServiceData[key]);
        }
    } else {
        NSLog(@"该远程推送不包含来自融云的推送服务");
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    //推送的自定义消息
    completionHandler(UIBackgroundFetchResultNewData);

    if ([userInfo objectForKey:APPDATA]) {
        [self pushData:[userInfo objectForKey:APPDATA]];
//        [Helper alertViewWithTitle:@"444444" withBlock:^(UIAlertController *alertView) {
//            UIWindow   *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//            alertWindow.rootViewController = [[UIViewController alloc] init];
//            alertWindow.windowLevel = UIWindowLevelAlert + 1;
//            [alertWindow makeKeyAndVisible];
//            [alertWindow.rootViewController presentViewController:alertView animated:YES completion:nil];
//        }];
    }
}
#pragma mark -- 跳转数据解析
- (void)pushData:(NSString *)pushDataString{
    NSDictionary *dict = [ConvertJson convertJSONToDict:pushDataString];
    if (dict) {
        if ([dict objectForKey:@"pushData"]) {
            if ([[dict objectForKey:@"pushData"] objectForKey:@"url"]) {
                NSString *urlString = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"pushData"] objectForKey:@"url"]];
                [self pushSpecifiedViewCtrl:urlString];
                
//                [Helper alertViewWithTitle:urlString withBlock:^(UIAlertController *alertView) {
//                    UIWindow   *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//                    alertWindow.rootViewController = [[UIViewController alloc] init];
//                    alertWindow.windowLevel = UIWindowLevelAlert + 1;
//                    [alertWindow makeKeyAndVisible];
//                    [alertWindow.rootViewController presentViewController:alertView animated:YES completion:nil];
//                }];
                
                //统计
                if ([[dict objectForKey:@"pushData"] objectForKey:@"pushLogKey"]) {
                    NSMutableDictionary *pushDict = [NSMutableDictionary dictionary];
                    [pushDict setObject:[NSString stringWithFormat:@"%@", [[dict objectForKey:@"pushData"] objectForKey:@"pushLogKey"]] forKey:@"pushLogKey"];
                    [pushDict setObject:DEFAULF_USERID forKey:@"userKey"];
                    [pushDict setObject:@0 forKey:@"type"];
                    [Helper requestCountPushLog:pushDict];
                }
            }
        }
    }
}
- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    /**
     * 统计推送打开率3
     */
    [[RCIMClient sharedRCIMClient] recordLocalNotificationEvent:notification];
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center  willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //远程推送通知
    }
    else {
        // 本地通知
    }
    
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);// 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler: (void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        if ([userInfo objectForKey:APPDATA]) {
            [self pushData:[userInfo objectForKey:APPDATA]];
            [Helper alertViewWithTitle:@"1000000" withBlock:^(UIAlertController *alertView) {
                UIWindow   *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                alertWindow.rootViewController = [[UIViewController alloc] init];
                alertWindow.windowLevel = UIWindowLevelAlert + 1;
                [alertWindow makeKeyAndVisible];
                [alertWindow.rootViewController presentViewController:alertView animated:YES completion:nil];
            }];
            
        }
        
    }
    else {
        // 本地通知
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
// 设置消息推送的样式
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    /**
     * 推送处理2
     */
    [application registerForRemoteNotifications];
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [[RCIM sharedRCIM] disconnect];

    if (DEFAULF_IconCount) {
        NSLog(@"DEFAULF_IconCount ==%@", DEFAULF_IconCount);
        [UIApplication sharedApplication].applicationIconBadgeNumber = [DEFAULF_IconCount integerValue];
    }else{
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 为消息分享保存会话信息
//    [self saveConversationInfoForMessageShare];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    if ([[RCIMClient sharedRCIMClient] getConnectionStatus] == ConnectionStatus_Connected) {
        // 插入分享消息
//        [self insertSharedMessageIfNeed];
    }
//
    /*
     * 2017年02月21日11:51:14
     * 与下面applicationDidBecomeActive里面重复
     */
//    [application cancelAllLocalNotifications];
}
//插入分享消息
- (void)insertSharedMessageIfNeed {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [self connectRongTK];
    
    _pushID = 0;
    
    [UMSocialSnsService  applicationDidBecomeActive];
    
    [application cancelAllLocalNotifications];
    
    [self getCurPosition];
        
    [self loadMessageData];
}
#pragma mark --链接融云
- (void)connectRongTK{
    
    if (DEFAULF_USERID) {
        // TODO
        NSString  *token  = [UserDefaults objectForKey:@"rongTk"];
        [Helper requestRCIMWithToken:token];
    }
}
- (void)applicationWillTerminate:(UIApplication *)application {
    
}
#pragma MARK --定位方法
-(void)getCurPosition{
    if (_locationManager==nil) {
        _locationManager=[[CLLocationManager alloc] init];
    }
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager.delegate=self;
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        _locationManager.distanceFilter=10.0f;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            [_locationManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
        }
        [_locationManager startUpdatingLocation];
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currLocation = [locations lastObject];

    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //将获得的所有信息显示到label上
             NSLog(@"位置信息%@",placemark.name);
             //获取城市
             NSString *city = placemark.locality;
             
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             
             if ([city containsString:@"市"] || [city containsString:@"省"]) {
                 city = [city substringToIndex:[city length] - 1];
             }
             [user setObject:city forKey:CITYNAME];
             
             if (placemark.administrativeArea) {
                 [user setObject:placemark.administrativeArea forKey:PROVINCENAME];
             }

             [user synchronize];
             
         } else {
             
         }
     }];
    
    [user setObject:[NSNumber numberWithFloat:currLocation.coordinate.latitude] forKey:BDMAPLAT];//纬度
    [user setObject:[NSNumber numberWithFloat:currLocation.coordinate.longitude] forKey:BDMAPLNG];//经度
    [_locationManager stopUpdatingLocation];
    [user synchronize];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
        //NSLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
        //NSLog(@"无法获取位置信息");
    }
    //定位失败后也下载数据
}
#pragma mark -- 通知、短信URL跳转
- (void)pushSpecifiedViewCtrl:(NSString *)urlString{
    _pushID = 1;
    
    // 获取导航控制器
    TabBarController *tabVC = (TabBarController *)self.window.rootViewController;
    UINavigationController *pushClassStance = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
    [pushClassStance popToRootViewControllerAnimated:YES];
        
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        
    }
    else
    {
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"show" object:nil];
        } withBlockSure:^{
            JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
            vc.reloadCtrlData = ^(){
                NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                [center postNotificationName:@"loadMessageData" object:nil];
            };
            [pushClassStance pushViewController:vc animated:YES];
        } withBlock:^(UIAlertController *alertView) {
            [pushClassStance presentViewController:alertView animated:YES completion:nil];
        }];
        return;
    }
    
    if ([urlString containsString:@"dagolfla://"]) {
        
        [[JGHPushClass pushClass] URLString:urlString pushVC:^(UIViewController *vc) {
            vc.hidesBottomBarWhenPushed = YES;
            [pushClassStance pushViewController:vc animated:YES];
        }];
    }
}
#pragma mark -- 下载未读消息数量/获取通知数量
- (void)loadMessageData{
    if (!DEFAULF_USERID)
    {
        return;
    }
    
    [self updateBadgeValueForTabBarItem];
}
#pragma mark -- 获取融云消息
- (void)updateBadgeValueForTabBarItem
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // 获取导航控制器
        TabBarController *tabVC = (TabBarController *)self.window.rootViewController;
        if (![tabVC isKindOfClass:[TabBarController class]]) {
            return ;
        }
        
        NSArray *displayConversationTypeArray = @[@1];
        
        //会话消息
        int countChat = [[RCIMClient sharedRCIMClient]
                         getUnreadCount:displayConversationTypeArray];
        //球队消息
        int teamUnreadCount = [[RCIMClient sharedRCIMClient]
                               getUnreadCount:ConversationType_SYSTEM targetId:TEAM_ID];
        //系统消息
        int systemUnreadCount = [[RCIMClient sharedRCIMClient]
                                 getUnreadCount:ConversationType_SYSTEM targetId:SYSTEM_ID];
        //新球友消息
        int newFriendUnreadCount = [[RCIMClient sharedRCIMClient]
                                    getUnreadCount:ConversationType_SYSTEM targetId:NEW_FRIEND_ID];
        
        int iconCount = countChat +teamUnreadCount +systemUnreadCount +newFriendUnreadCount;
        
        UINavigationController *RedVc = (UINavigationController *)tabVC.viewControllers[2];
        //本地存红点数
        NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
        [userdef setObject:@(iconCount) forKey:IconCount];
        [userdef synchronize];
        
        if (iconCount > 0) {
            [RedVc.tabBarController.tabBar showBadgeOnItemIndex:2 badgeValue:iconCount];
        } else {
            [RedVc.tabBarController.tabBar hideBadgeOnItemIndex:2];
        }
    });
}

#pragma mark - 启动广告页
/**
 *  初始化广告页面
 */
- (void)getAdvertisingImage
{
    // 1.判断沙盒中是否存在广告图片，如果存在，直接显示]
    NSArray *dataArray = [UserDefaults objectForKey:@"adData"];
    BOOL isExistPic = false;
    for (NSDictionary *imageDict in dataArray) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
        NSString *imageName = [imageDict objectForKey:@"imageName"];
        int A = [self compareDate:currentDateStr withDate:imageName];
        switch (A) {
            case -1:{
                [self deleteOldImage:imageName];
            }break;
            case 0:{
                NSString *filePath = [self getFilePathWithImageName:imageName];
                BOOL isExist = [self isFileExistWithFilePath:filePath];
                if (isExist&&DEFAULF_USERID) {// 图片存在
                    isExistPic = true;
                    AdvertiseView *advertiseView = [[AdvertiseView alloc] initWithFrame:self.window.bounds];
                    advertiseView.filePath = filePath;
                    [advertiseView setCallBack:^{
                        [self startApp];
                    }];
                    if (filePath.length>0) {
                        [advertiseView show];
                    }
                    break;
                }
            }break;
            default:
                break;
        }
    }
    if (!isExistPic||!DEFAULF_USERID) {
        JGLAnimationViewController* aniVc = [[JGLAnimationViewController alloc]init];
        self.window.rootViewController = aniVc;
        [aniVc setCallBack:^{
            [self startApp];
        }];
    }
    // 2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新
    [self getAdvertisingImageWithUrl];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushAdView) name:@"pushtoad" object:nil];
}


/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}

/**
 *  初始化广告页面
 */
- (void)getAdvertisingImageWithUrl
{
    // TODO 请求广告接口
    NSDictionary *dict = [NSDictionary dictionary];
    if (DEFAULF_USERID) {
        dict = @{
                 @"userKey":DEFAULF_USERID
                 };
    }
    
    [[JsonHttp jsonHttp] httpRequest:@"index/getStartPageList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {

        NSArray *listArray = [data objectForKey:@"list"];
        NSMutableArray *mDataArray = [NSMutableArray arrayWithArray:[UserDefaults objectForKey:@"adData"]];

        for (int i = 0; i<listArray.count; i++) {
            
            NSDictionary *imageDict = listArray[i];
            NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
            NSMutableString *mImageName = [NSMutableString stringWithFormat:@"%@",[imageDict objectForKey:@"startTime"]];
            NSString * imageName =  [mImageName substringToIndex:10];
            NSString * picURL = [imageDict objectForKey:@"picURL"];
            NSString * webLinkURL = [imageDict objectForKey:@"webLinkURL"];
            [mDict setValue:imageName forKey:@"imageName"];
            [mDict setValue:picURL forKey:@"picURL"];
            [mDict setValue:webLinkURL forKey:@"webLinkURL"];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
            
            int A = [self compareDate:currentDateStr withDate:imageName];
            
            if (A>-1) {
                BOOL isExist = false;
                for (int j = 0; j<mDataArray.count; j++) {
                    NSDictionary *isExistDict = mDataArray[j];
                    NSString *isExistPicURL = [isExistDict objectForKey:@"picURL"];
                    NSString *isExistImageName = [isExistDict objectForKey:@"imageName"];
                    NSString *isExistWebLInkURL = [isExistDict objectForKey:@"webLinkURL"];
                    
                    BOOL picURLEquel = [isExistPicURL isEqualToString:picURL];
                    BOOL nameEquel  = [isExistImageName isEqualToString:imageName];
                    BOOL webLinkEquel = [isExistWebLInkURL isEqualToString:webLinkURL];
                    
                    if (picURLEquel&&nameEquel&&webLinkEquel) {
                        isExist = true;
                    }
                    if (!(picURLEquel&&webLinkEquel)&&nameEquel) {
//                        isExist = true;
                        [mDataArray removeObject:mDict];
                        [self deleteOldImage:imageName];
                        for (int i = 0; i<mDataArray.count; i++) {
                            NSDictionary *imageDict = mDataArray[i];
                            NSString *ImageName = [imageDict objectForKey:@"imageName"];
                            if ([ImageName isEqualToString:imageName]) {
                                [mDataArray removeObjectAtIndex:i];
                            }
                        }

                    }
                }
                if (!isExist) {
                    [mDataArray addObject:mDict];
                }
            }
            [UserDefaults setValue:mDataArray forKey:@"adData"];
        }
    }];
    

    NSArray *listArray = [UserDefaults objectForKey:@"adData"];
    for (NSDictionary *imageDict in listArray) {
        // 获取图片名
        NSString * imageName =  [imageDict objectForKey:@"imageName"];
        // 拼接沙盒路径
        NSString *filePath = [self getFilePathWithImageName:imageName];
        BOOL isExist = [self isFileExistWithFilePath:filePath];
        NSString *imageUrl = [imageDict objectForKey:@"picURL"];
        if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
            [self downloadAdImageWithUrl:imageUrl imageName:imageName];
        }
    }
}
/**
 *  下载新图片
 */
- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        
        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称
        
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {
            // 保存成功
            NSLog(@"保存成功");
        }else{
            NSLog(@"保存失败");
        }
    });
}

/**
 *  删除旧图片
 */
- (void)deleteOldImage:(NSString *)imageName
{
    NSString *filePath = [self getFilePathWithImageName:imageName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:nil];
    
    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:[UserDefaults objectForKey:@"adData"]];
    
    for (int i = 0; i<dataArray.count; i++) {
        NSDictionary *imageDict = dataArray[i];
        NSString *ImageName = [imageDict objectForKey:@"imageName"];
        if ([ImageName isEqualToString:imageName]) {
            [dataArray removeObjectAtIndex:i];
        }
    }
    [UserDefaults setValue:dataArray forKey:@"adData"];
}

/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName
{
    if (imageName) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        
        return filePath;
    }
    
    return nil;
}
//点击跳转
-(void)pushAdView{
    
    NSArray *dataArray = [UserDefaults objectForKey:@"adData"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
    NSDictionary *imageDict = [NSDictionary dictionary];

    for (NSDictionary *indexDict in dataArray) {
        NSString *imageName = [indexDict objectForKey:@"imageName"];
        if ([imageName isEqualToString:currentDateStr]) {
            imageDict = indexDict;
            break;
        }
    }
    
    NSString *urlString = [imageDict objectForKey:@"webLinkURL"];

    if ([urlString containsString:@"dagolfla://"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UITabBarController *tabVC = (UITabBarController *)self.window.rootViewController;
            UINavigationController *pushClassStance = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
            [[JGHPushClass pushClass] URLString:urlString pushVC:^(UIViewController *vc) {
                vc.hidesBottomBarWhenPushed = YES;
                [pushClassStance pushViewController:vc animated:YES];
            }];
        });
    }
    
}
//时间比较
-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}


- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark -- 获取本地记分数据，并提交
- (void)submitLocalScoreData{
    [[JGHScoreAF shareScoreAF]submitLocalScoreData];
}

@end
