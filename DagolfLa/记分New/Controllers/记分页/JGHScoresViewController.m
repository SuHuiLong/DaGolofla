//
//  JGHScoresViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHScoresViewController.h"
#import "JGHScoresMainViewController.h"
#import "JGHScoresHoleView.h"
#import "JGHScoreListModel.h"
#import "JGHEndScoresViewController.h"
#import "JGDHistoryScoreViewController.h"
#import "JGHCabbieWalletViewController.h"
#import "JGLCaddieScoreViewController.h"
#import "JGHPoorScoreHoleView.h"
#import "JGHHistoryAndResultsViewController.h"
#import "JGHScoreDatabase.h"
#import "JGHScoreAF.h"

//static NSInteger switchMode;

@interface JGHScoresViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate, JGHScoresHoleViewDelegate, JGHPoorScoreHoleViewDelegate>
{
    UIPageViewController *_pageViewController;
    NSMutableArray *_dataArray;
    
    NSInteger _selectHole;
    
    JGHScoresHoleView *_scoresView;
    
    JGHPoorScoreHoleView *_poorScoreView;
    
    UIView *_tranView;
    
    UIBarButtonItem *_item;
    
    NSMutableDictionary *_macthDict;//结束页面的参数
    
    NSInteger _selectPage;
    
    NSInteger _isEdtor;// 0-未修改， 1- 修改
    
    NSNumber *_walletMonay;//红包金额
    
    NSArray *_areaArray;
    
    NSMutableArray *_currentAreaArray;
    
    NSMutableDictionary *_ballDict;
    
    NSInteger _ballKey;
    
    NSInteger _scoreFinish;//是否完成记分0-,1-完成
    
    NSInteger _switchMode;// 0- 总；1- 差
    
    //NSInteger _refreshArea;
    
}

@property (nonatomic, strong)NSMutableArray *userScoreArray;

//@property (nonatomic, strong)UIButton *titleBtn;

@property (nonatomic, weak)NSTimer *timer;//计时器

@end

@implementation JGHScoresViewController

- (instancetype)init{
    if (self == [super init]) {
        self.userScoreArray = [NSMutableArray array];
        _macthDict = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //替换任务栏
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icn_home"] style:UIBarButtonItemStylePlain target:self action:@selector(backHome)];
    leftItem.tintColor=[UIColor colorWithHexString:@"#32b14d"];
    [leftItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15 * ProportionAdapter], NSFontAttributeName, nil] forState:(UIControlStateNormal)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    
    //创建记分表
    [[JGHScoreDatabase shareScoreDatabase]initDataBaseTableName:_scorekey];
    
    _walletMonay = 0;//红包金额
    
    [self.segment setTitle:@"差杆模式" forSegmentAtIndex:0];
    [self.segment setTitle:@"总杆模式" forSegmentAtIndex:1];
    
    //_refreshArea = 0;
    
    _ballDict = [NSMutableDictionary dictionary];
    NSUserDefaults *userdf = [NSUserDefaults standardUserDefaults];
    
    if ([userdf objectForKey:[NSString stringWithFormat:@"switchMode%@", _scorekey]]) {
        _switchMode = [[userdf objectForKey:[NSString stringWithFormat:@"switchMode%@", _scorekey]] integerValue];
        if (_switchMode == 0) {
            //总杆
            self.segment.selectedSegmentIndex = 1;
        }else{
            self.segment.selectedSegmentIndex = 0;
        }
    }else{
        _switchMode = 1;
        [userdf setObject:@"1" forKey:[NSString stringWithFormat:@"switchMode%@", _scorekey]];
        [userdf synchronize];
    }
    
    _areaArray = [NSArray array];
    _currentAreaArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noticePushScoresCtrl:) name:@"noticePushScores" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noticeAllScoresCtrl) name:@"noticeAllScores" object:nil];
    
    _selectHole = 0;
    if (_currentPage > 0) {
        _selectPage = _currentPage + 1;
    }else{
        _selectPage = 1;
    }
    
    _isEdtor = 0;
    
    _item = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveScoresClick)];
    _item.tintColor=[UIColor colorWithHexString:@"#32b14d"];
    [_item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15 * ProportionAdapter], NSFontAttributeName, nil] forState:(UIControlStateNormal)];
    self.navigationItem.rightBarButtonItem = _item;
    
    _dataArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<18; i++) {
        [_dataArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    if (_backHistory == 1) {
        [self historyScoreList];
    }
    
    //记分本地缓存
    //先查找本地是否存在记分记录，如果存在使用本地数据，否则使用接口数据
    BOOL result = [[JGHScoreDatabase shareScoreDatabase] selectScoreModel:_scorekey];
    if (result) {
        //本地数据
        [self loadLocalData];
    }else{
        //网络数据
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self getScoreList];
        });
    }
    
    //把所有的scoreKey 列表存在DF里面，供请求队列获取本地数据库数据  userdf
    NSMutableArray *scoreKeyArray = [NSMutableArray array];
    if ([userdf objectForKey:@"scoreKeyArray"]) {
        //本地存在
        scoreKeyArray = [userdf objectForKey:@"scoreKeyArray"];
        //插入scoreKey
        NSInteger content = 0;
        for (int i=0; i<scoreKeyArray.count; i++) {
            NSString *scoreKey = scoreKeyArray[i];
            if ([_scorekey isEqualToString:scoreKey]) {
                content = 1;
            }
        }
        
        if (content) {
            [scoreKeyArray addObject:_scorekey];
        }
        
        [userdf setObject:scoreKeyArray forKey:@"scoreKeyArray"];
    }else{
        //本地不存在
        [scoreKeyArray addObject:_scorekey];
        
        [userdf setObject:scoreKeyArray forKey:@"scoreKeyArray"];
    }
    
    [userdf synchronize];
}
#pragma mark -- segmentAction 记分模式切换
- (void)segmentAction:(UISegmentedControl *)segment{
    NSLog(@"%td", segment.selectedSegmentIndex);
    
    NSUserDefaults *userdf = [NSUserDefaults standardUserDefaults];
    
    if (segment.selectedSegmentIndex == 0) {
         //差杆模式
        _switchMode = 1;
        [userdf setObject:@1 forKey:[NSString stringWithFormat:@"switchMode%@", _scorekey]];
    }else{
        _switchMode = 0;
        [userdf setObject:@0 forKey:[NSString stringWithFormat:@"switchMode%@", _scorekey]];
    }
    
    [userdf synchronize];
    
    //更新数据库
    [[JGHScoreDatabase shareScoreDatabase]updateSwithModel:_switchMode andScoreKey:_scorekey];
    
    JGHScoresMainViewController *sub = (JGHScoresMainViewController *)_pageViewController.viewControllers[0];
    [sub switchScoreModeNote];
}
#pragma mark -- 返回首页
- (void)backHome{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [_timer invalidate];
    _timer = nil;
}
#pragma mark -- 计时器执行
- (void)changeTimeAtTimeDoClick{
    [[JsonHttp jsonHttp]cancelRequest];
    
    if ([[JGHScoreDatabase shareScoreDatabase]getScoreSave:_scorekey]) {
        //保存洞号
        _isEdtor = 0;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:DEFAULF_USERID forKey:@"userKey"];
        NSMutableArray *listArray = [NSMutableArray array];
        for (JGHScoreListModel *model in self.userScoreArray) {
            NSMutableDictionary *listDict = [NSMutableDictionary dictionary];
            if (model.userKey) {
                [listDict setObject:model.userKey forKey:@"userKey"];// 用户Key
            }else{
                [listDict setObject:@(0) forKey:@"userKey"];// 用户Key
            }
            
            [listDict setObject:model.userName forKey:@"userName"];// 用户名称
            if (model.userMobile) {
                [listDict setObject:model.userMobile forKey:@"userMobile"];// 手机号
            }else{
                [listDict setObject:@"" forKey:@"userMobile"];// 手机号
            }
            
            if (model.tTaiwan) {
                [listDict setObject:model.tTaiwan forKey:@"tTaiwan"];// T台
            }else{
                [listDict setObject:@"" forKey:@"tTaiwan"];// T台
            }
            
            [listDict setObject:_currentAreaArray[0] forKey:@"region1"];//region1
            [listDict setObject:_currentAreaArray[1] forKey:@"region2"];//region2
            [listDict setObject:model.poleNameList forKey:@"poleNameList"];// 球洞名称
            [listDict setObject:model.poleNumber forKey:@"poleNumber"];// 球队杆数
            [listDict setObject:model.pushrod forKey:@"pushrod"];// 推杆
            [listDict setObject:model.onthefairway forKey:@"onthefairway"];// 是否上球道
            [listDict setObject:model.timeKey forKey:@"timeKey"];// 是否上球道
            [listDict setObject:@(_switchMode) forKey:@"scoreModel"];//记分模式
            [listArray addObject:listDict];
        }
        
        [dict setObject:listArray forKey:@"list"];
        
        [[JsonHttp jsonHttp]httpRequestHaveSpaceWithMD5:@"score/saveScore" JsonKey:nil withData:dict failedBlock:^(id errType) {
            _isEdtor = 1;
        } completionBlock:^(id data) {
            NSLog(@"%@", data);
            NSLog(@"5S  时间保存");
            if ([[data objectForKey:@"packSuccess"]integerValue] == 1) {
                
                [[JGHScoreDatabase shareScoreDatabase]updateCommitDataScoreKey:_scorekey andCommitData:@"1"];
            }else{
                if ([data objectForKey:@"packResultMsg"]) {
                    _isEdtor = 1;
                }
            }
        }];
    }
}

