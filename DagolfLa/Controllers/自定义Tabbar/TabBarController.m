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


#import "ShouyeViewController.h"
#import "CommunityViewController.h"
#import "JKSlideViewController.h"
#import "MeViewController.h"
#import "JGLScoreNewViewController.h"

#import "UserDataInformation.h"
#import "EnterViewController.h"
#import "PersonHomeController.h"
#import "ChatListViewController.h"
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
    //    [self configViewControllers];
    //
    //    //创建标签
    //    [self createTabbarItems];
    
    //    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tab_bg1"]];
    UIImageView *backImgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 49)];
    backImgv.image = [UIImage imageNamed:@"tab_bg1"];
    [self.tabBar insertSubview:backImgv atIndex:0];
    self.tabBarController.tabBar.opaque = YES;
    
    
    
    self.tabBar.tintColor = [UIColor whiteColor];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    
    // 去掉系统的横线
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6)
    {
        [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    }
    
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


-(void)createTabbarItems
{
    _tabbar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 49*ScreenWidth/320)];
    _tabbar.image = [UIImage imageNamed:@"tabbar_bg"];
    _tabbar.userInteractionEnabled = YES;
    [self.tabBar addSubview:_tabbar];
    //    self.tabBar
    [self.tabBar showBadgeOnItemIndex:2];
    NSArray *titleArr = @[@"首页",@"社区",@"记分",@"消息",@"我的"];
    NSArray *picArr = @[@"tab_sy",
                        @"sq",
                        @"tab_jf",
                        @"xx",
                        @"tab_wd"];
    //    NSArray *picSelectedArr = @[@"tabbar_limitfree_press",
    //                                @"tabbar_reduceprice_press",
    //                                @"tabbar_appfree_press",
    //                                @"tabbar_subject_press"];
    for (int i = 0; i<titleArr.count; i++) {
        TabBarItem *item = [TabBarItem buttonWithType:UIButtonTypeCustom];
        item.frame = CGRectMake(ScreenWidth/titleArr.count*i, 0, ScreenWidth/titleArr.count, 49*ScreenWidth/320);
        [_tabbar addSubview:item];
        [item setTitle:titleArr[i] forState:UIControlStateNormal];
        [item setImage:[UIImage imageNamed:picArr[i]] forState:UIControlStateNormal];
        //        [item setImage:[UIImage imageNamed:picSelectedArr[i]] forState:UIControlStateSelected];
        if (i == 0) {
            item.selected = YES;
        }
        item.tag = 100 + i;
        [item addTarget:self action:@selector(actionClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i >0) {
            UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/5*i, 0, 1, _tabbar.frame.size.height)];
            imgv.image = [UIImage imageNamed:@"tab_line"];
            [_tabbar addSubview:imgv];
        }
        
    }
    
    //    [self.tabBar showBadgeOnItemIndex:4];
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
-(void)configViewControllers
{
    
    NSArray *vcArr = @[@"ShouyeViewController",
                       @"JKSlideViewController",
                       @"ScoreViewController",
                       @"ChatListViewController",
                       @"MeViewController"];
    
    NSArray *titleArr = @[@"首页",@"社区",@"记分",@"消息",@"我的"];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i<vcArr.count; i++) {
        if (i != 3) {
            ViewController *vc = [[NSClassFromString(vcArr[i]) alloc]init];
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
            //            vc.type = i;
            vc.title = titleArr[i];
            [arr addObject:navi];
        }
        else
        {
            RCConversationViewController *vc = [[NSClassFromString(vcArr[i]) alloc]init];
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
            //            vc.type = i;
            vc.title = titleArr[i];
            [arr addObject:navi];
        }
        //
    }
    self.viewControllers = arr;
    
}

-(void)setUpAllViewControlller
{
    ShouyeViewController *shou = [[ShouyeViewController alloc] init];
    shou.title = @"首页";
    [self setUpOneChildViewController:shou image:[UIImage imageNamed:@"tab_sy"] selectImage:[[UIImage imageNamed:@"tab_sy"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    JKSlideViewController *comVc = [[JKSlideViewController alloc] init];

    //    USAFreindViewController *fe = [[USAFreindViewController alloc] init];
//    CommunityViewController *comVc = [[CommunityViewController alloc] init];
    comVc.title = @"社区";
    [self setUpOneChildViewController:comVc image:[UIImage imageNamed:@"sq"] selectImage:[[UIImage imageNamed:@"sq"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    JGLScoreNewViewController *scoVc = [[JGLScoreNewViewController alloc] init];
    scoVc.title = @"记分";
    [self setUpOneChildViewController:scoVc image:[UIImage imageNamed:@"tab_jf"] selectImage:[[UIImage imageNamed:@"tab_jf"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    ChatListViewController *chatVc = [[ChatListViewController alloc] init];
    chatVc.title = @"消息";
    [self setUpOneChildViewController:chatVc image:[UIImage imageNamed:@"xx"] selectImage:[[UIImage imageNamed:@"xx"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    MeViewController *meVc = [[MeViewController alloc] init];
    meVc.title = @"我的";
    [self setUpOneChildViewController:meVc image:[UIImage imageNamed:@"tab_wd"]  selectImage:[UIImage imageNamed:@"tab_wd"]];
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
    if (ScreenWidth == 320) {
        [self.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tab_320.png"]];
    }
    else if (ScreenWidth == 375)
    {
        [self.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tab_375.png"]];
    }
    else
    {
        [self.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tab_414.png"]];
    }
    
    //    [self.tabBar setBackgroundColor:[UITool colorWithHexString:@"3b3f42" alpha:1]];
    
    naVC.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    naVC.tabBarItem.selectedImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:naVC];
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    //    NSArray* arr = tabBar.items;
    //    for(int i=0 ;i < 4 ;i++)
    //    {
    //    }
    //    item.selectedImage = [UIImage imageNamed:@"tab_bg2"];
    
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

@end
