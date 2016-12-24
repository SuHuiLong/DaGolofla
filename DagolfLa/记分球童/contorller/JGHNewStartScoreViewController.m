//
//  JGHNewStartScoreViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/12/19.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHNewStartScoreViewController.h"
#import "JGHScoresViewController.h"
#import "JGHScoreView.h"
#import "BallParkViewController.h"
#import "DateTimeViewController.h"
#import "JGLAddPlayerViewController.h"
#import "JGHOptionCaddieOrPalyView.h"
#import "JGHCabbieCertViewController.h"
#import "JGDPlayPersonViewController.h"
#import "JGHCaddieWithPalyerScoreView.h"
#import "JGDPlayerQRCodeViewController.h"
#import "JGDPlayerScanViewController.h"
#import "JGHCaddieWithCaddieScoreView.h"
#import "JGHCabbieRewardViewController.h"
#import "JGLAddClientViewController.h"
#import "JGHActivityScoreListView.h"
#import "JGHActivityScoreView.h"
#import "JGLAddActivePlayViewController.h"
#import "JGHHistoryAndResultsViewController.h"

@interface JGHNewStartScoreViewController ()

{
    NSInteger _caddie;//0-打球人，1-球童
    
//    JGHScoreView *_scoreView;//记分
}

@property (retain, nonatomic)JGHScoreView *scoreView;

@property (retain, nonatomic)JGHOptionCaddieOrPalyView *optionView;

@property (retain, nonatomic)JGHCaddieWithPalyerScoreView *caddieWithPalyerScoreView;

@property (retain, nonatomic)JGHCaddieWithCaddieScoreView *caddieWithCaddieScoreView;

@property (retain, nonatomic)JGHActivityScoreListView *activityScoreListView;

@property (retain, nonatomic)JGHActivityScoreView *activityScoreView;

@end

