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

@interface JGHScoresViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
{
    UIPageViewController *_pageViewController;
    NSMutableArray *_dataArray;
//    NSInteger _currentPage;
//    UIPageControl *_pageControl;
    
    NSInteger _selectHole;
    
    JGHScoresHoleView *_scoresView;
    
    UIView *_tranView;
    
    UIBarButtonItem *_item;
    UIButton *_arrowBtn;
    
    NSMutableDictionary *_macthDict;//结束页面的参数
    
    NSInteger _selectPage;
    
    NSInteger _selectcompleteHole;
    
    NSInteger _isEdtor;// 0-未修改， 1- 修改
    
    NSInteger _isFinishScore;//是否完成记分0 1
    
    NSNumber *_walletMonay;//红包金额
    
    NSInteger _cabbieFinishScore;//是否结束所有记分 1- 结束，0－不结束
}

@property (nonatomic, strong)NSMutableArray *userScoreArray;

@property (nonatomic, strong)UIButton *titleBtn;

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
    
    if (_backId != 1) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = BackBtnFrame;
        btn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
        [btn setImage:[UIImage imageNamed:@")-2"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(saveScoresAndBackClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    _cabbieFinishScore = 0;//不结束
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noticePushScoresCtrl:) name:@"noticePushScores" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noticeAllScoresCtrl) name:@"noticeAllScores" object:nil];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(110*ProportionAdapter, 0, 80*ProportionAdapter, 44)];
    self.titleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80*ProportionAdapter, 44)];
    [self.titleBtn setTitleColor:[UIColor colorWithHexString:@"#32b14d"] forState:(UIControlStateNormal)];
    [titleView addSubview:self.titleBtn];
    if (_currentPage > 0) {
        [self.titleBtn setTitle:[NSString stringWithFormat:@"%td HOLE", _currentPage+1] forState:UIControlStateNormal];
    }else{
        [self.titleBtn setTitle:@"1 HOLE" forState:UIControlStateNormal];
    }
    [self.titleBtn addTarget:self action:@selector(titleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _arrowBtn = [[UIButton alloc]initWithFrame:CGRectMake(80*ProportionAdapter, 10, 30, 24)];
    [_arrowBtn addTarget:self action:@selector(titleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_arrowBtn setImage:[UIImage imageNamed:@"zk"] forState:UIControlStateNormal];
    [titleView addSubview:_arrowBtn];
    
    UILabel *bgLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 42, 80*ProportionAdapter, 2)];
    bgLabel.backgroundColor = [UIColor colorWithHexString:@"#50BD67"];
    [titleView addSubview:bgLabel];
    
    self.navigationItem.titleView = titleView;
    
    _selectHole = 0;
    if (_currentPage > 0) {
        _selectPage = _currentPage + 1;
    }else{
        _selectPage = 1;
    }
    
    _isEdtor = 0;
    _isFinishScore = 0;
    _selectcompleteHole = 0;
    _item = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveScoresClick)];
    _item.tintColor=[UIColor colorWithHexString:@"#32b14d"];
    self.navigationItem.rightBarButtonItem = _item;
    
    _dataArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<18; i++) {
        [_dataArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    [self getScoreList];
    
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
    
    if (_isEdtor == 1) {
        //保存
        NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
        if (_selectPage > 0) {
            [userdef setObject:@(_selectPage-1) forKey:[NSString stringWithFormat:@"%@", _scorekey]];
        }else{
            [userdef setObject:@(_selectPage) forKey:[NSString stringWithFormat:@"%@", _scorekey]];
        }
        
        [userdef synchronize];
        
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
            [listDict setObject:model.poleNumber forKey:@"poleNumber"];// 球队杆数
            [listDict setObject:model.pushrod forKey:@"pushrod"];// 推杆
            [listDict setObject:model.onthefairway forKey:@"onthefairway"];// 是否上球道
            [listDict setObject:model.timeKey forKey:@"timeKey"];// 是否上球道
            [listArray addObject:listDict];
        }
        
        [dict setObject:listArray forKey:@"list"];
        
        [[JsonHttp jsonHttp]httpRequestWithMD5:@"score/saveScore" JsonKey:nil withData:dict failedBlock:^(id errType) {
            _isEdtor = 1;
        } completionBlock:^(id data) {
            NSLog(@"%@", data);
            
            NSLog(@"5S  时间保存");
            if ([[data objectForKey:@"packSuccess"]integerValue] == 1) {
                
                //                        [self scoresResult];
            }else{
                if ([data objectForKey:@"packResultMsg"]) {
                    _isEdtor = 1;
                }
            }
        }];
    }
}
#pragma mark -- 返回
- (void)saveScoresAndBackClick:(UIButton *)btn{
    [_timer invalidate];
    _timer = nil;
    btn.enabled = NO;
    [[JsonHttp jsonHttp]cancelRequest];//取消所有请求
    //保存
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    if (_selectPage > 0) {
        [userdef setObject:@(_selectPage-1) forKey:[NSString stringWithFormat:@"%@", _scorekey]];
    }else{
        [userdef setObject:@(_selectPage) forKey:[NSString stringWithFormat:@"%@", _scorekey]];
    }
    
    [userdef synchronize];
    //保存
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
        [listDict setObject:model.poleNumber forKey:@"poleNumber"];// 球队杆数
        [listDict setObject:model.pushrod forKey:@"pushrod"];// 推杆
        [listDict setObject:model.onthefairway forKey:@"onthefairway"];// 是否上球道
        [listDict setObject:model.timeKey forKey:@"timeKey"];// 是否上球道
        [listArray addObject:listDict];
    }
    
    [dict setObject:listArray forKey:@"list"];
    
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"score/saveScore" JsonKey:nil withData:dict failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"]integerValue] == 1) {
            
            [self scoresResult];
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
            
            [self performSelector:@selector(scoresResult) withObject:self afterDelay:1.0];
        }
    }];
    
    btn.enabled = YES;
}
#pragma mark -- 点击杆数跳转到指定的积分页面
- (void)noticePushScoresCtrl:(NSNotification *)not{
    //
    _selectHole = 0;
    [_item setTitle:@"保存"];
    [_scoresView removeFromSuperview];
    [_tranView removeFromSuperview];
//    _pageControl.currentPage = [[not.userInfo objectForKey:@"index"] integerValue];
    [self.titleBtn setTitle:[NSString stringWithFormat:@"%td HOLE", [[not.userInfo objectForKey:@"index"] integerValue]+1] forState:UIControlStateNormal];
    
    [[ShowHUD showHUD]showToastWithText:[NSString stringWithFormat:@"第-%td-洞", [[not.userInfo objectForKey:@"index"] integerValue]+1] FromView:self.view];
}
#pragma mark -- 所有记分完成后
- (void)noticeAllScoresCtrl{
    _selectcompleteHole = 1;
//    _isFinishScore = 1;
    [_item setTitle:@"完成"];
}
#pragma mark -- getScoreList 获取活动计分列表
- (void)getScoreList{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:_scorekey forKey:@"scoreKey"];
    [dict setObject:[JGReturnMD5Str getScoreListUserKey:[DEFAULF_USERID integerValue] andScoreKey:[_scorekey integerValue]] forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"score/getScoreList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            if ([data objectForKey:@"list"]) {
                NSArray *dataArray = [NSArray array];
                dataArray = [data objectForKey:@"list"];
                for (NSDictionary *dcitData in dataArray) {
                    JGHScoreListModel *model = [[JGHScoreListModel alloc]init];
                    [model setValuesForKeysWithDictionary:dcitData];
                    [self.userScoreArray addObject:model];
                }
                
                self.timer =[NSTimer scheduledTimerWithTimeInterval:[[data objectForKey:@"interval"] floatValue] target:self
                                                           selector:@selector(changeTimeAtTimeDoClick) userInfo:nil repeats:YES];
                [self.timer fire];
                
                _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:1 navigationOrientation:0 options:nil];
                
                JGHScoresMainViewController *sub = [[JGHScoresMainViewController alloc]init];
                sub.index = _currentPage;
                
                sub.dataArray = self.userScoreArray;
                __weak JGHScoresViewController *weakSelf = self;
                sub.returnScoresDataArray= ^(NSMutableArray *dataArray){
                    weakSelf.userScoreArray = dataArray;
                    _isEdtor = 1;
                };
                [_pageViewController setViewControllers:@[sub] direction:0 animated:NO completion:nil];
                
                [self.view addSubview:_pageViewController.view];
                
                _pageViewController.delegate = self;
                _pageViewController.dataSource = self;
                
                if ([data objectForKey:@"score"]) {
                    NSMutableDictionary *scoreDict = [data objectForKey:@"score"];
                    [_macthDict setObject:[scoreDict objectForKey:@"ballName"] forKey:@"ballName"];
                    [_macthDict setObject:[scoreDict objectForKey:@"ballKey"] forKey:@"placeId"];
                    [_macthDict setObject:[scoreDict objectForKey:@"createtime"] forKey:@"playTimes"];
                }
                
                for (int x=0; x<dataArray.count; x++) {
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
                        
                        if (x == dataArray.count -1 && i == 17) {
                            [self noticeAllScoresCtrl];
                        }
                    }
                }
                
                NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
                if (![userdef objectForKey:[NSString stringWithFormat:@"%@list", _scorekey]]) {
                    [self titleBtnClick];
                }
            }
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
}
#pragma mark -- titleBtn 点击事件
- (void)titleBtnClick{
    NSLog(@"XXX dong");
    if (_selectHole == 0) {
        _selectHole = 1;
        [_item setTitle:@"结束记分"];
        [_arrowBtn setImage:[UIImage imageNamed:@"zk1"] forState:UIControlStateNormal];
        _scoresView = [[JGHScoresHoleView alloc]init];
        _scoresView.frame = CGRectMake(0, 0, screenWidth, (194 + self.userScoreArray.count * 60)*ProportionAdapter);
        _scoresView.dataArray = self.userScoreArray;
        _scoresView.curPage = _selectPage;
        [self.view addSubview:_scoresView];
        [_scoresView reloadScoreList];//更新UI位置
        _tranView = [[UIView alloc]initWithFrame:CGRectMake(0, _scoresView.frame.size.height, screenWidth, (screenHeight -64)-(194 + self.userScoreArray.count * 60)*ProportionAdapter)];
        _tranView.backgroundColor = [UIColor blackColor];
        _tranView.alpha = 0.3;
        
        UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc]init];
        [tag addTarget:self action:@selector(titleBtnClick)];
        [_tranView addGestureRecognizer:tag];
        [self.view addSubview:_tranView];
        [self.view addSubview:_scoresView];
        
    }else{
        [_arrowBtn setImage:[UIImage imageNamed:@"zk"] forState:UIControlStateNormal];
        _selectHole = 0;
        [_item setTitle:@"保存"];
        [_scoresView removeFromSuperview];
        [_tranView removeFromSuperview];
    }
}
//返回前一页的视图控制器
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    JGHScoresMainViewController *s = (JGHScoresMainViewController *)viewController;
    _currentPage = s.index;
    if (_currentPage <= 0) {
        _currentPage = _dataArray.count - 1;
        JGHScoresMainViewController *sub = [[JGHScoresMainViewController alloc]init];
        sub.index = _currentPage;
        sub.dataArray = self.userScoreArray;
        return sub;
    }
    else
    {
        _currentPage--;
        JGHScoresMainViewController *sub = [[JGHScoresMainViewController alloc]init];
        sub.index = _currentPage;
        sub.dataArray = self.userScoreArray;
        return sub;
    }
}

