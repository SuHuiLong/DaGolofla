//
//  UseMallViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/7/22.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ResponseViewController.h"
#import "PostDataRequest.h"
#import "Helper.h"
#import "ChatDetailViewController.h"
#import "RCDraggableButton.h"
@interface ResponseViewController ()<UIWebViewDelegate>

@property(nonatomic,retain)UIWebView *webView;

@property(nonatomic,retain)UIImageView *imageView;

@property(nonatomic,retain)UIActivityIndicatorView *actIndicatorView;

@end

@implementation ResponseViewController

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


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务条款";
    self.webView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.webView.delegate=self;
    
    [self.view addSubview:self.webView];
    NSURL* url = [NSURL URLWithString:@"http://www.dagolfla.com:8081/dagaoerfu/html5/AppInfo/appinfo.html?type=1"];
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
-(void)btnWebClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_actIndicatorView stopAnimating];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    ////NSLog(@"webview下载失败，error = %@",[error localizedDescription]);
    self.imageView.image = [UIImage imageNamed:@"logo"];
}



@end
