//
//  JGTeamDeatilWKwebViewController.m
//  DagolfLa
//
//  Created by 東 on 16/5/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//
#import <WebKit/WebKit.h>
#import "JGTeamDeatilWKwebViewController.h"
#import "JGDWithDrawTeamMoneyViewController.h"

@interface JGTeamDeatilWKwebViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (strong, nonatomic) WKWebView *webView;

@end

@implementation JGTeamDeatilWKwebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_isShareBtn == 1) {
        UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-fenxiang"] style:(UIBarButtonItemStylePlain) target:self action:@selector(shareBtn)];
        bar.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = bar;

    }
    
    self.title = self.teamName;
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.allowsBackForwardNavigationGestures =YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.detailString]]];
    
    
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://imgcache.dagolfla.com/html/index.html"]]];
    
//    if (self.detailString) {
//        [self.webView loadHTMLString:self.detailString baseURL:nil];
//    }else{
//        [Helper alertViewNoHaveCancleWithTitle:@"球队暂无简介" withBlock:^(UIAlertController *alertView) {
//            [self.navigationController presentViewController:alertView animated:YES completion:nil];
//        }];
//    }
    
    // Do any additional setup after loading the view.
}

#pragma mark -- 分享
- (void)shareBtn{
    ShareAlert* alert = [[ShareAlert alloc]initMyAlert];
    
    [self.view addSubview:alert];
    [alert setCallBackTitle:^(NSInteger index) {
        [self shareInfo:index];
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        [alert show];
    }];
}

-(void)shareInfo:(NSInteger)index{
    
    NSData *fiData = [[NSData alloc]init];
    fiData = [NSData dataWithContentsOfURL:[Helper setImageIconUrl:@"activity" andTeamKey:self.teamKey andIsSetWidth:YES andIsBackGround:YES]];
    
    
    NSString*  shareUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/team/group.html?key=%td", self.teamKey];
    
    [UMSocialData defaultData].extConfig.title=[NSString stringWithFormat:@"%@分组表",self.teamName];
    
    if (index == 0){
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"【%@】%@分组表", self.teamName,self.teamName]  image:(fiData != nil && fiData.length > 0) ?fiData : [UIImage imageNamed:TeamBGImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //                [self shareS:indexRow];
            }
        }];
        
    }else if (index==1){
        //朋友圈
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[NSString stringWithFormat:@"%@球队%@活动的分组表", self.teamName,self.teamName] image:(fiData != nil && fiData.length > 0) ?fiData : [UIImage imageNamed:TeamBGImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //                [self shareS:indexRow];
            }
        }];
    }else{
        UMSocialData *data = [UMSocialData defaultData];
        data.shareImage = [UIImage imageNamed:@"logo"];
        data.shareText = [NSString stringWithFormat:@"%@%@",@"打高尔夫啦",shareUrl];
        [[UMSocialControllerService defaultControllerService] setSocialData:data];
        //2.设置分享平台
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }
    
}


- (void)clearCookies{
    
    WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];
    [dateStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]
                     completionHandler:^(NSArray<WKWebsiteDataRecord *> * __nonnull records) {
                         for (WKWebsiteDataRecord *record  in records)
                         {
                             //                             if ( [record.displayName containsString:@"baidu"]) //取消备注，可以针对某域名清除，否则是全清
                             //                             {
                             [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:record.dataTypes
                                                                       forDataRecords:@[record]
                                                                    completionHandler:^{
                                                                        NSLog(@"Cookies for %@ deleted successfully",record.displayName);
                                                                    }];
                             //                             }
                         }
                     }];
    
}


// 是否允许加载网页 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *urlString = [[navigationAction.request URL] absoluteString];
    
    urlString = [urlString stringByRemovingPercentEncoding];
    NSLog(@"%@", urlString);
    //    NSLog(@"urlString=%@",urlString);
    // 用://截取字符串
    // 成员管理
    //dagolfla://weblink/teamMemberMgr?teamKey=xx&userKey=xx
    // 球队提现
    //dagolfla://weblink/teamWithDraw?teamKey=xx&userKey=xx
    //dagolfla://weblink/teamWithDraw?teamKey=4372&userKey=244
    
    
    NSArray  * array= [urlString componentsSeparatedByString:@":"];
//    NSArray  * arrayUrl= [urlString componentsSeparatedByString:@"privatemsg:"];
//    NSString *xinWenURL = @"privatemsg";
    
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    
    if ([array[0] isEqualToString:@"dagolfla"]) {
        //球队提现
        if ([urlString containsString:@"teamWithDraw"]) {
            JGDWithDrawTeamMoneyViewController *vc = [[JGDWithDrawTeamMoneyViewController alloc] init];
//            vc.teamKey = [self.detailDic objectForKey:@"timeKey"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if ([urlString containsString:@"teamMemberMgr"]) {
            JGDWithDrawTeamMoneyViewController *vc = [[JGDWithDrawTeamMoneyViewController alloc] init];
            //            vc.teamKey = [self.detailDic objectForKey:@"timeKey"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    
//    if ([urlComps count]) {
//        // 获取协议头
//        NSString *protocolHead = [urlComps objectAtIndex:0];
//        NSLog(@"protocolHead=%@",protocolHead);
//    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

/**
func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
    
    if let url = navigationAction.request.URL{
        if let host = url.host{  //获取域名
            print(host.lowercaseString)
        }
        if let url = url.absoluteString{
            print(url)
            if url.contain("tel"){<span style="font-family: Arial, Helvetica, sans-serif;">//自己给String做的一个扩展方法,实现判断是否包含 </span>
                
                let tel = url.replace("tel:", to: "") //自己给String做的一个扩展方法,实现替换
                let url1 = NSURL(string: "tel://" + tel)
                //自己封装的一个简易的的对话框弹框
                HUDialog.showDiaLoge("是否拨打:\(tel)", message: "", BtnTitle1: "取消", BtnBlock1: { () -> () in
                    
                }, BtnTitle2: "确认", BtnBlock2: { () -> () in
                    
                    UIApplication.sharedApplication().openURL(url1!)//打电话
                })
                
            }
            
        }
    }
    
    decisionHandler(WKNavigationActionPolicy.Allow) //决定是否加载这个请求, .Cancel则会取消这个加载 这个方法必须是同步的,且必须在本代理方法结束前调用
    
}
 */

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
