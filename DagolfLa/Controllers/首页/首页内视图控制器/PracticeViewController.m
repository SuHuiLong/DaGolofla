//
//  PracticeViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/7/22.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "PracticeViewController.h"
#import "Helper.h"
#import "PostDataRequest.h"

#import "ChatDetailViewController.h"
#import "RCDraggableButton.h"

@interface PracticeViewController ()<UIWebViewDelegate>


@property(nonatomic,retain)UIWebView *webView;

@property(nonatomic,retain)UIImageView *imageView;

@property(nonatomic,retain)UIActivityIndicatorView *actIndicatorView;

@end

@implementation PracticeViewController

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
    self.navigationController.navigationBarHidden=YES;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBarHidden=NO;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    self.webView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight-10*ScreenWidth/375+64);
    self.webView.delegate=self;
    
    [self.view addSubview:self.webView];

    RCDraggableButton *avatar = [[RCDraggableButton alloc] initInKeyWindowWithFrame:CGRectMake(0, 100, 33, 38)];
    [self.view addSubview:avatar];
    avatar.backgroundColor = [UIColor clearColor];
    [avatar setBackgroundImage:[UIImage imageNamed:@"sy"] forState:UIControlStateNormal];
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnWebClick:)];
    tapGesture.numberOfTapsRequired = 1;
    [avatar addGestureRecognizer:tapGesture];
    
    UIActivityIndicatorView* actIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    actIndicator.frame = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2-100, 0, 0);
    [actIndicator startAnimating];
    [self.view addSubview:actIndicator];
    _actIndicatorView = actIndicator;
    
    NSString* strUrl;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isWeChat"] integerValue] == 1) {
        strUrl = [[NSString stringWithFormat:@"http://www.dagolfla.com/app/api/client/api.php?Action=AppToUserOathBind&method=login&openid=%@&uid=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"openId"],[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    else
    {
        strUrl = [NSString stringWithFormat:@"http://www.dagolfla.com/app/api/client/api.php?Action=UserLogin&uid=%@&psw=%@&url=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"],[[NSUserDefaults standardUserDefaults] objectForKey:@"passWord"],@"index.jsp"];
    }
    
    [[PostDataRequest sharedInstance] getDataRequest:strUrl success:^(id respondsData) {
//        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        
        
        NSURL* url = [NSURL URLWithString:@"http://www.dagolfla.com/app/PracticeSerch.html"];
        //    NSURL* url = [NSURL URLWithString:@"http://www.dagolfla.com/app/PracticeSerch.html"];
        
        //设置页面禁止滚动
        _webView.scrollView.bounces = NO ;
        //设置web占满屏幕
        _webView.scalesPageToFit = YES ;
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
        
        
        
    } failed:^(NSError *error) {
        [_actIndicatorView stopAnimating];
    }];

}

-(void)btnWebClick:(UIButton *)btn
{
    //    [btn removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    ////NSLog(@"%@",[request.URL absoluteString]);
    NSArray  * array= [[request.URL absoluteString] componentsSeparatedByString:@":"];
    NSArray  * arrayUrl= [[request.URL absoluteString] componentsSeparatedByString:@"privatemsg:"];
    NSString *xinWenURL = @"privatemsg";
    //聊天
    if ([array[0] isEqual:xinWenURL]) {
        ////NSLog(@"%@",arrayUrl[1]);
        [[PostDataRequest sharedInstance] getDataRequest:arrayUrl[1] success:^(id respondsData) {
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            self.navigationController.navigationBarHidden=NO;
            ChatDetailViewController *vc = [[ChatDetailViewController alloc] init];
            //设置聊天类型
            vc.conversationType = ConversationType_PRIVATE;
            //设置对方的id
            vc.targetId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"shopid"]];
            //设置对方的名字
            //    vc.userName = model.conversationTitle;
            //设置聊天标题
            vc.title = [dict objectForKey:@"shopname"];
            //设置不现实自己的名称  NO表示不现实
            vc.displayUserNameInCell = NO;
            [self.navigationController pushViewController:vc animated:YES];
        } failed:^(NSError *error) {
            
        }];
        return NO;
        
    }
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
    UIImageView *statusView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 20)];
    
    statusView.image = [UIImage imageNamed:@"nav_bg"];
    
    CGRect frame = statusView.frame;
    
    frame.origin = CGPointMake(0, 0);
    
    statusView.frame = frame;
    
    [self.view addSubview:statusView];
    [_actIndicatorView stopAnimating];
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    ////NSLog(@"webview下载失败，error = %@",[error localizedDescription]);
    self.imageView.image = [UIImage imageNamed:@"logo"];
}



@end
