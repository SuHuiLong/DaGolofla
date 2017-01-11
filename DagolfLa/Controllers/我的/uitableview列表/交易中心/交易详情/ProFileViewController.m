//
//  StadiumViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/7/22.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ProFileViewController.h"
#import "Helper.h"
#import "PostDataRequest.h"
#import "ChatDetailViewController.h"
#import "RCDraggableButton.h"

#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"

@interface ProFileViewController ()<UIWebViewDelegate>
{
    NSString* _payUrl;
    NSMutableDictionary* _dictCan;
    UIAlertController *_actionView;
}
@property(nonatomic,retain)UIWebView *webView;

@property(nonatomic,retain)UIImageView *imageView;

@property(nonatomic,retain)UIActivityIndicatorView *actIndicatorView;

@end

@implementation ProFileViewController

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
    _dictCan = [[NSMutableDictionary alloc]init];
    self.webView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight-7*ScreenWidth/375+64);
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
        ////NSLog(@"%@",[dict objectForKey:@"msg"]);
        
        NSURL* url = [NSURL URLWithString:@"http://www.dagolfla.com/app/MyAddress.html"];
        
        //设置页面禁止滚动r
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
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *userAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *customUserAgent = [userAgent stringByAppendingFormat:@" dagolfla/2.0"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":customUserAgent}];
    
    ////NSLog(@"%@",[request.URL absoluteString]);
    NSString *str = [[request.URL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
    //支付
    if ([str rangeOfString:@"dagolfla://pay"].location != NSNotFound){
        _payUrl = str;
        NSArray *arrayUrl = [_payUrl componentsSeparatedByString:@"?"];
        NSArray *arrayCanShu = [arrayUrl[2] componentsSeparatedByString:@"&"];
        for (int i = 0; i < arrayCanShu.count; i++) {
            if (![Helper isBlankString:arrayCanShu[i]]) {
                NSArray* arrCan = [arrayCanShu[i] componentsSeparatedByString:@"="];
                [_dictCan setObject:arrCan[1] forKey:arrCan[0]];
            }
        }
        NSLog(@"%@",_dictCan);
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *weiChatAction = [UIAlertAction actionWithTitle:@"微信支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //添加请求
            [self weChatPay];
        }];
        UIAlertAction *zhifubaoAction = [UIAlertAction actionWithTitle:@"支付宝支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //添加请求
            [self zhifubaoPay];
        }];
        
        _actionView = [UIAlertController alertControllerWithTitle:@"选择支付方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [_actionView addAction:weiChatAction];
        [_actionView addAction:zhifubaoAction];
        [_actionView addAction:cancelAction];
        [self presentViewController:_actionView animated:YES completion:nil];
    }
    else
    {
        
    }
    
    
    
    return YES;
}


#pragma mark -- 支付宝
- (void)zhifubaoPay{
    NSLog(@"支付宝支付");
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@3 forKey:@"orderType"];
    [dict setObject:[_dictCan objectForKey:@"ordersn"] forKey:@"ordersn"];
    [dict setObject:[_dictCan objectForKey:@"protitle"] forKey:@"name"];//title
    [[JsonHttp jsonHttp]httpRequest:@"pay/doPayByAliPay" JsonKey:@"payInfo" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        NSLog(@"%@",[data objectForKey:@"query"]);
        [[AlipaySDK defaultService] payOrder:[data objectForKey:@"query"] fromScheme:@"dagolfla" callback:^(NSDictionary *resultDic) {
            
            NSLog(@"支付宝=====%@",resultDic[@"resultStatus"]);
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                NSLog(@"陈公");
            } else if ([resultDic[@"resultStatus"] isEqualToString:@"4000"]) {
                [Helper alertViewWithTitle:@"对不起，您的支付失败了" withBlock:^(UIAlertController *alertView) {
                    [self.navigationController presentViewController:alertView animated:YES completion:nil];
                }];
            } else if ([resultDic[@"resultStatus"] isEqualToString:@"6002"]) {
                [Helper alertViewWithTitle:@"对不起，请检查您的网络" withBlock:^(UIAlertController *alertView) {
                    [self.navigationController presentViewController:alertView animated:YES completion:nil];
                }];
            } else if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
                NSLog(@"取消支付");
            } else {
                [Helper alertViewWithTitle:@"对不起，您的支付失败了" withBlock:^(UIAlertController *alertView) {
                    [self.navigationController presentViewController:alertView animated:YES completion:nil];
                }];
            }
        }];
    }];
}

#pragma mark -- 微信支付
- (void)weChatPay{
    NSLog(@"微信支付");
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@3 forKey:@"orderType"];
    [dict setObject:[_dictCan objectForKey:@"ordersn"] forKey:@"ordersn"];
    [dict setObject:[_dictCan objectForKey:@"protitle"] forKey:@"name"];
    
    [[JsonHttp jsonHttp]httpRequest:@"pay/doPayWeiXin" JsonKey:@"payInfo" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        [[ShowHUD showHUD]showToastWithText:@"请检查您的网络" FromView:self.view];
    } completionBlock:^(id data) {
        NSDictionary *dict = [data objectForKey:@"pay"];
        //微信
        if (dict) {
            PayReq *request = [[PayReq alloc] init];
            request.openID       = [dict objectForKey:@"appid"];
            request.partnerId    = [dict objectForKey:@"partnerid"];
            request.prepayId     = [dict objectForKey:@"prepayid"];
            request.package      = [dict objectForKey:@"Package"];
            request.nonceStr     = [dict objectForKey:@"noncestr"];
            request.timeStamp    =[[dict objectForKey:@"timestamp"] intValue];
            request.sign         = [dict objectForKey:@"sign"];
            
            [WXApi sendReq:request];
        }else
        {
            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
        }
    }];
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
    self.imageView.image = [UIImage imageNamed:DefaultHeaderImage];
}


@end
