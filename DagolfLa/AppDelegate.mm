//
//  AppDelegate.m
//  DagolfLa
//
//  Created by bhxx on 15/10/9.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"
#import "XHLaunchAd.h"
#import "IQKeyboardManager.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"

#import "PageViewController.h"
#import <BaiduMapAPI/BMapKit.h>//引入所有的头文件

#import <BaiduMapAPI/BMKMapView.h>//只引入所需的单个头文件

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

#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>

#import <TAESDK/TaeSDK.h>
#import <AlipaySDK/AlipaySDK.h>

#import "UMMobClick/MobClick.h"
#import "JGHNewHomePageViewController.h"
#import "JGTeamMainhallViewController.h"
#import "JGLAnimationViewController.h"
#import "NewFriendViewController.h"
#import "JGTeamGroupViewController.h"
#import "JGLPresentAwardViewController.h"
#import "JGDActSelfHistoryScoreViewController.h"
#import "JGDWithDrawTeamMoneyViewController.h"
#import "JGTeamMemberController.h"
#import "JGLJoinManageViewController.h"
#import "JGPhotoAlbumViewController.h"
#import "JGTeamActibityNameViewController.h"
#import "JGLScoreRankViewController.h"
#import "JGNewCreateTeamTableViewController.h"
#import "UseMallViewController.h"
#import "JGDNewTeamDetailViewController.h"
#import "JGLPushDetailsViewController.h"
#import "DetailViewController.h"
#import "ChatListViewController.h"

#define ImgUrlString2 @"http://res.dagolfla.com/h5/ad/app.jpg"


