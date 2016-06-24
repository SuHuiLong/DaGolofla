//
//  JGTeamDeatilWKwebViewController.m
//  DagolfLa
//
//  Created by 東 on 16/5/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//
#import <WebKit/WebKit.h>
#import "JGTeamDeatilWKwebViewController.h"

@interface JGTeamDeatilWKwebViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (strong, nonatomic) WKWebView *webView;

@end

@implementation JGTeamDeatilWKwebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSSet *websiteDataTypes = [NSSet setWithArray:@[
                                                    WKWebsiteDataTypeDiskCache,
                                                    WKWebsiteDataTypeOfflineWebApplicationCache,
                                                    WKWebsiteDataTypeMemoryCache,
                                                    WKWebsiteDataTypeLocalStorage,
                                                    WKWebsiteDataTypeCookies,
                                                    WKWebsiteDataTypeSessionStorage,
                                                    WKWebsiteDataTypeIndexedDBDatabases,
                                                    WKWebsiteDataTypeWebSQLDatabases
                                                    ]];
    //你可以选择性的删除一些你需要删除的文件 or 也可以直接全部删除所有缓存的type
    //NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes   
                                               modifiedSince:dateFrom completionHandler:^{
                                                   // code
                                               }];

    
    
    
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
