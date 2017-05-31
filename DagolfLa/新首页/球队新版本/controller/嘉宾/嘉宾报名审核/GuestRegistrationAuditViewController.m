//
//  GuestRegistrationAuditViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/5/24.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "GuestRegistrationAuditViewController.h"
#import "GuestRegistrationAuditModel.h"
#import "GuestRegistrationAuditTableViewCell.h"

@interface GuestRegistrationAuditViewController ()<UITableViewDelegate,UITableViewDataSource>

//主视图
@property (nonatomic,strong) UITableView *mainTableView;
//数据源
@property (nonatomic,strong) NSMutableArray *dataArray;
//是否允许嘉宾报名 0:不允许 1：允许
@property (nonatomic,assign) NSInteger allowAdd;
@end

@implementation GuestRegistrationAuditViewController
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - CreateView
-(void)createView{
    [self createNavagationView];
    [self createMainTableView];
}
//导航栏
-(void)createNavagationView{
    self.title = @"嘉宾报名审核";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

//创建主视图
-(void)createMainTableView{
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) style:UITableViewStyleGrouped];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [mainTableView registerClass:[GuestRegistrationAuditTableViewCell class] forCellReuseIdentifier:@"GuestRegistrationAuditTableViewCellID"];
    [self.view addSubview:mainTableView];
    mainTableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    
    self.mainTableView = mainTableView;
    
}
#pragma mark - MJRefresh
-(void)headerRefresh{
    [self initMainData];
}

#pragma mark - InitData
-(void)initData{
    [self initMainData];
}
//主视图数据
-(void)initMainData{
    NSString *md5 = [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@&teamKey=%td&activityKey=%tddagolfla.com",DEFAULF_USERID,_teamKey, _activityKey]];
    
    NSDictionary *dict = @{
                           @"activityKey":@(_activityKey),
                           @"userKey":DEFAULF_USERID,
                           @"teamKey":@(_teamKey),
                           @"md5":md5,
                           };
    
    [[JsonHttp jsonHttp]httpRequest:@"team/getGuestSignupTeamActivityAuditeList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        [self.mainTableView.mj_header endRefreshing];
    } completionBlock:^(id data) {
        [self.mainTableView.mj_header endRefreshing];

        bool packSuccess = [[data objectForKey:@"packSuccess"] boolValue];
        if (packSuccess) {
            //是否允许嘉宾报名
            _allowAdd = [[data objectForKey:@"allowGuestsSignup"] integerValue];
            //列表数据
            NSArray *listArray = [data objectForKey:@"waitAuditeList"];
            //审核列表数据
            NSMutableArray *auditArray = [NSMutableArray array];
            for (NSDictionary *indexDict in listArray) {
                GuestRegistrationAuditModel *model = [GuestRegistrationAuditModel modelWithDictionary:indexDict];
                    [auditArray addObject:model];
            }
            //已操作列表
            NSArray *handleArray = [data objectForKey:@"auditeLogList"];
            //已操作列表数据
            NSMutableArray *otherArray = [NSMutableArray array];
            for (NSDictionary *indexDict in handleArray) {
                GuestRegistrationAuditModel *model = [GuestRegistrationAuditModel modelWithDictionary:indexDict];
                    [otherArray addObject:model];
            }
            self.dataArray = [NSMutableArray arrayWithObjects:auditArray,otherArray, nil];
            [self.mainTableView reloadData];
        }
    }];
}
//选择是否允许嘉宾报名活动
-(void)setAllowAddOrNot:(NSInteger)type{
    
    NSDictionary *dict = @{
                           @"userKey":DEFAULF_USERID,
                           @"teamKey":@(_teamKey),
                           @"activityKey":@(_activityKey),
                           @"state":@(type)
                           };
    
    [[ShowHUD showHUD]showAnimationWithText:@"切换中..." FromView:self.view];
    [[JsonHttp jsonHttp] httpRequestWithMD5:@"team/doAllowGuestsSignup" JsonKey:nil withData:dict failedBlock:^(id errType) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        bool packSuccess = [[data objectForKey:@"packSuccess"] boolValue];
        if (packSuccess) {
            if (_allowAdd == 0) {
                _allowAdd = 1;
                [MobClick event:@"teamclan_allowguestapply_click"];

            }else{
                _allowAdd = 0;
            }
            [_mainTableView reloadData];
        }
    
    }];
}
//审核球队活动报名
-(void)GuestPlayerId:(NSString*)playerId :(NSInteger)type{
    NSDictionary *dict = @{
                           @"userKey":DEFAULF_USERID,
                           @"teamKey":@(_teamKey),
                           @"activityKey":@(_activityKey),
                           @"signupKey":playerId,
                           @"state":@(type)
                           };
    
    [[ShowHUD showHUD]showAnimationWithText:@"操作中..." FromView:self.view];
    [[JsonHttp jsonHttp] httpRequestWithMD5:@"team/doAuditeTeamActivitySignupGuest" JsonKey:nil withData:dict failedBlock:^(id errType) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        bool packSuccess = [[data objectForKey:@"packSuccess"] boolValue];
        if (packSuccess) {
            [self initMainData];
        }
    }];
}
#pragma mark - Action
//返回
-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}
//是否允许嘉宾报名按钮点击
-(void)allowSwithClick:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        NSLog(@"开");
    }else {
        NSLog(@"关");
    }
    [self setAllowAddOrNot:isButtonOn];
}
//审核同意点击
-(void)sureClick:(UIButton *)sender{
    NSString *userKey = [self getUserKeyByButton:sender];
    [self GuestPlayerId:userKey :0];
}
//审核拒绝点击
-(void)reguestClick:(UIButton *)sender{
    NSString *userKey = [self getUserKeyByButton:sender];
    [self GuestPlayerId:userKey :3];
}


