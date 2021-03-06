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
#import "JGLFeedbackViewController.h"

#import "ShareAlert.h"
#import "UMSocial.h"

#import "UMSocialWechatHandler.h"
#import "JGDCreatTeamViewController.h"

@interface JGTeamDeatilWKwebViewController ()<WKNavigationDelegate,WKUIDelegate>
{
    NSString* _strShareMd;
    NSString* _teamRealName;
}
@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic, strong) UIBarButtonItem * backItem;
@property (nonatomic, strong) UIBarButtonItem * closeItem;
@end

@implementation JGTeamDeatilWKwebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.teamName) {
        self.navigationItem.title = self.teamName;
    }
    [self updateNavigationItems];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    if (_isReward == 1) {
        UIBarButtonItem* bar = [[UIBarButtonItem alloc]initWithTitle:@"建议与反馈" style:UIBarButtonItemStylePlain target:self action:@selector(recordBtn)];
        bar.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = bar;
    }
    if (_isManage == YES) {
    UIBarButtonItem* bar = [[UIBarButtonItem alloc]initWithTitle:@"提现记录" style:UIBarButtonItemStylePlain target:self action:@selector(recordBtn)];
    bar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = bar;
        
    }
    if (_isScore == YES) {

        UIBarButtonItem* bar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_portshare"] style:UIBarButtonItemStylePlain target:self action:@selector(shareBtn)];
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
    if (_isScoreAll == YES) {
        UIBarButtonItem* bar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_portshare"] style:UIBarButtonItemStylePlain target:self action:@selector(shareBtn)];
        bar.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = bar;
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        [dict setObject:@(_teamKey) forKey:@"teamKey"];
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
    if (_isShareBtn == 1) {
        UIBarButtonItem* bar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_portshare"] style:UIBarButtonItemStylePlain target:self action:@selector(shareBtn)];
        bar.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = bar;
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        [dict setObject:@(_teamKey) forKey:@"teamKey"];
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
    
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    [self.view addSubview:self.webView];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.allowsBackForwardNavigationGestures =YES;
    if (_isScore == YES) {
        NSString* strMd = [JGReturnMD5Str getUserScoreWithTeamKey:_teamTimeKey userKey:[DEFAULF_USERID integerValue] srcKey:_activeTimeKey srcType:1];
        NSString* strU = [NSString stringWithFormat:@"%@&md5=%@",self.detailString,strMd];
        NSString* strU1 = [NSString stringWithFormat:@"%@&share=1&md5=%@",self.detailString,strMd];
        _strShareMd = strU1;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strU]]];
    }
    else if (_isManage == YES){
        NSString* strMd = [JGReturnMD5Str getTeamBillInfoWithTeamKey:_teamKey userKey:[DEFAULF_USERID integerValue]];
        NSString* strU = [NSString stringWithFormat:@"%@&md5=%@",self.detailString,strMd];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strU]]];
    }
    else if (_isScoreAll == YES){
        //成绩总览
        NSString* strMd = [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@&teamKey=%tddagolfla.com", DEFAULF_USERID, _teamKey]];
        NSString* strU = [NSString stringWithFormat:@"%@&md5=%@",self.detailString,strMd];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strU]]];
    }
    else{
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.detailString]]];
    }
    
    
    if (self.fromWitchVC == 722) {
        UIBarButtonItem* bar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fenxiang"] style:(UIBarButtonItemStylePlain) target:self action:@selector(shareStatisticsDataClick)];
        bar.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = bar;
    }
    
}

