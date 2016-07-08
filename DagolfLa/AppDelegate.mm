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
#import "UMSocialSinaHandler.h"

#import "PageViewController.h"
#import <BaiduMapAPI/BMapKit.h>//引入所有的头文件

#import <BaiduMapAPI/BMKMapView.h>//只引入所需的单个头文件

#import "UserInformationModel.h"
#import "UserDataInformation.h"
//融云
#import <RongIMKit/RongIMKit.h>

#import "Helper.h"
#import "PostDataRequest.h"
#import "NewsDetailController.h"
#import "JPUSHService.h"

#import <TAESDK/TaeSDK.h>

#import <AlipaySDK/AlipaySDK.h>

#import "UMMobClick/MobClick.h"

@interface AppDelegate ()
{
    BMKMapManager* _mapManager;
}
@end

@implementation AppDelegate

- (void)umengTrack {
    //    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick setLogEnabled:YES];
    UMConfigInstance.appKey = @"574c75ed67e58ecb16003314";
    UMConfigInstance.secret = nil;
    //    UMConfigInstance.eSType = E_UM_GAME;
    [MobClick startWithConfigure:UMConfigInstance];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        
    //初始化趣拍
    [[TaeSDK sharedInstance] asyncInit:^{
        
    } failedCallback:^(NSError *error) {
        NSLog(@"TaeSDK init failed!!!");
    }];
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
    
    //极光推送
    // Required
    //    NSUserDefaults *use = [NSUserDefaults standardUserDefaults];
    //    if ([use objectForKey:@"shake"]) {
    //        if ([[use objectForKey:@"shake"] integerValue] == 1) {
    //            //可以添加自定义categories
    //            [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
    //                                                              UIUserNotificationTypeSound |
    //                                                              UIUserNotificationTypeAlert)
    //                                                  categories:nil];
    //        } else {
    //            //categories 必须为nil
    //            [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
    //                                                              UIRemoteNotificationTypeSound |
    //                                                              UIRemoteNotificationTypeAlert)
    //                                                  categories:nil];
    //        }
    //    } else {
    //        [use setObject:@1 forKey:@"shake"];
    //        [use synchronize];
    //        //如需兼容旧版本的方式，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化和同时使用pushConfig.plist文件声明appKey等配置内容。
    //        [JPUSHService setupWithOption:launchOptions appKey:@"831cd22faea3454090c15bbe" channel:@"Publish channel" apsForProduction:NO];
    //    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    // Required
    //如需兼容旧版本的方式，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化和同时使用pushConfig.plist文件声明appKey等配置内容。
    [JPUSHService setupWithOption:launchOptions appKey:@"831cd22faea3454090c15bbe" channel:nil apsForProduction:NO];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    //融云
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    if ([user objectForKey:@"userId"]) {
        
        
        [[PostDataRequest sharedInstance] postDataRequest:@"user/queryById.do" parameter:@{@"userId":[user objectForKey:@"userId"]} success:^(id respondsData) {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingAllowFragments error:nil];
            if ([[dict objectForKey:@"success"] integerValue]==1) {
                
                
                //保存用户数据信息
                UserInformationModel *model = [[UserInformationModel alloc] init];
                [model setValuesForKeysWithDictionary:[dict objectForKey:@"rows"]];
                [[UserDataInformation sharedInstance] saveUserInformation:model];
                //                设置会话列表头像和会话界面头像
                
                NSString *token=[UserDataInformation sharedInstance].userInfor.rongTk;
                [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(40*ScreenWidth/375, 40*ScreenWidth/375);
                [RCIM sharedRCIM].globalConversationAvatarStyle=RC_USER_AVATAR_CYCLE;
                [RCIM sharedRCIM].globalMessageAvatarStyle=RC_USER_AVATAR_CYCLE;
                [[RCIM sharedRCIM] initWithAppKey:@"0vnjpoadnkihz"];//pgyu6atqylmiu
                
                [[RCIM sharedRCIM] setUserInfoDataSource:[UserDataInformation sharedInstance]];
                [[RCIM sharedRCIM] setGroupInfoDataSource:[UserDataInformation sharedInstance]];
                NSString *str1=[NSString stringWithFormat:@"%@",[user objectForKey:@"userId"]];
                NSString *str2=[NSString stringWithFormat:@"%@",[user objectForKey:@"userName"]];
                //完整的图片请求路径
                NSString *str3=[NSString stringWithFormat:@"http://139.196.9.49:8081/small_%@",[user objectForKey:@"pic"]];
                //                NSLog(@"%@",[user objectForKey:@"pic"]);
                RCUserInfo *userInfo=[[RCUserInfo alloc] initWithUserId:str1 name:str2 portrait:str3];
                [RCIM sharedRCIM].currentUserInfo=userInfo;
                [RCIM sharedRCIM].enableMessageAttachUserInfo=NO;
                //                [RCIM sharedRCIM].receiveMessageDelegate=self;
                // 快速集成第二步，连接融云服务器
                [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
                    //NSLog(@"1111");
                    //自动登录   连接融云服务器
                    [[UserDataInformation sharedInstance] synchronizeUserInfoRCIM];
                    
                }error:^(RCConnectErrorCode status) {
                    // Connect 失败
                    //                        NSLog(@"连接失败");
                }tokenIncorrect:^() {
                    // Token 失效的状态处理
                    //
                    //                         NSLog(@"token失效");
                }];
                
            }
            else
            {
                [[RCIM sharedRCIM] initWithAppKey:@"0vnjpoadnkihz"];//pgyu6atqylmiu
                //网页端同步退出
                [[PostDataRequest sharedInstance] getDataRequest:[NSString stringWithFormat:@"http://www.dagolfla.com/app/api/client/api.php?Action=UserLogOut"] success:^(id respondsData) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                } failed:^(NSError *error) {
                    
                }];
                
                [[NSURLCache sharedURLCache] removeAllCachedResponses];
                [[RCIMClient sharedRCIMClient]logout];
                //清空记分的数据和登录的数据
                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                
                [user removeObjectForKey:@"userId"];
                [user removeObjectForKey:@"scoreObjectTitle"];
                [user removeObjectForKey:@"scoreballName"];
                [user removeObjectForKey:@"scoreSite0"];
                [user removeObjectForKey:@"scoreSite1"];
                [user removeObjectForKey:@"scoreType"];
                [user removeObjectForKey:@"scoreTTaiwan"];
                [user removeObjectForKey:@"scoreObjectId"];
                [user removeObjectForKey:@"scoreballId"];
                [user removeObjectForKey:@"openId"];
                [user removeObjectForKey:@"uid"];
                [user removeObjectForKey:@"isWeChat"];
                //
                [user synchronize];
                
            }
        } failed:^(NSError *error) {
            [[RCIM sharedRCIM] initWithAppKey:@"0vnjpoadnkihz"];//pgyu6atqylmiu
            //网页端同步退出
            [[PostDataRequest sharedInstance] getDataRequest:[NSString stringWithFormat:@"http://www.dagolfla.com/app/api/client/api.php?Action=UserLogOut"] success:^(id respondsData) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            } failed:^(NSError *error) {
                
            }];
            
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            [[RCIMClient sharedRCIMClient]logout];
            //清空记分的数据和登录的数据
            NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
            
            [user removeObjectForKey:@"userId"];
            [user removeObjectForKey:@"scoreObjectTitle"];
            [user removeObjectForKey:@"scoreballName"];
            [user removeObjectForKey:@"scoreSite0"];
            [user removeObjectForKey:@"scoreSite1"];
            [user removeObjectForKey:@"scoreType"];
            [user removeObjectForKey:@"scoreTTaiwan"];
            [user removeObjectForKey:@"scoreObjectId"];
            [user removeObjectForKey:@"scoreballId"];
            [user removeObjectForKey:@"openId"];
            [user removeObjectForKey:@"uid"];
            [user removeObjectForKey:@"isWeChat"];
            //
            [user synchronize];
            
        }];
        
        
    }
    else
    {
        [[RCIM sharedRCIM] initWithAppKey:@"0vnjpoadnkihz"];//pgyu6atqylmiu
    }
    
    //取出新版本号
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
        [self startApp];
    }
    
    
    //微信支付
    [WXApi registerApp:@"wxdcdc4e20544ed728"];
    [self umengTrack];
    return YES;
}


