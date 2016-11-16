//
//  JGLNewShopDetailViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLWebUserMallViewController.h"
#import "RCDraggableButton.h"
#import "MyOrderViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "JGDSetBusinessPWDViewController.h"
#import "JGHbalanceView.h"
#import "WCLPassWordView.h"

@interface JGLWebUserMallViewController ()<UIApplicationDelegate,WKNavigationDelegate,WKUIDelegate, WCLPassWordViewDelegate, JGHbalanceViewDelegate>
{
    UIAlertController *_actionView;
    
    NSString* _payUrl;
    NSMutableDictionary* _dictCan;
    
    NSString *_price;
    
    UIView *_bgView;
}
@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic,retain)UIActivityIndicatorView *actIndicatorView;

@property (nonatomic, retain)JGHbalanceView *balanceView;

@property (nonatomic, retain)WCLPassWordView *passWordView;

@end

@implementation JGLWebUserMallViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //把当前界面的导航栏隐藏
    //    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createWebView];
    _dictCan = [[NSMutableDictionary alloc]init];
    _price = @"0.00";
}

#pragma mark --创建wkwebview
-(void)createWebView
{
    //加载的时候展示的任务栏，加载时会隐藏
//    UIImageView *statusView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 20)];
//    statusView.image = [UIImage imageNamed:@"nav_bg"];
//    CGRect frame = statusView.frame;
//    frame.origin = CGPointMake(0, 0);
//    statusView.frame = frame;
//    [self.view addSubview:statusView];
//    [_actIndicatorView stopAnimating];
    /*
    NSString* strUrl;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isWeChat"] integerValue] == 1)
    {
        strUrl = [[NSString stringWithFormat:@"http://www.dagolfla.com/app/api/client/api.php?Action=AppToUserOathBind&method=login&openid=%@&uid=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"openId"],[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    else
    {
        strUrl = [NSString stringWithFormat:@"http://www.dagolfla.com/app/api/client/api.php?Action=UserLogin&uid=%@&psw=%@&url=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"],[[NSUserDefaults standardUserDefaults] objectForKey:@"passWord"],@"index.jsp"];
    }
    */
    //-----登录PHP－－－－
    NSUserDefaults *useDef = [NSUserDefaults standardUserDefaults];
    
    if ([useDef objectForKey:PHPState]) {
        if ([[useDef objectForKey:PHPState] integerValue] == 1) {
            [self resgterWebView];
        }else{
            NSString *url = [NSString stringWithFormat:@"http://www.dagolfla.com/app/api/client/api.php?Action=UserLoginUserid&uid=%@&url=dsadsa", DEFAULF_USERID];
            
            [[JsonHttp jsonHttp]httpRequest:url failedBlock:^(id errType) {
                
            } completionBlock:^(id data) {
                NSLog(@"%@", data);
                //state - 1成功
                NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
                if ([[data objectForKey:@"state"] integerValue] == 1) {
                    [self resgterWebView];
                }
               
                [userDef setObject:[data objectForKey:@"state"] forKey:PHPState];
            }];
        }
    }else{
        NSString *url = [NSString stringWithFormat:@"http://www.dagolfla.com/app/api/client/api.php?Action=UserLoginUserid&uid=%@&url=dsadsa", DEFAULF_USERID];
        
        [[JsonHttp jsonHttp]httpRequest:url failedBlock:^(id errType) {
            
        } completionBlock:^(id data) {
            NSLog(@"%@", data);
            //state - 1成功
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            if ([[data objectForKey:@"state"] integerValue] == 1) {
                [self resgterWebView];
            }
            
            [userDef setObject:[data objectForKey:@"state"] forKey:PHPState];
        }];
    }
//    [[PostDataRequest sharedInstance] getDataRequest:strUrl success:^(id respondsData) {
//        
//        self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, -20, screenWidth, screenHeight)];
//        [self.view addSubview:self.webView];
//        self.webView.UIDelegate = self;
//        self.webView.navigationDelegate = self;
//        self.webView.allowsBackForwardNavigationGestures =YES;
//        
//        __weak typeof(self) weakSelf = self;
//        [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
//            __strong typeof(weakSelf) strongSelf = weakSelf;
//            
//            NSString *userAgent = result;
//            NSString *newUserAgent = [userAgent stringByAppendingString:@" DagolfLa/2.0"];
//            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
//            [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
//            
//            strongSelf.webView = [[WKWebView alloc] initWithFrame:strongSelf.view.bounds];
//            [strongSelf.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
//                [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlRequest]]];
//                //重设任务栏
//                UIImageView *statusView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
//                statusView.image = [UIImage imageNamed:@"nav_bg"];
//                CGRect frame = statusView.frame;
//                frame.origin = CGPointMake(0, 0);
//                statusView.frame = frame;
//                [self.view addSubview:statusView];
//                [_actIndicatorView stopAnimating];
//                
//                
////                NSString *js = @"javascript:void(0);";
////                [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable other, NSError * _Nullable error) {
////                    self.navigationController.navigationBarHidden=NO;
////                    [self.navigationController popViewControllerAnimated:YES];
////                }];
//            
//            }];
//            
//        }];
//        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlRequest]]];
//        RCDraggableButton *avatar = [[RCDraggableButton alloc] initInKeyWindowWithFrame:CGRectMake(0, 100, 33, 38)];
//        [self.view addSubview:avatar];
//        avatar.backgroundColor = [UIColor clearColor];
//        [avatar setBackgroundImage:[UIImage imageNamed:@"sy"] forState:UIControlStateNormal];
//        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnWebClick:)];
//        tapGesture.numberOfTapsRequired = 1;
//        [avatar addGestureRecognizer:tapGesture];
//  
//    } failed:^(NSError *error) {
//        [_actIndicatorView stopAnimating];
//    }];
}
- (void)resgterWebView{
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, -20, screenWidth, screenHeight)];
    [self.view addSubview:self.webView];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.allowsBackForwardNavigationGestures =YES;
    
    __weak typeof(self) weakSelf = self;
    [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        NSString *userAgent = result;
        NSString *newUserAgent = [userAgent stringByAppendingString:@" DagolfLa/2.0"];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
        
        strongSelf.webView = [[WKWebView alloc] initWithFrame:strongSelf.view.bounds];
        [strongSelf.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlRequest]]];
            //重设任务栏
            UIImageView *statusView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
            statusView.image = [UIImage imageNamed:@"nav_bg"];
            CGRect frame = statusView.frame;
            frame.origin = CGPointMake(0, 0);
            statusView.frame = frame;
            [self.view addSubview:statusView];
            [_actIndicatorView stopAnimating];
            
            
            //                NSString *js = @"javascript:void(0);";
            //                [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable other, NSError * _Nullable error) {
            //                    self.navigationController.navigationBarHidden=NO;
            //                    [self.navigationController popViewControllerAnimated:YES];
            //                }];
            
        }];
        
    }];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlRequest]]];
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
    //    [btn removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    
    NSString *url = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    decisionHandler(WKNavigationActionPolicyAllow);
    
    
    if ([url rangeOfString:@"backsys"].location != NSNotFound){
        self.navigationController.navigationBarHidden=NO;
        [self.navigationController popViewControllerAnimated:YES];
        return ;
    }
    //   分享
    if ([url rangeOfString:@"dagolfla://share"].location != NSNotFound) {
        ShareAlert* alert = [[ShareAlert alloc]initMyAlert];
        alert.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenWidth);
        [alert setCallBackTitle:^(NSInteger index) {
            [self shareInfo:index shareUrl:url];
        }];
        [UIView animateWithDuration:0.2 animations:^{
            [alert show];
        }];
        return ;
    }
    
    if ([url rangeOfString:@"dagolfla://pay"].location != NSNotFound){
        _payUrl = url;
        NSArray *arrayUrl = [_payUrl componentsSeparatedByString:@"?"];
        NSArray *arrayCanShu = [arrayUrl[2] componentsSeparatedByString:@"&"];
        for (int i = 0; i < arrayCanShu.count; i++) {
            if (![Helper isBlankString:arrayCanShu[i]]) {
                NSArray* arrCan = [arrayCanShu[i] componentsSeparatedByString:@"="];
                [_dictCan setObject:arrCan[1] forKey:arrCan[0]];
            }
        }
        
        [[ShowHUD showHUD]showAnimationWithText:@"加载中..." FromView:self.view];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:DEFAULF_USERID forKey:@"userKey"];
        [[JsonHttp jsonHttp]httpRequest:@"user/getUserBalance" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
            [[ShowHUD showHUD]hideAnimationFromView:self.view];
        } completionBlock:^(id data) {
            NSLog(@"%@", data);
            [[ShowHUD showHUD]hideAnimationFromView:self.view];
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                NSString *balanceString;
                if ([_dictCan objectForKey:@"price"]) {
                    _price = [NSString stringWithFormat:@"%.2f", [[_dictCan objectForKey:@"price"] floatValue]];
                    if ([[data objectForKey:@"money"] floatValue] >= [[_dictCan objectForKey:@"price"] floatValue]) {
                        balanceString = [NSString stringWithFormat:@"余额支付（¥%.2f）", [[data objectForKey:@"money"] floatValue]];
                    }else{
                        balanceString = [NSString stringWithFormat:@"余额支付（余额不足 ¥%.2f）", [[data objectForKey:@"money"] floatValue]];
                    }
                }else{
                    balanceString = @"余额支付";
                }
                
                // 分别3个创建操作
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                UIAlertAction *weiChatAction = [UIAlertAction actionWithTitle:@"微信支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //添加微信支付请求
                    [self weChatPay];
                }];
                UIAlertAction *zhifubaoAction = [UIAlertAction actionWithTitle:@"支付宝支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //添加支付宝支付请求
                    [self zhifubaoPay];
                }];
                UIAlertAction *balanceAction = [UIAlertAction actionWithTitle:balanceString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //余额支付
                    if ([[data objectForKey:@"money"] floatValue] >= [_price floatValue]) {
                        if ([[data objectForKey:@"isSetPayPassWord"] integerValue] == 0) {
                            JGDSetBusinessPWDViewController *setpassCtrl = [[JGDSetBusinessPWDViewController alloc]init];
                            [self.navigationController pushViewController:setpassCtrl animated:YES];
                        }else{
                            [self dreawBalance:[NSString stringWithFormat:@"%.2f", [[data objectForKey:@"money"] floatValue]]];
                        }
                    }else{
                        return ;
                    }
                    
                }];
                _actionView = [UIAlertController alertControllerWithTitle:@"选择支付方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                [_actionView addAction:weiChatAction];
                [_actionView addAction:zhifubaoAction];
                [_actionView addAction:balanceAction];
                [_actionView addAction:cancelAction];
                [self presentViewController:_actionView animated:YES completion:nil];
            }else{
                if ([data objectForKey:@"packResultMsg"]) {
                    [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                }
            }
        }];
    }
    else
    {
        
    }
    
}
#pragma mark -- 余额支付
- (void)dreawBalance:(NSString *)balance{
    //
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    _bgView.backgroundColor = [UIColor colorWithHexString:BG_color];
    _bgView.alpha = 0.5;
    [self.view addSubview:_bgView];
    
    _balanceView = [[JGHbalanceView alloc]initWithFrame:CGRectMake(15 *ProportionAdapter, 84 *ProportionAdapter, screenWidth -30*ProportionAdapter, 286*ProportionAdapter)];
    _balanceView.layer.masksToBounds = YES;
    _balanceView.delegate = self;
    _balanceView.layer.cornerRadius = 5.0*ProportionAdapter;
    _balanceView.alpha = 1.0;
    if ([_price floatValue] > 0.00) {
        [_balanceView configJGHbalanceViewPrice:[_price floatValue] andBalance:balance andDetail:[_dictCan objectForKey:@"protitle"]];
    }else{
        [_balanceView configJGHbalanceViewPrice:0.00 andBalance:balance andDetail:[_dictCan objectForKey:@"protitle"]];
    }
    
    //密码输入框
    _passWordView = [[[NSBundle mainBundle]loadNibNamed:@"WCLPassWordView" owner:self options:nil]lastObject];
    _passWordView.frame = CGRectMake(13 *ProportionAdapter, 222 *ProportionAdapter, _balanceView.frame.size.width -26*ProportionAdapter, 45 *ProportionAdapter);
    _passWordView.delegate = self;
    _passWordView.backgroundColor = [UIColor whiteColor];
    [_balanceView addSubview:_passWordView];
    
    [self.view addSubview:_balanceView];
}
#pragma mark -- 监听输入的改变
- (void)passWordDidChange:(WCLPassWordView *)passWord{
    
}
#pragma mark -- 监听输入的完成时
- (void)passWordCompleteInput:(WCLPassWordView *)passWord{
    [self balancePay];
}
#pragma mark -- 监听开始输入
- (void)passWordBeginInput:(WCLPassWordView *)passWord{
    
}
#pragma mark －－ 删除密码输入框
- (void)deleteBalanceView:(UIButton *)btn{
    [_balanceView removeFromSuperview];
    [_passWordView removeFromSuperview];
    [_bgView removeFromSuperview];
}
#pragma mark -- 余额支付
- (void)balancePay{
    [[ShowHUD showHUD]showAnimationWithText:@"支付中..." FromView:self.view];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@3 forKey:@"orderType"];
    [dict setObject:[_dictCan objectForKey:@"ordersn"] forKey:@"ordersn"];
    [dict setObject:[_dictCan objectForKey:@"protitle"] forKey:@"name"];//title
    [dict setObject:@"活动报名" forKey:@"name"];
    [dict setObject:@"活动余额支付订单" forKey:@"otherInfo"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"pay/doPayByUserAccount" JsonKey:@"payInfo" withData:dict failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        [_bgView removeFromSuperview];
    } completionBlock:^(id data) {
        NSLog(@"%@",[data objectForKey:@"query"]);
        [_balanceView removeFromSuperview];
        [_bgView removeFromSuperview];
        
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        //
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            MyOrderViewController *groupCtrl = [[MyOrderViewController alloc]init];
            //groupCtrl.header = 1;
            [self.navigationController pushViewController:groupCtrl animated:YES];
        }else{
            _passWordView.textStore = [@"" mutableCopy];
            [_passWordView deleteBackward];
            [_passWordView becomeFirstResponder];
            
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showAnimationWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }else{
                [[ShowHUD showHUD]showAnimationWithText:@"支付失败！" FromView:self.view];
            }
        }
    }];
}
#pragma mark -- 支付宝
- (void)zhifubaoPay{
    //    NSLog(@"支付宝支付");
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@3 forKey:@"orderType"];
    [dict setObject:[_dictCan objectForKey:@"ordersn"] forKey:@"ordersn"];
    [dict setObject:[_dictCan objectForKey:@"protitle"] forKey:@"name"];//title
    [[JsonHttp jsonHttp]httpRequest:@"pay/doPayByAliPay" JsonKey:@"payInfo" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        //        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        NSLog(@"%@",[data objectForKey:@"query"]);
        [[AlipaySDK defaultService] payOrder:[data objectForKey:@"query"] fromScheme:@"dagolfla" callback:^(NSDictionary *resultDic) {
            
            //            NSLog(@"支付宝=====%@",resultDic[@"resultStatus"]);
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
        //
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
