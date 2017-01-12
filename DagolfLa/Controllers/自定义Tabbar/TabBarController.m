//
//  TabBarController.m
//
//
//  Created by huangdl on 15-5-4.
//  Copyright (c) 2015年 liq. All rights reserved.
//

#import "TabBarController.h"
#import "TabBarItem.h"
#import "AppDelegate.h"


#import "JGHNewHomePageViewController.h"
#import "CommunityViewController.h"
#import "JKSlideViewController.h"
#import "MeViewController.h"
//#import "JGLScoreNewViewController.h"

#import "UserDataInformation.h"
#import "PersonHomeController.h"
#import "ChatListViewController.h"
//#import "JGHMessageViewController.h"
#import "UITabBar+badge.h"
#import "UITool.h"

//融云
#import <RongIMKit/RongIMKit.h>
@interface TabBarController ()<UINavigationControllerDelegate, UITabBarControllerDelegate>
{
    UIImageView *_tabbar;
}
@end

@implementation TabBarController

+ (TabBarController *)shareInstance {
    static TabBarController *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ////NSLog(@"100");
}



- (void)viewDidLoad {
    [super viewDidLoad];
    //创建视图控制器数组
    //
    //    //创建标签
    //    [self createTabbarItems];
    
    //    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tab_bg1"]];
    UIImageView *backImgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, .5)];
//    backImgv.backgroundColor = [UITool colorWithHexString:@"8a8b87" alpha:1];
    [self.tabBar insertSubview:backImgv atIndex:0];
    self.tabBarController.tabBar.opaque = YES;
//    [self.tabBar setTitleTextAttributes:[UITool colorWithHexString:@"" alpha:1];
    
    
//    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UITool colorWithHexString:@"929292" alpha:1]} forState:UIControlStateNormal];
//    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UITool colorWithHexString:@"32b14d" alpha:1]} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];

    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#015836"]} forState:UIControlStateSelected];
    
    // 去掉系统的横线
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6)
//    {
//        [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
//    }
//    
    [self setUpAllViewControlller];
    
}

-(void)setUpAllViewControlller
{
    JGHNewHomePageViewController *shou = [[JGHNewHomePageViewController alloc] init];
    shou.title = @"首页";
    [self setUpOneChildViewController:shou image:[UIImage imageNamed:@"home-page_gray"] selectImage:[[UIImage imageNamed:@"home-page_green"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    JKSlideViewController *comVc = [[JKSlideViewController alloc] init];
    
    comVc.title = @"球友圈";
    [self setUpOneChildViewController:comVc image:[UIImage imageNamed:@"main_btn_community"] selectImage:[[UIImage imageNamed:@"main_btn_community_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
    ChatListViewController *chatVc = [[ChatListViewController alloc] init];
    chatVc.title = @"消息";
    [self setUpOneChildViewController:chatVc image:[UIImage imageNamed:@"chat_gray"] selectImage:[[UIImage imageNamed:@"chat_green"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    MeViewController *meVc = [[MeViewController alloc] init];
    meVc.title = @"我的";
    [self setUpOneChildViewController:meVc image:[UIImage imageNamed:@"mine_gray"]  selectImage:[UIImage imageNamed:@"mine_green"]];
}
// 添加一个子控制器的方法
- (void)setUpOneChildViewController:(UIViewController *)vController image:(UIImage *)image selectImage:(UIImage *)selectImage
{
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:vController];
    
    // 防止返回根视图控制器，不走viewWillAppear
    naVC.delegate = self;
    // 调整图片的位置,代码的位置写在tabbar添加子导航控制器
    naVC.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);

    [self.tabBar setBackgroundColor:[UITool colorWithHexString:@"f6f7f7" alpha:1]];
    
    naVC.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    naVC.tabBarItem.selectedImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:naVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    // 获取当前的控制器
    UINavigationController *navC = self.selectedViewController;
    UIViewController *currentVC = navC.visibleViewController;
    
    // 因为默认shouldAutorotate是YES，所以每个不需要支持横屏的控制器都需要重写一遍这个方法
    // 一般项目中要支持横屏的界面比较少，为了解决这个问题，就取反值：shouldAutorotate返回为YES的时候不能旋转，返回NO的时候可以旋转
    // 所以只要重写了shouldAutorotate方法的控制器，并return了NO，这个控制器就可以旋转
    // 当然，如果项目中支持横屏的界面占多数的话，可以不取反值。
    NSLog(@"当前控制器：%@  是否支持旋转：%zd", currentVC, !currentVC.shouldAutorotate);
    
    return !currentVC.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

@end
