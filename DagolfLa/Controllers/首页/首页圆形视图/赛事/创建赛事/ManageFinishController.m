//
//  ManageFinishController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/1.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ManageFinishController.h"
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"
#import "ShareAlert.h"

#import "ManageViewController.h"

@interface ManageFinishController ()

@end

@implementation ManageFinishController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建完成";
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [self createView];
    
    [self createBtnView];
}


-(void)createView
{
    UIView* viewBase = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth-50*ScreenWidth/375)];
    [self.view addSubview:viewBase];
    viewBase.backgroundColor = [UIColor whiteColor];
    
    
    UIView* viewImg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*2/6+20*ScreenWidth/375)];
    [self.view addSubview:viewImg];
    viewImg.backgroundColor = [UIColor blackColor];
    
    UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2-30*ScreenWidth/375, 20*ScreenWidth/375, 60*ScreenWidth/375, 60*ScreenWidth/375)];
    imgv.image = [UIImage imageNamed:@"wanc"];
    [viewImg addSubview:imgv];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 90*ScreenWidth/375, ScreenWidth, 30*ScreenWidth/375)];
    label.font = [UIFont systemFontOfSize:20*ScreenWidth/375];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [viewImg addSubview:label];
    label.text = @"您的赛事已创建成功!";
    
    
    
    UILabel *labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, ScreenWidth*2/6+20*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 40)];
    labelDetail.text = @"您可以邀请您的朋友，通过参赛邀请码参加比赛，或者让您的朋友通过观赛邀请码，在线观看您的记分情况!";
    labelDetail.numberOfLines = 0;
    labelDetail.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [viewBase addSubview:labelDetail];
    
    
    
    //观赛人邀请码
    UILabel *labelMan2 = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, ScreenWidth-130*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 30*ScreenWidth/375)];
    //    labelMan2.text = @"观赛人邀请码:1613071";
    labelMan2.text = [NSString stringWithFormat:@"观赛人邀请码:%@",_model.eventWatchNums];
    labelMan2.numberOfLines = 0;
    labelMan2.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    [viewBase addSubview:labelMan2];
    
    
    UIButton* btnWatch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnWatch.frame = CGRectMake(ScreenWidth-70*ScreenWidth/375, ScreenWidth-130*ScreenWidth/375, 60*ScreenWidth/375, 30*ScreenWidth/375);
    btnWatch.layer.cornerRadius = 8*ScreenWidth/375;
    btnWatch.layer.masksToBounds = YES;
    [btnWatch setTitle:@"分享" forState:UIControlStateNormal];
    [viewBase addSubview:btnWatch];
    [btnWatch setTitleColor:[UIColor colorWithRed:0.40f green:0.75f blue:0.46f alpha:1.00f] forState:UIControlStateNormal];
    btnWatch.titleLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    btnWatch.layer.borderColor = [[UIColor colorWithRed:0.40f green:0.75f blue:0.46f alpha:1.00f] CGColor];
    btnWatch.layer.borderWidth = 1*ScreenWidth/375;
    [btnWatch addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    btnWatch.tag = 1221;
    
    //参赛人邀请码
    UILabel *labelMan1 = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, ScreenWidth-90*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 30*ScreenWidth/375)];
    //    labelMan1.text = @"参赛人邀请码:1613071";
    labelMan1.text = [NSString stringWithFormat:@"参赛人邀请码:%@",_model.eventCompetitionNums];
    labelMan1.numberOfLines = 0;
    labelMan1.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    [viewBase addSubview:labelMan1];
    
    UIButton* btnJoin = [UIButton buttonWithType:UIButtonTypeCustom];
    btnJoin.frame = CGRectMake(ScreenWidth-70*ScreenWidth/375, ScreenWidth-90*ScreenWidth/375, 60*ScreenWidth/375, 30*ScreenWidth/375);
    btnJoin.layer.cornerRadius = 8*ScreenWidth/375;
    btnJoin.layer.masksToBounds = YES;
    [btnJoin setTitle:@"分享" forState:UIControlStateNormal];
    [btnJoin setTitleColor:[UIColor colorWithRed:0.40f green:0.75f blue:0.46f alpha:1.00f] forState:UIControlStateNormal];
    [viewBase addSubview:btnJoin];
    btnJoin.titleLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    btnJoin.layer.borderColor = [[UIColor colorWithRed:0.40f green:0.75f blue:0.46f alpha:1.00f] CGColor];
    btnJoin.layer.borderWidth = 1*ScreenWidth/375;
    [btnJoin addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    btnJoin.tag = 1222;
}


