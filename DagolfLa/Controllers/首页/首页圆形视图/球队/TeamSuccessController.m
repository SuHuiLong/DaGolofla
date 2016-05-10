//
//  TeamSuccessController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/8.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "TeamSuccessController.h"
#import "MBProgressHUD.h"
#import "TeamInviteViewController.h"
#import "PostDataRequest.h"
#import "FriendModel.h"
#import "TeamMessageController.h"

#import "Helper.h"

#import "ShareAlert.h"
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"
@interface TeamSuccessController ()
{
    //好友列表请求的数据
    NSMutableArray* _arrayIndex;
    NSMutableArray* _arrayData;
    NSMutableArray* _arrayData1;
    
    NSMutableArray* _messageArray;
    NSMutableArray* _telArray;
    
    MBProgressHUD * _progre;
}
@end

@implementation TeamSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建成功";
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    
    _arrayIndex = [[NSMutableArray alloc]init];
    _arrayData = [[NSMutableArray alloc]init];
    _arrayData1 = [[NSMutableArray alloc]init];
    
    _messageArray = [[NSMutableArray alloc]init];
    _telArray = [[NSMutableArray alloc]init];
    
    //球队显示logo
    [self headView];
    //邀请好友，分享球队
    [self createFriendTeam];
}

-(void)headView
{
    UIView* viewHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 180*ScreenWidth/375)];
    viewHead.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewHead];
    
    UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2-50*ScreenWidth/375, 20*ScreenWidth/375, 100*ScreenWidth/375, 100*ScreenWidth/375)];
    imgv.image = [UIImage imageWithData:_teamLogo[0]];
    [viewHead addSubview:imgv];
    
    
    NSString* aString = _teamName;
//    CGSize titleSize = [aString sizeWithFont:[UIFont systemFontOfSize:14*ScreenWidth/375] constrainedToSize:CGSizeMake(MAXFLOAT, 20*ScreenWidth/375)];
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(0, 140*ScreenWidth/375, ScreenWidth, 40)];
    labelName.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    labelName.text = aString;
    labelName.textAlignment = NSTextAlignmentCenter;
    [viewHead addSubview:labelName];
}
-(void)createFriendTeam
{
    UIView* viewBase = [[UIView alloc]initWithFrame:CGRectMake(0, 200*ScreenWidth/375, ScreenWidth, 44*2*ScreenWidth/375)];
    [self.view addSubview:viewBase];
    viewBase.backgroundColor = [UIColor whiteColor];
    //邀请好友
    UIImageView* imgvAdd = [[UIImageView alloc]initWithFrame:CGRectMake(20*ScreenWidth/375, 12*ScreenWidth/375, 20*ScreenWidth/375, 20*ScreenWidth/375)];
    imgvAdd.image = [UIImage imageNamed:@"tianjia"];
    [viewBase addSubview:imgvAdd];
    
    UILabel* labelAdd = [[UILabel alloc]initWithFrame:CGRectMake(60*ScreenWidth/375, 12*ScreenWidth/375, 100*ScreenWidth/375, 20*ScreenWidth/375)];
    labelAdd.text = @"邀请好友";
    labelAdd.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [viewBase addSubview:labelAdd];
    
    UIButton* btnAdd = [UIButton buttonWithType:UIButtonTypeSystem];
    btnAdd.backgroundColor = [UIColor clearColor];
    btnAdd.frame = CGRectMake(0, 0, ScreenWidth, 44*ScreenWidth/375);
    [btnAdd addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [viewBase addSubview:btnAdd];
    
    //分割线
    UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 44*ScreenWidth/375, ScreenWidth, 1*ScreenWidth/375)];
    viewLine.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [viewBase addSubview:viewLine];
    //分享球队
    UIImageView* imgvShare = [[UIImageView alloc]initWithFrame:CGRectMake(20*ScreenWidth/375, 56*ScreenWidth/375, 20*ScreenWidth/375, 20*ScreenWidth/375)];
    imgvShare.image = [UIImage imageNamed:@"fenxiang"];
    [viewBase addSubview:imgvShare];
    
    UILabel* labelShare = [[UILabel alloc]initWithFrame:CGRectMake(60*ScreenWidth/375, 56*ScreenWidth/375, 100*ScreenWidth/375, 20*ScreenWidth/375)];
    labelShare.text = @"分享球队";
    labelShare.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [viewBase addSubview:labelShare];
    
    
    UIButton* btnShare = [UIButton buttonWithType:UIButtonTypeSystem];
    btnShare.backgroundColor = [UIColor clearColor];
    btnShare.frame = CGRectMake(0, 44*ScreenWidth/375, ScreenWidth, 44*ScreenWidth/375);
    [btnShare addTarget:self action:@selector(shareTeamClick) forControlEvents:UIControlEventTouchUpInside];
    [viewBase addSubview:btnShare];
    
    
    UILabel* labelTishi = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 288*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 30*ScreenWidth/375)];
    labelTishi.text = @"您的球队已经创建，尽快添加好友一起更好的享受高尔夫吧！";
    labelTishi.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
    labelTishi.textColor = [UIColor lightGrayColor];
    
    [self.view addSubview:labelTishi];
    
}