@implementation JGHNewStartScoreViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self createItem];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self createItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    _isActivity = 0;
    
    [self.segment setTitle:@"自助记分" forSegmentAtIndex:0];
    [self.segment setTitle:@"球童记分" forSegmentAtIndex:1];
    
    [self loadJudgeData];//下载判断数据
    
    [self createScoreView];
}
#pragma mark -- 普通记分
- (void)createScoreView{
    //普通记分页面
    _scoreView = [[JGHScoreView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight -64)];
    __weak JGHNewStartScoreViewController *weakNewStartCtrl = self;
    _scoreView.blockSelectBall = ^(){
        BallParkViewController* ballVc = [[BallParkViewController alloc]init];
        ballVc.type1=1;
        
        ballVc.callback1=^(NSDictionary *dict, NSNumber *num){
            NSMutableArray *selectAreaArray = [NSMutableArray array];
            NSMutableArray *dataBallArray = [NSMutableArray array];
            
            if (dict.count != 0) {
                //添加默认勾选区域，2个全勾，其他不勾
                NSArray *ballAreasArray = [dict objectForKey:@"ballAreas"];
                if (ballAreasArray.count == 2) {
                    [selectAreaArray addObject:@1];
                    [selectAreaArray addObject:@1];
                }else{
                    for (int i=0; i<ballAreasArray.count; i++) {
                        [selectAreaArray addObject:@0];
                    }
                }
                
                [dataBallArray addObject:[dict objectForKey:@"ballAreas"]];
                [dataBallArray addObject:[dict objectForKey:@"tAll"]];
                
                [weakNewStartCtrl.scoreView reloadDataBallArray:dataBallArray andSelectAreaArray:selectAreaArray andNumTimeKeyLogo:[num integerValue]];
            }
        };
        [ballVc setCallback:^(NSString *balltitle, NSInteger ballid) {
            [weakNewStartCtrl.scoreView reloadBallName:balltitle andBallId:ballid];
        }];
        [weakNewStartCtrl.navigationController pushViewController:ballVc animated:YES];
    };
    
    _scoreView.blockSelectTime = ^(){
        DateTimeViewController* dateVc = [[DateTimeViewController alloc]init];
        dateVc.typeIndex = @1;
        [dateVc setCallback:^(NSString *dateStr, NSString *dateWeek, NSString *str) {
            [weakNewStartCtrl.scoreView reloadTime:str];
            
        }];
        [weakNewStartCtrl.navigationController pushViewController:dateVc animated:YES];
    };
    
    _scoreView.blockSelectPalyer = ^(NSMutableArray *palyArray){
        JGLAddPlayerViewController* addVc = [[JGLAddPlayerViewController alloc]init];
        addVc.blockSurePlayer = ^(NSMutableArray *array){
            [weakNewStartCtrl.scoreView reloadPalyerArray:array];
        };
        
        addVc.preListArray = palyArray;
        [weakNewStartCtrl.navigationController pushViewController:addVc animated:YES];
    };
    
    _scoreView.blockSelectScore = ^(NSString *scorekey){
        JGHScoresViewController *scoresCtrl = [[JGHScoresViewController alloc]init];
        scoresCtrl.scorekey = scorekey;
        [weakNewStartCtrl.navigationController pushViewController:scoresCtrl animated:YES];
    };
    
    [self.baseScrollView addSubview:_scoreView];
}
#pragma mark -- 下载数据
- (void)loadJudgeData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"score/hasMainScore" JsonKey:nil withData:dict failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            if ([data objectForKey:@"has"]) {
                _caddie = [[data objectForKey:@"has"] integerValue];
                
                NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
                [userdef setObject:@1 forKey:@"isCaddie"];
                [userdef synchronize];
            }else{
                _caddie = 0;
            }
            
            if ([[data objectForKey:@"scoreKey"] integerValue] != 0) {
                
                [Helper alertViewWithTitle:@"您还有记分尚未完成，是否前往继续记分" withBlockCancle:^{
                    
                } withBlockSure:^{
                    JGHScoresViewController* scrVc = [[JGHScoresViewController alloc]init];
                    scrVc.scorekey = [NSString stringWithFormat:@"%@",[data objectForKey:@"scoreKey"]];
                    //                NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
                    //
                    //                if ([userdef objectForKey:[NSString stringWithFormat:@"%@", [data objectForKey:@"scoreKey"]]]) {
                    //                    scrVc.currentPage = [[userdef objectForKey:[NSString stringWithFormat:@"%@", [data objectForKey:@"scoreKey"]]] integerValue];
                    //                }
                    //
                    //                NSLog(@"%@", [userdef objectForKey:[data objectForKey:@"scoreKey"]]);
                    [self.navigationController pushViewController:scrVc animated:YES];
                } withBlock:^(UIAlertController *alertView) {
                    [self.navigationController presentViewController:alertView animated:YES completion:nil];
                }];
            }

            if ([[data objectForKey:@"acBoolean"] integerValue] == 1) {
                //存在近三天记分活动
                _activityScoreListView = [[JGHActivityScoreListView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight -64)];
                __weak JGHNewStartScoreViewController *weakSelf = self;
                _activityScoreListView.blockChangeActivityStartScore = ^(JGLChooseScoreModel *model){
                    //选择某个活动，刷新页面－－－替换成活动记分
                    [weakSelf.scoreView removeFromSuperview];
                    [weakSelf createActivityScoreView:model];
                };
                
                [self.baseScrollView addSubview:_activityScoreListView];
            }
            else{
                //                [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                //                JGLSelfScoreViewController* SsVc = [[JGLSelfScoreViewController alloc]init];
                //                [self.navigationController pushViewController:SsVc animated:YES];
            }

        }
        
    }];
}
#pragma mark -- 活动记分
- (void)createActivityScoreView:(JGLChooseScoreModel *)model{
    _activityScoreView = [[JGHActivityScoreView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight -64)];
    [_activityScoreView reloadData:model];
    
    __weak JGHNewStartScoreViewController *weakSelf = self;
    //开始记分
    _activityScoreView.blockSelectActivityScore = ^(NSString *scoreKey){
        JGHScoresViewController *scoresCtrl = [[JGHScoresViewController alloc]init];
        scoresCtrl.scorekey = scoreKey;
        [weakSelf.navigationController pushViewController:scoresCtrl animated:YES];
    };
    //时间
    _activityScoreView.blockSelectActivityScoreDate = ^(){
        DateTimeViewController* dateVc = [[DateTimeViewController alloc]init];
        dateVc.typeIndex = @1;
        [dateVc setCallback:^(NSString *dateStr, NSString *dateWeek, NSString *str) {
            [weakSelf.activityScoreView reloadTime:dateStr];
        }];
        [weakSelf.navigationController pushViewController:dateVc animated:YES];
    };
    //打球人
    _activityScoreView.blockSelectActivityScorePalyer = ^(NSMutableArray *palyerArray, JGLChooseScoreModel *model){
        JGLAddActivePlayViewController* addVc = [[JGLAddActivePlayViewController alloc]init];
        addVc.model = model;
        addVc.blockSurePlayer = ^( NSMutableArray *palyArray)
        {
            //分配T台信息
            //存在T台数据，保留；否则重新设置默认T台数据
            [weakSelf.activityScoreView reloadPalyerArray:palyerArray];
            
        };
        
        addVc.palyArray = palyerArray;
        [weakSelf.navigationController pushViewController:addVc animated:YES];
    };
    
    [self.baseScrollView addSubview:_activityScoreView];
}