#pragma mark --分享点击事件
-(void)shareClick:(UIButton *)btn
{
    
    ShareAlert* alert = [[ShareAlert alloc]initMyAlert];
    alert.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenWidth);
    [alert setCallBackTitle:^(NSInteger index) {
//        [self shareInfoo:index];
        [self shareInfoo:index showBtn:btn];
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [alert show];
    }];
}

-(void)shareInfoo:(NSInteger)index showBtn:(UIButton *)btn
{
    NSString * shareUrl = [NSString stringWithFormat:@"http://www.dagolfla.com:8081/dagaoerfu/html5/tujian/down.html?eventid=%@",_model.eventId];

    [UMSocialData defaultData].extConfig.title= [NSString stringWithFormat:@"邀请您参与%@",_model.eventTite];
    
    //观赛
    if (btn.tag == 1222) {
        if(index==0)
        {
            //微信
            [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:@"www.dagolfla.com"];
            [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"打高尔夫啦:您的参赛码是%@",_model.eventCompetitionNums] image:[UIImage imageNamed:@"logo"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    ////NSLog(@"分享成功！");
                }
            }];
        }
        else if (index==1){
            
            [UMSocialData defaultData].extConfig.title= [NSString stringWithFormat:@"打高尔夫啦:您的参赛码是%@",_model.eventCompetitionNums];

            
            //朋友圈
            [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
            [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[NSString stringWithFormat:@"打高尔夫啦:您的参赛码是%@",_model.eventCompetitionNums] image:[UIImage imageNamed:@"logo"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
        }else{
            
            UMSocialData *data = [UMSocialData defaultData];
            data.shareImage = [UIImage imageNamed:@"logo"];
            data.shareText = [NSString stringWithFormat:@"打高尔夫啦:您的参赛码是%@",_model.eventCompetitionNums];
            
            [[UMSocialControllerService defaultControllerService] setSocialData:data];
            //2.设置分享平台
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            
        }
    }
    else
    {
       if(index==0)
       {
           //微信
           [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
           [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
           [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"打高尔夫啦:您的观赛码是%@",_model.eventWatchNums] image:[UIImage imageNamed:@"logo"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
               if (response.responseCode == UMSResponseCodeSuccess) {
                   ////NSLog(@"分享成功！");
               }
           }];
       }
       else if (index==1)
       {
           [UMSocialData defaultData].extConfig.title= [NSString stringWithFormat:@"打高尔夫啦:您的观赛码是%@",_model.eventWatchNums];
 
           
           //朋友圈
           [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
           [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
           [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[NSString stringWithFormat:@"打高尔夫啦:您的观赛码是%@",_model.eventWatchNums] image:[UIImage imageNamed:@"logo"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
               if (response.responseCode == UMSResponseCodeSuccess) {
               }
           }];

           
       }
       else
       {
           UMSocialData *data = [UMSocialData defaultData];
           data.shareImage = [UIImage imageNamed:@"logo"];
           data.shareText = [NSString stringWithFormat:@"打高尔夫啦:您的观赛码是%@",_model.eventWatchNums];
           
           [[UMSocialControllerService defaultControllerService] setSocialData:data];
           //2.设置分享平台
           [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
           
       }
   }
}


-(void)createBtnView
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10*ScreenWidth/375, ScreenHeight-60*ScreenWidth/375-64, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 8*ScreenWidth/375;
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnSureClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)btnSureClick
{
    UIViewController *target=nil;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ManageViewController class]]) {
            target=vc;

        }
    }
    if (target) {
        [self.navigationController popToViewController:target animated:YES];
    }
    
    
//
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
