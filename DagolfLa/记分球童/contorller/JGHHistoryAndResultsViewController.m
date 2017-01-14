//
//  JGHHistoryAndResultsViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/12/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHHistoryAndResultsViewController.h"
#import "JGHRetrieveScoreViewController.h"
#import "JGHHistoryScoreView.h"
#import "JGHScoresViewController.h"
#import "JGDHistoryScoreModel.h"
#import "JGDNotActScoreViewController.h"
#import "JGDPlayerHisScoreCardViewController.h"
#import "JGDNotActivityHisCoreViewController.h"
#import "JGDHistoryScoreShowViewController.h"
#import "JGHScoreResultWKwebView.h"

@interface JGHHistoryAndResultsViewController ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, retain)JGHHistoryScoreView *historyScoreView;

@property (nonatomic, retain)JGHScoreResultWKwebView *scoreResultWKwebView;

@property (nonatomic, retain)UIGestureRecognizer *gest;


@end

@implementation JGHHistoryAndResultsViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self createItem];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //替换任务栏
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    //下载数据
    [self.historyScoreView.tableView.header beginRefreshing];
    
    [self.scoreResultWKwebView loadWebUrl:[NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/score/scoreList.html?userKey=%@&md5=%@",DEFAULF_USERID, [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]]]];
    
    [self createItem];
}
-(void)backButtonClcik{
    [self.historyScoreView.searchController dismissViewControllerAnimated:YES completion:^{
        
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self.segment setTitle:@"历史记分" forSegmentAtIndex:0];
    [self.segment setTitle:@"数据统计" forSegmentAtIndex:1];
    
    self.baseScrollView.scrollEnabled = NO;    
    
    [self createHistoryScoreView];
    
    [self createCountData];
    
    [self createRetrieveBtn];
}
- (void)createRetrieveBtn{
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"取回记分" style:UIBarButtonItemStyleDone target:self action:@selector(retrieveScore)];
    [rightBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15 * ProportionAdapter], NSFontAttributeName, nil] forState:(UIControlStateNormal)];
    rightBtn.tintColor = [UIColor colorWithHexString:Bar_Segment];
    self.navigationItem.rightBarButtonItem = rightBtn;
}
- (void)segmentAction:(UISegmentedControl *)segment{
    if (segment.selectedSegmentIndex == 0) {
        self.baseScrollView.contentOffset = CGPointMake( 0, 0);
//        _segment.selectedSegmentIndex = 0;
        [self createRetrieveBtn];
    }else{
        self.baseScrollView.contentOffset = CGPointMake( screenWidth, 0);
//        _segment.selectedSegmentIndex = 1;
        UIBarButtonItem* bar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fenxiangScore"] style:(UIBarButtonItemStylePlain) target:self action:@selector(shareStatisticsDataClick)];
        bar.tintColor = [UIColor colorWithHexString:Bar_Segment];
        self.navigationItem.rightBarButtonItem = bar;
    }
}
#pragma mark ----- 分享
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