-(void)addClick
{
    TeamInviteViewController *teamVc = [[TeamInviteViewController alloc]init];
    
    teamVc.block = ^(NSMutableArray* arrayIndex, NSMutableArray* arrayData, NSMutableArray *addressArray){
        //接收数据
        [_arrayIndex removeAllObjects];
        [_arrayData1 removeAllObjects];
        [_arrayData removeAllObjects];
        
        [_messageArray removeAllObjects];
        [_telArray removeAllObjects];
        
        _arrayIndex=arrayIndex;
        _arrayData1=arrayData;
        
        for (int i = 0; i < [addressArray[0] count]; i++) {
            [_telArray addObject:addressArray[0][i]];
        }
        
        [_arrayData addObjectsFromArray:arrayData[0]];
        [_arrayData addObjectsFromArray:arrayData[1]];
        //        [_arrayData addObjectsFromArray:arrayData[2]];
        //存储短信数组
        [_messageArray addObjectsFromArray:arrayData[2]];
        
        
        //        ////NSLog(@"%@",[_arrayData[0] userId]);
        //        NSString *strId;
        NSMutableArray* arrayIdLis = [[NSMutableArray alloc]init];
        for (int i = 0 ; i < _arrayData.count; i++) {
            FriendModel* model = [[FriendModel alloc]init];
            model = _arrayData[i];
            [arrayIdLis addObject:model.userId];
        }
//        NSString *nsIdList=[arrayIdLis componentsJoinedByString:@","];
        _progre = [[MBProgressHUD alloc] initWithView:self.view];
        _progre.mode = MBProgressHUDModeIndeterminate;
        _progre.labelText = @"正在通知好友...";
        [self.view addSubview:_progre];
        [_progre show:YES];
       
                _progre.labelText = @"通知好友成功";
                // 延迟2秒执行：
                double delayInSeconds = 1.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    // code to be executed on the main queue after delay
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if (_messageArray.count != 0) {
                        [Helper alertViewWithTitle:@"是否立即发送短信邀请好友" withBlockCancle:^{
                            
                        } withBlockSure:^{
                            TeamMessageController* team = [[TeamMessageController alloc]init];
                            team.dataArray = _messageArray;
                            team.telArray = _telArray;
                            [self.navigationController pushViewController:team animated:YES];
                            
                        } withBlock:^(UIAlertController *alertView) {
                            [self presentViewController:alertView animated:YES completion:nil];
                        }];

                    }
                    
                });
        
    };
    teamVc.arrayIndex = _arrayIndex;
    teamVc.arrayData = _arrayData1;
    
    [self.navigationController pushViewController:teamVc animated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (alertView.tag == 1230) {
            TeamMessageController* team = [[TeamMessageController alloc]init];
            
            team.dataArray = _messageArray;
            team.telArray = _telArray;
            [self.navigationController pushViewController:team animated:YES];
            ////NSLog(@"%@      %@ ",team.dataArray, team.telArray );
        }
    }
    
}


#pragma mark --分享球队
-(void)shareTeamClick
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
    
    NSString*  shareUrl = [NSString stringWithFormat:@"http://www.dagolfla.com:8081/dagaoerfu/html5/team/Team_details.html?id=%@&userId=%@",_teamId,[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
    [UMSocialData defaultData].extConfig.title=@"打高尔夫啦";
    if(index==0)
    {
        //微信
        [UMSocialWechatHandler setWXAppId:@"wxdcdc4e20544ed728" appSecret:@"fdc75aae5a98f2aa0f62ef8cba2b08e9" url:shareUrl];
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"打高尔夫啦" image:[UIImage imageNamed:@"logo"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
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
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"打高尔夫啦" image:[UIImage imageNamed:@"logo"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                ////NSLog(@"分享成功！");
            }
        }];
        
    }
    else
    {
        
        UMSocialData *data = [UMSocialData defaultData];
        data.shareImage = [UIImage imageNamed:@"logo"];
        data.shareText = [NSString stringWithFormat:@"%@%@",@"打高尔夫啦",shareUrl];
        [[UMSocialControllerService defaultControllerService] setSocialData:data];
        //2.设置分享平台
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
        
    }
}

@end