- (void)updateNavigationItems{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"btn_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)backButtonClcik{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma 查看成绩时需要分享
//分享点击事件
-(void)shareBtn
{
    ShareAlert* alert = [[ShareAlert alloc]initMyAlert];
    alert.frame = CGRectMake(0, ScreenHeight, ScreenWidth, kHvertical(210));
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
    NSString * shareUrl;
    if (_isScoreAll == YES) {
        fxData = [NSData dataWithContentsOfURL:[Helper setImageIconUrl:@"team" andTeamKey:_teamKey andIsSetWidth:YES andIsBackGround:NO] ];

        shareUrl = [NSString stringWithFormat:@"%@&md5=%@&share=1", _detailString, [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@&teamKey=%tddagolfla.com", DEFAULF_USERID, _teamKey]]];
        [UMSocialData defaultData].extConfig.title = [NSString stringWithFormat:@"成绩总览"];//这边标题要改
    }
    else if (_isShareBtn == 1)
    {
        fxData = [NSData dataWithContentsOfURL:[Helper setImageIconUrl:@"activity" andTeamKey:_activeTimeKey andIsSetWidth:YES andIsBackGround:YES]];
        
        NSString* strMd = [JGReturnMD5Str getTeamGroupNameListTeamKey:_teamKey activityKey:_activeTimeKey userKey:[DEFAULF_USERID integerValue]];
        shareUrl = [NSString stringWithFormat:@"https://imgcache.dagolfla.com/share/team/group.html?teamKey=%td&activityKey=%td&userKey=%td&share=1&md5=%@",_teamKey, _activeTimeKey, [DEFAULF_USERID integerValue],strMd];
        [UMSocialData defaultData].extConfig.title=[NSString stringWithFormat:@"%@分组表",_activeName];
    }
    else{
        fxData = [NSData dataWithContentsOfURL:[Helper setImageIconUrl:@"team" andTeamKey:_teamTimeKey andIsSetWidth:YES andIsBackGround:NO] ];

        shareUrl = _strShareMd;
        [UMSocialData defaultData].extConfig.title = [NSString stringWithFormat:@"%@",_activeName];
    }
    
   
    if(index==0)
    {
            //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        if (_isScoreAll == YES) {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"%@成绩总览",_teamRealName] image:(fxData != nil && fxData.length > 0) ?fxData : [UIImage imageNamed:TeamBGImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
        }
        else if (_isShareBtn == 1)
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"【%@】%@分组表", self.teamName,_activeName]  image:(fxData != nil && fxData.length > 0) ?fxData : [UIImage imageNamed:DefaultHeaderImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    //                [self shareS:indexRow];
                }
            }];
        }
        else{
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"%@%@的成绩",_teamRealName,_activeName] image:(fxData != nil && fxData.length > 0) ?fxData : [UIImage imageNamed:TeamBGImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
        }
        
    }
    else if (index==1)
    {
                
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        if (_isScoreAll == YES) {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[NSString stringWithFormat:@"%@成绩总览",_teamRealName] image:(fxData != nil && fxData.length > 0) ?fxData : [UIImage imageNamed:TeamBGImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
        }
        else if (_isShareBtn == 1)
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[NSString stringWithFormat:@"【%@】%@分组表", self.teamName,_activeName]  image:(fxData != nil && fxData.length > 0) ?fxData : [UIImage imageNamed:DefaultHeaderImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    //                [self shareS:indexRow];
                }
            }];
        }
        else{
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[NSString stringWithFormat:@"%@%@的成绩",_teamRealName,_activeName] image:(fxData != nil && fxData.length > 0) ?fxData : [UIImage imageNamed:TeamBGImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
        }
        
        
    }
    else
    {
        
        UMSocialData *data = [UMSocialData defaultData];
        data.shareImage = [fxData length] > 0 ? fxData : [UIImage imageNamed:TeamBGImage];
        if (_isScoreAll == YES) {
            data.shareText = [NSString stringWithFormat:@"%@的成绩总览",_teamRealName];
            [[UMSocialControllerService defaultControllerService] setSocialData:data];
        }
        else if (_isShareBtn == 1)
        {
            data.shareImage = [UIImage imageNamed:DefaultHeaderImage];
            data.shareText = [NSString stringWithFormat:@"%@%@",@"君高高尔夫",shareUrl];
            [[UMSocialControllerService defaultControllerService] setSocialData:data];
        }
        else{
            data.shareText = [NSString stringWithFormat:@"%@%@的成绩",_teamRealName,_activeName];
            [[UMSocialControllerService defaultControllerService] setSocialData:data];
        }
        //2.设置分享平台
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
        
    }
}




