//
//  AppDelegate.h
//  DagolfLa
//
//  Created by bhxx on 15/10/9.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import <RongIMKit/RongIMKit.h>

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,RCIMConnectionStatusDelegate, RCIMReceiveMessageDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)loadMessageData;//下载未读消息数量/获取通知数量

@end