//返回后一页的视图控制器
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    JGHScoresMainViewController *s = (JGHScoresMainViewController *)viewController;
    _currentPage = s.index;
    if (_currentPage >= _dataArray.count - 1) {
        _currentPage = 0;
        JGHScoresMainViewController *sub = [[JGHScoresMainViewController alloc]init];
        sub.index = _currentPage;
        sub.dataArray = self.userScoreArray;
        return sub;
    }
    else
    {
        _currentPage++;
        JGHScoresMainViewController *sub = [[JGHScoresMainViewController alloc]init];
        sub.index = _currentPage;
        sub.dataArray = self.userScoreArray;
        //        sub.text = _dataArray[_currentPage];
        NSLog(@"%@",sub);
        return sub;
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    JGHScoresMainViewController *sub = (JGHScoresMainViewController *)pageViewController.viewControllers[0];
    
    __weak JGHScoresViewController *weakSelf = self;
    sub.returnScoresDataArray= ^(NSMutableArray *dataArray){
        weakSelf.userScoreArray = dataArray;
        _isEdtor = 1;
    };
    [self.titleBtn setTitle:[NSString stringWithFormat:@"%td HOLE", sub.index+1] forState:UIControlStateNormal];
    _selectPage = sub.index+1;
//    _pageControl.currentPage = sub.index;
//    [[ShowHUD showHUD]showToastWithText:[NSString stringWithFormat:@"第-%td-洞", sub.index+1] FromView:self.view];
}

