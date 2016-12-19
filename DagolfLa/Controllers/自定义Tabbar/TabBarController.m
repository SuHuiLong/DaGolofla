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
    //    self.tabBarController.tabBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideTabBar) name:@"hide" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTabBar) name:@"show" object:nil];
    ////NSLog(@"88");
    
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hide" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"show" object:nil];
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

-(void)hideTabBar
{
    self.tabBar.hidden = YES;
}
-(void)showTabBar
{
    self.tabBar.hidden = NO;
}

-(void)actionClick:(UIButton *)btn
{
    for (UIView *view in btn.superview.subviews) {
        
        if ([view isKindOfClass:[TabBarItem class]]) {
            TabBarItem *item = (TabBarItem *)view;
            item.selected = NO;
        }
    }
    self.selectedIndex = btn.tag - 100;
    btn.selected = YES;
}
    ///////JKSlideViewController     /////CommunityViewController
//-(void)configViewControllers
//{
//    
//    NSArray *vcArr = @[@"ShouyeViewController",
//                       @"JKSlideViewController",
//                       @"ScoreViewController",
//                       @"ChatListViewController",
//                       @"MeViewController"];
//    
//    NSArray *titleArr = @[@"首页",@"社区",@"记分",@"消息",@"我的"];
//    NSMutableArray *arr = [[NSMutableArray alloc]init];
//    for (int i = 0; i<vcArr.count; i++) {
//        if (i != 3) {
//            ViewController *vc = [[NSClassFromString(vcArr[i]) alloc]init];
//            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
//            //            vc.type = i;
//            vc.title = titleArr[i];
//            [arr addObject:navi];
//        }
//        else
//        {
//            RCConversationViewController *vc = [[NSClassFromString(vcArr[i]) alloc]init];
//            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
//            //            vc.type = i;
//            vc.title = titleArr[i];
//            [arr addObject:navi];
//        }
//        //
//    }
//    self.viewControllers = arr;
//    
//}

-(void)setUpAllViewControlller
{
    JGHNewHomePageViewController *shou = [[JGHNewHomePageViewController alloc] init];
    shou.title = @"首页";
    [self setUpOneChildViewController:shou image:[UIImage imageNamed:@"home-page_gray"] selectImage:[[UIImage imageNamed:@"home-page_green"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    JKSlideViewController *comVc = [[JKSlideViewController alloc] init];
    
    
    
    
    //    USAFreindViewController *fe = [[USAFreindViewController alloc] init];
//    CommunityViewController *comVc = [[CommunityViewController alloc] init];
    comVc.title = @"球友圈";
    [self setUpOneChildViewController:comVc image:[UIImage imageNamed:@"main_btn_community"] selectImage:[[UIImage imageNamed:@"main_btn_community_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
//    JGLScoreNewViewController *scoVc = [[JGLScoreNewViewController alloc] init];
//    scoVc.title = @"记分";
    
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
    //    if ([vController isKindOfClass:[ViewController class]]) {
    naVC.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    //    } else {
    //        naVC.tabBarItem.imageInsets = UIEdgeInsetsMake(3, 0, -3, 0);
    //    }
    
    //    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tab_bg1"]];
//    if (ScreenWidth == 320) {
//        [self.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tab_320.png"]];
//    }
//    else if (ScreenWidth == 375)
//    {
//        [self.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tab_375.png"]];
//    }
//    else
//    {
//        [self.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tab_414.png"]];
//    }
//    [self.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"nav_bgcolor"]];
//    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"nav_bgcolor"]];
    [self.tabBar setBackgroundColor:[UITool colorWithHexString:@"f6f7f7" alpha:1]];
    
    naVC.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    naVC.tabBarItem.selectedImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:naVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
// 程序不卡的代码
//    if (self.selectedIndex == 1 || self.selectedIndex == 2 || self.selectedIndex == 3 || self.selectedIndex == 4) {
//        return YES;
//    }else {
//        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] != nil) {
//            return YES;
//        }else {
//            if (tabBarController.viewControllers[0] == viewController) {
//                return NO;
//            }else {
//                NSNotification *notification = [NSNotification notificationWithName:@"loging" object:nil userInfo:nil];
//                [[NSNotificationCenter defaultCenter] postNotification:notification];
//                return NO;
//            }
//        }
//    }
//}

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
