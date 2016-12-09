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
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>

#import <TAESDK/TaeSDK.h>

#import <AlipaySDK/AlipaySDK.h>

#import "UMMobClick/MobClick.h"

#import "JGLAnimationViewController.h"
#define ImgUrlString2 @"http://res.dagolfla.com/h5/ad/app.jpg"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<CLLocationManagerDelegate, JPUSHRegisterDelegate>
{
    BMKMapManager* _mapManager;
}
//@property (strong, nonatomic) UIView *lunchView;
//@property (strong, nonatomic) UIWebView* webView;
@property (strong, nonatomic) CLLocationManager* locationManager;
@end

@implementation AppDelegate

- (void)umengTrack {
    //    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick setLogEnabled:YES];
    UMConfigInstance.appKey = @"574c75ed67e58ecb16003314";
    UMConfigInstance.secret = nil;
    //    UMConfigInstance.eSType = E_UM_GAME;
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick beginLogPageView:@""];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:[NSNumber numberWithFloat:31.15] forKey:BDMAPLAT];//纬度
    [user setObject:[NSNumber numberWithFloat:121.56] forKey:BDMAPLNG];//经度
    [user setObject:@"上海市" forKey:CITYNAME];//城市名
    [user synchronize];
    //定位
    [self getCurPosition];
    
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
    
    //-------------
//    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    //融云
//    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
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
    
    //调用PHP登录
    [self phpLogin];
    
    NSURL *url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
//    NSLog(@"%@", UIApplicationLaunchOptionsURLKey);
    if (url != nil) {
        if ([[url query] containsString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
//            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//                NSLog(@"result = %@",resultDic);
//                NSLog(@"客户端支付");
//            }];
            
        }else{
            
            [self APSHomeDealUrl:[NSString stringWithFormat:@"%@", url]];
        }

    }
    
    return YES;
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
//    [self gifReLoad];
    self.window.rootViewController = [[TabBarController alloc]init];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}
-(void)gifReLoad
{
    /**
     *  1.显示启动页广告
     */
    [XHLaunchAd showWithAdFrame:CGRectMake(0, 0,self.window.bounds.size.width, self.window.bounds.size.height) setAdImage:^(XHLaunchAd *launchAd) {
        
        //未检测到广告数据,启动页停留时间,不设置默认为3,(设置4即表示:启动页显示了4s,还未检测到广告数据,就自动进入window根控制器)
        launchAd.noDataDuration = 3;
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
        });
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
            [self APSHomeDealUrl:[NSString stringWithFormat:@"%@", url]];
        }
        
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
            [self APSHomeDealUrl:[NSString stringWithFormat:@"%@", url]];
        }
        
        return YES;
    }else{
        return [UMSocialSnsService handleOpenURL:url wxApiDelegate:self];
        //        [UMSocialSnsService handleOpenURL:url
        //                            wxDelegate:self];
    }
//    return YES;
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
            [self APSHomeDealUrl:[NSString stringWithFormat:@"%@", url]];
        }
        
        return YES;
    }
    else
    {
        return YES;
    }
}
#pragma mark -- 极光推送跳转
- (void)APSHomeDealUrl:(NSString *)dealURLString{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:dealURLString forKey:@"details"];
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"PushJGTeamActibityNameViewController" object:nil userInfo:dict];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}
#pragma mark -- 跳转到指定活动详情页面
//-(void)gotoAppPage:(NSString *)timekey switchDetails:(NSString *)details
//{
//    if ([timekey integerValue]>0) {
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        
//        [dict setObject:[NSString stringWithFormat:@"%td", [timekey integerValue]] forKey:@"timekey"];
//        [dict setObject:[NSString stringWithFormat:@"%@", details] forKey:@"details"];
//        //创建一个消息对象
//        NSNotification * notice = [NSNotification notificationWithName:@"PushJGTeamActibityNameViewController" object:nil userInfo:dict];
//        //发送消息
//        [[NSNotificationCenter defaultCenter]postNotification:notice];
//
//    }
//    else{
//        if (![Helper isBlankString:timekey]) {
//            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//            
//            timekey = [timekey stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            [dict setObject:[NSString stringWithFormat:@"%@", timekey] forKey:@"timekey"];
//            
//            [dict setObject:[NSString stringWithFormat:@"%@", details] forKey:@"details"];
//            //创建一个消息对象
//            NSNotification * notice = [NSNotification notificationWithName:@"PushJGTeamActibityNameViewController" object:nil userInfo:dict];
//            //发送消息
//            [[NSNotificationCenter defaultCenter]postNotification:notice];
//        }
//    }
//}

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
//    [JPUSHService handleRemoteNotification:userInfo];
    
     // 取得 APNs 标准信息内容
     NSDictionary *aps = [userInfo valueForKey:@"aps"];
//     NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
//     NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
//     NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
//     
//     // 取得Extras字段内容
//     NSString *customizeField1 = [userInfo valueForKey:@"customizeExtras"]; //服务端中Extras字段，key是自己定义的
//     NSLog(@"content =[%@], badge=[%d], sound=[%@], customize field  =[%@]",content, badge,sound,customizeField1);
    
     // iOS 10 以下 Required
     [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    //推送的自定义消息
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);

    [self APSHomeDealUrl:[userInfo objectForKey:@"url"]];
}
- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
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
    
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);; // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler: (void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [self APSHomeDealUrl:[userInfo objectForKey:@"url"]];
        
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
    [application registerForRemoteNotifications];
}

//自定义消息
//- (void)networkDidReceiveMessage:(NSNotification *)notification
//{
//    //网站推送
//    NSDictionary * userInfo = [notification userInfo];
//    NSString *content = [userInfo valueForKey:@"content"];
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];
//    
//    NSString *customizeField1 = [extras valueForKey:@"content"]; //自定义参数，key是自己定义的
//    
//}


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
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if ([[RCIMClient sharedRCIMClient] getConnectionStatus] == ConnectionStatus_Connected) {
        // 插入分享消息
//        [self insertSharedMessageIfNeed];
    }
    
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UMSocialSnsService  applicationDidBecomeActive];
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
//    [JPUSHService resetBadge];
    
    [self getCurPosition];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
//    [self loadIndexdata];
}

@end
