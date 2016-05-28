//
//  JGLNewShopDetailViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLNewShopDetailViewController.h"
#import "RCDraggableButton.h"
@interface JGLNewShopDetailViewController ()<UIApplicationDelegate,WKNavigationDelegate,WKUIDelegate>
@property (strong, nonatomic) WKWebView *webView;
@property(nonatomic,retain)UIActivityIndicatorView *actIndicatorView;

@end

@implementation JGLNewShopDetailViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //把当前界面的导航栏隐藏
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self createWebView];
}

#pragma mark --创建wkwebview
-(void)createWebView
{
    
    UIImageView *statusView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 20)];
    statusView.image = [UIImage imageNamed:@"nav_bg"];
    CGRect frame = statusView.frame;
    frame.origin = CGPointMake(0, 0);
    statusView.frame = frame;
    [self.view addSubview:statusView];
    [_actIndicatorView stopAnimating];
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [self.view addSubview:self.webView];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.allowsBackForwardNavigationGestures =YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlRequest]]];
    
    RCDraggableButton *avatar = [[RCDraggableButton alloc] initInKeyWindowWithFrame:CGRectMake(0, 100, 33, 38)];
    [self.view addSubview:avatar];
    avatar.backgroundColor = [UIColor clearColor];
    [avatar setBackgroundImage:[UIImage imageNamed:@"sy"] forState:UIControlStateNormal];
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnWebClick:)];
    tapGesture.numberOfTapsRequired = 1;
    [avatar addGestureRecognizer:tapGesture];
}
-(void)btnWebClick:(UIButton *)btn
{
    //    [btn removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
