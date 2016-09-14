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

#import "Helper.h"
#import "PostDataRequest.h"
#import "NewsDetailController.h"
#import "JPUSHService.h"

#import <TAESDK/TaeSDK.h>

#import <AlipaySDK/AlipaySDK.h>

#import "UMMobClick/MobClick.h"


#define ImgUrlString2 @"http://res.dagolfla.com/h5/ad/app.jpg"
@interface AppDelegate ()
{
    BMKMapManager* _mapManager;
}
//@property (strong, nonatomic) UIView *lunchView;
//@property (strong, nonatomic) UIWebView* webView;
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
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
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
                NSString *str3=[NSString stringWithFormat:@"http://www.dagolfla.com:8081/small_%@",[user objectForKey:@"pic"]];
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
    //微信支付
    [WXApi registerApp:@"wxdcdc4e20544ed728"];
    [self umengTrack];

    //    //取出新版本号
    //    NSString* versionKey = (NSString*)kCFBundleVersionKey;
    //    NSString* version = [NSBundle mainBundle].infoDictionary[versionKey];
    //    //取出老的版本号
    //    NSString* lastVerson = [[NSUserDefaults standardUserDefaults]valueForKey:versionKey];
    //    if(![version isEqualToString:lastVerson])
    //    {
    //        PageViewController* pageview = [[PageViewController alloc]init];
    //        self.window.rootViewController = pageview;
    //        [pageview setCallBack:^{
    //            [[NSUserDefaults standardUserDefaults]setValue:version forKey:versionKey];
    //            [[NSUserDefaults standardUserDefaults]synchronize];
    //            [self startApp];
    //        }];
    //    }
    //    else
    //    {
    [self startApp];
    //    }
    return YES;
}
-(void)startApp
{
    [self gifReLoad];
    [self.window makeKeyAndVisible];
}
-(void)gifReLoad
{
    /**
     *  1.显示启动页广告
     */
    [XHLaunchAd showWithAdFrame:CGRectMake(0, 0,self.window.bounds.size.width, self.window.bounds.size.height) setAdImage:^(XHLaunchAd *launchAd) {
        
        //未检测到广告数据,启动页停留时间,不设置默认为3,(设置4即表示:启动页显示了4s,还未检测到广告数据,就自动进入window根控制器)
        //launchAd.noDataDuration = 4;
        
        //获取广告数据
        [self requestImageData:^(NSString *imgUrl, NSInteger duration, NSString *openUrl) {
            
            /**
             *  2.设置广告数据
             */
            
//            WEAKLAUNCHAD;//定义一个weakLaunchAd
            [launchAd setImageUrl:imgUrl duration:duration skipType:SkipTypeTimeText options:XHWebImageDefault completed:^(UIImage *image, NSURL *url) {
                
                //异步加载图片完成回调(若需根据图片尺寸,刷新广告frame,可在这里操作)
                //weakLaunchAd.adFrame = ...;
                
            } click:^{
                //打开网页
                
            }];
            
        }];
        
    } showFinish:^{
        self.window.rootViewController = [[TabBarController alloc]init];
        self.window.backgroundColor = [UIColor whiteColor];
    }];
}
/**
 *  模拟:向服务器请求广告数据
 *
 *  @param imageData 回调imageUrl,及停留时间,跳转链接
 */
-(void)requestImageData:(void(^)(NSString *imgUrl,NSInteger duration,NSString *openUrl))imageData{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if(imageData)
        {
            imageData(ImgUrlString2,3.5,@"http://www.dagolfla.com");
        }
    });
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    //这里判断是否发起的请求为微信支付，如果是的话，用WXApi的方法调起微信客户端的支付页面（://pay 之前的那串字符串就是你的APPID，）
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"wxdcdc4e20544ed728://pay"]].location != NSNotFound) {
        return  [WXApi handleOpenURL:url delegate:self];
        //不是上面的情况的话，就正常用shareSDK调起相应的分享页面
    }
    else if ([url.host isEqualToString:@"safepay"]) {
        //这个是进程KILL掉之后也会调用，这个只是第一次授权回调，同时也会返回支付信息
        [[AlipaySDK defaultService]processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSString * str = resultDic[@"result"];
            NSLog(@"result = %@",str);
        }];
        //跳转支付宝钱包进行支付，处理支付结果，这个只是辅佐订单支付结果回调
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            id<DataVerifier> dataVeri = CreateRSADataVerifier(@"public");
            //验证签名是否一致
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
//                [[ShowHUD showHUD]showToastWithText:@"支付成功！" FromView:self.view];
                //跳转分组页面
//                [self performSelector:@selector(popToChannel) withObject:self afterDelay:TIMESlEEP];
                
            } else if ([resultDic[@"resultStatus"] isEqualToString:@"4000"]) {
                NSLog(@"失败");
//                [[ShowHUD showHUD]showToastWithText:@"支付失败！" FromView:self.view];
            } else if ([resultDic[@"resultStatus"] isEqualToString:@"6002"]) {
                NSLog(@"网络错误");
//                [[ShowHUD showHUD]showToastWithText:@"网络异常，支付失败！" FromView:self.view];
            } else if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
                NSLog(@"取消支付");
//                [[ShowHUD showHUD]showToastWithText:@"支付已取消！" FromView:self.view];
            } else {
                NSLog(@"支付失败");
//                [[ShowHUD showHUD]showToastWithText:@"支付失败！" FromView:self.view];
            }
            
        }];
        return YES;
    }
    else{
        return [UMSocialSnsService handleOpenURL:url wxApiDelegate:self];
//        [UMSocialSnsService handleOpenURL:url
//                            wxDelegate:self];
    }
    
}

//新浪微博的
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"wxdcdc4e20544ed728://pay"]].location != NSNotFound) {
        return  [WXApi handleOpenURL:url delegate:self];
        //不是上面的情况的话，就正常用shareSDK调起相应的分享页面
    }else{
        return [UMSocialSnsService handleOpenURL:url wxApiDelegate:self];
        //        [UMSocialSnsService handleOpenURL:url
        //                            wxDelegate:self];
    }
    return YES;
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
            NSString *actKey = @"";
            NSString *actDetail = @"";
            if ([url query]) {
                actKey = [[[NSString stringWithFormat:@"%@", [url query]] componentsSeparatedByString:@"="] objectAtIndex:1];
                actDetail = [[[NSString stringWithFormat:@"%@", [url query]] componentsSeparatedByString:@"="] objectAtIndex:0];
            }
            
            [self gotoAppPage:actKey switchDetails:actDetail];
        }
        
        return YES;
    }
    else
    {
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



#pragma mark --消息推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [JPUSHService registerDeviceToken:deviceToken];
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