#pragma mark -- 账户体现
- (void)recordBtn{
    if (_isReward == 1) {
        JGLFeedbackViewController* feVc = [[JGLFeedbackViewController alloc]init];
        [self.navigationController pushViewController:feVc animated:YES];
    }
    else{
        JGLDrawalRecordViewController* dwVc = [[JGLDrawalRecordViewController alloc]init];
        dwVc.teamKey = _teamKey;
        [self.navigationController pushViewController:dwVc animated:YES];
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
                                                                       forDataRecords:@[record]completionHandler:^{
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
        //创建球队
        if ([urlString containsString:@"createTeam"]) {
            
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            
            JGDCreatTeamViewController *createVC = [[JGDCreatTeamViewController alloc] init];
            
            if ([user objectForKey:@"cacheCreatTeamDic"]) {
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"是否继续上次编辑" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [user setObject:0 forKey:@"cacheCreatTeamDic"];
                    
                    [self.navigationController pushViewController:createVC animated:YES];
                }];
                
                UIAlertAction* action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    createVC.detailDic = [[user objectForKey:@"cacheCreatTeamDic"] mutableCopy];
                    
                    [self.navigationController pushViewController:createVC animated:YES];
                }];
                
                [alert addAction:action1];
                [alert addAction:action2];
                [self presentViewController:alert animated:YES completion:nil];
                
            }else{
                [self.navigationController pushViewController:createVC animated:YES];
            }
            
        }
        
        // 年费设置  setYearMoney
//        if ([urlString containsString:@"setYearMoney"]) {
//            if ([urlString containsString:@"?"]) {
//                JGTeamMemberController *tmVc = [[JGTeamMemberController alloc] init];
//                
//                tmVc.teamKey = [NSNumber numberWithInteger:[[self returnTimeKeyWithUrlString:urlString] integerValue]];
//                
//                tmVc.teamManagement = 1;
//                [self.navigationController pushViewController:tmVc animated:YES];
//            }
//        }
        
        // 球队详情  teamDetail
        
        
        // 球队活动详情  teamActivityDetail
        
        // 社区详情
//    dagolfla://weblink/moodDetail?moodKey=xx
        
        // 商城商品详情
//    dagolfla://weblink/goodDetail?goodKey=xx
        
        // H5详情
//    dagolfla://weblink/openURL?url=xx(URLEncord)
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


#pragma mark ----- 统计

// 分享
//统计记分点击事件
-(void)shareStatisticsDataClick
{
    ShareAlert* alert = [[ShareAlert alloc]initMyAlert];
    alert.frame = CGRectMake(0, ScreenHeight, ScreenWidth, kHvertical(210));
    [alert setCallBackTitle:^(NSInteger index) {
        [self shareWithInfo:index];
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [alert show];
    }];
}

-(void)shareWithInfo:(NSInteger)index
{
    
    NSString*  shareUrl = [NSString stringWithFormat:@"https://imgcache.dagolfla.com/share/score/scoreList.html?userKey=%@&md5=%@&share=1",DEFAULF_USERID, [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]]];
    
    [UMSocialData defaultData].extConfig.title=[NSString stringWithFormat:@"打球数据统计分析"];
    if(index==0)
    {
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"数据很完整,分析的不错,值得一看" image:[UIImage imageNamed:IconLogo] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                ////NSLog(@"分享成功！");
            }
        }];
    }
    else if (index==1)
    {
        //朋友圈
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"数据很完整,分析的不错,值得一看" image:[UIImage imageNamed:IconLogo] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                ////NSLog(@"分享成功！");
            }
        }];
    }
    else
    {
        UMSocialData *data = [UMSocialData defaultData];
        data.shareImage = [UIImage imageNamed:IconLogo];
        data.shareText = [NSString stringWithFormat:@"%@%@",@"数据很完整,分析的不错,值得一看",shareUrl];
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
