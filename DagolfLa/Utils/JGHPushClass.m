//
//  JGHPushClass.m
//  DagolfLa
//
//  Created by 黄安 on 17/1/12.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHPushClass.h"
#import "JGDDPhotoAlbumViewController.h"
#import "NewFriendViewController.h"
#import "JGDWithDrawTeamMoneyViewController.h"
#import "JGTeamMainhallViewController.h"
#import "JGTeamMemberController.h"
#import "JGLJoinManageViewController.h"
#import "JGHNewActivityDetailViewController.h"
#import "JGTeamGroupViewController.h"
#import "JGLScoreRankViewController.h"
#import "JGLPresentAwardViewController.h"
#import "JGDNewTeamDetailViewController.h"
#import "UseMallViewController.h"
#import "DetailViewController.h"
#import "JGNewCreateTeamTableViewController.h"
#import "JGWkNewsViewController.h"

#import "JGDCourtDetailViewController.h" // 球场详情
#import "JGDBookCourtViewController.h"
#import "JGNewsViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "JGHTeamShadowViewController.h"

static JGHPushClass *pushClass = nil;

@implementation JGHPushClass

+(instancetype)pushClass
{
    @synchronized(self){
        
        if (pushClass == nil) {
            pushClass = [[self alloc]init];
        }
    }
    
    return pushClass;
}