#pragma mark -- 自主记分


#pragma mark -- 我是球童-我是打球人
- (void)createCaddieAndPalyerView{
    _optionView = [[JGHOptionCaddieOrPalyView alloc]initWithFrame:CGRectMake(screenWidth, 0, screenWidth, screenHeight -64)];
    __weak JGHNewStartScoreViewController *weakSelf = self;
    _optionView.blockSelectCaddie = ^(){
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:@1 forKey:@"isCaddie"];
        [def synchronize];
//        [weakSelf.optionView removeFromSuperview];
//        weakSelf.optionView = nil;
        if (_caddie == 1) {
            //球童
            [weakSelf.optionView removeFromSuperview];
            weakSelf.optionView = nil;
            [weakSelf createCaddieView];
        }else{
            //球童认证
            JGHCabbieCertViewController* cadVc = [[JGHCabbieCertViewController alloc]init];
            [weakSelf.navigationController pushViewController:cadVc animated:YES];
        }
    };
    
    _optionView.blockSelectPalyer = ^(){
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:@0 forKey:@"isCaddie"];
        [def synchronize];
        [weakSelf.optionView removeFromSuperview];
        weakSelf.optionView = nil;
        //打球人
        [weakSelf createPalyerView];
        //JGDPlayPersonViewController
    };
    [self.baseScrollView addSubview:_optionView];
}
#pragma mark -- 我是球童
- (void)createCaddieView{
    _caddieWithCaddieScoreView = [[JGHCaddieWithCaddieScoreView alloc]initWithFrame:CGRectMake(screenWidth, 0, screenWidth, screenHeight -64)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    btn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    [btn setImage:[UIImage imageNamed:@"cabbArwed_Score"] forState:UIControlStateNormal];
    btn.tintColor = [UIColor colorWithHexString:Bar_Segment];
    [btn addTarget:self action:@selector(pushRewardCtrl:) forControlEvents:UIControlEventTouchUpInside];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    __weak JGHNewStartScoreViewController *weakSelf = self;
    //更多
    _caddieWithCaddieScoreView.blockCaddieMoreScore = ^(){
        JGHHistoryAndResultsViewController *hisVC = [[JGHHistoryAndResultsViewController alloc] init];
        [weakSelf.navigationController pushViewController:hisVC animated:YES];
    };
    //我的二维码
    _caddieWithCaddieScoreView.blockCaddieErweimaClick = ^(){
        JGDPlayerQRCodeViewController* barVc = [[JGDPlayerQRCodeViewController alloc]init];
        [weakSelf.navigationController pushViewController:barVc animated:YES];
    };
    //扫码
    NSInteger isCaddie = _caddie;
    _caddieWithCaddieScoreView.blockCaddieSaomaClick = ^(){
         JGLAddClientViewController* addVc = [[JGLAddClientViewController alloc]init];
         //    addVc.blockData = ^(NSString* numQId){
         //        _qCodeId = numQId;
         //        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(loopAct) userInfo:nil repeats:YES];
         //        [self.timer fire];
         //    };
         addVc.isCaddie = isCaddie;
         [weakSelf.navigationController pushViewController:addVc animated:YES];
    };
    
    [self.baseScrollView addSubview:_caddieWithCaddieScoreView];
}
#pragma mark -- 我是打球人
- (void)createPalyerView{
    _caddieWithPalyerScoreView = [[JGHCaddieWithPalyerScoreView alloc]initWithFrame:CGRectMake(screenWidth, 0, screenWidth, screenHeight -64)];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"我是球童" style:UIBarButtonItemStyleDone target:self action:@selector(ballBoy)];
    [rightBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15 * ProportionAdapter], NSFontAttributeName, nil] forState:(UIControlStateNormal)];
    rightBtn.tintColor = [UIColor colorWithHexString:Bar_Segment];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    __weak JGHNewStartScoreViewController *weakSelf = self;
    //我的二维码
    _caddieWithPalyerScoreView.blockSelectMyCode = ^(){
        JGDPlayerQRCodeViewController *codeVC = [[JGDPlayerQRCodeViewController alloc] init];
        codeVC.clipBlock = ^(NSString *name, NSInteger throw) {
            [weakSelf.caddieWithPalyerScoreView blackQRcodeName:name andThrow:throw];
        };
        [weakSelf.navigationController pushViewController:codeVC animated:YES];
    };
    //扫描
    _caddieWithPalyerScoreView.blockSelectSweepCode = ^(){
        JGDPlayerScanViewController *scanVC = [[JGDPlayerScanViewController alloc] init];
        scanVC.clipBlock = ^(NSString *name, NSInteger throw) {
            [weakSelf.caddieWithPalyerScoreView blackQRcodeName:name andThrow:throw];
        };
        [weakSelf.navigationController pushViewController:scanVC animated:YES];
    };
    //更多
    _caddieWithPalyerScoreView.blockSelectMoreScore = ^(){
        JGHHistoryAndResultsViewController *hisVC = [[JGHHistoryAndResultsViewController alloc] init];
        [weakSelf.navigationController pushViewController:hisVC animated:YES];
    };
    
    [self.baseScrollView addSubview:_caddieWithPalyerScoreView];
}
- (void)segmentAction:(UISegmentedControl *)segment{
    NSLog(@"%td", segment.selectedSegmentIndex);
    if (segment.selectedSegmentIndex == 0) {
        self.baseScrollView.contentOffset = CGPointMake(0, 0);
    }else{
        NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
        if ([userdef objectForKey:@"isCaddie"]) {//本地是否记录
            if (_caddie == 1) {
                //球童
                [self createCaddieView];
            }else{
                //打球人
                [self createPalyerView];
            }
        }else{
            if (_optionView == nil) {
                [self createCaddieAndPalyerView];//选择身份
            }
        }
        
        self.baseScrollView.contentOffset = CGPointMake(screenWidth, 0);
    }
}

#pragma mark -- 我是球童跳转
- (void)ballBoy{
    JGHCabbieCertViewController *cabVC = [[JGHCabbieCertViewController alloc] init];
    [self.navigationController pushViewController:cabVC animated:YES];
}
#pragma mark -- 奖励
- (void)pushRewardCtrl:(UIButton *)btn{
    JGHCabbieRewardViewController *cabbieRewardCtrl = [[JGHCabbieRewardViewController alloc]init];
    [self.navigationController pushViewController:cabbieRewardCtrl animated:YES];
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