#pragma mark -- 所有记分完成后
- (void)noticeAllScoresCtrl{
    _scoreFinish = 1;
    [_item setTitle:@"完成"];
}
#pragma mark -- getScoreList 获取活动计分列表
- (void)getScoreList{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:_scorekey forKey:@"scoreKey"];
    [dict setObject:[JGReturnMD5Str getScoreListUserKey:[DEFAULF_USERID integerValue] andScoreKey:[_scorekey integerValue]] forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"score/getOperationScoreList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self loadScoreView:data];
            });
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
}
#pragma mark -- 本地数据
- (void)loadLocalData{
    _userScoreArray = [[JGHScoreDatabase shareScoreDatabase]getAllScore];
    
    [self showViewWithScoreModel];
}
#pragma mark -- 处理下载的数据
- (void)loadScoreView:(id)data{
    if ([data objectForKey:@"ballAreas"]) {
        _areaArray = [data objectForKey:@"ballAreas"];
        
    }
    
    if ([data objectForKey:@"score"]) {
        NSMutableDictionary *scoreDict = [data objectForKey:@"score"];
        [_macthDict setObject:[scoreDict objectForKey:@"ballName"] forKey:@"ballName"];
        [_macthDict setObject:[scoreDict objectForKey:@"ballKey"] forKey:@"placeId"];
        [_macthDict setObject:[scoreDict objectForKey:@"createtime"] forKey:@"playTimes"];
        [_ballDict setObject:[scoreDict objectForKey:@"ballKey"] forKey:@"ballKey"];
        _switchMode = [[scoreDict objectForKey:@"scoreModel"] integerValue];
        
    }
    
    if ([data objectForKey:@"score"]) {
        _scoreFinish = [[[data objectForKey:@"score"] objectForKey:@"scoreFinish"] integerValue];
        if (_scoreFinish == 1) {
            _item.title = @"完成";
        }else{
            _item.title = @"保存";
        }
    }
    
    if ([data objectForKey:@"list"]) {
        NSArray *dataArray = [NSArray array];
        dataArray = [data objectForKey:@"list"];
        
        for (NSDictionary *dcitData in dataArray) {
            JGHScoreListModel *model = [[JGHScoreListModel alloc]init];
            [model setValuesForKeysWithDictionary:dcitData];
            
            if ([data objectForKey:@"ballAreas"]) {
                model.ballAreas = [data objectForKey:@"ballAreas"];
            }
            
            if ([data objectForKey:@"score"]) {
                model.score = [data objectForKey:@"score"];
            }
            
            model.interval = [data objectForKey:@"interval"];
            
            model.switchMode = _switchMode;
            model.finish = [NSString stringWithFormat:@"%td", _scoreFinish];
            
            //存数据库
            [[JGHScoreDatabase shareScoreDatabase]addJGHScoreListModel:model];
            
            [self.userScoreArray addObject:model];
        }
        
        [self showViewWithScoreModel];
    }
}
#pragma mark -- 获取数据后 显示页面
- (void)showViewWithScoreModel{
    JGHScoreListModel *model = [[JGHScoreListModel alloc]init];
    model = _userScoreArray[0];
    
    if (model.region1 != nil) {
        [_currentAreaArray addObject:model.region1];
    }
    
    if (model.region2 != nil) {
        [_currentAreaArray addObject:model.region2];
    }
    
    self.timer =[NSTimer scheduledTimerWithTimeInterval:[model.interval integerValue] target:self
                                               selector:@selector(changeTimeAtTimeDoClick) userInfo:nil repeats:YES];
    [self.timer fire];
    
    _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:1 navigationOrientation:0 options:nil];
    
    JGHScoresMainViewController *sub = [[JGHScoresMainViewController alloc]init];
    //sub.index = _currentPage;
    NSUserDefaults *userdf = [NSUserDefaults standardUserDefaults];
    sub.index = [[userdf objectForKey:[NSString stringWithFormat:@"%@", _scorekey]] integerValue];
    sub.dataArray = self.userScoreArray;
    sub.currentAreaArray = _currentAreaArray;
    sub.switchMode = _switchMode;
    sub.scorekey = _scorekey;
    __weak JGHScoresViewController *weakSelf = self;
    sub.returnScoresDataArray= ^(NSMutableArray *dataArray){
        weakSelf.userScoreArray = dataArray;
        _isEdtor = 1;
    };
    sub.selectHoleBtnClick = ^(){
        [self titleBtnClick];
    };
    
    [_pageViewController setViewControllers:@[sub] direction:0 animated:YES completion:nil];
    
    [self.view addSubview:_pageViewController.view];
    
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    for (int x=0; x< _userScoreArray.count; x++) {
        JGHScoreListModel *model = [[JGHScoreListModel alloc]init];
        model = self.userScoreArray[x];
        for (int i=0; i<18; i++) {
            if ([[model.poleNumber objectAtIndex:i] integerValue] == -1) {
                break;
            }else{
                if ([[model.onthefairway objectAtIndex:i] integerValue] == -1) {
                    break;
                }
            }
            
            if (x == _userScoreArray.count -1 && i == 17) {
                [self noticeAllScoresCtrl];
            }
        }
    }
    
    [self titleBtnClick];
    
}

