//
//  JGTeamDeatilWKwebViewController.m
//  DagolfLa
//
//  Created by 東 on 16/5/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//
#import <WebKit/WebKit.h>
#import "JGTeamDeatilWKwebViewController.h"

@interface JGTeamDeatilWKwebViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (strong, nonatomic) WKWebView *webView;

@end

@implementation JGTeamDeatilWKwebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.teamName;
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.allowsBackForwardNavigationGestures =YES;
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://imgcache.dagolfla.com/html/index.html"]]];
    if (self.detailString) {
        [self.webView loadHTMLString:self.detailString baseURL:nil];
    }else{
        [Helper alertViewNoHaveCancleWithTitle:@"球队详情页面为空" withBlock:^(UIAlertController *alertView) {
            [self.navigationController presentViewController:alertView animated:YES completion:nil];
        }];
    }
    
    
    
    // Do any additional setup after loading the view.
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
