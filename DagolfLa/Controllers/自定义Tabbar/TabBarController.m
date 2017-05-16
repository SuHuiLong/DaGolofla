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
#import "DiscoveryActivitiesViewController.h"
#import "JKSlideViewController.h"
#import "MeViewController.h"

#import "PersonHomeController.h"
#import "ChatListViewController.h"
//#import "JGHMessageViewController.h"
#import "UITabBar+badge.h"
#import "UITool.h"

//融云
#import <RongIMKit/RongIMKit.h>
@interface TabBarController ()<UINavigationControllerDelegate, UITabBarControllerDelegate, UITabBarDelegate>{
    UIImageView *_tabbar;
}

@property (nonatomic,strong)UIButton *button;

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
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if ([item.title isEqualToString:@"首页"]) {
        [MobClick event:@"tab_home_click"];
    }else if ([item.title isEqualToString:@"球友圈"]) {
        [MobClick event:@"tab_ball_friends_click"];
    }else if ([item.title isEqualToString:@"消息"]) {
        [MobClick event:@"tab_msg_click"];
    }else if ([item.title isEqualToString:@"我的"]) {
        [MobClick event:@"tab_mine_click"];
    }else{
    
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
}

#pragma mark - createView
-(void)createView{
    UIImageView *backImgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, .5)];
    [self.tabBar insertSubview:backImgv atIndex:0];
    self.tabBarController.tabBar.opaque = YES;

    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];

    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#015836"]} forState:UIControlStateSelected];
    [self setUpAllViewControlller];
    [self setup];

}
//  添加突出按钮
-(void)setup
{
    [self addCenterButtonWithImage:[UIImage imageNamed:@"NavigationBar_ScoreCardDefault"] selectedImage:[UIImage imageNamed:@"NavigationBar_ScoreCardSelected"]];
    self.delegate=self;
    
}
// addCenterButton
-(void) addCenterButtonWithImage:(UIImage*)buttonImage selectedImage:(UIImage*)selectedImage{
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button addTarget:self action:@selector(pressChange:) forControlEvents:UIControlEventTouchUpInside];
    //  设定button大小为适应图片
    CGFloat W = buttonImage.size.width;
    CGFloat H = buttonImage.size.height;
    _button.frame = CGRectMake(self.tabBar.center.x - W/2, CGRectGetHeight(self.tabBar.bounds)-H - 8, W, H);
    
    [_button setImage:buttonImage forState:UIControlStateNormal];
    [_button setImage:selectedImage forState:UIControlStateSelected];
    
    _button.adjustsImageWhenHighlighted=NO;
    [self.tabBar addSubview:_button];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_button removeFromSuperview];
        [self.tabBar addSubview:_button];
    });
}


-(void)setUpAllViewControlller
{
    JGHNewHomePageViewController *shou = [[JGHNewHomePageViewController alloc] init];
    shou.title = @"首页";
    [self setUpOneChildViewController:shou image:[UIImage imageNamed:@"home-page_gray"] selectImage:[[UIImage imageNamed:@"home-page_green"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    JKSlideViewController *comVc = [[JKSlideViewController alloc] init];
    comVc.title = @"球友圈";
    [self setUpOneChildViewController:comVc image:[UIImage imageNamed:@"main_btn_community"] selectImage:[[UIImage imageNamed:@"main_btn_community_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    DiscoveryActivitiesViewController *daVc = [[DiscoveryActivitiesViewController alloc] init];
    daVc.title = @"发现活动";
    [self setUpOneChildViewController:daVc image:nil selectImage:nil];
    
    ChatListViewController *chatVc = [[ChatListViewController alloc] init];
    chatVc.title = @"消息";
    [self setUpOneChildViewController:chatVc image:[UIImage imageNamed:@"chat_gray"] selectImage:[[UIImage imageNamed:@"chat_green"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    MeViewController *meVc = [[MeViewController alloc] init];
    meVc.title = @"我的";
    [self setUpOneChildViewController:meVc image:[UIImage imageNamed:@"mine_gray"]  selectImage:[UIImage imageNamed:@"mine_green"]];
    
}

#pragma mark - Action
//中间按钮点击
-(void)pressChange:(id)sender{
    self.selectedIndex=2;
    _button.selected=YES;
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

@end