//新浪微博的
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([url.scheme isEqualToString:@"wxdcdc4e20544ed728"]) {
        [WXApi handleOpenURL:url delegate:self];
    }
    else{
        return  [UMSocialSnsService handleOpenURL:url];
    }
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    if ([url.scheme isEqualToString:@"sina.561e0d97e0f55a66640014e2"])
    {
        return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    }else if ([url.scheme isEqualToString:@"wxdcdc4e20544ed728"]) {
        BOOL result = [UMSocialSnsService handleOpenURL:url];
        if (result == FALSE) {
            //调用其他SDK，例如支付宝SDK等
            return [WXApi handleOpenURL:url delegate:self];
        }
        return result;
    }else if ([url.scheme isEqualToString:@"dagolfla"]){
        NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
        NSLog(@"URL scheme:%@", [url scheme]);
        NSLog(@"URL query: %@", [url query]);
        NSString *actKey = @"";
        NSString *actDetail = @"";
        if ([url query]) {
            actKey = [[[NSString stringWithFormat:@"%@", [url query]] componentsSeparatedByString:@"="] objectAtIndex:1];
            actDetail = [[[NSString stringWithFormat:@"%@", [url query]] componentsSeparatedByString:@"="] objectAtIndex:0];
        }
        
        [self gotoAppPage:actKey switchDetails:actDetail];
        return YES;
    }
    else
    {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSLog(@"客户端支付");
        }];
        
        return YES;
    }
}