#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<CLLocationManagerDelegate, JPUSHRegisterDelegate, RCIMConnectionStatusDelegate>
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
        [self contanctUpload];
    }
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:[NSNumber numberWithFloat:31.15] forKey:BDMAPLAT];//纬度
    [user setObject:[NSNumber numberWithFloat:121.56] forKey:BDMAPLNG];//经度
    [user setObject:@"上海" forKey:CITYNAME];//城市名
    [user synchronize];
    
    //设置状态栏字体颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
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
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://www.dagolfla.com"];
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"BvLmax5esQ8rSrLQbhkYZa1b"  generalDelegate:nil];
    if (!ret) {
        //NSLog(@"manager start failed!");
    }
    // Add the navigation controller's view to the window and display.
    [self.window makeKeyAndVisible];
    //-------------------------极光推送-------------------------
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil];
    }
    //测试NO，线上YES；
    [JPUSHService setupWithOption:launchOptions appKey:@"831cd22faea3454090c15bbe" channel:@"Publish chanel" apsForProduction:NO];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    //-------------------------融云-------------------------
    //初始化融云SDK
    [[RCIM sharedRCIM] initWithAppKey:RongYunAPPKEY];//pgyu6atqylmiu
    if ([user objectForKey:@"userId"]) {
        // TODO
        NSString  *token  = [user objectForKey:@"rongTk"];
        [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
            NSLog(@":======== userId=%@", userId);
            //自动登录   连接融云服务器
            [[UserDataInformation sharedInstance] synchronizeUserInfoRCIM];
        } error:^(RCConnectErrorCode status) {
            NSLog(@":======== status=%ld", (long)status);
        } tokenIncorrect:^{
            
        }];
    }
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
        NSDictionary *apsInfo = [pushInfo objectForKey:@"aps"];
        if(apsInfo)
        {
            [self startApp];
            
            [self pushSpecifiedViewCtrl:[NSString stringWithFormat:@"%@", url]];
            
            [self updateBadgeValueForTabBarItem];
        }
    }else if (url != nil) {
        if ([[url query] containsString:@"safepay"]) {
            
        }else{
            if ([[url scheme] isEqualToString:@"dagolfla"]) {
                NSLog(@"%@", self.window.rootViewController);
                [self startApp];
                
                [self pushSpecifiedViewCtrl:[NSString stringWithFormat:@"%@", url]];
                
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
            PageViewController* pageview = [[PageViewController alloc]init];
            self.window.rootViewController = pageview;
            [pageview setCallBack:^{
                [[NSUserDefaults standardUserDefaults]setValue:version forKey:versionKey];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [self startApp];
            }];
        }
        else
        {
            JGLAnimationViewController* aniVc = [[JGLAnimationViewController alloc]init];
            self.window.rootViewController = aniVc;
            [aniVc setCallBack:^{
                [self startApp];
            }];
            
        }
    }
    //调用PHP登录
    [self phpLogin];
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
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//    NSNumber *left = [notification.userInfo objectForKey:@"left"];
//    if ([RCIMClient sharedRCIMClient].sdkRunningMode ==
//        RCSDKRunningMode_Backgroud &&
//        0 == left.integerValue) {
//        int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
//                                                                             @(ConversationType_PRIVATE),
//                                                                             @(ConversationType_DISCUSSION),
//                                                                             @(ConversationType_APPSERVICE),
//                                                                             @(ConversationType_PUBLICSERVICE),
//                                                                             @(ConversationType_GROUP)
//                                                                             ]];        
//        if (DEFAULF_IconCount) {
//            [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount + [DEFAULF_IconCount integerValue];
//        }else{
//            [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount;
//        }
//    }else{
//        if (DEFAULF_IconCount) {
//            [UIApplication sharedApplication].applicationIconBadgeNumber =[DEFAULF_IconCount integerValue] +1;
//        }else{
//            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//        }
//    }
    [UIApplication sharedApplication].applicationIconBadgeNumber =
    [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
}
- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo
              reply:(void (^)(NSDictionary *))reply {
//    RCWKRequestHandler *handler =
//    [[RCWKRequestHandler alloc] initHelperWithUserInfo:userInfo
//                                              provider:self
//                                                 reply:reply];
//    if (![handler handleWatchKitRequest]) {
        // can not handled!
        // app should handle it here
        NSLog(@"not handled the request: %@", userInfo);
//    }
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
            //        [UMSocialSnsService handleOpenURL:url
            //                            wxDelegate:self];
        }
    }else if ([url.scheme isEqualToString:@"dagolfla"]){
        NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
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
    // Required
    [JPUSHService registerDeviceToken:deviceToken];
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
    // Required,For systems with less than or equal to iOS6
//    [JPUSHService handleRemoteNotification:userInfo];
    
     // 取得 APNs 标准信息内容
//     NSDictionary *aps = [userInfo valueForKey:@"aps"];
//     NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
//     NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
//     NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
//     
//     // 取得Extras字段内容
//     NSString *customizeField1 = [userInfo valueForKey:@"customizeExtras"]; //服务端中Extras字段，key是自己定义的
//     NSLog(@"content =[%@], badge=[%d], sound=[%@], customize field  =[%@]",content, badge,sound,customizeField1);
    
     // iOS 10 以下 Required
     [JPUSHService handleRemoteNotification:userInfo];
    
    
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
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);

    [self pushSpecifiedViewCtrl:[NSString stringWithFormat:@"%@", [userInfo objectForKey:@"url"]]];
}
- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
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
        [JPUSHService handleRemoteNotification:userInfo];
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
        [self pushSpecifiedViewCtrl:[NSString stringWithFormat:@"%@", [userInfo objectForKey:@"url"]]];
        [JPUSHService handleRemoteNotification:userInfo];
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
//    RCConnectionStatus status = [[RCIMClient sharedRCIMClient] getConnectionStatus];
//    if (status != ConnectionStatus_SignUp) {
//        int unreadMsgCount = [[RCIMClient sharedRCIMClient]
//                              getUnreadCount:@[
//                                               @(ConversationType_PRIVATE),
//                                               @(ConversationType_DISCUSSION),
//                                               @(ConversationType_APPSERVICE),
//                                               @(ConversationType_PUBLICSERVICE),
//                                               @(ConversationType_GROUP)
//                                               ]];
//        if (DEFAULF_IconCount) {
//            NSLog(@"DEFAULF_IconCount ==%@", DEFAULF_IconCount);
//            [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount + [DEFAULF_IconCount integerValue];
//        }else{
//            [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount;
//        }
//    }else{
        if (DEFAULF_IconCount) {
            NSLog(@"DEFAULF_IconCount ==%@", DEFAULF_IconCount);
            [UIApplication sharedApplication].applicationIconBadgeNumber = [DEFAULF_IconCount integerValue];
        }else{
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }
//    }
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 为消息分享保存会话信息
//    [self saveConversationInfoForMessageShare];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    if ([[RCIMClient sharedRCIMClient] getConnectionStatus] == ConnectionStatus_Connected) {
        // 插入分享消息
        [self insertSharedMessageIfNeed];
    }
    
    [application cancelAllLocalNotifications];
}
//插入分享消息
- (void)insertSharedMessageIfNeed {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [[RCIM sharedRCIM] initWithAppKey:RongYunAPPKEY];//pgyu6atqylmiu
    if (DEFAULF_USERID) {
        // TODO
        NSString  *token  = [user objectForKey:@"rongTk"];
        [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
            NSLog(@":======== userId=%@", userId);
            //自动登录   连接融云服务器
            [[UserDataInformation sharedInstance] synchronizeUserInfoRCIM];
        } error:^(RCConnectErrorCode status) {
            NSLog(@":======== status=%ld", (long)status);
        } tokenIncorrect:^{
            
        }];
    }
    
    _pushID = 0;
    
    // 获取导航控制器