#pragma mark -- 创建统计数据
- (void)createCountData{
    _scoreResultWKwebView = [[JGHScoreResultWKwebView alloc]initWithFrame:CGRectMake(screenWidth, 0, screenWidth, screenHeight -64)];
    [_scoreResultWKwebView loadWebUrl:[NSString stringWithFormat:@"http://imgcache.dagolfla.com/share/score/scoreList.html?userKey=%@&md5=%@",DEFAULF_USERID, [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]]]];
    [self.baseScrollView addSubview:_scoreResultWKwebView];
}
#pragma mark -- 创建历史记分
- (void)createHistoryScoreView{
    _historyScoreView = [[JGHHistoryScoreView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight -64)];
    __weak JGHHistoryAndResultsViewController *weakSelf = self;
    _historyScoreView.blockSelectHistoryScore = ^(JGDHistoryScoreModel *model){
        if (([model.userType integerValue] == 1) && (![model.userKey isEqualToString:model.scoreUserKey])) {
            
            if ([model.scoreFinish integerValue] == 0) {
                JGHScoresViewController *scoreVC = [[JGHScoresViewController alloc] init];
                scoreVC.isCabbie = [model.userType integerValue];
                NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
                if ([userdef objectForKey:[NSString stringWithFormat:@"%@", model.timeKey]]) {
                    scoreVC.currentPage = [[userdef objectForKey:[NSString stringWithFormat:@"%@", model.timeKey]] integerValue];
                }
                NSLog(@"%@", [userdef objectForKey:[NSString stringWithFormat:@"%@", model.timeKey]]);
                scoreVC.scorekey = [NSString stringWithFormat:@"%@", model.timeKey];
//                scoreVC.backHistory = 1;
                [weakSelf.navigationController pushViewController:scoreVC animated:YES];
            }else if ([model.scoreFinish integerValue] == 2) {
                
                if ([model.srcType integerValue] == 0) {
                    
                    JGDNotActScoreViewController *notAciVC = [[JGDNotActScoreViewController alloc] init];
                    notAciVC.timeKey = model.timeKey;
                    notAciVC.ballkid = 10;   //  未完成
                    //       notAciVC.ballkid = 11;
                    [weakSelf.navigationController pushViewController:notAciVC animated:YES];
                    
                }else{
                    
                    JGDPlayerHisScoreCardViewController *showVC = [[JGDPlayerHisScoreCardViewController alloc] init];
                    showVC.timeKey = model.timeKey;
                    showVC.ballkid = 10;  // 未完成
                    //     showVC.ballkid = 11;
                    [weakSelf.navigationController pushViewController:showVC animated:YES];
                }
            } else{
                
                if ([model.srcType integerValue] == 0) {
                    
                    JGDNotActScoreViewController *notAciVC = [[JGDNotActScoreViewController alloc] init];
                    notAciVC.timeKey = model.timeKey;
                    //                notAciVC.ballkid = 10;   //  未完成
                    notAciVC.ballkid = 11;
                    [weakSelf.navigationController pushViewController:notAciVC animated:YES];
                    
                }else{
                    
                    JGDPlayerHisScoreCardViewController *showVC = [[JGDPlayerHisScoreCardViewController alloc] init];
                    showVC.timeKey = model.timeKey;
                    //                showVC.ballkid = 10;  // 未完成
                    showVC.ballkid = 11;
                    [weakSelf.navigationController pushViewController:showVC animated:YES];
                }
            }
        }else{
            if ([model.scoreFinish integerValue] == 0) {
                JGHScoresViewController *scoreVC = [[JGHScoresViewController alloc] init];
                scoreVC.isCabbie = [model.userType integerValue];
                NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
                if ([userdef objectForKey:[NSString stringWithFormat:@"%@", model.timeKey]]) {
                    scoreVC.currentPage = [[userdef objectForKey:[NSString stringWithFormat:@"%@", model.timeKey]] integerValue];
                }
                NSLog(@"%@", [userdef objectForKey:[NSString stringWithFormat:@"%@", model.timeKey]]);
                scoreVC.scorekey = [NSString stringWithFormat:@"%@", model.timeKey];
//                scoreVC.backHistory = 1;
                [weakSelf.navigationController pushViewController:scoreVC animated:YES];
            }else{
                
                if ([model.srcType integerValue] == 0) {
                    
                    JGDNotActivityHisCoreViewController *notAciVC = [[JGDNotActivityHisCoreViewController alloc] init];
                    notAciVC.timeKey = model.timeKey;
                    [weakSelf.navigationController pushViewController:notAciVC animated:YES];
                    
                }else{
                    
                    JGDHistoryScoreShowViewController *showVC = [[JGDHistoryScoreShowViewController alloc] init];
                    showVC.timeKey = model.timeKey;
                    [weakSelf.navigationController pushViewController:showVC animated:YES];
                }
            }
        }
    };
    
    _historyScoreView.blockSelectHistoryScoreAlert = ^(UIAlertController *alert){
        [weakSelf presentViewController:alert animated:YES completion:nil];
    };
    
    [self.baseScrollView addSubview:_historyScoreView];
}

#pragma mark -- 取回记分
- (void)retrieveScore{
    JGHRetrieveScoreViewController *retriveveVC = [[JGHRetrieveScoreViewController alloc] init];
    retriveveVC.history = 1;
    [self.navigationController pushViewController:retriveveVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (BOOL)shouldAutorotate
//{
//    return YES;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
