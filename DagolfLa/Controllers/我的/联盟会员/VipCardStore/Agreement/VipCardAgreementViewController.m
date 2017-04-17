//
//  VipCardAgreementViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/4/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "VipCardAgreementViewController.h"

@interface VipCardAgreementViewController ()
//webView
@property(nonatomic, strong)WKWebView *webView;

@end

@implementation VipCardAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - CreateView
-(void)createView{
    [self createNavigation];
    [self createWebView];
}
-(void)createNavigation{
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    self.title = @"君高联盟";
}
//展示
-(void)createWebView{
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-kHvertical(51))];
    //2.创建URL
    NSURL *URL = [NSURL URLWithString:@"http://res.dagolfla.com/h5/league/sysLeagueAgreement.html"];
    //3.创建Request
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    //4.加载Request
    [webView loadRequest:request];
    //5.添加到视图
    self.webView = webView;
    [self.view addSubview:webView];
    
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
