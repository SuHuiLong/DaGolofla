//
//  ForgetViewController.h
//  DaGolfla
//
//  Created by bhxx on 15/7/22.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ForgetViewController.h"

@interface ForgetViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIView* webBrowserView;

@property(nonatomic,retain)UIWebView *webView;

@property(nonatomic,retain)UIImageView *imageView;

@property(nonatomic,retain)UIActivityIndicatorView *actIndicatorView;

@end

@implementation ForgetViewController

-(UIWebView *)webView
{
    if (_webView==nil) {
        _webView=[[UIWebView alloc]init];
    }
    return _webView;
}

-(UIImageView *)imageView
{
    if (_imageView==nil) {
        _imageView=[[UIImageView alloc]init];
    }
    return _imageView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden=YES;
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.webView.delegate=self;
    [self.view addSubview:self.webView];
    self.title = @"忘记密码";
    
    
    NSURL* url = [NSURL URLWithString:@"http://www.dagolfla.com/app/login/Forgetpassword.html"];
    //    NSURL* url = [NSURL URLWithString:@"http://www.dagolfla.com/app/MembershipSerch.html"];
    //设置页面禁止滚动
    _webView.scrollView.bounces = NO ;
    //设置web占满屏幕
    _webView.scalesPageToFit = YES ;
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    UIActivityIndicatorView* actIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    actIndicator.frame = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2-100, 0, 0);
    
    [actIndicator startAnimating];
    [self.view addSubview:actIndicator];
    
    _actIndicatorView = actIndicator;
    
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

//    NSString *backStr = @"backsys";
    if ([@"http://www.dagolfla.com/app/" isEqualToString:[request.URL absoluteString]]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return NO;
        
    }

    return YES;
}





//加载完成
/**===========================JS  注入====================================*/
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_actIndicatorView stopAnimating];

    
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    ////NSLog(@"webview下载失败，error = %@",[error localizedDescription]);
    self.imageView.image = [UIImage imageNamed:@"logo"];
}

@end
