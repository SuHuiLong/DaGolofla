//
//  JGWkNewsViewController.m
//  DagolfLa
//
//  Created by 東 on 17/2/13.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGWkNewsViewController.h"

@interface JGWkNewsViewController ()<WKNavigationDelegate,WKUIDelegate>
{
    UIBarButtonItem *_bar;
}
@property (strong, nonatomic) WKWebView *webView;

@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, retain)NSDictionary *detailDic;

@end

@implementation JGWkNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"高球资讯";
    NSString *md5Str;
    if (DEFAULF_USERID) {
        md5Str = [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@&newsId=%@dagolfla.com", DEFAULF_USERID, _newsId]];
        self.urlString = [NSString stringWithFormat:@"https://mobile.dagolfla.com/news/getHtmlBody?userKey=%@&newsId=%@&md5=%@", DEFAULF_USERID, _newsId, md5Str];
    }else{
        md5Str = [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=0&newsId=%@dagolfla.com", _newsId]];
        self.urlString = [NSString stringWithFormat:@"https://mobile.dagolfla.com/news/getHtmlBody?userKey=0&newsId=%@&md5=%@", _newsId, md5Str];
    }
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    [self.view addSubview:self.webView];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.allowsBackForwardNavigationGestures =YES;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getNewInfo];
    });
}

- (void)getNewInfo{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_newsId forKey:@"newsId"];
    if (DEFAULF_USERID) {
        [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    }else{
        [dict setObject:@0 forKey:@"userKey"];
    }
    [[JsonHttp jsonHttp]httpRequest:@"news/getNewInfo" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            if ([data objectForKey:@"news"]) {
                self.detailDic = [data objectForKey:@"news"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self createBarBtn];
                });
            }
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
        
    }];
}
- (void)createBarBtn{
    _bar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fenxiang"] style:(UIBarButtonItemStyleDone) target:self action:@selector(shareAct)];
    _bar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = _bar;
}
- (void)shareAct{
    ShareAlert* alert = [[ShareAlert alloc]initMyAlert];
    alert.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenWidth);
    [alert setCallBackTitle:^(NSInteger index) {
        [self shareInfo:index];
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [alert show];
    }];

}

#pragma mark -- 分享
-(void)shareInfo:(NSInteger)index{
    
    NSData *fiData;
    
    fiData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [self.detailDic objectForKey:@"picURL"]]]];
    NSObject* obj;
    if (fiData != nil && fiData.length > 0) {
        obj = fiData;
    }
    else
    {
        obj = [UIImage imageNamed:@"iconlogo"];
    }
    
    NSString *md5Str;
    NSString*  shareUrl;
    if (DEFAULF_USERID) {
        md5Str = [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@&newsId=%@dagolfla.com", DEFAULF_USERID, _newsId]];
        shareUrl = [NSString stringWithFormat:@"https://mobile.dagolfla.com/news/getHtmlBody?userKey=%@&newsId=%@&md5=%@&share=1", DEFAULF_USERID, _newsId, md5Str];
    }else{
        md5Str = [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=0&newsId=%@dagolfla.com", _newsId]];
        shareUrl = [NSString stringWithFormat:@"https://mobile.dagolfla.com/news/getHtmlBody?userKey=0&newsId=%@&md5=%@&share=1", _newsId, md5Str];
    }


    [UMSocialData defaultData].extConfig.title=[NSString stringWithFormat:@"%@", [self.detailDic objectForKey:@"title"]];
    if (index == 0){
        
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"%@" ,[self.detailDic objectForKey:@"summary"]]  image:obj location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //                [self shareS:indexRow];
            }
        }];
        
    }else if (index==1){
        //朋友圈
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[NSString stringWithFormat:@"%@" ,[self.detailDic objectForKey:@"summary"]] image:obj location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //                [self shareS:indexRow];
            }
        }];
    }else{
        UMSocialData *data = [UMSocialData defaultData];
        data.shareImage = [UIImage imageNamed:DefaultHeaderImage];
        data.shareText = [NSString stringWithFormat:@"%@%@",@"君高高尔夫",shareUrl];
        [[UMSocialControllerService defaultControllerService] setSocialData:data];
        //2.设置分享平台
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
//        self.launchActivityTableView.frame = CGRectMake(0, 64, ScreenWidth, screenHeight - 64 - 49);
        
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
