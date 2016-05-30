//
//  JGLNewShopDetailViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLNewShopDetailViewController.h"
#import "RCDraggableButton.h"

#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"

@interface JGLNewShopDetailViewController ()<UIApplicationDelegate,WKNavigationDelegate,WKUIDelegate>
@property (strong, nonatomic) WKWebView *webView;
@property(nonatomic,retain)UIActivityIndicatorView *actIndicatorView;

@end

@implementation JGLNewShopDetailViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //把当前界面的导航栏隐藏
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self createWebView];
}

#pragma mark --创建wkwebview
-(void)createWebView
{
    
    UIImageView *statusView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 20)];
    statusView.image = [UIImage imageNamed:@"nav_bg"];
    CGRect frame = statusView.frame;
    frame.origin = CGPointMake(0, 0);
    statusView.frame = frame;
    [self.view addSubview:statusView];
    [_actIndicatorView stopAnimating];
    
    
    
    
    NSString* strUrl;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isWeChat"] integerValue] == 1) {
        strUrl = [[NSString stringWithFormat:@"http://www.dagolfla.com/app/api/client/api.php?Action=AppToUserOathBind&method=login&openid=%@&uid=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"openId"],[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    else
    {
        strUrl = [NSString stringWithFormat:@"http://www.dagolfla.com/app/api/client/api.php?Action=UserLogin&uid=%@&psw=%@&url=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"],[[NSUserDefaults standardUserDefaults] objectForKey:@"passWord"],@"index.jsp"];
    }
    //NSLog(@"%@",strUrl);
    [[PostDataRequest sharedInstance] getDataRequest:strUrl success:^(id respondsData) {

        self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        [self.view addSubview:self.webView];
        self.webView.UIDelegate = self;
        self.webView.navigationDelegate = self;
        self.webView.allowsBackForwardNavigationGestures =YES;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlRequest]]];
        
        RCDraggableButton *avatar = [[RCDraggableButton alloc] initInKeyWindowWithFrame:CGRectMake(0, 100, 33, 38)];
        [self.view addSubview:avatar];
        avatar.backgroundColor = [UIColor clearColor];
        [avatar setBackgroundImage:[UIImage imageNamed:@"sy"] forState:UIControlStateNormal];
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnWebClick:)];
        tapGesture.numberOfTapsRequired = 1;
        [avatar addGestureRecognizer:tapGesture];

    } failed:^(NSError *error) {
        [_actIndicatorView stopAnimating];
    }];
    
    
    
    
    
}
-(void)btnWebClick:(UIButton *)btn
{
    //    [btn removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *url = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",url);
    decisionHandler(WKNavigationActionPolicyAllow);
    

    if ([url rangeOfString:@"https://mapi.alipay.com"].location != NSNotFound){
        //支付宝
        NSLog(@"支付宝支付");
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        [dict setObject:@0 forKey:@"orderType"];
        [dict setObject:@527 forKey:@"srcKey"];
//        [dict setObject:@"活动报名" forKey:@"name"];
//        if (_invoiceKey != nil) {
//            [dict setObject:_addressKey forKey:@"addressKey"];
//            [dict setObject:_invoiceKey forKey:@"invoiceKey"];
//        }
        
        [[JsonHttp jsonHttp]httpRequest:@"pay/doPayByAliPay" JsonKey:@"payInfo" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
            NSLog(@"errType == %@", errType);
        } completionBlock:^(id data) {
            NSLog(@"%@",[data objectForKey:@"query"]);
            [[AlipaySDK defaultService] payOrder:[data objectForKey:@"query"] fromScheme:@"dagolfla" callback:^(NSDictionary *resultDic) {
                
                NSLog(@"支付宝=====%@",resultDic[@"resultStatus"]);
                if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                    NSLog(@"陈公");
                } else if ([resultDic[@"resultStatus"] isEqualToString:@"4000"]) {
                    NSLog(@"失败");
                } else if ([resultDic[@"resultStatus"] isEqualToString:@"6002"]) {
                    NSLog(@"网络错误");
                } else if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
                    NSLog(@"取消支付");
                } else {
                    NSLog(@"支付失败");
                }
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] removeObserver:self];
            }];
        }];
        
        
    }
    else
    {
        
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