//    TabBarController *tabVC = (TabBarController *)self.window.rootViewController;
//    if ([tabVC isKindOfClass:[TabBarController class]]) {
//        TabBarController *tabVC = (TabBarController *)self.window.rootViewController;
////        ChatListViewController *pushClassStance = (ChatListViewController *)tabVC.viewControllers[tabVC.selectedIndex];
//        ChatListViewController *nowVC = [(UINavigationController *)self.window.rootViewController viewControllers][tabVC.selectedIndex];
//        [nowVC.conversationListTableView.header beginRefreshing];
//    }
    
    [UMSocialSnsService  applicationDidBecomeActive];
    
    [application cancelAllLocalNotifications];
    
    [self getCurPosition];
    
    [self postAppJpost];
    
    [self loadMessageData];
}
#pragma mark -- 极光推送的id和数据
-(void)postAppJpost
{
    if (DEFAULF_USERID) {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        [dict setObject:DEFAULF_USERID forKey:userID];
        
        if ([JPUSHService registrationID] != nil) {
            [dict setObject:[JPUSHService registrationID] forKey:@"jgpush"];
        }
        
        [[JsonHttp jsonHttp]httpRequestWithMD5:@"user/doUpdateUserInfo" JsonKey:nil withData:dict failedBlock:^(id errType) {
            
        } completionBlock:^(id data) {
            NSLog(@"%@", data);
            
        }];
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
    //NSLog(@"经度=%f 纬度=%f 高度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);
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
             NSLog(@"%@",placemark.name);
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
            [[NSNotificationCenter defaultCenter] postNotificationName:@"show" object:nil];
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
        // 球队提现
        if ([urlString containsString:@"teamWithDraw"]) {
            if ([urlString containsString:@"?"]) {
                JGDWithDrawTeamMoneyViewController *vc = [[JGDWithDrawTeamMoneyViewController alloc] init];
                vc.teamKey = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:urlString andKey:@"teamKey"] integerValue]];
                [pushClassStance pushViewController:vc animated:YES];        }
        }
        // 球队大厅
        if ([urlString containsString:@"teamHall"]) {
            JGTeamMainhallViewController *teamMainCtrl = [[JGTeamMainhallViewController alloc]init];
            [pushClassStance pushViewController:teamMainCtrl animated:YES];
        }
        // 成员管理
        if ([urlString containsString:@"teamMemberMgr"]) {
            JGTeamMemberController* menVc = [[JGTeamMemberController alloc]init];
            menVc.title = @"队员管理";
            menVc.power = @"1004,1001,1002,1005";
            menVc.teamManagement = 1;
            menVc.teamKey = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:urlString andKey:@"teamKey"] integerValue]];
            [pushClassStance pushViewController:menVc animated:YES];
        }
        // 入队审核页面
        if ([urlString containsString:@"auditTeamMember"]) {
            JGLJoinManageViewController *jgJoinVC = [[JGLJoinManageViewController alloc] init];
            jgJoinVC.teamKey = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:urlString andKey:@"teamKey"] integerValue]];
            [pushClassStance pushViewController:jgJoinVC animated:YES];
        }
        //新球友
        if ([urlString containsString:@"newUserFriendList"]) {
            NewFriendViewController *friendCtrl = [[NewFriendViewController alloc]init];
            friendCtrl.fromWitchVC = 2;
            [pushClassStance pushViewController:friendCtrl animated:YES];
        }
        // 相册
        if ([urlString containsString:@"teamMediaList"]) {
            JGPhotoAlbumViewController *albumVC = [[JGPhotoAlbumViewController alloc]init];
            albumVC.albumKey = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:urlString andKey:@"albumKey"] integerValue]];
            albumVC.hidesBottomBarWhenPushed = YES;
            [pushClassStance pushViewController:albumVC animated:YES];
        }
        //活动详情
        if ([urlString containsString:@"teamActivityDetail"]) {
            JGTeamActibityNameViewController *teamCtrl= [[JGTeamActibityNameViewController alloc]init];
            teamCtrl.teamKey = [[Helper returnKeyVlaueWithUrlString:urlString andKey:@"activityKey"] integerValue];
            teamCtrl.hidesBottomBarWhenPushed = YES;
            [pushClassStance pushViewController:teamCtrl animated:YES];
        }
        
        //分组--普通用户
        if ([urlString containsString:@"activityGroup"]) {
            JGTeamGroupViewController *teamGroupCtrl= [[JGTeamGroupViewController alloc]init];
            teamGroupCtrl.teamActivityKey = [[Helper returnKeyVlaueWithUrlString:urlString andKey:@"activityKey"] integerValue];
            teamGroupCtrl.hidesBottomBarWhenPushed = YES;
            [pushClassStance pushViewController:teamGroupCtrl animated:YES];
        }
        //分组--管理
        if ([urlString containsString:@"activityGroupAdmin"]) {
            JGTeamGroupViewController *teamGroupCtrl= [[JGTeamGroupViewController alloc]init];
            teamGroupCtrl.teamActivityKey = [[Helper returnKeyVlaueWithUrlString:urlString andKey:@"activityKey"] integerValue];
            teamGroupCtrl.hidesBottomBarWhenPushed = YES;
            [pushClassStance pushViewController:teamGroupCtrl animated:YES];
        }
        //活动成绩详情 --
        if ([urlString containsString:@"activityScore"]) {
            JGLScoreRankViewController *scoreLiveCtrl= [[JGLScoreRankViewController alloc]init];
            scoreLiveCtrl.activity = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:urlString andKey:@"activityKey"] integerValue]];
            scoreLiveCtrl.teamKey = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:urlString andKey:@"teamKey"] integerValue]];
            scoreLiveCtrl.hidesBottomBarWhenPushed = YES;
            [pushClassStance pushViewController:scoreLiveCtrl animated:YES];
        }
        //获奖详情 --
        if ([urlString containsString:@"awardedInfo"]) {
            JGLPresentAwardViewController *teamGroupCtrl= [[JGLPresentAwardViewController alloc]init];
            teamGroupCtrl.activityKey = [[Helper returnKeyVlaueWithUrlString:urlString andKey:@"activityKey"] integerValue];
            teamGroupCtrl.teamKey = [[Helper returnKeyVlaueWithUrlString:urlString andKey:@"teamKey"] integerValue];
            teamGroupCtrl.isManager = 0;//0-非管理员
            teamGroupCtrl.hidesBottomBarWhenPushed = YES;
            [pushClassStance pushViewController:teamGroupCtrl animated:YES];
        }
        //球队详情
        if ([urlString containsString:@"teamDetail"]) {
            JGDNewTeamDetailViewController *newTeamVC = [[JGDNewTeamDetailViewController alloc] init];
            newTeamVC.timeKey = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:urlString andKey:@"teamKey"] integerValue]];
            newTeamVC.hidesBottomBarWhenPushed = YES;
            [pushClassStance pushViewController:newTeamVC animated:YES];
        }
        //商品详情
        if ([urlString containsString:@"goodDetail"]) {
            UseMallViewController* userVc = [[UseMallViewController alloc]init];
            userVc.linkUrl = [NSString stringWithFormat:@"http://www.dagolfla.com/app/ProductDetails.html?proid=%td", [[Helper returnKeyVlaueWithUrlString:urlString andKey:@"timekey"] integerValue]];
            userVc.hidesBottomBarWhenPushed = YES;
            [pushClassStance pushViewController:userVc animated:YES];
        }
        //H5
        if ([urlString containsString:@"openURL"]) {
            JGLPushDetailsViewController* puVc = [[JGLPushDetailsViewController alloc]init];
            puVc.strUrl = [Helper returnKeyVlaueWithUrlString:urlString andKey:@"timekey"];
            puVc.hidesBottomBarWhenPushed = YES;
            [pushClassStance pushViewController:puVc animated:YES];
        }
        //社区
        if ([urlString containsString:@"moodKey"]) {
            DetailViewController * comDevc = [[DetailViewController alloc]init];
            comDevc.detailId = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:urlString andKey:@"timekey"] integerValue]];
            comDevc.hidesBottomBarWhenPushed = YES;
            [pushClassStance pushViewController:comDevc animated:YES];
        }
        //创建球队
        if ([urlString containsString:@"createTeam"]) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            
            if ([user objectForKey:@"cacheCreatTeamDic"]) {
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"是否继续上次编辑" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [user setObject:0 forKey:@"cacheCreatTeamDic"];
                    JGNewCreateTeamTableViewController *creatteamVc = [[JGNewCreateTeamTableViewController alloc] init];
                    creatteamVc.hidesBottomBarWhenPushed = YES;
                    [pushClassStance pushViewController:creatteamVc animated:YES];
                }];
                UIAlertAction* action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    JGNewCreateTeamTableViewController *creatteamVc = [[JGNewCreateTeamTableViewController alloc] init];
                    creatteamVc.detailDic = [[user objectForKey:@"cacheCreatTeamDic"] mutableCopy];
                    creatteamVc.titleField.text = [[user objectForKey:@"cacheCreatTeamDic"] objectForKey:@"name"];
                    creatteamVc.hidesBottomBarWhenPushed = YES;
                    [pushClassStance pushViewController:creatteamVc animated:YES];
                }];
                
                [alert addAction:action1];
                [alert addAction:action2];
                [pushClassStance presentViewController:alert animated:YES completion:nil];
                
            }else{
                JGNewCreateTeamTableViewController *creatteamVc = [[JGNewCreateTeamTableViewController alloc] init];
                [pushClassStance pushViewController:creatteamVc animated:YES];
            }
        }
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

@end