#pragma mark -- 保存／结束记分
- (void)saveScoresClick{
    _item.enabled = NO;
    
    //保存
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    if (_selectPage > 0) {
        [userdef setObject:@(_selectPage-1) forKey:[NSString stringWithFormat:@"%@", _scorekey]];
    }else{
        [userdef setObject:@(_selectPage) forKey:[NSString stringWithFormat:@"%@", _scorekey]];
    }
    
    [userdef synchronize];
    
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
        
        [listDict setObject:model.poleNumber forKey:@"poleNumber"];// 球队杆数
        [listDict setObject:model.pushrod forKey:@"pushrod"];// 推杆
        [listDict setObject:model.onthefairway forKey:@"onthefairway"];// 是否上球道
        [listDict setObject:model.timeKey forKey:@"timeKey"];// 是否上球道
        [listArray addObject:listDict];
    }
    
    [dict setObject:listArray forKey:@"list"];
    
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"score/saveScore" JsonKey:nil withData:dict failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"]integerValue] == 1) {
            NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
            if (![userdef objectForKey:[NSString stringWithFormat:@"%@list", _scorekey]]) {
                [userdef setObject:@1 forKey:[NSString stringWithFormat:@"%@list", _scorekey]];
                [userdef synchronize];
            }
            
            if (_selectcompleteHole == 1 || _selectHole == 1) {
                if (_selectHole == 1 && _isCabbie == 1 && _selectcompleteHole != 1 && _cabbieFinishScore == 0) {
                    //球童结束记分--1、判断18洞是否完成
                    [Helper alertViewWithTitle:@"您尚未完成所有成绩录入，是否确定结束记分？" withBlockCancle:^{
                        _cabbieFinishScore = 0;//不结束
                    } withBlockSure:^{
                        _cabbieFinishScore = 1;//结束
                        [self finishScore];
                    } withBlock:^(UIAlertController *alertView) {
                        [self presentViewController:alertView animated:YES completion:nil];
                    }];
                    return;
                }
                
                [self finishScore];
            }else{
                if (_selectcompleteHole != 1) {
                    [[ShowHUD showHUD]showToastWithText:@"记分保存成功！" FromView:self.view];
                }
                
                [self performSelector:@selector(scoresResult) withObject:self afterDelay:1.0];
            }
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
            
            [self performSelector:@selector(scoresResult) withObject:self afterDelay:1.0];
        }
    }];
    
    _item.enabled = YES;
}
#pragma mark -- 结束记分／完成
- (void)finishScore{
    _item.enabled = NO;
    [_timer invalidate];
    _timer = nil;
    //完成  finishScore
    [[ShowHUD showHUD]showAnimationWithText:@"提交中..." FromView:self.view];
    
    NSMutableDictionary *finishDict = [NSMutableDictionary dictionary];
    [finishDict setObject:DEFAULF_USERID forKey:@"userKey"];
    [finishDict setObject:_scorekey forKey:@"scoreKey"];
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"score/finishScore" JsonKey:nil withData:finishDict failedBlock:^(id errType) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        if ([[data objectForKey:@"packSuccess"]integerValue] == 1) {
            if ([data objectForKey:@"money"]) {
                _walletMonay = [data objectForKey:@"money"];
            }
            
            //获取主线层
            if ([NSThread isMainThread]) {
                NSLog(@"Yay!");
                [[ShowHUD showHUD]showToastWithText:@"记分结束！" FromView:self.view];
                [self performSelector:@selector(pushJGHEndScoresViewController) withObject:self afterDelay:1.0];
            } else {
                NSLog(@"Humph, switching to main");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[ShowHUD showHUD]showToastWithText:@"记分结束！" FromView:self.view];
                    [self performSelector:@selector(pushJGHEndScoresViewController) withObject:self afterDelay:1.0];
                });
            }
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
    _item.enabled = YES;
}
#pragma mark --历史记分
- (void)scoresResult{
    if (_isCabbie == 1) {
        // isCaddie;//是否是球童，1，是球童，
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[JGLCaddieScoreViewController class]]) {
                //                [[NSNotificationCenter defaultCenter] postNotificationName:@"CaddieScoreRefreshing" object:@{@"cabbie": @"1"}];
                NSNotification * notice = [NSNotification notificationWithName:@"reloadCaddieScoreData" object:nil userInfo:nil];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
                
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }else{
        NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
        if (_selectPage > 0) {
            [userdef setObject:@(_selectPage-1) forKey:[NSString stringWithFormat:@"%@", _scorekey]];
        }else{
            [userdef setObject:@(_selectPage) forKey:[NSString stringWithFormat:@"%@", _scorekey]];
        }
        
        [userdef synchronize];
        
        NSLog(@"%@", [userdef objectForKey:[NSString stringWithFormat:@"%@", _scorekey]]);
        JGDHistoryScoreViewController *historyCtrl = [[JGDHistoryScoreViewController alloc]init];
        [self.navigationController pushViewController:historyCtrl animated:YES];
    }
}
#pragma mark -- 完成记分---跳转
- (void)pushJGHEndScoresViewController{
    
    if (_cabbieFinishScore == 1) {
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
                        scoreCount += [model.poleNumber[i] integerValue];
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
