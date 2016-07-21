//

//  SpeciallOfferViewController.m

//  DaGolfla

//

//  Created by bhxx on 15/7/23.

//  Copyright (c) 2015年 bhxx. All rights reserved.

//



#import "VoteViewController.h"

#import "UMSocial.h"

#import "UMSocialSinaHandler.h"

#import "UMSocialWechatHandler.h"

#import "ShareAlert.h"

#import "PostDataRequest.h"
#import "Helper.h"

//微信
#import "WXApi.h"
#import "payRequsestHandler.h"

@interface VoteViewController ()<UIWebViewDelegate>
{
    NSString* _strUrl;
}

@property(nonatomic,retain)UIWebView *webView;
@property(nonatomic,retain)UIImageView *imageView;
@property(nonatomic,retain)UIActivityIndicatorView *actIndicatorView;
@property (strong,nonatomic)NSString *currentURL;
@property (strong,nonatomic)NSString *currentTitle;
@property (strong,nonatomic)NSString *currentHTML;

@end


@implementation VoteViewController

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
    self.navigationController.navigationBarHidden=NO;
//    self.view.backgroundColor = [UIColor redColor];
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareVoteClick)];
    shareBtn.tintColor = [UIColor whiteColor];
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    self.navigationItem.rightBarButtonItem = shareBtn;
    self.title = @"我要投票";
    self.webView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight-15*ScreenWidth/375-10*ScreenWidth/375);
    self.webView.delegate=self;
   
    [self.view addSubview:self.webView];
    
    NSString* strUrl = @"http://www.dagolfla.com:8081/dagaoerfu/html5/vote/Vote.html";

    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?userId=%@",strUrl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]]];
    
    //设置web占满屏幕
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    UIActivityIndicatorView* actIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
   
    actIndicator.frame = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2-100, 0, 0);

    [actIndicator startAnimating];
    [self.view addSubview:actIndicator];
    _actIndicatorView = actIndicator;
  
}

-(void)backButtonClcik
{
    //加载完成
    /**===========================JS  注入====================================*/
//    [_webView stringByEvaluatingJavaScriptFromString:@"var script = document.createElement('script');"
//     "script.type = 'text/javascript';"
//     "script.text = \"function backa ()"
//     "{"
//     "alert(1)"
//     "history.back(-1);"
//     "}/;"
//     "document.getElementsByTagName('head')[0].appendChild(script);"];  //添加到head标签中
    
    [_webView stringByEvaluatingJavaScriptFromString:@"history.back(-1)"];
    NSString * fruid = _strUrl;
    NSArray  * array= [fruid componentsSeparatedByString:@"userId"];
    NSString* shareUrl = [array[0] substringToIndex:([array[0] length]-1)];
    
    //返回主页
    if ([shareUrl isEqualToString:@"http://www.dagolfla.com:8081/dagaoerfu/html5/vote/Vote.html"]) {
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark --分享点击事件
-(void)shareVoteClick
{
//    ShareAlert* alert = [[ShareAlert alloc]initMyAlert];
//    alert.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenWidth);
//    [alert setCallBackTitle:^(NSInteger index) {
//        [self shareInfo:index];
//    }];
//    [UIView animateWithDuration:0.2 animations:^{
//        [alert show];
//    }];
    
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@0 forKey:@"orderType"];
    [dict setObject:@527 forKey:@"srcKey"];
    [[JsonHttp jsonHttp]httpRequest:@"pay/doPayWeiXin" JsonKey:@"payInfo" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        [[ShowHUD showHUD]showToastWithText:@"请检查您的网络" FromView:self.view];
    } completionBlock:^(id data) {
        
        NSDictionary *dict = [data objectForKey:@"pay"];
        //微信
        //创建支付签名对象
        //        payRequsestHandler *req = [payRequsestHandler alloc];
        
        //初始化支付签名对象
        //        [req init:@"wxdcdc4e20544ed728" mch_id:[dict objectForKey:@"partnerid"]];
        //设置秘钥
        //        [req setKey:[[data objectForKey:@"rows"] objectForKey:@"key"]];
        
        //        NSMutableDictionary *dict1 = [req sendPay_demoPrePayid:[dict objectForKey:@"prepayid"]];
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

-(void)shareInfo:(NSInteger)index
{
    NSString * fruid = _strUrl;
    NSArray  * array= [fruid componentsSeparatedByString:@"userId"];
    NSString* shareUrl = [array[0] substringToIndex:([array[0] length]-1)];
    
    //NSLog(@"%@",shareUrl);
    
    
    NSUserDefaults *userDe = [NSUserDefaults standardUserDefaults];
    NSNumber *userId = [userDe objectForKey:@"userId"];

    //判断 是否含有小游戏
    if([shareUrl rangeOfString:@"dagaoerfu/html5/luck/index.html"].location !=NSNotFound){
        
        [[PostDataRequest sharedInstance] postDataRequest:@"tvoteUser/doWeiXinShare.do" parameter:@{@"userID":userId} success:^(id respondsData) {
        } failed:^(NSError *error) {
            //NSLog(@"%@",error);
        }];

    }else{
//        //NSLog(@"no");
    }
    
    
    NSString* strTitle = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [UMSocialData defaultData].extConfig.title = strTitle;
    if(index==0)
    {
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"您的朋友请您投他一票" image:[UIImage imageNamed:@"logo"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [[NSURLCache sharedURLCache] removeAllCachedResponses];
            }
        }];
    }
    else if (index==1)
    {
        //朋友圈
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"您的朋友请您投他一票" image:[UIImage imageNamed:@"logo"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [[NSURLCache sharedURLCache] removeAllCachedResponses];
            }
        }];
   
    }
    else
    {

        UMSocialData *data = [UMSocialData defaultData];
        data.shareImage = [UIImage imageNamed:@"logo"];
        data.shareText = [NSString stringWithFormat:@"%@%@",@"您的朋友请您投他一票",shareUrl];
        [[UMSocialControllerService defaultControllerService] setSocialData:data];
        //2.设置分享平台
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
  
    }
    
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [_actIndicatorView startAnimating];
    //返回
    _strUrl = [request.URL absoluteString];
//    //NSLog(@"qingqiu ===    %@",_strUrl);
//    NSArray  * arrayBack= [[request.URL absoluteString] componentsSeparatedByString:@":"];
    NSString *backStr = @"backsys";
//    if (_strUrl isEqual:backStr]) {
//        self.navigationController.navigationBarHidden=NO;
//        [self.navigationController popViewControllerAnimated:YES];
//        return NO;
//    }
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_actIndicatorView stopAnimating];

}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.imageView.image = [UIImage imageNamed:@"logo"];
}

//- (void)dealloc
//{
//    [_webView stopLoading];
//    _webView.delegate=nil;
//    self.webView = nil;
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
//}
//

@end