#pragma mark -- 记分详情
- (void)titleBtnClick{
    NSLog(@"XXX dong");
    _item.enabled = YES;
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIButton *holeDireBtn = [window viewWithTag:15000];
    
    if (_selectHole == 0) {
        _selectHole = 1;
        if (_scoreFinish == 1) {
            [_item setTitle:@"完成"];
        }else{
            [_item setTitle:@"保存"];//结束记分
        }
        
        [holeDireBtn setImage:[UIImage imageNamed:@"zk"] forState:UIControlStateNormal];
        
        NSUserDefaults *userdf = [NSUserDefaults standardUserDefaults];
        _switchMode = [[userdf objectForKey:[NSString stringWithFormat:@"switchMode%@", _scorekey]] integerValue];
        if (_switchMode == 0) {
            
            _scoresView = [[JGHScoresHoleView alloc]init];
            _scoresView.delegate = self;
            _scoresView.frame = CGRectMake(0, screenHeight +(screenHeight-(35*3 +80 +60*2 + self.userScoreArray.count * 30*2)*ProportionAdapter), screenWidth, (35*3 +80 +60*2 + self.userScoreArray.count * 30*2)*ProportionAdapter);
            
            _scoresView.dataArray = self.userScoreArray;
            _scoresView.scorekey = _scorekey;
            _scoresView.curPage = _selectPage;
            
            [self.view addSubview:_scoresView];
            
            [_scoresView reloadScoreList:_currentAreaArray andAreaArray:_areaArray];//更新UI位置
            //遮罩
            _tranView = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight, screenWidth, screenHeight-(35*3 +80 +60*2 + self.userScoreArray.count * 30*2)*ProportionAdapter)];
            _tranView.backgroundColor = [UIColor blackColor];
            _tranView.alpha = 0.3;
            
            UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc]init];
            [tag addTarget:self action:@selector(titleBtnClick)];
            [_tranView addGestureRecognizer:tag];
            [[UIApplication sharedApplication].keyWindow addSubview:_tranView];
            
            [self showViewAnimate:_scoresView];
        }else{
            
            _poorScoreView = [[JGHPoorScoreHoleView alloc]init];
            _poorScoreView.delegate = self;
            _poorScoreView.frame = CGRectMake(0, screenHeight, screenWidth, (35*3 +80 +60*2 + self.userScoreArray.count * 30*2)*ProportionAdapter);
            _poorScoreView.dataArray = self.userScoreArray;
            _poorScoreView.scorekey = _scorekey;
            _poorScoreView.curPage = _selectPage;
            // _poorScoreView.curPage = [[userdf objectForKey:[NSString stringWithFormat:@"%@", _scorekey]] integerValue];
            [self.view addSubview:_poorScoreView];
            
            [_poorScoreView reloadScoreList:_currentAreaArray andAreaArray:_areaArray];//更新UI位置
            
            [self.view setUserInteractionEnabled:NO];

            
            _tranView = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight, screenWidth, (screenHeight -52*ProportionAdapter)-(35*3 +80 +60*2 + self.userScoreArray.count * 30*2)*ProportionAdapter)];
            _tranView.backgroundColor = [UIColor blackColor];
            _tranView.alpha = 0.3;
            
            UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc]init];
            [tag addTarget:self action:@selector(titleBtnClick)];
            [_tranView addGestureRecognizer:tag];
            [[UIApplication sharedApplication].keyWindow addSubview:_tranView];
            
            [self showViewAnimate:_poorScoreView];
        }
    }else{
        [holeDireBtn setImage:[UIImage imageNamed:@"zk1"] forState:UIControlStateNormal];
        _selectHole = 0;
        if (_scoreFinish == 1) {
            [_item setTitle:@"完成"];
        }else{
            [_item setTitle:@"保存"];
        }

        [self removeALlView];
    }
    
    [userdef synchronize];
}
- (void)showViewAnimate:(UIView *)animateView{
    [UIView animateWithDuration:0.3f animations:^{
        _tranView.frame = CGRectMake(0, 0, screenWidth, screenHeight-(35*3 +80 +60*2 + self.userScoreArray.count * 30*2)*ProportionAdapter);
        animateView.frame = CGRectMake(0, screenHeight -((35*3 +80 +60*2 + self.userScoreArray.count * 30*2)*ProportionAdapter +64), screenWidth, (35*3 +80 +60*2 + self.userScoreArray.count * 30*2)*ProportionAdapter);
        [self.view setUserInteractionEnabled:YES];
    }];
}
- (void)removeALlView{
    [self.view setUserInteractionEnabled:NO];
    [_scoresView setUserInteractionEnabled:NO];
    [UIView animateWithDuration:0.3f animations:^{
        if (_scoresView != nil) {
            [[[UIApplication sharedApplication].keyWindow viewWithTag:34567]removeFromSuperview];
            [[[UIApplication sharedApplication].keyWindow viewWithTag:45678]removeFromSuperview];
            //[[UIApplication sharedApplication].keyWindow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            _scoresView.frame = CGRectMake(0, screenHeight +((screenHeight -52*ProportionAdapter)-(35*2 +80 +60*2 + self.userScoreArray.count * 30*2)*ProportionAdapter), screenWidth, (35*2 +80 +60*2 + self.userScoreArray.count * 30*2)*ProportionAdapter);
        }
        
        if (_poorScoreView != nil) {
            //[[UIApplication sharedApplication].keyWindow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [[[UIApplication sharedApplication].keyWindow viewWithTag:34567]removeFromSuperview];
            [[[UIApplication sharedApplication].keyWindow viewWithTag:45678]removeFromSuperview];
            _poorScoreView.frame = CGRectMake(0, screenHeight +((screenHeight -52*ProportionAdapter)-(35*2 +80 +60*2 + self.userScoreArray.count * 30*2)*ProportionAdapter), screenWidth, (35*2 +80 +60*2 + self.userScoreArray.count * 30*2)*ProportionAdapter);
        }
        
        _tranView.frame = CGRectMake(0, screenHeight, screenWidth, (screenHeight -52*ProportionAdapter)-(35*2 +80 +60*2 + self.userScoreArray.count * 30*2)*ProportionAdapter);
        [self.view setUserInteractionEnabled:YES];
        [self performSelector:@selector(removeAnimateView) withObject:nil afterDelay:0.4f];
    }];
}
#pragma mark -- 关闭成绩列表视图
- (void)scoresHoleViewDelegateCloseBtnClick:(UIButton *)btn{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIButton *holeDireBtn = [window viewWithTag:15000];
    [holeDireBtn setImage:[UIImage imageNamed:@"zk1"] forState:UIControlStateNormal];
    _selectHole = 0;
    if (_scoreFinish == 1) {
        [_item setTitle:@"完成"];
    }else{
        [_item setTitle:@"保存"];
    }
    
    [self removeALlView];
}
- (void)removeAnimateView{
    if (_scoresView != nil) {
        //[_scoresView.areaListView removeFromSuperview];
        [_scoresView removeFromSuperview];
        _scoresView = nil;
    }
    
    if (_poorScoreView != nil) {
        
        [_poorScoreView removeFromSuperview];
        _poorScoreView = nil;
    }
    
    if (_tranView != nil) {
        [_tranView removeFromSuperview];
        _tranView = nil;
    }
}
#pragma mark -- 点击杆数跳转到指定的积分页面
- (void)noticePushScoresCtrl:(NSNotification *)not{

    //if (_refreshArea == 0) {
        _selectHole = 0;
        
        [self removeALlView];
    //}else{
      //  _selectHole = 1;
    //}
    
    if (_scoreFinish == 1) {
        [_item setTitle:@"完成"];
    }else{
        [_item setTitle:@"保存"];
    }
    
    //_refreshArea = 0;
    
    //[self.titleBtn setTitle:[NSString stringWithFormat:@"%td Hole PAR %td", [self returnPoleNameList:[[not.userInfo objectForKey:@"index"] integerValue]], [self returnStandardlever:[[not.userInfo objectForKey:@"index"] integerValue]]] forState:UIControlStateNormal];
    //当前页
    //NSInteger currentingPage = _currentPage;
    
    _currentPage = [[not.userInfo objectForKey:@"index"] integerValue];
    JGHScoresMainViewController *vc2;
    for (JGHScoresMainViewController *vc in _pageViewController.viewControllers) {
        if (vc.index == _currentPage){
            vc2 = vc;
        }
    }
    if (vc2 == nil) {
        vc2 = [[JGHScoresMainViewController alloc] init];
        vc2.index = _currentPage;
    }
    
    vc2.dataArray = self.userScoreArray;
    vc2.currentAreaArray = _currentAreaArray;
    vc2.switchMode = _switchMode;
    vc2.scorekey = _scorekey;
    _currentPage = vc2.index;
    _selectPage = _currentPage +1;
    //保存
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    if (vc2.index > 0) {
        [userdef setObject:@(vc2.index) forKey:[NSString stringWithFormat:@"%@", _scorekey]];
    }else{
        [userdef setObject:@0 forKey:[NSString stringWithFormat:@"%@", _scorekey]];
    }
    
    [userdef synchronize];
    __weak JGHScoresViewController *weakSelf = self;
    vc2.returnScoresDataArray= ^(NSMutableArray *dataArray){
        weakSelf.userScoreArray = dataArray;
        _isEdtor = 1;
    };
    vc2.selectHoleBtnClick = ^(){
        [self titleBtnClick];
    };
    
    if ([[not.userInfo objectForKey:@"direction"] integerValue] == 0) {
        [_pageViewController setViewControllers:@[vc2] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }else{
        [_pageViewController setViewControllers:@[vc2] direction:0 animated:YES completion:nil];
    }
    
    [self pageViewController:_pageViewController viewControllerAfterViewController:vc2];
    
    [self performSelector:@selector(removeRepeatView) withObject:nil afterDelay:0.3f];
}
- (void)removeRepeatView{
    [[[UIApplication sharedApplication].keyWindow viewWithTag:1234]removeFromSuperview];
}
#pragma mark -- 历史记分卡－－修改页面 
- (void)historyScoreList{
    JGHScoresMainViewController *vc2;
    for (JGHScoresMainViewController *vc in _pageViewController.viewControllers) {
        if (vc.index == _currentPage){
            vc2 = vc;
        }
    }
    if (vc2 == nil) {
        vc2 = [[JGHScoresMainViewController alloc] init];
        vc2.index = _currentPage;
    }
    
    vc2.dataArray = self.userScoreArray;
    vc2.currentAreaArray = _currentAreaArray;
    vc2.switchMode = _switchMode;
    vc2.scorekey = _scorekey;
//    _currentPage = vc2.index;
    _selectPage = _currentPage +1;
    //保存
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    if (vc2.index > 0) {
        [userdef setObject:@(vc2.index) forKey:[NSString stringWithFormat:@"%@", _scorekey]];
    }else{
        [userdef setObject:@0 forKey:[NSString stringWithFormat:@"%@", _scorekey]];
    }
    
    [userdef synchronize];
    __weak JGHScoresViewController *weakSelf = self;
    vc2.returnScoresDataArray= ^(NSMutableArray *dataArray){
        weakSelf.userScoreArray = dataArray;
        _isEdtor = 1;
    };
    vc2.selectHoleBtnClick = ^(){
        [self titleBtnClick];
    };
    [_pageViewController setViewControllers:@[vc2] direction:0 animated:YES completion:nil];
    
    
    [self pageViewController:_pageViewController viewControllerAfterViewController:vc2];
}
//返回前一页的视图控制器
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    JGHScoresMainViewController *s = (JGHScoresMainViewController *)viewController;
    s.switchMode = _switchMode;
    _currentPage = s.index;
    
    if (_currentPage <= 0) {
        _currentPage = _dataArray.count - 1;
        JGHScoresMainViewController *sub = [[JGHScoresMainViewController alloc]init];
        sub.index = _currentPage;
        //保存
  
        NSUserDefaults *userdf = [NSUserDefaults standardUserDefaults];
        sub.switchMode = [[userdf objectForKey:[NSString stringWithFormat:@"switchMode%@", _scorekey]] integerValue];
        sub.scorekey = _scorekey;
        sub.dataArray = self.userScoreArray;
        sub.currentAreaArray = _currentAreaArray;
        return sub;
    }
    else
    {
        //保存
        NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
        _currentPage--;
        
        JGHScoresMainViewController *sub = [[JGHScoresMainViewController alloc]init];
        sub.switchMode = [[userdef objectForKey:[NSString stringWithFormat:@"switchMode%@", _scorekey]] integerValue];
        sub.index = _currentPage;
        
        [userdef synchronize];
        
        sub.scorekey = _scorekey;
        sub.dataArray = self.userScoreArray;
        sub.currentAreaArray = _currentAreaArray;
        return sub;
    }
    
}

