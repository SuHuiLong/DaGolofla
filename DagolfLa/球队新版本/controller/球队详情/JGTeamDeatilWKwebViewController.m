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
#import "JGTeamMemberController.h"
#import "JGLDrawalRecordViewController.h"

#import "ShareAlert.h"
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"
@interface JGTeamDeatilWKwebViewController ()<WKNavigationDelegate,WKUIDelegate>
{
    NSString* _strShareMd;
    NSString* _teamRealName;
}
@property (strong, nonatomic) WKWebView *webView;

@end

@implementation JGTeamDeatilWKwebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_isManage == YES) {
    UIBarButtonItem* bar = [[UIBarButtonItem alloc]initWithTitle:@"提现记录" style:UIBarButtonItemStylePlain target:self action:@selector(recordBtn)];
    bar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = bar;
        
    }
    if (_isScore == YES) {
        UIBarButtonItem* bar = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareBtn)];
        bar.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = bar;
        
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        [dict setObject:@(_teamTimeKey) forKey:@"teamKey"];
        [[JsonHttp jsonHttp]httpRequest:@"team/getTeamName" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        } completionBlock:^(id data) {
            NSLog(@"data == %@", data);
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                _teamRealName = [data objectForKey:@"teamName"];
            }else{
                //错误
            }
        }];
        
        
    }
    
    self.title = self.teamName;
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.allowsBackForwardNavigationGestures =YES;
    if (_isScore == YES) {
        NSString* strMd = [JGReturnMD5Str getUserScoreWithTeamKey:_teamTimeKey userKey:[DEFAULF_USERID integerValue] srcKey:_activeTimeKey srcType:1];
        NSString* strU = [NSString stringWithFormat:@"%@&md5=%@",self.detailString,strMd];
        _strShareMd = strU;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strU]]];
    }
    else if (_isManage == YES){
//        NSString* strMd = [JGReturnMD5Str getUserScoreWithTeamKey:_teamTimeKey userKey:[DEFAULF_USERID integerValue] srcKey:_activeTimeKey srcType:1];
        NSString* strMd = [JGReturnMD5Str getTeamBillInfoWithTeamKey:_teamKey userKey:[DEFAULF_USERID integerValue]];
        NSString* strU = [NSString stringWithFormat:@"%@&md5=%@",self.detailString,strMd];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strU]]];
    }
    else{
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.detailString]]];
    }
    
}

#pragma 查看成绩时需要分享
//分享点击事件
-(void)shareBtn
{
    ShareAlert* alert = [[ShareAlert alloc]initMyAlert];
    alert.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenWidth);
    [alert setCallBackTitle:^(NSInteger index) {
        [self shareInfo:index];
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [alert show];
    }];
}

-(void)shareInfo:(NSInteger)index
{
    NSData *fxData;
    UIImage* fxImg;
    if ([fxData isEqual:nil] != NO) {
        fxData = [NSData dataWithContentsOfURL:[Helper setImageIconUrl:@"team" andTeamKey:_teamTimeKey andIsSetWidth:YES andIsBackGround:NO] ];
    }
    else
    {
        fxImg = [UIImage imageNamed:@"logo"];
    }

    NSString * shareUrl = _strShareMd;
    [UMSocialData defaultData].extConfig.title = [NSString stringWithFormat:@"%@",_activeName];
    if(index==0)
    {
            //微信
            [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
            [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"%@%@的成绩",_teamRealName,_activeName] image:[fxData isEqual:nil] != NO ? fxData : fxImg location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
   
    }
    else if (index==1)
    {
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"%@%@的成绩",_teamRealName,_activeName] image:[fxData length] > 0 ? fxData : fxImg location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
            }
        }];
        
    }
    else
    {
        
        UMSocialData *data = [UMSocialData defaultData];
        data.shareImage = [fxData length] > 0 ? fxData : fxImg;
        data.shareText = [NSString stringWithFormat:@"%@%@的成绩",_teamRealName,_activeName];
        [[UMSocialControllerService defaultControllerService] setSocialData:data];
        //2.设置分享平台
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
        
    }
}




#pragma mark -- 账户体现
- (void)recordBtn{
    JGLDrawalRecordViewController* dwVc = [[JGLDrawalRecordViewController alloc]init];
    dwVc.teamKey = _teamKey;
    [self.navigationController pushViewController:dwVc animated:YES];
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
    
    NSArray  * array= [urlString componentsSeparatedByString:@":"];
    
    if ([array[0] isEqualToString:@"dagolfla"]) {
        //球队提现
        if ([urlString containsString:@"teamWithDraw"]) {
            if ([urlString containsString:@"?"]) {
                JGDWithDrawTeamMoneyViewController *vc = [[JGDWithDrawTeamMoneyViewController alloc] init];
                vc.teamKey = [NSNumber numberWithInteger:[[self returnTimeKeyWithUrlString:urlString] integerValue]];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        // 成员管理
        if ([urlString containsString:@"teamMemberMgr"]) {
            if ([urlString containsString:@"?"]) {
                JGTeamMemberController *tmVc = [[JGTeamMemberController alloc] init];
                
                tmVc.teamKey = [NSNumber numberWithInteger:[[self returnTimeKeyWithUrlString:urlString] integerValue]];
                
                tmVc.teamManagement = 1;
                [self.navigationController pushViewController:tmVc animated:YES];
            }
        }
    }
    
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (NSString *)returnTimeKeyWithUrlString:(NSString *)string{
    NSArray *parameterArray = [NSArray array];
    NSString *timeKey;
    NSArray *timeKeyArray = [string componentsSeparatedByString:@"?"];
    if ([timeKeyArray count] == 2) {
        NSString *parameterStr = [timeKeyArray objectAtIndex:1];
        if ([parameterStr containsString:@"&"]) {
            parameterArray = [parameterStr componentsSeparatedByString:@"&"];
            if ([[parameterArray objectAtIndex:0]containsString:@"teamKey"]) {
                timeKey = [[[parameterArray objectAtIndex:0]componentsSeparatedByString:@"="] objectAtIndex:1];
            }
        }
    }
    
    return timeKey;
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
