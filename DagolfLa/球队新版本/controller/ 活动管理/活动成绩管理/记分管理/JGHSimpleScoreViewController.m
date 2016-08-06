//
//  JGHSimpleScoreViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/29.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHSimpleScoreViewController.h"
#import "JGHSimpleScorePepoleBaseCell.h"
#import "JGHSimpleAndResultsCell.h"
#import "JGHOperationSimlpeCell.h"
#import "JGHSetBallBaseCell.h"
#import "JGHOperationScoreCell.h"
#import "JGHScoreCalculateCell.h"
#import "JGHOperationScoreListCell.h"
#import "JGTeamAcitivtyModel.h"
#import "JGLAddActiivePlayModel.h"
#import "JGHActivityScoreManagerViewController.h"

static NSString *const JGHSimpleScorePepoleBaseCellIdentifier = @"JGHSimpleScorePepoleBaseCell";
static NSString *const JGHSimpleAndResultsCellIdentifier = @"JGHSimpleAndResultsCell";
static NSString *const JGHOperationSimlpeCellIdentifier = @"JGHOperationSimlpeCell";
static NSString *const JGHSetBallBaseCellIdentifier = @"JGHSetBallBaseCell";
static NSString *const JGHOperationScoreCellIdentifier = @"JGHOperationScoreCell";
static NSString *const JGHOperationScoreListCellIdentifier = @"JGHOperationScoreListCell";

@interface JGHSimpleScoreViewController ()<UITableViewDelegate, UITableViewDataSource, JGHSimpleAndResultsCellDelegate, JGHSetBallBaseCellDelegate, JGHOperationSimlpeCellDelegate, JGHScoreCalculateCellDelegate>
{
    NSInteger _selectId;//0-简单记分；1-十八洞开始记分；2-记分；3-记分列表页
    
    NSInteger _poles;//总杆数默认0；
    
    NSMutableDictionary *_userScoreBeanDict;//用户成绩参数
    
    UIView *_ballView;
    
    UIView *_ballTwoView;
    
//    NSMutableArray *_polesArray;//十八洞杆数
    
    NSMutableArray *_holeArray;
    
    NSString *_region1;
    NSString *_region2;
    
    NSMutableArray *_standardParArray;
    
    NSString *_ballName;//球场名
    NSString *_loginpic;//球场图片地址
}

@property (nonatomic, strong)NSMutableArray *polesArray;//十八洞杆数
@property (nonatomic, strong)UITableView *simpleScoreTableView;
@property (nonatomic, assign)NSInteger holeListId;//list选择的洞

@end

@implementation JGHSimpleScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"添加记分";
    _selectId = 0;
    _poles = 72;
    _holeListId = 0;
    _ballName = @"";
    _loginpic = @"";
    _userScoreBeanDict = [NSMutableDictionary dictionary];
    self.polesArray = [NSMutableArray array];
    _holeArray = [NSMutableArray array];
    _standardParArray = [NSMutableArray array];
    for (int i=0; i<18; i++) {
        [self.polesArray addObject:@(-1)];
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick:)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
    
    [self createTable];
    
    [self loadBallData];
}
#pragma mark -- 获取标准杆
- (void)getStandardlevers{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(_actModel.ballKey) forKey:@"ballKey"];
    [dict setObject:_region1 forKey:@"region1"];
    [dict setObject:_region2 forKey:@"region2"];
    [dict setObject:[JGReturnMD5Str getStandardleversBallKey:_actModel.ballKey andRegion1:_region1 andRegion2:_region2] forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"ball/getStandardlevers" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"]integerValue] == 1) {
            _standardParArray = [data objectForKey:@"parList"];
            _selectId = 2;
            [self.simpleScoreTableView reloadData];
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
}
#pragma mark -- 球场信息
- (void)loadBallData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(_actModel.ballKey) forKey:@"ballKey"];
    [[JsonHttp jsonHttp]httpRequest:@"ball/getBallCode" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            _holeArray = [data objectForKey:@"ballAreas"];
            _region1 = [_holeArray objectAtIndex:0];
            _region2 = [_holeArray objectAtIndex:0];
            _ballName = [data objectForKey:@"ballName"];
            _loginpic = [data objectForKey:@"loginpic"];
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
}