//下一页的视图控制器
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    
    JGHScoresMainViewController *s = (JGHScoresMainViewController *)viewController;
    s.switchMode = _switchMode;
    
    _currentPage = s.index;
    
    if (_currentPage >= _dataArray.count - 1) {
        _currentPage = 0;
        JGHScoresMainViewController *sub = [[JGHScoresMainViewController alloc]init];
        NSUserDefaults *userdf = [NSUserDefaults standardUserDefaults];
        sub.switchMode = [[userdf objectForKey:[NSString stringWithFormat:@"switchMode%@", _scorekey]] integerValue];
        sub.index = _currentPage;
        
        sub.scorekey = _scorekey;
        sub.dataArray = self.userScoreArray;
        sub.currentAreaArray = _currentAreaArray;
        return sub;
    }
    else
    {
        //保存
        NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
        
        _currentPage++;
        
        JGHScoresMainViewController *sub = [[JGHScoresMainViewController alloc]init];
        
        sub.switchMode = [[userdef objectForKey:[NSString stringWithFormat:@"switchMode%@", _scorekey]] integerValue];
        sub.index = _currentPage;
        
        [userdef synchronize];
        
        sub.scorekey = _scorekey;
        sub.dataArray = self.userScoreArray;
        sub.currentAreaArray = _currentAreaArray;
        NSLog(@"%@",sub);
        
        return sub;
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
    JGHScoresMainViewController *sub = (JGHScoresMainViewController *)pageViewController.viewControllers[0];
    NSUserDefaults *userdf = [NSUserDefaults standardUserDefaults];
    sub.switchMode = [[userdf objectForKey:[NSString stringWithFormat:@"switchMode%@", _scorekey]] integerValue];
    sub.scorekey = _scorekey;
    _currentPage = sub.index;
    sub.currentAreaArray = _currentAreaArray;
    __weak JGHScoresViewController *weakSelf = self;
    sub.returnScoresDataArray= ^(NSMutableArray *dataArray){
        weakSelf.userScoreArray = dataArray;
        _isEdtor = 1;
    };
    sub.selectHoleBtnClick = ^(){
        [self titleBtnClick];
    };
    //[self.titleBtn setTitle:[NSString stringWithFormat:@"%td Hole PAR %td", [self returnPoleNameList:sub.index], [self returnStandardlever:sub.index]] forState:UIControlStateNormal];
    
    NSLog(@"viewControllers == %@", _pageViewController.viewControllers);
    
    _currentPage = sub.index;
    _selectPage = sub.index+1;
    
    [sub switchScoreModeNote];
}
#pragma mark -- 获取标准杆
- (NSInteger)returnStandardlever:(NSInteger)standardId{
    JGHScoreListModel *model = [[JGHScoreListModel alloc]init];
    model = _userScoreArray[0];
    return [model.standardlever[standardId] integerValue];
}
#pragma mark -- 获取洞号
- (NSInteger)returnPoleNameList:(NSInteger)poleNameList{
    JGHScoreListModel *model = [[JGHScoreListModel alloc]init];
    model = _userScoreArray[0];
    NSLog(@"poleNameList == %td", [model.poleNameList[poleNameList] integerValue]);
    return [model.poleNameList[poleNameList] integerValue];
}
#pragma mark -- 保存／结束记分
- (void)saveScoresClick{
    _item.enabled = NO;
    
    //保存
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    if (_currentPage > 0) {
        [userdef setObject:@(_currentPage -1) forKey:[NSString stringWithFormat:@"%@", _scorekey]];
    }else{
        [userdef setObject:@0 forKey:[NSString stringWithFormat:@"%@", _scorekey]];
    }
    
    [userdef synchronize];
    
    dispatch_queue_t queueSave = dispatch_queue_create("saveScore", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queueSave, ^{
        [[JGHScoreAF shareScoreAF]httpScoreKey:_scorekey failedBlock:^(id errType) {
            _item.enabled = YES;
        } completionBlock:^(id data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _item.enabled = YES;
                
                if ([[data objectForKey:@"packSuccess"]integerValue] == 1) {
                    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
                    if (![userdef objectForKey:[NSString stringWithFormat:@"%@list", _scorekey]]) {
                        [userdef setObject:@1 forKey:[NSString stringWithFormat:@"%@list", _scorekey]];
                        [userdef synchronize];
                    }
                    
                    if (_scoreFinish == 0) {
                        [[ShowHUD showHUD]showToastWithText:@"保存成功" FromView:self.view];
                        
                        [[JGHScoreDatabase shareScoreDatabase]updateCommitDataScoreKey:_scorekey andCommitData:@"1"];
                    }else{
                        [self finishScore];
                    }
                }else{
                    if ([data objectForKey:@"packResultMsg"]) {
                        [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                    }
                }
            });
        }];
    });
    
    /*
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    NSMutableArray *listArray = [NSMutableArray array];
    for (JGHScoreListModel *model in self.userScoreArray) {
        NSMutableDictionary *listDict = [NSMutableDictionary dictionary];
        if (model.userKey) {
            [listDict setObject:model.userKey forKey:@"userKey"];// 用户Key
        }else{
            [listDict setObject:@(0) forKey:@"userKey"];// 用户Key
        }
        
        [listDict setObject:model.userName forKey:@"userName"];// 用户名称
        if (model.userMobile) {
            [listDict setObject:model.userMobile forKey:@"userMobile"];// 手机号
        }else{
            [listDict setObject:@"" forKey:@"userMobile"];// 手机号
        }
        if (model.tTaiwan) {
            [listDict setObject:model.tTaiwan forKey:@"tTaiwan"];// T台
        }else{
            [listDict setObject:@"" forKey:@"tTaiwan"];// T台
        }
        
        [listDict setObject:_currentAreaArray[0] forKey:@"region1"];//region1
        [listDict setObject:_currentAreaArray[1] forKey:@"region2"];//region2
        [listDict setObject:model.poleNameList forKey:@"poleNameList"];// 球洞名称
        [listDict setObject:model.poleNumber forKey:@"poleNumber"];// 球队杆数
        [listDict setObject:model.pushrod forKey:@"pushrod"];// 推杆
        [listDict setObject:model.onthefairway forKey:@"onthefairway"];// 是否上球道
        [listDict setObject:model.timeKey forKey:@"timeKey"];// 是否上球道
        [listDict setObject:@(_switchMode) forKey:@"scoreModel"];//记分模式
        
        [listArray addObject:listDict];
    }
    
    [dict setObject:listArray forKey:@"list"];
    
    [[JsonHttp jsonHttp]httpRequestHaveSpaceWithMD5:@"score/saveScore" JsonKey:nil withData:dict failedBlock:^(id errType) {
        _item.enabled = YES;
    } completionBlock:^(id data) {
        _item.enabled = YES;
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"]integerValue] == 1) {
            NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
            if (![userdef objectForKey:[NSString stringWithFormat:@"%@list", _scorekey]]) {
                [userdef setObject:@1 forKey:[NSString stringWithFormat:@"%@list", _scorekey]];
                [userdef synchronize];
            }
            
            if (_scoreFinish == 0) {
                [[ShowHUD showHUD]showToastWithText:@"保存成功" FromView:self.view];
            }else{
                [self finishScore];
            }
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
     */
}
#pragma mark -- 结束记分／完成
- (void)finishScore{
    _item.enabled = NO;
    [_timer invalidate];
    _timer = nil;
    self.view.userInteractionEnabled = NO;
    [[ShowHUD showHUD]showAnimationWithText:@"提交中..." FromView:self.view];
    //完成  finishScore
    dispatch_queue_t queue = dispatch_queue_create("finishScore", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        [[JGHScoreAF shareScoreAF]httpFinishScoreKey:_scorekey failedBlock:^(id errType) {
            [[ShowHUD showHUD]hideAnimationFromView:self.view];
            self.view.userInteractionEnabled = YES;
            _item.enabled = YES;
        } completionBlock:^(id data) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.view.userInteractionEnabled = YES;
                _item.enabled = YES;
                [[ShowHUD showHUD]hideAnimationFromView:self.view];
                if ([[data objectForKey:@"packSuccess"]integerValue] == 1) {
                    if ([data objectForKey:@"money"]) {
                        _walletMonay = [data objectForKey:@"money"];
                    }
                    
                    [[ShowHUD showHUD]showToastWithText:@"记分结束！" FromView:self.view];
                    [self performSelector:@selector(pushJGHEndScoresViewController) withObject:self afterDelay:1.0];//TIMESlEEP
                    
                    //记分完成后－－－删除本地记分表
                    [[JGHScoreDatabase shareScoreDatabase]deleteTable:_scorekey];
                    NSMutableArray *scoreKeyArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"scoreKeyArray"];
                    NSInteger deleteId =0;
                    for (int i=0; i<scoreKeyArray.count; i++) {
                        NSString *userdfScoreKey = [NSString stringWithFormat:@"%@", scoreKeyArray[i]];
                        if ([userdfScoreKey isEqualToString:_scorekey]) {
                            deleteId =i;
                        }
                    }
                    
                    [scoreKeyArray removeObjectAtIndex:deleteId];
                    
                    [[NSUserDefaults standardUserDefaults]setObject:scoreKeyArray forKey:@"scoreKeyArray"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }else{
                    if ([data objectForKey:@"packResultMsg"]) {
                        [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                    }
                }
            });
            
        }];
    });
    
    
    /*
    [[ShowHUD showHUD]showAnimationWithText:@"提交中..." FromView:self.view];
    
    NSMutableDictionary *finishDict = [NSMutableDictionary dictionary];
    [finishDict setObject:DEFAULF_USERID forKey:@"userKey"];
    [finishDict setObject:_scorekey forKey:@"scoreKey"];
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"score/finishScore" JsonKey:nil withData:finishDict failedBlock:^(id errType) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        self.view.userInteractionEnabled = YES;
        _item.enabled = YES;
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        
        self.view.userInteractionEnabled = YES;
        _item.enabled = YES;
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        if ([[data objectForKey:@"packSuccess"]integerValue] == 1) {
            if ([data objectForKey:@"money"]) {
                _walletMonay = [data objectForKey:@"money"];
            }
     // ----------------------11111
            //获取主线层
            if ([NSThread isMainThread]) {
                NSLog(@"Yay!");
                [[ShowHUD showHUD]showToastWithText:@"记分结束！" FromView:self.view];
                [self performSelector:@selector(pushJGHEndScoresViewController) withObject:self afterDelay:1.0];//TIMESlEEP
            } else {
                NSLog(@"Humph, switching to main");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[ShowHUD showHUD]showToastWithText:@"记分结束！" FromView:self.view];
                    [self performSelector:@selector(pushJGHEndScoresViewController) withObject:self afterDelay:1.0];//TIMESlEEP
                });
            }
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
     */
}
#pragma mark --历史记分
- (void)scoresResult{
    if (_isCabbie == 1) {
        // isCaddie;//是否是球童，1，是球童，
        NSInteger _isPushCtrl =0;
        
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[JGLCaddieScoreViewController class]]) {
                //                [[NSNotificationCenter defaultCenter] postNotificationName:@"CaddieScoreRefreshing" object:@{@"cabbie": @"1"}];
                NSNotification * notice = [NSNotification notificationWithName:@"reloadCaddieScoreData" object:nil userInfo:nil];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
                
                [self.navigationController popToViewController:controller animated:YES];
                _isPushCtrl = 1;
            }
        }
        
        if (_isPushCtrl == 0) {
            JGDHistoryScoreViewController *historyCtrl = [[JGDHistoryScoreViewController alloc]init];
            [self.navigationController pushViewController:historyCtrl animated:YES];
        }
    }else{
        
        JGDHistoryScoreViewController *historyCtrl = [[JGDHistoryScoreViewController alloc]init];
        [self.navigationController pushViewController:historyCtrl animated:YES];
    }
}
#pragma mark -- 完成记分---跳转
- (void)pushJGHEndScoresViewController{
    
    if (_backHistory == 1) {// 长按返回历史记分卡
//        JGDHistoryScoreViewController *historyCtrl = [[JGDHistoryScoreViewController alloc]init];
//        [self.navigationController pushViewController:historyCtrl animated:YES];
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[JGHHistoryAndResultsViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
                return;
            }
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if (_scoreFinish == 1 && _isCabbie == 1 && _walletMonay == 0) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[JGLCaddieScoreViewController class]]) {
                    NSNotification * notice = [NSNotification notificationWithName:@"reloadCaddieScoreData" object:nil userInfo:nil];
                    //发送消息
                    [[NSNotificationCenter defaultCenter]postNotification:notice];
                    
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
        }else{
            // && [_walletMonay floatValue] > 0
            if (_isCabbie == 1) {
                JGHCabbieWalletViewController *wealetCtrl = [[JGHCabbieWalletViewController alloc]init];
                wealetCtrl.wealMony = _walletMonay;
                NSString *userNameString = @"";
                for (JGHScoreListModel *model in self.userScoreArray) {
                    if (model.userName) {
                        [userNameString stringByAppendingString:model.userName];
                    }
                }
                
                wealetCtrl.customerName = userNameString;
                [self.navigationController pushViewController:wealetCtrl animated:YES];
            }else{
                NSInteger scoreCount = 0;
                for (int i=0; i<_userScoreArray.count; i++) {
                    JGHScoreListModel *model = [[JGHScoreListModel alloc]init];
                    model = _userScoreArray[i];
                    if ([model.userKey integerValue] == [DEFAULF_USERID integerValue]) {
                        for (int i=0; i<model.poleNumber.count; i++) {
                            if ([model.poleNumber[i] integerValue] != -1) {
                                scoreCount += [model.poleNumber[i] integerValue];
                            }
                        }
                    }
                }
                [_macthDict setObject:@(scoreCount) forKey:@"poleNum"];
                JGHEndScoresViewController *endScoresCtrl = [[JGHEndScoresViewController alloc]init];
                endScoresCtrl.dict = _macthDict;
                [self.navigationController pushViewController:endScoresCtrl animated:YES];
            }    
        }
    }
}
#pragma mark -- 切换球场区域 -- 总杆模式
- (void)oneAreaString:(NSString *)areaString andID:(NSInteger)selectId{
    [Helper alertViewWithTitle:@"确定切换打球区吗？该区切换前的记分数据会被清空！" withBlockCancle:^{
    } withBlockSure:^{
        
        [self loadOneAreaData:areaString andBtnTag:selectId];
    } withBlock:^(UIAlertController *alertView) {
        UIWindow   *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alertWindow.rootViewController = [[UIViewController alloc] init];
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        [alertWindow makeKeyAndVisible];
        [alertWindow.rootViewController presentViewController:alertView animated:YES completion:nil];
    }];
}
#pragma mark -- 切换球场区域 -- 总杆模式
- (void)poorOneAreaString:(NSString *)areaString andID:(NSInteger)selectId{
    [Helper alertViewWithTitle:@"确定切换打球区吗？该区切换前的记分数据会被清空！" withBlockCancle:^{
    } withBlockSure:^{
        
        [self loadOneAreaData:areaString andBtnTag:selectId];
    } withBlock:^(UIAlertController *alertView) {
        UIWindow   *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alertWindow.rootViewController = [[UIViewController alloc] init];
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        [alertWindow makeKeyAndVisible];
        [alertWindow.rootViewController presentViewController:alertView animated:YES completion:nil];
    }];
}
#pragma mark -- 切换第一区 -- 总杆模式
- (void)loadOneAreaData:(NSString *)btnString andBtnTag:(NSInteger)tag{
    NSLog(@"%@", btnString);
    //getOperationScoreList
    
    [[ShowHUD showHUD]showAnimationWithText:@"切换中..." FromView:self.view];
    [_ballDict setObject:btnString forKey:@"area"];// 区域名
    [_ballDict setObject:[JGReturnMD5Str getHoleNameAndPolesBallKey:[[_ballDict objectForKey:@"ballKey"] integerValue] andArea:btnString] forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"ball/getHoleNameAndPoles" JsonKey:nil withData:_ballDict requestMethod:@"GET" failedBlock:^(id errType) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            NSArray *holeNamesArray = [NSArray array];//球洞名称
            holeNamesArray = [data objectForKey:@"holeNames"];
            NSArray *standardleverArray = [NSArray array];//标准杆
            standardleverArray = [data objectForKey:@"poles"];
            if (tag < 400) {
                //更换区域信息
                [_currentAreaArray replaceObjectAtIndex:0 withObject:btnString];
                
                //userScoreArray--poleNameList
                for (int j=0; j<self.userScoreArray.count; j++) {
                    JGHScoreListModel *model = self.userScoreArray[j];
                    NSMutableArray *poleNameList = [NSMutableArray arrayWithArray:model.poleNameList];
                    NSMutableArray *poleNumber = [NSMutableArray arrayWithArray:model.poleNumber];
                    //onthefairway
                    NSMutableArray *onthefairway = [NSMutableArray arrayWithArray:model.onthefairway];
                    //pushrod
                    NSMutableArray *pushrod = [NSMutableArray arrayWithArray:model.pushrod];
                    //standardlever
                    NSMutableArray *standardlever = [NSMutableArray arrayWithArray:model.standardlever];
                    
                    for (int i=0; i< 9; i++) {
                        [poleNameList replaceObjectAtIndex:i withObject:holeNamesArray[i]];
                        [poleNumber replaceObjectAtIndex:i withObject:@-1];
                        [onthefairway replaceObjectAtIndex:i withObject:@-1];
                        [pushrod replaceObjectAtIndex:i withObject:@-1];
                        [standardlever replaceObjectAtIndex:i withObject:standardleverArray[i]];
                    }
                    
                    model.poleNameList = poleNameList;
                    model.poleNumber = poleNumber;
                    model.onthefairway = onthefairway;
                    model.pushrod = pushrod;
                    model.standardlever = standardlever;
                    [self.userScoreArray replaceObjectAtIndex:j withObject:model];
                }
                
            }else{
                //更换区域信息
                [_currentAreaArray replaceObjectAtIndex:1 withObject:btnString];
                
                for (int j=0; j<self.userScoreArray.count; j++) {
                    JGHScoreListModel *model = self.userScoreArray[j];
                    NSMutableArray *poleNameList = [NSMutableArray arrayWithArray:model.poleNameList];
                     NSMutableArray *poleNumber = [NSMutableArray arrayWithArray:model.poleNumber];
                    //onthefairway
                    NSMutableArray *onthefairway = [NSMutableArray arrayWithArray:model.onthefairway];
                    //pushrod
                    NSMutableArray *pushrod = [NSMutableArray arrayWithArray:model.pushrod];
                    //standardlever
                    NSMutableArray *standardlever = [NSMutableArray arrayWithArray:model.standardlever];
                    
                    for (int i=0; i< 9; i++) {
                        [poleNameList replaceObjectAtIndex:i +9 withObject:holeNamesArray[i]];
                        [poleNumber replaceObjectAtIndex:i +9 withObject:@-1];
                        [onthefairway replaceObjectAtIndex:i +9 withObject:@-1];
                        [pushrod replaceObjectAtIndex:i +9 withObject:@-1];
                        [standardlever replaceObjectAtIndex:i +9 withObject:standardleverArray[i]];
                    }
                    
                    model.poleNameList = poleNameList;
                    model.poleNumber = poleNumber;
                    model.onthefairway = onthefairway;
                    model.pushrod = pushrod;
                    model.standardlever = standardlever;
                    [self.userScoreArray replaceObjectAtIndex:j withObject:model];
                }
            }
            
            //刷新
            [_scoresView reloadViewData:self.userScoreArray andCurrentAreaArrat:_currentAreaArray];
            [_poorScoreView reloadPoorViewData:self.userScoreArray andCurrentAreaArrat:_currentAreaArray];
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
        
        //[self.titleBtn setTitle:[NSString stringWithFormat:@"%td Hole PAR %td", [self returnPoleNameList:_selectPage -1], [self returnStandardlever:_selectPage -1]] forState:UIControlStateNormal];
        
        //========================
        //_refreshArea = 1;
        
        NSLog(@"_selectPage == %td", _selectPage);
        //NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
        //[userDict setObject:@(_currentPage) forKey:@"index"];
        //创建一个消息对象
        //NSNotification * notice = [NSNotification notificationWithName:@"noticePushScores" object:nil userInfo:userDict];
        
        //发送消息
        //[[NSNotificationCenter defaultCenter]postNotification:notice];
        
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
