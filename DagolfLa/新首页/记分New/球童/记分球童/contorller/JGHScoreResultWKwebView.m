//
//  JGHScoreResultWKwebView.m
//  DagolfLa
//
//  Created by 黄安 on 16/12/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHScoreResultWKwebView.h"

@interface JGHScoreResultWKwebView ()<WKUIDelegate>

@property (strong, nonatomic) WKWebView *webView;

@end

@implementation JGHScoreResultWKwebView


- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
        [self addSubview:self.webView];
        self.webView.UIDelegate = self;
//        self.webView.navigationDelegate = self;
//        self.webView.allowsBackForwardNavigationGestures =YES;
//        if (_isScore == YES) {
//            NSString* strMd = [JGReturnMD5Str getUserScoreWithTeamKey:_teamTimeKey userKey:[DEFAULF_USERID integerValue] srcKey:_activeTimeKey srcType:1];
//            NSString* strU = [NSString stringWithFormat:@"%@&md5=%@",self.detailString,strMd];
//            NSString* strU1 = [NSString stringWithFormat:@"%@&share=1&md5=%@",self.detailString,strMd];
//            _strShareMd = strU1;
//            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strU]]];
//        }
//        else if (_isManage == YES){
//            NSString* strMd = [JGReturnMD5Str getTeamBillInfoWithTeamKey:_teamKey userKey:[DEFAULF_USERID integerValue]];
//            NSString* strU = [NSString stringWithFormat:@"%@&md5=%@",self.detailString,strMd];
//            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strU]]];
//        }
//        else if (_isScoreAll == YES){
//            //成绩总览
//            NSString* strMd = [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@&teamKey=%tddagolfla.com", DEFAULF_USERID, _teamKey]];
//            NSString* strU = [NSString stringWithFormat:@"%@&md5=%@",self.detailString,strMd];
//            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strU]]];
//        }
//        else{
        
//        }
        
        
//        if (self.fromWitchVC == 722) {
//            UIBarButtonItem* bar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fenxiang"] style:(UIBarButtonItemStylePlain) target:self action:@selector(shareStatisticsDataClick)];
//            bar.tintColor = [UIColor whiteColor];
//            self.navigationItem.rightBarButtonItem = bar;
//        }
    }
    return self;
}
- (void)loadWebUrl:(NSString *)urlString{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}


#pragma mark ----- 统计
// 分享
//统计记分点击事件
-(void)shareStatisticsDataClick
{
    ShareAlert* alert = [[ShareAlert alloc]initMyAlert];
    alert.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenWidth);
    [alert setCallBackTitle:^(NSInteger index) {
        [self shareWithInfo:index];
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [alert show];
    }];
}

-(void)shareWithInfo:(NSInteger)index
{
    
    NSString*  shareUrl = [NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/score/scoreList.html?userKey=%@&md5=%@&share=1",DEFAULF_USERID, [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]]];
    
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