- (void)createTable{
    self.simpleScoreTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight -64) style:UITableViewStylePlain];
    
    UINib *simpleScorePepoleNib = [UINib nibWithNibName:@"JGHSimpleScorePepoleBaseCell" bundle: [NSBundle mainBundle]];
    [self.simpleScoreTableView registerNib:simpleScorePepoleNib forCellReuseIdentifier:JGHSimpleScorePepoleBaseCellIdentifier];
    
    UINib *simpleAndResultsNib = [UINib nibWithNibName:@"JGHSimpleAndResultsCell" bundle: [NSBundle mainBundle]];
    [self.simpleScoreTableView registerNib:simpleAndResultsNib forCellReuseIdentifier:JGHSimpleAndResultsCellIdentifier];
    
    UINib *operationSimlpeNib = [UINib nibWithNibName:@"JGHOperationSimlpeCell" bundle: [NSBundle mainBundle]];
    [self.simpleScoreTableView registerNib:operationSimlpeNib forCellReuseIdentifier:JGHOperationSimlpeCellIdentifier];
    
    UINib *setBallBaseCellNib = [UINib nibWithNibName:@"JGHSetBallBaseCell" bundle: [NSBundle mainBundle]];
    [self.simpleScoreTableView registerNib:setBallBaseCellNib forCellReuseIdentifier:JGHSetBallBaseCellIdentifier];
    
    UINib *operationScoreCellNib = [UINib nibWithNibName:@"JGHOperationScoreCell" bundle: [NSBundle mainBundle]];
    [self.simpleScoreTableView registerNib:operationScoreCellNib forCellReuseIdentifier:JGHOperationScoreCellIdentifier];
    
    [self.simpleScoreTableView registerClass:[JGHScoreCalculateCell class] forCellReuseIdentifier:@"JGHScoreCalculateCell"];
    
    UINib *operationScoreListCellNib = [UINib nibWithNibName:@"JGHOperationScoreListCell" bundle: [NSBundle mainBundle]];
    [self.simpleScoreTableView registerNib:operationScoreListCellNib forCellReuseIdentifier:JGHOperationScoreListCellIdentifier];
    
    self.simpleScoreTableView.delegate = self;
    self.simpleScoreTableView.dataSource = self;
    
    self.simpleScoreTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.simpleScoreTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self.view addSubview:self.simpleScoreTableView];
}

