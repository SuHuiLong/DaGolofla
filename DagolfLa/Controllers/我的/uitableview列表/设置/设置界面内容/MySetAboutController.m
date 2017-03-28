//
//  PackageViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/7/22.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "MySetAboutController.h"
#import "Helper.h"
#import "PostDataRequest.h"
@interface MySetAboutController ()<UIWebViewDelegate>

@property(nonatomic,retain)UIWebView *webView;

@property(nonatomic,retain)UIImageView *imageView;

@property(nonatomic,retain)UIActivityIndicatorView *actIndicatorView;

@end

@implementation MySetAboutController

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
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    self.webView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
    self.webView.delegate=self;
    
    [self.view addSubview:self.webView];
    
    NSString* versionKey = (NSString*)kCFBundleVersionKey;
    NSString* version = [NSBundle mainBundle].infoDictionary[versionKey];
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://res.dagolfla.com/h5/aboutUs/index.html?version=%@", version]];
    
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

-(void)webViewDidFinishLoad:(UIWebView *)webView
{

    [_actIndicatorView stopAnimating];
    
    
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    ////NSLog(@"webview下载失败，error = %@",[error localizedDescription]);
    self.imageView.image = [UIImage imageNamed:DefaultHeaderImage];
}



@end
