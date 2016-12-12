//
//  UseMallViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/7/22.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "UseMallViewController.h"
#import "PostDataRequest.h"
#import "Helper.h"
#import "ChatDetailViewController.h"
#import "RCDraggableButton.h"

#import "MyOrderViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
@interface UseMallViewController ()<UIWebViewDelegate>
{
    NSString* _payUrl;
    NSMutableDictionary* _dictCan;
    UIAlertController *_actionView;
}
@property(nonatomic,retain)UIWebView *webView;

@property(nonatomic,retain)UIImageView *imageView;

@property(nonatomic,retain)UIActivityIndicatorView *actIndicatorView;

@end

@implementation UseMallViewController

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
//    self.navigationController.navigationBarHidden=NO;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //如果为空就直接赋值，否则从推送或者分享跳转页面中调取
    if ([Helper isBlankString:_linkUrl]) {
        _linkUrl = @"http://www.dagolfla.com/app/index.html";
    }
    _dictCan = [[NSMutableDictionary alloc]init];
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
        
        NSURL* url = [NSURL URLWithString:_linkUrl];
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
    NSString *str = [[request.URL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"1111  ======      =   %@",str);
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
    if (![Helper isBlankString:[request.URL absoluteString]]) {
        if ([arrayBack[0] isEqual:backStr]) {
            self.navigationController.navigationBarHidden=NO;
            [self.navigationController popViewControllerAnimated:YES];
            return NO;
            
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    //   分享
    if ([str rangeOfString:@"dagolfla://share"].location != NSNotFound) {
        ShareAlert* alert = [[ShareAlert alloc]initMyAlert];
        alert.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenWidth);
        [alert setCallBackTitle:^(NSInteger index) {
            [self shareInfo:index shareUrl:str];
        }];
        [UIView animateWithDuration:0.2 animations:^{
            [alert show];
        }];
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
                MyOrderViewController *groupCtrl = [[MyOrderViewController alloc]init];
                groupCtrl.header = 1;
                [self.navigationController pushViewController:groupCtrl animated:YES];
            } else if ([resultDic[@"resultStatus"] isEqualToString:@"4000"]) {
                [[ShowHUD showHUD]showToastWithText:@"支付失败！" FromView:self.view];
            } else if ([resultDic[@"resultStatus"] isEqualToString:@"6002"]) {
                [[ShowHUD showHUD]showToastWithText:@"对不起，请检查您的网络" FromView:self.view];
            } else if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
                //                NSLog(@"取消支付");
            } else {
                [[ShowHUD showHUD]showToastWithText:@"支付失败！" FromView:self.view];
            }
        }];
    }];
}

#pragma mark -- 微信支付
- (void)weChatPay{
    NSLog(@"微信支付");
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"weChatNotice" object:nil];
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

#pragma mark -- 微信支付成功后返回的通知
- (void)notice:(NSNotification *)not{
    NSInteger secess = [[not.userInfo objectForKey:@"secess"] integerValue];
    if (secess == 1) {
        //跳转分组页面
        MyOrderViewController *groupCtrl = [[MyOrderViewController alloc]init];
        groupCtrl.header = 1;
        [self.navigationController pushViewController:groupCtrl animated:YES];
    }else if (secess == 2){
        [[ShowHUD showHUD]showToastWithText:@"支付已取消！" FromView:self.view];
    }else{
        [[ShowHUD showHUD]showToastWithText:@"支付失败！" FromView:self.view];
    }
}
#pragma mark --分享
-(void)shareInfo:(NSInteger)index shareUrl:(NSString *)strUrl
{
    NSArray* array1 = [strUrl componentsSeparatedByString:@"fromurl="];
    NSArray* array2 = [array1[1] componentsSeparatedByString:@"&"];
    NSString*  shareUrl = array2[0];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    for (int i = 1; i < array2.count; i ++) {
        NSArray* array3 = [array2[i] componentsSeparatedByString:@"="];
        [dict setObject:array3[1] forKey:array3[0]];
    }
    
    [UMSocialData defaultData].extConfig.title=[NSString stringWithFormat:@"%@",[dict objectForKey:@"title"]];
    NSData* fiData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"shareimg"]]];
    
    if(index==0)
    {
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[dict objectForKey:@"title"] image:fiData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                
            }
        }];
    }
    else if (index==1)
    {
        //朋友圈
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[dict objectForKey:@"title"] image:fiData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                ////NSLog(@"分享成功！");
            }
        }];
        
    }
    else
    {
        
        UMSocialData *data = [UMSocialData defaultData];
        data.shareImage = fiData;
        data.shareText = [NSString stringWithFormat:@"%@%@",[dict objectForKey:@"title"],shareUrl];
        [[UMSocialControllerService defaultControllerService] setSocialData:data];
        //2.设置分享平台
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
    }
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