#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 60 *ProportionAdapter;
    }else if (indexPath.section == 1) {
        return 50 *ProportionAdapter;
    }else{
        if (_selectId == 0) {
            return 310 *ProportionAdapter;
        }else if (_selectId == 1){
            return 280 *ProportionAdapter;
        }else{
            return screenWidth;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGHSimpleScorePepoleBaseCell *tranCell = [tableView dequeueReusableCellWithIdentifier:JGHSimpleScorePepoleBaseCellIdentifier];
        [tranCell configScoreJGLAddActiivePlayModel:_playModel];
        tranCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return tranCell;
    }else if (indexPath.section == 1) {
        JGHSimpleAndResultsCell *centerBtnCell = [tableView dequeueReusableCellWithIdentifier:JGHSimpleAndResultsCellIdentifier];
        centerBtnCell.delegate = self;
        [centerBtnCell configUIBtn:_selectId];
        centerBtnCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return centerBtnCell;
    }else {
        if (_selectId == 0) {
            JGHOperationSimlpeCell *operationSimlpeCell = [tableView dequeueReusableCellWithIdentifier:JGHOperationSimlpeCellIdentifier];
            operationSimlpeCell.delegate = self;
            [operationSimlpeCell configPoles:_poles];
            operationSimlpeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return operationSimlpeCell;
        }else if (_selectId == 1){
            JGHSetBallBaseCell *setBallBaseCell = [tableView dequeueReusableCellWithIdentifier:JGHSetBallBaseCellIdentifier];
            setBallBaseCell.delegate = self;
            [setBallBaseCell configRegist1:_region1 andRegist2:_region2];
            [setBallBaseCell configViewBallName:_ballName andLoginpic:_loginpic];
            setBallBaseCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return setBallBaseCell;
        }else if (_selectId == 2){
            JGHScoreCalculateCell *scoreCalculateCell = [tableView dequeueReusableCellWithIdentifier:@"JGHScoreCalculateCell"];
            scoreCalculateCell.delegate = self;
            scoreCalculateCell.poleNumberArray = self.polesArray;
            scoreCalculateCell.parArray = _standardParArray;
            scoreCalculateCell.holeId = _holeListId;
            scoreCalculateCell.ballName = _ballName;
            scoreCalculateCell.loginpic = _loginpic;
//            [scoreCalculateCell setNeedsLayout];
            __weak JGHSimpleScoreViewController *weakSelf = self;
            scoreCalculateCell.returnScoresCalculateDataArray= ^(NSMutableArray *dataArray){
                weakSelf.polesArray = dataArray;
            };
            scoreCalculateCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return scoreCalculateCell;
        }else{
            JGHOperationScoreListCell *operationScoreListCell = [tableView dequeueReusableCellWithIdentifier:JGHOperationScoreListCellIdentifier];
            __weak JGHSimpleScoreViewController *holeSelf = self;
            operationScoreListCell.returnHoleId= ^(NSInteger holeId){
                holeSelf.holeListId = holeId;
                _selectId = 2;
                [self.simpleScoreTableView reloadData];
            };
            
            operationScoreListCell.poleArray = self.polesArray;
            operationScoreListCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [operationScoreListCell reloadOperScoreBtnListCellData];
            return operationScoreListCell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*ProportionAdapter;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10*ProportionAdapter)];
    view.backgroundColor = [UIColor colorWithHexString:BG_color];
    return view;
}
#pragma mark -- 简单记分 ＋
- (void)addRodBtn{
    NSLog(@"简单记分 ＋");
    _poles += 1;
    
    [self.simpleScoreTableView reloadData];
}
#pragma mark -- 简单记分 －
- (void)redRodBtn{
    NSLog(@"简单记分 －");
    if (_poles > 0) {
        _poles -= 1;
    }else{
        _poles = 0;
    }
    
    [self.simpleScoreTableView reloadData];
}
#pragma mark -- 第一九洞
- (void)oneAndNineBtn{
    NSLog(@"第一九洞");
    JGHSetBallBaseCell *setBallBaseCell = [self.simpleScoreTableView dequeueReusableCellWithIdentifier:JGHSetBallBaseCellIdentifier];
    _ballView = [[UIView alloc]initWithFrame:CGRectMake( setBallBaseCell.oneBtn.frame.origin.x, setBallBaseCell.oneBtn.frame.origin.y + 140 *ProportionAdapter + setBallBaseCell.oneBtn.frame.size.height, setBallBaseCell.oneBtn.frame.size.width, 30 * 4 *ProportionAdapter)];
    for (int i=0; i< _holeArray.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, i * 30, _ballView.frame.size.width, 30*ProportionAdapter)];
        [btn setTitle:_holeArray[i] forState:UIControlStateNormal];
        btn.tag = 200 + i;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(oneAndNineBtnSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor whiteColor];
        [_ballView addSubview:btn];
    }
    [self.view addSubview:_ballView];
}
#pragma mark -- 第一九洞选择事件
- (void)oneAndNineBtnSelectClick:(UIButton *)btn{
    NSLog(@"A区");
    _region1 = [_holeArray objectAtIndex:btn.tag - 200];
    [self.simpleScoreTableView reloadData];
    [_ballView removeFromSuperview];
}
#pragma mark -- 第二九洞
- (void)twoAndNineBtn{
    NSLog(@"第二九洞");
    JGHSetBallBaseCell *setBallBaseCell = [self.simpleScoreTableView dequeueReusableCellWithIdentifier:JGHSetBallBaseCellIdentifier];
    _ballTwoView = [[UIView alloc]initWithFrame:CGRectMake( setBallBaseCell.twoBtn.frame.origin.x, setBallBaseCell.twoBtn.frame.origin.y + 140 *ProportionAdapter + setBallBaseCell.twoBtn.frame.size.height, setBallBaseCell.twoBtn.frame.size.width, 30 * 4 *ProportionAdapter)];
    for (int i=0; i< _holeArray.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, i * 30, _ballTwoView.frame.size.width, 30*ProportionAdapter)];
        [btn setTitle:_holeArray[i] forState:UIControlStateNormal];
        btn.tag = 300 + i;
        [btn addTarget:self action:@selector(twoAndNineBtnSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_ballTwoView addSubview:btn];
    }
    [self.view addSubview:_ballTwoView];
}
#pragma mark -- 第二九洞选择事件
- (void)twoAndNineBtnSelectClick:(UIButton *)btn{
    NSLog(@"A区");
    _region2 = [_holeArray objectAtIndex:btn.tag - 300];
    [self.simpleScoreTableView reloadData];
    [_ballTwoView removeFromSuperview];
}
#pragma mark -- 开始录入
- (void)startScoreBtn{
    NSLog(@"开始录入");
    [self getStandardlevers];
}
#pragma mark -- 简单记分
- (void)selectSimpleScoreBtnClick:(UIButton *)btn{
    NSLog(@"简单记分");
    _selectId = 0;
    [self.simpleScoreTableView reloadData];
}
#pragma mark -- 十八洞记分
- (void)selectHoleScoreBtnClick:(UIButton *)btn{
    NSLog(@"十八洞记分");
    _selectId = 1;
    [self.simpleScoreTableView reloadData];
}
#pragma mark -- 十八洞记分 list
- (void)selectScoreListBtn{
    NSLog(@"十八洞记分 list");
    _selectId = 3;
    [self.simpleScoreTableView reloadData];
}
#pragma mark -- 完成
- (void)saveBtnClick:(UIBarButtonItem *)item{
    NSLog(@"完成");
    [[ShowHUD showHUD]showAnimationWithText:@"提交中" FromView:self.view];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    if (_actModel.teamActivityKey != 0) {
        [dict setObject:@(_actModel.teamActivityKey) forKey:@"activityKey"];
    }else{
        [dict setObject:@([_actModel.timeKey integerValue]) forKey:@"activityKey"];
    }
    
    NSMutableDictionary *userScoreDict = [NSMutableDictionary dictionary];
    
    if (_selectId != 0) {
        [dict setObject:_region1 forKey:@"region1"];
        [dict setObject:_region2 forKey:@"region2"];
        if ([_playModel.userKey integerValue] != 0) {
            [userScoreDict setObject:_playModel.userKey forKey:@"userKey"];
        }else{
            [userScoreDict setObject:@0 forKey:@"userKey"];
        }
        
        if (_playModel.userName) {
            [userScoreDict setObject:_playModel.userName forKey:@"userName"];
        }
        
        if (_playModel.mobile) {
            [userScoreDict setObject:_playModel.mobile forKey:@"userMobile"];
        }
        
        if (_playModel.almost) {
            [userScoreDict setObject:@"" forKey:@"almost"];
        }
        
        [userScoreDict setObject:_polesArray forKey:@"poleNumber"];
        [dict setObject:userScoreDict forKey:@"userScoreBean"];
    }else{
        if ([_playModel.userKey integerValue] != 0) {
            [userScoreDict setObject:_playModel.userKey forKey:@"userKey"];
        }else{
            [userScoreDict setObject:@0 forKey:@"userKey"];
        }
        
        if (_playModel.userName) {
            [userScoreDict setObject:_playModel.userName forKey:@"userName"];
        }
        
        if (_playModel.mobile) {
            [userScoreDict setObject:_playModel.mobile forKey:@"userMobile"];
        }
        
        if (_playModel.almost) {
            [userScoreDict setObject:@"" forKey:@"almost"];
        }
        
        [userScoreDict setObject:@(_poles) forKey:@"poles"];
        [dict setObject:userScoreDict forKey:@"userScoreBean"];
    }
    
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"score/makeupTeamScore" JsonKey:nil withData:dict failedBlock:^(id errType) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            if ([NSThread isMainThread]) {
                NSLog(@"Yay!");
                [self performSelector:@selector(pushCtrl) withObject:self afterDelay:1.0];
            } else {
                NSLog(@"Humph, switching to main");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performSelector:@selector(pushCtrl) withObject:self afterDelay:1.0];
                });
            }
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
}
- (void)pushCtrl{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[JGHActivityScoreManagerViewController class]]) {
            
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"redloadActivityScoreManagerData" object:nil userInfo:nil];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            [self.navigationController popToViewController:controller animated:YES];
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