- (void)URLString:(NSString *)urlString pushVC:(PushClass)pushVC{
    if ([urlString containsString:@"teamWithDraw"]) {
        if ([urlString containsString:@"?"]) {
            JGDWithDrawTeamMoneyViewController *vc = [[JGDWithDrawTeamMoneyViewController alloc] init];
            vc.teamKey = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:urlString andKey:@"teamKey"] integerValue]];
            if (pushVC) {
                pushVC(vc);
            }
        }
    }
    
    // 球场详情
    if ([urlString containsString:@"bookBallParkDetail"]) {
        JGDCourtDetailViewController *teamMainCtrl = [[JGDCourtDetailViewController alloc]init];
        teamMainCtrl.timeKey = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:urlString andKey:@"bookBallParkKey"] integerValue]];
        if (pushVC) {
            pushVC(teamMainCtrl);
        }
    }
    
    // 球场列表
    if ([urlString containsString:@"bookBallParkList"]) {
        JGDBookCourtViewController *teamMainCtrl = [[JGDBookCourtViewController alloc]init];
        if (pushVC) {
            pushVC(teamMainCtrl);
        }
    }
    
    // 球队大厅
    if ([urlString containsString:@"teamHall"]) {
        JGTeamMainhallViewController *teamMainCtrl = [[JGTeamMainhallViewController alloc]init];
        if (pushVC) {
            pushVC(teamMainCtrl);
        }
    }
    
    // 成员管理
    if ([urlString containsString:@"teamMemberMgr"]) {
        JGTeamMemberController *menVc = [[JGTeamMemberController alloc]init];
        menVc.title = @"队员管理";
        menVc.power = @"1004,1001,1002,1005";
        menVc.teamManagement = 1;
        menVc.teamKey = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:urlString andKey:@"teamKey"] integerValue]];
        if (pushVC) {
            pushVC(menVc);
        }
    }
    
    // 入队审核页面
    if ([urlString containsString:@"auditTeamMember"]) {
        JGLJoinManageViewController *jgJoinVC = [[JGLJoinManageViewController alloc] init];
        jgJoinVC.teamKey = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:urlString andKey:@"teamKey"] integerValue]];
        if (pushVC) {
            pushVC(jgJoinVC);
        }
    }

    //新球友
    if ([urlString containsString:@"newUserFriendList"]) {
        NewFriendViewController *friendCtrl = [[NewFriendViewController alloc]init];
        friendCtrl.fromWitchVC = 2;
        if (pushVC) {
            pushVC(friendCtrl);
        }
    }
    
    // 相册
    if ([urlString containsString:@"teamMediaList"]) {
        JGDDPhotoAlbumViewController *albumVC = [[JGDDPhotoAlbumViewController alloc]init];
        albumVC.albumKey = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:urlString andKey:@"albumKey"] integerValue]];
        if (pushVC) {
            pushVC(albumVC);
        }
    }
    
    //活动详情
    if ([urlString containsString:@"teamActivityDetail"]) {
        JGHNewActivityDetailViewController *teamCtrl= [[JGHNewActivityDetailViewController alloc]init];
        teamCtrl.teamKey = [[Helper returnKeyVlaueWithUrlString:urlString andKey:@"activityKey"] integerValue];
        if (pushVC) {
            pushVC(teamCtrl);
        }
    }
    
    //分组--普通用户
    if ([urlString containsString:@"activityGroup"]) {
        JGTeamGroupViewController *teamGroupCtrl= [[JGTeamGroupViewController alloc]init];
        teamGroupCtrl.teamActivityKey = [[Helper returnKeyVlaueWithUrlString:urlString andKey:@"activityKey"] integerValue];
        if (pushVC) {
            pushVC(teamGroupCtrl);
        }
    }
    
    //分组--管理
    if ([urlString containsString:@"activityGroupAdmin"]) {
        JGTeamGroupViewController *teamGroupCtrl= [[JGTeamGroupViewController alloc]init];
        teamGroupCtrl.teamActivityKey = [[Helper returnKeyVlaueWithUrlString:urlString andKey:@"activityKey"] integerValue];
        if (pushVC) {
            pushVC(teamGroupCtrl);
        }
    }
    
    //活动成绩详情 --
    if ([urlString containsString:@"activityScore"]) {
        JGLScoreRankViewController *scoreLiveCtrl= [[JGLScoreRankViewController alloc]init];
        scoreLiveCtrl.activity = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:urlString andKey:@"activityKey"] integerValue]];
        scoreLiveCtrl.teamKey = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:urlString andKey:@"teamKey"] integerValue]];
        if (pushVC) {
            pushVC(scoreLiveCtrl);
        }
    }
    
    //获奖详情 --
    if ([urlString containsString:@"awardedInfo"]) {
        JGLPresentAwardViewController *teamGroupCtrl= [[JGLPresentAwardViewController alloc]init];
        teamGroupCtrl.activityKey = [[Helper returnKeyVlaueWithUrlString:urlString andKey:@"activityKey"] integerValue];
        teamGroupCtrl.teamKey = [[Helper returnKeyVlaueWithUrlString:urlString andKey:@"teamKey"] integerValue];
        //teamGroupCtrl.isManager = 0;//0-非管理员
        if (pushVC) {
            pushVC(teamGroupCtrl);
        }
    }
    
    //球队详情
    if ([urlString containsString:@"teamDetail"]) {
        JGDNewTeamDetailViewController *newTeamVC = [[JGDNewTeamDetailViewController alloc] init];
        newTeamVC.timeKey = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:urlString andKey:@"teamKey"] integerValue]];
        if (pushVC) {
            pushVC(newTeamVC);
        }
    }
    
    //商品详情
    if ([urlString containsString:@"goodDetail"]) {
        UseMallViewController* userVc = [[UseMallViewController alloc]init];
        userVc.linkUrl = [NSString stringWithFormat:@"http://www.dagolfla.com/app/ProductDetails.html?proid=%td", [[Helper returnKeyVlaueWithUrlString:urlString andKey:@"goodKey"] integerValue]];
        if (pushVC) {
            pushVC(userVc);
        }
    }
    
    //H5 -- 高旅套餐
    if ([urlString containsString:@"openURL"]) {
        UseMallViewController* userVc = [[UseMallViewController alloc]init];
        userVc.linkUrl = [[Helper returnKeyVlaueWithUrlString:urlString andKey:@"url"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (pushVC) {
            pushVC(userVc);
        }

    }
    
    //社区
    if ([urlString containsString:@"moodKey"]) {
        DetailViewController * comDevc = [[DetailViewController alloc]init];
        comDevc.detailId = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:urlString andKey:@"timekey"] integerValue]];
        if (pushVC) {
            pushVC(comDevc);
        }
    }
    
    //创建球队
    if ([urlString containsString:@"createTeam"]) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        
        if ([user objectForKey:@"cacheCreatTeamDic"]) {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"是否继续上次编辑" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [user setObject:0 forKey:@"cacheCreatTeamDic"];
                JGNewCreateTeamTableViewController *creatteamVc = [[JGNewCreateTeamTableViewController alloc] init];
                if (pushVC) {
                    pushVC(creatteamVc);
                }
            }];
            UIAlertAction* action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                JGNewCreateTeamTableViewController *creatteamVc = [[JGNewCreateTeamTableViewController alloc] init];
                creatteamVc.detailDic = [[user objectForKey:@"cacheCreatTeamDic"] mutableCopy];
                creatteamVc.titleField.text = [[user objectForKey:@"cacheCreatTeamDic"] objectForKey:@"name"];
                if (pushVC) {
                    pushVC(creatteamVc);
                }
            }];
            
            [alert addAction:action1];
            [alert addAction:action2];
            if (pushVC) {
                pushVC(alert);
            }
            
        }else{
            JGNewCreateTeamTableViewController *creatteamVc = [[JGNewCreateTeamTableViewController alloc] init];
            if (pushVC) {
                pushVC(creatteamVc);
            }
        }
        
    }
    
    if ([urlString containsString:@"shakeSound"]) {
        [self sharkAction];
    }
    
    if ([urlString containsString:@"closeWebView"]) {
        if (pushVC) {
            pushVC(nil);
        }
    }
    
    //资讯
    if ([urlString containsString:@"newsDetail"]) {
        JGWkNewsViewController * comDevc = [[JGWkNewsViewController alloc]init];
        comDevc.newsId = [NSString stringWithFormat:@"%@", [Helper returnKeyVlaueWithUrlString:urlString andKey:@"newId"]];
        if (pushVC) {
            pushVC(comDevc);
        }
    }
    
    //更多资讯
    if ([urlString containsString:@"golfNewsList"]) {
        JGNewsViewController *moreCtrl = [[JGNewsViewController alloc]init];
        if (pushVC) {
            pushVC(moreCtrl);
        }
    }
    
    //球队掠影
    if ([urlString containsString:@"recommendAlbumList"]) {
        JGHTeamShadowViewController *moreCtrl = [[JGHTeamShadowViewController alloc]init];
        if (pushVC) {
            pushVC(moreCtrl);
        }
    }
}



//摇一摇事件
-(void)sharkAction{
    
    SystemSoundID   soundID;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shake-sound" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    
    //播放声音
    AudioServicesPlaySystemSound (soundID);
    //播放震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
}



@end
