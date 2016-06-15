//
//  PackageViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/7/22.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ChangePicViewController.h"
//#import "Helper.h"
//#import "PostDataRequest.h"
#import "RCDraggableButton.h"
@interface ChangePicViewController ()<UIWebViewDelegate>

@property(nonatomic,retain)UIWebView *webView;

@property(nonatomic,retain)UIImageView *imageView;

@property(nonatomic,retain)UIActivityIndicatorView *actIndicatorView;


@end

@implementation ChangePicViewController

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
    
    self.title = _strTitle;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    self.webView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.webView.delegate=self;
    
    [self.view addSubview:self.webView];
    NSURL* url;
    if ([_strUrl rangeOfString:@"?"].location != NSNotFound) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@&userId=%@",_strUrl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]]];
    }
    else
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?userId=%@",_strUrl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]]];
    }
    //    NSURL* url = [NSURL URLWithString:@"http://www.dagolfla.com/app/Packbookserch.html"];
    
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
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

    //返回
    NSArray  * arrayBack= [[request.URL absoluteString] componentsSeparatedByString:@":"];
    ////NSLog(@"%@",arrayBack);
    NSString *backStr = @"backsys";
    if ([arrayBack[0] isEqual:backStr]) {
        self.navigationController.navigationBarHidden=NO;
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
        
    }
    return YES;
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