#pragma mark -- 跳转到指定活动详情页面
-(void)gotoAppPage:(NSString *)timekey switchDetails:(NSString *)details
{
    if ([timekey integerValue]>0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        [dict setObject:[NSString stringWithFormat:@"%td", [timekey integerValue]] forKey:@"timekey"];
        [dict setObject:[NSString stringWithFormat:@"%@", details] forKey:@"details"];
        //创建一个消息对象
        NSNotification * notice = [NSNotification notificationWithName:@"PushJGTeamActibityNameViewController" object:nil userInfo:dict];
        //发送消息
        [[NSNotificationCenter defaultCenter]postNotification:notice];

    }
    else{
        if (![Helper isBlankString:timekey]) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            
            timekey = [timekey stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [dict setObject:[NSString stringWithFormat:@"%@", timekey] forKey:@"timekey"];
            
            [dict setObject:[NSString stringWithFormat:@"%@", details] forKey:@"details"];
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"PushJGTeamActibityNameViewController" object:nil userInfo:dict];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
        }
    }
}

-(void)startApp
{
    self.window.rootViewController = [[TabBarController alloc]init];
    self.window.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark --消息推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [JPUSHService registerDeviceToken:deviceToken];
}



-(void)onReq:(BaseReq *)req{
    
}

-(void)onResp:(BaseResp *)resp{
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
            }
                break;
            case WXErrCodeCommon:
            { //签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
                
                NSLog(@"支付结果: 失败!");
            }
                break;
            case WXErrCodeUserCancel:
            { //用户点击取消并返回
                
            }
                break;
            case WXErrCodeSentFail:
            { //发送失败
                NSLog(@"发送失败");
            }
                break;
            case WXErrCodeUnsupport:
            { //微信不支持
                NSLog(@"微信不支持");
            }
                break;
            case WXErrCodeAuthDeny:
            { //授权失败
                NSLog(@"授权失败");
            }
                break;
            default:
                break;
        }
        //------------------------
        
        //创建一个消息对象
        NSNotification * notice = [NSNotification notificationWithName:@"weChatNotice" object:nil userInfo:@{@"secess":@"1"}];
        //发送消息
        [[NSNotificationCenter defaultCenter]postNotification:notice];
    }
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    //推送的自定义消息
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
//    NewsDetailController * VC = [[NewsDetailController alloc]init];
//    //    VC.pushType = 1;
//    UINavigationController * Nav = [[UINavigationController alloc]initWithRootViewController:VC];//这里加导航栏是因为我跳转的页面带导航栏，如果跳转的页面不带导航，那这句话请省去。
//    //    [self.window.rootViewController presentViewController:Nav animated:YES completion:nil];
//    [self.window.rootViewController.navigationController pushViewController:VC animated:YES];
    NSString* str = [userInfo objectForKey:@"url"];
    NSURL *url = [NSURL URLWithString:str];
    if ([url.scheme isEqualToString:@"dagolfla"]){
        NSLog(@"URL scheme:%@", [url scheme]);
        NSLog(@"URL query: %@", [url query]);
        NSString *actKey = @"";
        NSString *actDetail = @"";
        if ([url query]) {
            actKey = [[[NSString stringWithFormat:@"%@", [url query]] componentsSeparatedByString:@"="] objectAtIndex:1];
            actDetail = [[[NSString stringWithFormat:@"%@", [url query]] componentsSeparatedByString:@"="] objectAtIndex:0];
        }
        
        [self gotoAppPage:actKey switchDetails:actDetail];
    }

    
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    //Optional
}

// 设置消息推送的样式
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

//自定义消息
- (void)networkDidReceiveMessage:(NSNotification *)notification
{
    //网站推送
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    
    NSString *customizeField1 = [extras valueForKey:@"content"]; //自定义参数，key是自己定义的
    
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UMSocialSnsService  applicationDidBecomeActive];
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    [JPUSHService resetBadge];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
