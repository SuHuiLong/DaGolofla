//
//  UseMallViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/7/22.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "JGLPushDetailsViewController.h"
#import "PostDataRequest.h"
#import "Helper.h"
#import "ChatDetailViewController.h"
#import "RCDraggableButton.h"
#import "JGTeamActibityNameViewController.h"
#import "UseMallViewController.h"
#import "DetailViewController.h"
#import "JGNotTeamMemberDetailViewController.h"
#import "JGTeamMemberORManagerViewController.h"
@interface JGLPushDetailsViewController ()<UIWebViewDelegate>
{
    NSString* _payUrl;
    NSMutableDictionary* _dictCan;
    UIAlertController *_actionView;
}
@property(nonatomic,retain)UIWebView *webView;

@property(nonatomic,retain)UIImageView *imageView;

@property(nonatomic,retain)UIActivityIndicatorView *actIndicatorView;

@end

@implementation JGLPushDetailsViewController

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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dictCan = [[NSMutableDictionary alloc]init];
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:view];
    self.webView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight-10*ScreenWidth/375);
    self.webView.delegate=self;
    
    [self.view addSubview:self.webView];
    
    RCDraggableButton *avatar = [[RCDraggableButton alloc] initInKeyWindowWithFrame:CGRectMake(0, 100, 33, 38)];
    [self.view addSubview:avatar];
    avatar.backgroundColor = [UIColor clearColor];
    [avatar setBackgroundImage:[UIImage imageNamed:@"sy"] forState:UIControlStateNormal];
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnWebClick:)];
    tapGesture.numberOfTapsRequired = 1;
    [avatar addGestureRecognizer:tapGesture];
    
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
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
        
        NSURL* url = [NSURL URLWithString:_strUrl];
        //设置页面禁止滚动
        _webView.scrollView.bounces = NO ;
        //设置web占满屏幕
        _webView.scalesPageToFit = YES ;
        
        
        NSString *userAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        NSString *customUserAgent = [userAgent stringByAppendingFormat:@" dagolfla/2.0"];
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":customUserAgent}];
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
    NSLog(@"%@",[request.URL absoluteString]);
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
       
    }
    else
    {
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
            
        } withBlockSure:^{
            JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
            vc.reloadCtrlData = ^(){
                
            };
            [self.navigationController pushViewController:vc animated:YES];
        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
        return NO;
    }
    
    return YES;
    NSString *str = [[request.URL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSArray  * array= [[request.URL absoluteString] componentsSeparatedByString:@":"];
    NSArray  * arrayUrl= [[request.URL absoluteString] componentsSeparatedByString:@"privatemsg:"];
    NSString *xinWenURL = @"privatemsg";

    if ([str rangeOfString:@"activityKey"].location != NSNotFound) {

        NSURL *url = [NSURL URLWithString:str];
        if ([url.scheme isEqualToString:@"dagolfla"]){
            NSLog(@"URL scheme:%@", [url scheme]);
            NSLog(@"URL query: %@", [url query]);
            NSString *actKey = @"";
            NSString *actDetail = @"";
            if ([url query]) {
                actKey = [[[NSString stringWithFormat:@"%@", [url query]] componentsSeparatedByString:@"="] objectAtIndex:1];
                actDetail = [[[NSString stringWithFormat:@"%@", [url query]] componentsSeparatedByString:@"="] objectAtIndex:0];
                //活动
                JGTeamActibityNameViewController *teamCtrl= [[JGTeamActibityNameViewController alloc]init];
                teamCtrl.teamKey = [actKey integerValue];
                teamCtrl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:teamCtrl animated:YES];
                return YES;
            }
        }
        
    }
    
    else if ([str rangeOfString:@"teamKey"].location != NSNotFound)
    {
        
        NSURL *url = [NSURL URLWithString:str];
        if ([url.scheme isEqualToString:@"dagolfla"]){
            NSString *actKey = @"";
            NSString *actDetail = @"";
            if ([url query]) {
                actKey = [[[NSString stringWithFormat:@"%@", [url query]] componentsSeparatedByString:@"="] objectAtIndex:1];
                actDetail = [[[NSString stringWithFormat:@"%@", [url query]] componentsSeparatedByString:@"="] objectAtIndex:0];
                //球队
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userKey"];
                [dic setObject:@([actKey integerValue]) forKey:@"teamKey"];
                
                [[JsonHttp jsonHttp] httpRequest:@"team/getTeamInfo" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
                    
                } completionBlock:^(id data) {
                    
                    
                    if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                        
                        if (![data objectForKey:@"teamMember"]) {
                            JGNotTeamMemberDetailViewController *detailVC = [[JGNotTeamMemberDetailViewController alloc] init];
                            detailVC.detailDic = [data objectForKey:@"team"];
                            
                            [self.navigationController pushViewController:detailVC animated:YES];
                        }else{
                            
                            if ([[[data objectForKey:@"teamMember"] objectForKey:@"power"] containsString:@"1005"]){
                                JGTeamMemberORManagerViewController *detailVC = [[JGTeamMemberORManagerViewController alloc] init];
                                detailVC.detailDic = [data objectForKey:@"team"];
                                detailVC.isManager = YES;
                                [self.navigationController pushViewController:detailVC animated:YES];
                            }else{
                                JGTeamMemberORManagerViewController *detailVC = [[JGTeamMemberORManagerViewController alloc] init];
                                detailVC.detailDic = [data objectForKey:@"team"];
                                detailVC.isManager = NO;
                                [self.navigationController pushViewController:detailVC animated:YES];
                            }
                            
                            
                        }
                        
                    }else{
                        if ([data objectForKey:@"packResultMsg"]) {
                            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                        }
                    }
                    
                }];
                return YES;
            }
        }
    }
    
    else if ([str rangeOfString:@"goodKey"].location != NSNotFound)
    {
        
        NSURL *url = [NSURL URLWithString:str];
        if ([url.scheme isEqualToString:@"dagolfla"]){
            NSLog(@"URL scheme:%@", [url scheme]);
            NSLog(@"URL query: %@", [url query]);
            NSString *actKey = @"";
            NSString *actDetail = @"";
            if ([url query]) {
                actKey = [[[NSString stringWithFormat:@"%@", [url query]] componentsSeparatedByString:@"="] objectAtIndex:1];
                actDetail = [[[NSString stringWithFormat:@"%@", [url query]] componentsSeparatedByString:@"="] objectAtIndex:0];
                //商城
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                UseMallViewController* userVc = [[UseMallViewController alloc]init];
                userVc.linkUrl = [NSString stringWithFormat:@"http://www.dagolfla.com/app/ProductDetails.html?proid=%td",[actKey integerValue]];
                [self.navigationController pushViewController:userVc animated:YES];
                return YES;
            }
        }
    }
    
    else if ([str rangeOfString:@"moodKey"].location != NSNotFound)
    {
        NSURL *url = [NSURL URLWithString:str];
        if ([url.scheme isEqualToString:@"dagolfla"]){
            NSLog(@"URL scheme:%@", [url scheme]);
            NSLog(@"URL query: %@", [url query]);
            NSString *actKey = @"";
            NSString *actDetail = @"";
            if ([url query]) {
                actKey = [[[NSString stringWithFormat:@"%@", [url query]] componentsSeparatedByString:@"="] objectAtIndex:1];
                actDetail = [[[NSString stringWithFormat:@"%@", [url query]] componentsSeparatedByString:@"="] objectAtIndex:0];
                //社区
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                DetailViewController * comDevc = [[DetailViewController alloc]init];
                
                comDevc.detailId = [NSNumber numberWithInteger:[actKey integerValue]];
                
                [self.navigationController pushViewController:comDevc animated:YES];
                return YES;
            }
        }
 
    }
    else{
        
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
