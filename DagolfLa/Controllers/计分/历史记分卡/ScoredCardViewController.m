//
//  ScoredCardViewController
//  DaGolfla
//
//  Created by bhxx on 15/7/22.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ScoredCardViewController.h"
#import "ShareAlert.h"
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"

#import "ScoreProfessViewController.h"

#import "PostDataRequest.h"
#import "Helper.h"

@interface ScoredCardViewController ()<UIWebViewDelegate>

@property(nonatomic,retain)UIWebView *webView;

@property(nonatomic,retain)UIImageView *imageView;

@property(nonatomic,retain)UIActivityIndicatorView *actIndicatorView;

@end

@implementation ScoredCardViewController

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
    //NSLog(@"是否简单%@",_model.scoreIsSimple);
    //简单记分
    if ([_model.scoreIsSimple integerValue] == 1) {
        //自己记得分
        if ([_model.scoreWhoScoreUserId integerValue] != [[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] integerValue]) {
            //未认领
            if ([_model.scoreIsClaim integerValue] == 0) {
                if ([_model.scoreisend integerValue] != 0) {
                    //已经完成
                    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@,%@,在%@代您记分，是否认领该记分?",_model.userName,_model.scoreCreateTime,_model.scoreballName] preferredStyle:UIAlertControllerStyleAlert];
                    [self presentViewController:alert animated:YES completion:nil];
                    UIAlertAction* action1=[UIAlertAction actionWithTitle:@"认领" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [[PostDataRequest sharedInstance] postDataRequest:@"score/update.do" parameter:@{@"scoreId":_model.scoreId,@"scoreIsClaim":@1} success:^(id respondsData) {
                            //                        [Helper alertViewWithTitle:@"记分认领成功" withBlock:nil];
                            [Helper alertViewNoHaveCancleWithTitle:@"记分认领成功" withBlock:nil];
                        } failed:^(NSError *error) {
                            
                        }];
                    }];
                    UIAlertAction *action2=[UIAlertAction actionWithTitle:@"仅查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alert addAction:action1];
                    [alert addAction:action2];
                    
                }
            }
        }
    }
    else
    {
        //自己记得分
        if ([_model.scoreWhoScoreUserId integerValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] integerValue]) {
            
            if ([_model.scoreisend integerValue] == 0) {
                //未完成
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"您在%@时,在%@球场记分未完成,是否继续记分？",_model.scoreCreateTime,_model.scoreballName] preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:YES completion:nil];
                UIAlertAction* action1=[UIAlertAction actionWithTitle:@"继续记分" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    ScoreProfessViewController *simpVc = [[ScoreProfessViewController alloc]init];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                    simpVc.isSave = @10;
                    simpVc.strTitle = _model.scoreObjectTitle;
                    simpVc.strBallName = _model.scoreballName;
                    simpVc.strSite0 = _model.scoreSite0;
                    simpVc.strSite1 = _model.scoreSite1;
                    simpVc.strType = _model.scoreType;
                    simpVc.strTee = _model.scoreTTaiwan;
                    simpVc.scoreObjectId = _model.scoreObjectId;
                    simpVc.ballId = _model.scoreballId;
                    [self.navigationController pushViewController:simpVc animated:YES];
                    
                    
                }];
                UIAlertAction *action2=[UIAlertAction actionWithTitle:@"仅查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:action1];
                [alert addAction:action2];
            }
            else{
                //已完成
            }
        }
        //别人记分
        else
        {
            //未认领
            if ([_model.scoreIsClaim integerValue] == 0) {
                if ([_model.scoreisend integerValue] == 0) {
                    //未完成
                    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@,%@,在%@代您记分尚未完成，是否取回记分权继续记分?",_model.userName,_model.scoreCreateTime,_model.scoreballName] preferredStyle:UIAlertControllerStyleAlert];
                    [self presentViewController:alert animated:YES completion:nil];
                    UIAlertAction* action1=[UIAlertAction actionWithTitle:@"取回记分权" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [[PostDataRequest sharedInstance] postDataRequest:@"score/getMyQx.do" parameter:@{@"userMobile":[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"],@"type":_model.scoreType,@"scoreObjectId":_model.scoreObjectId,@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]} success:^(id respondsData) {
                            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
                            if ([[dict objectForKey:@"success"] integerValue] == 1) {
                                ScoreProfessViewController *simpVc = [[ScoreProfessViewController alloc]init];
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                                simpVc.isSave = @10;
                                simpVc.strTitle = _model.scoreObjectTitle;
                                simpVc.strBallName = _model.scoreballName;
                                simpVc.strSite0 = _model.scoreSite0;
                                simpVc.strSite1 = _model.scoreSite1;
                                simpVc.strType = _model.scoreType;
                                simpVc.strTee = _model.scoreTTaiwan;
                                simpVc.scoreObjectId = _model.scoreObjectId;
                                simpVc.ballId = _model.scoreballId;
                                [self.navigationController pushViewController:simpVc animated:YES];
                            }
                            else
                            {
                                [Helper alertViewWithTitle:@"取回记分权限错误" withBlock:^(UIAlertController *alertView) {
                                    [self presentViewController:alertView animated:YES completion:nil];
                                }];
                            }
                        } failed:^(NSError *error) {
                            
                        }];
                        
                        
                    }];
                    UIAlertAction *action2=[UIAlertAction actionWithTitle:@"仅查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alert addAction:action1];
                    [alert addAction:action2];
                    
                }
                else{
                    //已经完成
                    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@,%@,在%@代您记分，是否认领该记分?",_model.userName,_model.scoreCreateTime,_model.scoreballName] preferredStyle:UIAlertControllerStyleAlert];
                    [self presentViewController:alert animated:YES completion:nil];
                    UIAlertAction* action1=[UIAlertAction actionWithTitle:@"认领" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [[PostDataRequest sharedInstance] postDataRequest:@"score/update.do" parameter:@{@"scoreId":_model.scoreId,@"scoreIsClaim":@1} success:^(id respondsData) {
                            //                        [Helper alertViewWithTitle:@"记分认领成功" withBlock:nil];
                            [Helper alertViewNoHaveCancleWithTitle:@"记分认领成功" withBlock:nil];
                        } failed:^(NSError *error) {
                            
                        }];
                    }];
                    UIAlertAction *action2=[UIAlertAction actionWithTitle:@"仅查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alert addAction:action1];
                    [alert addAction:action2];
                    
                }
            }
        }

    }
    
    
    
    
    self.navigationController.navigationBarHidden=NO;
    
    //右边按钮
    UIBarButtonItem* shareBtn = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareCardClick)];
    shareBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = shareBtn;
    
    self.title = _model.scoreballName;
    self.webView.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-15*ScreenWidth/375);
    self.webView.delegate=self;
    
    [self.view addSubview:self.webView];
    NSURL* url = [[NSURL alloc]init];
    if ([_model.scoreIsSimple integerValue] == 1) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.dagolfla.com:8081/dagaoerfu/html5/team/Score_details.html?scoreId=%@",_model.scoreId]];
    }
    else
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.dagolfla.com:8081/dagaoerfu/html5/team/Historical_score.html?id=%@",_model.scoreId]];
    }