#pragma mark - UITableviewDelegate&&Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count==0) {
        return 0;
    }
    
    NSMutableArray *sectionArray = self.dataArray[section];
    return sectionArray.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHvertical(50);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kHvertical(10);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        if (self.dataArray.count==0) {
            return 0;
        }
        NSMutableArray *sectionArray = self.dataArray[1];
        if (sectionArray.count>0) {
            return kHvertical(55);
        }
        return 0;
    }
    return kHvertical(200);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GuestRegistrationAuditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GuestRegistrationAuditTableViewCellID"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    GuestRegistrationAuditModel *model = self.dataArray[indexPath.section][indexPath.row];
    [cell configModel:model];
    [cell.sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.reguestBtn addTarget:self action:@selector(reguestClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [Factory createViewWithBackgroundColor:ClearColor frame:CGRectMake(0, 0, screenWidth, 0)];
    if (self.dataArray.count==0) {
        return footerView;
    }
    if (section==0) {
        NSMutableArray *sectionArray = self.dataArray[1];
        if (sectionArray.count>0) {
            footerView.height = kHvertical(55);
            //细线
            UIView *line = [Factory createViewWithBackgroundColor:RGB(213,213,213) frame:CGRectMake(0, kHvertical(38), screenWidth, 1)];
            [footerView addSubview:line];
            //审批记录
            UILabel *history = [Factory createLabelWithFrame:CGRectMake(screenWidth/2 - kWvertical(40), kHvertical(20), kWvertical(80), kHvertical(33)) textColor:RGB(160,160,160) fontSize:kHorizontal(14) Title:@"审批记录"];
            history.backgroundColor = RGB(238,238,238);
            [history setTextAlignment:NSTextAlignmentCenter];
            [footerView addSubview:history];
        }
    }else{
        footerView.height = kHvertical(200);
        //是否接受嘉宾报名
        UIView *whitebackView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, kHvertical(10), screenWidth, kHvertical(51))];
        [footerView addSubview:whitebackView];
        UILabel *title = [Factory createLabelWithFrame:CGRectMake(kWvertical(10), 0, screenWidth/2, kHvertical(51)) textColor:RGB(49,49,49) fontSize:kHorizontal(17) Title:@"接受嘉宾报名"];
        [whitebackView addSubview:title];
        UISwitch *allowSwith = [[UISwitch alloc] initWithFrame:CGRectMake(screenWidth - kWvertical(62), kHvertical(10), kWvertical(52), kHvertical(31))];
        allowSwith.onTintColor = RGB(76,217,100);
        allowSwith.on = YES;
        if (_allowAdd==0) {
            allowSwith.on = NO;
        }
        [allowSwith addTarget:self action:@selector(allowSwithClick:) forControlEvents:UIControlEventValueChanged];
        [whitebackView addSubview:allowSwith];
        //文字描述
        NSString *textStr = @"设置接受嘉宾报名后，队外成员能看到并申请参加球队活动，球队管理员可选择同意或拒绝。管理员可关闭此设置，届时队外成员将无法参加该活动，已被同意参与者不受影响。";
        UILabel *desc = [Factory createLabelWithFrame:CGRectMake(kWvertical(10), kHvertical(81), screenWidth - kWvertical(20), kHvertical(110)) textColor:RGB(160,160,160) fontSize:kHorizontal(14) Title:textStr];
        desc.numberOfLines = 0;
        [footerView addSubview:desc];
    }
    return footerView;
}

#pragma mark - Other
//通过cell上按钮获取当前cell上userKey
-(NSString *)getUserKeyByButton:(UIButton *)sender{
    GuestRegistrationAuditTableViewCell *cell = (GuestRegistrationAuditTableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.mainTableView indexPathForCell:cell];
    GuestRegistrationAuditModel *model = self.dataArray[0][indexPath.row];
    return model.timeKey;
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