//html5/team/Historical_score.html
    //设置页面禁止滚动
    _webView.scrollView.bounces = NO ;
    //设置web占满屏幕
    _webView.scalesPageToFit = YES ;
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    UIActivityIndicatorView* actIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    actIndicator.frame = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2-100, 0, 0);
    
    [actIndicator startAnimating];
    [self.view addSubview:actIndicator];
    
    _actIndicatorView = actIndicator;
    
    
}
-(void)shareCardClick
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
    NSString*  shareUrl;
    if ([_model.scoreIsSimple integerValue] == 1) {
        shareUrl = [NSString stringWithFormat:@"http://www.dagolfla.com:8081/dagaoerfu/html5/team/Score_details.html?scoreId=%@",_model.scoreId];
    }
    else
    {
        shareUrl = [NSString stringWithFormat:@"http://www.dagolfla.com:8081/dagaoerfu/html5/team/Historical_score.html?id=%@",_model.scoreId];
    }
    
    [UMSocialData defaultData].extConfig.title=[NSString stringWithFormat:@"%@打球成绩",_model.scoreballName];
    if(index==0)
    {
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"打得不错,来看看吧" image:[UIImage imageNamed:@"logo"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
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
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"打得不错,来看看吧" image:[UIImage imageNamed:@"logo"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                
            }
        }];
        
    }
    else
    {
        
        UMSocialData *data = [UMSocialData defaultData];
        data.shareImage = [UIImage imageNamed:@"logo"];
        data.shareText = [NSString stringWithFormat:@"%@%@",@"打得不错,来看看吧",shareUrl];
        [[UMSocialControllerService defaultControllerService] setSocialData:data];
        //2.设置分享平台
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
          
        
    }
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_actIndicatorView stopAnimating];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    ////NSLog(@"webview下载失败，error = %@",[error localizedDescription]);
    self.imageView.image = [UIImage imageNamed:@"logo"];
}

@end
