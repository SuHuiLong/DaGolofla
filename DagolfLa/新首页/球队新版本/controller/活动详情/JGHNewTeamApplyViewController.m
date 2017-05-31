//
//  JGHNewTeamApplyViewController.m
//  DagolfLa
//
//  Created by 黄安 on 17/1/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHNewTeamApplyViewController.h"
#import "JGTeamGroupViewController.h"
#import "JGTeamAcitivtyModel.h"
#import "JGHAddTeamPlaysViewController.h"
#import "JGHNewApplyActivityDetailCell.h"
#import "JGHNewApplyPepoleCell.h"
#import "JGHNewApplyerListCell.h"
#import "JGHNewAddTeamPlaysViewController.h"

static NSString *const JGHNewApplyActivityDetailCellIdentifier = @"JGHNewApplyActivityDetailCell";
static NSString *const JGHNewApplyPepoleCellIdentifier = @"JGHNewApplyPepoleCell";
static NSString *const JGHNewApplyerListCellIdentifier = @"JGHNewApplyerListCell";

@interface JGHNewTeamApplyViewController ()<UITableViewDelegate, UITableViewDataSource, JGHNewApplyerListCellDelegate>
{
    NSMutableArray *_relApplistArray;
    
    UIButton *_submitBtn;
}
@property (retain, nonatomic) UITableView *teamApplyTableView;

@property (nonatomic, strong)NSMutableArray *applyArray;//成员数组----添加成员字典

@property (nonatomic, strong)NSMutableDictionary *info;


@end

@implementation JGHNewTeamApplyViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _isPushToDetail = false;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"报名详情";
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.applyArray = [NSMutableArray array];
    self.info = [NSMutableDictionary dictionary];
    
    _relApplistArray = [NSMutableArray array];
    
    [self createSubmitApplyBtn];
    //默认添加自己的信息
    if (!_isApply) {
        NSMutableDictionary *applyDict = [NSMutableDictionary dictionary];
        [applyDict setObject:[NSString stringWithFormat:@"%td", _modelss.teamKey] forKey:@"teamKey"];//球队key
        [applyDict setObject:_modelss.timeKey forKey:@"activityKey"];//球队活动id
        
        //NSDictionary *costDict = [NSDictionary dictionary];
        //costDict = _costListArray[0];
        [applyDict setObject:@-1 forKey:@"type"];//资费类型
        //[applyDict setObject:[NSString stringWithFormat:@"%@", [costDict objectForKey:@"money"]] forKey:@"money"];//实际付款金额
        
        [applyDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];//报名用户key , 没有则是嘉宾
        
        [applyDict setObject:[NSString stringWithFormat:@"%.2f", [_modelss.subsidyPrice floatValue]] forKey:@"subsidyPrice"];
        //先判断是否存在球队真是姓名，否则给用户名
        if (self.userName == nil) {
            [applyDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"] forKey:@"name"];//姓名
        }else{
            [applyDict setObject:self.userName forKey:@"name"];//姓名
        }
        
        if ([self.teamMember objectForKey:@"mobile"]) {
            [applyDict setObject:[self.teamMember objectForKey:@"mobile"] forKey:@"mobile"];//手机号
        }
        
        [applyDict setObject:@"1" forKey:@"isOnlinePay"];//是否线上付款 1-线上
        [applyDict setObject:@0 forKey:@"signUpInfoKey"];//报名信息的timeKey
        [applyDict setObject:@0 forKey:@"timeKey"];//timeKey
        [applyDict setObject:@"1" forKey:@"select"];//付款勾选默认勾
        
        if ([self.teamMember objectForKey:@"almost"]) {
            [applyDict setObject:[self.teamMember objectForKey:@"almost"] forKey:@"almost"];
        }
        
        //性别
        if ([self.teamMember objectForKey:@"sex"]) {
            [applyDict setObject:[self.teamMember objectForKey:@"sex"] forKey:@"sex"];
        }
        
        [self.applyArray addObject:applyDict];
        
        _submitBtn.backgroundColor = [UIColor colorWithHexString:Nav_Color];
        _submitBtn.enabled = YES;
    }else{
        _submitBtn.enabled = NO;
        _submitBtn.backgroundColor = [UIColor lightGrayColor];
    }
    
    self.teamApplyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, screenWidth, screenHeight - 44 -64 - 30)];
    
    [self.teamApplyTableView registerClass:[JGHNewApplyActivityDetailCell class] forCellReuseIdentifier:JGHNewApplyActivityDetailCellIdentifier];
    
    [self.teamApplyTableView registerClass:[JGHNewApplyPepoleCell class] forCellReuseIdentifier:JGHNewApplyPepoleCellIdentifier];
    
    [self.teamApplyTableView registerClass:[JGHNewApplyerListCell class] forCellReuseIdentifier:JGHNewApplyerListCellIdentifier];
    
    self.teamApplyTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.teamApplyTableView.dataSource = self;
    self.teamApplyTableView.delegate = self;
    self.teamApplyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.teamApplyTableView];
}
#pragma mark -- tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        //人员个数
        return self.applyArray.count;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10 *ProportionAdapter;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35 *ProportionAdapter;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 132 *ProportionAdapter;
    }
    return 44 *ProportionAdapter;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGHNewApplyerListCell *applyListCel = [tableView dequeueReusableCellWithIdentifier:JGHNewApplyerListCellIdentifier forIndexPath:indexPath];
    applyListCel.deleteApplyBtn.tag = indexPath.row + 100;
    applyListCel.delegate = self;
    applyListCel.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_applyArray.count > 0) {
        [applyListCel configDict:_applyArray[indexPath.row]];
    }
    
    return applyListCel;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        JGHNewApplyActivityDetailCell *infoCell = [tableView dequeueReusableCellWithIdentifier:JGHNewApplyActivityDetailCellIdentifier];
        infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [infoCell configJGTeamAcitivtyModel:_modelss];
        return (UIView *)infoCell;
    }else {
        JGHNewApplyPepoleCell *applyPepoleCell = [tableView dequeueReusableCellWithIdentifier:JGHNewApplyPepoleCellIdentifier];
        [applyPepoleCell.addApplyBtn addTarget:self action:@selector(addApplyerBtn) forControlEvents:UIControlEventTouchUpInside];
        return (UIView *)applyPepoleCell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10*ProportionAdapter)];
    footView.backgroundColor = [UIColor colorWithHexString:BG_color];
    return footView;
}
#pragma mark -- 添加报名人
- (void)addApplyerBtn{
    JGHNewAddTeamPlaysViewController *addTeamPlaysCtrl = [[JGHNewAddTeamPlaysViewController alloc]init];
    addTeamPlaysCtrl.isPushToDetail = _isPushToDetail;
    addTeamPlaysCtrl.playListArray = [NSMutableArray arrayWithArray:_applyArray];
    if (_modelss.teamActivityKey != 0) {
        addTeamPlaysCtrl.activityKey = _modelss.teamActivityKey;
    }else{
        addTeamPlaysCtrl.activityKey = [_modelss.timeKey integerValue];
    }
    
    addTeamPlaysCtrl.teamKey = _modelss.teamKey;
    __weak typeof(self) weakself = self;
    addTeamPlaysCtrl.blockPlayListArray = ^(NSMutableArray *listArray){
        _applyArray = listArray;
        if (_applyArray.count > 0) {
            _submitBtn.backgroundColor = [UIColor colorWithHexString:Nav_Color];
            _submitBtn.enabled = YES;
        }else{
            _submitBtn.backgroundColor = [UIColor lightGrayColor];
            _submitBtn.enabled = NO;
        }
        [weakself.teamApplyTableView reloadData];
    };
    
    [self.navigationController pushViewController:addTeamPlaysCtrl animated:YES];
}
#pragma mark -- 立即报名 －－ 仅报名
- (void)didJustApplyListApplyBtn:(UIButton *)btn{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.applyArray];
    [_applyArray removeAllObjects];
    NSInteger count = [array count];
    for (int i=0; i<count; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict = array[i];
        if ([[dict objectForKey:@"isOnlinePay"] integerValue] == 1) {
            [dict setObject:@0 forKey:@"isOnlinePay"];//是否线上付款 1-线上
        }
        
        [self.applyArray addObject:dict];
    }
    
    [self submitInfo:4];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 删除打球人
- (void)selectApplyDeleteBtn:(UIButton *)btn{
    NSLog(@"%td", btn.tag - 100);
    if (_applyArray.count > 0) {
        [self.applyArray removeObjectAtIndex:btn.tag - 100];
    }
    
    if (_applyArray.count > 0) {
        _submitBtn.backgroundColor = [UIColor colorWithHexString:Nav_Color];
        _submitBtn.enabled = YES;
    }else{
        _submitBtn.backgroundColor = [UIColor lightGrayColor];
        _submitBtn.enabled = NO;
    }
    
    [self.teamApplyTableView reloadData];
}
#pragma mark -- 提交报名信息
- (void)submitInfo:(NSInteger)type{
    if (![self.applyArray count]) {
        [[ShowHUD showHUD]showToastWithText:@"请添加打球人，再报名！" FromView:self.view];
        return;
    }
    
    [[ShowHUD showHUD]showAnimationWithText:@"报名中..." FromView:self.view];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    [dict setObject:[userdef objectForKey:userID] forKey:@"appUserKey"];
    [self.info setObject:[NSString stringWithFormat:@"%td", _modelss.teamKey] forKey:@"teamKey"];//球队key
    if (_modelss.teamActivityKey == 0) {
        [self.info setObject:[NSString stringWithFormat:@"%td", [_modelss.timeKey integerValue]] forKey:@"activityKey"];//球队活动key
    }else{
        [self.info setObject:[NSString stringWithFormat:@"%td", _modelss.teamActivityKey] forKey:@"activityKey"];//球队活动key
    }
    
    [self.info setObject:[userdef objectForKey:@"userName"] forKey:@"userName"];//报名人名称//teamkey 156
    
    [self.info setObject:[userdef objectForKey:userID] forKey:@"userKey"];//用户Key
    [self.info setObject:@0 forKey:@"timeKey"];//timeKey
    
    
    for (NSMutableDictionary *dic in _applyArray) {
        [dic setObject:@-1 forKey:@"type"];
    }
    
    [dict setObject:_applyArray forKey:@"teamSignUpList"];//报名人员数组
    
    
    [dict setObject:_info forKey:@"info"];
    [dict setObject:@0 forKey:@"srcType"];//报名类型－－0非嘉宾通道
    //deviceID
    NSString * uuid= [FCUUID getUUID];
    [dict setObject:uuid forKey:@"deviceID"];
    
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"team/doTeamActivitySignUp" JsonKey:nil withData:dict failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        NSLog(@"data == %@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            //跳转分组页面
            [LQProgressHud showMessage:@"您已成功报名！"];
            [self performSelector:@selector(pushCtrl) withObject:self afterDelay:0.3f];
            
        }else{
            if ([data count] == 2) {
                [Helper alertViewWithTitle:@"报名失败！" withBlock:^(UIAlertController *alertView) {
                    [self presentViewController:alertView animated:YES completion:nil];
                }];
            }else{
                if ([data objectForKey:@"packResultMsg"]) {
                    [Helper alertViewWithTitle:[data objectForKey:@"packResultMsg"] withBlock:^(UIAlertController *alertView) {
                        [self presentViewController:alertView animated:YES completion:nil];
                    }];
                }
            }
        }
    }];
}

- (void)pushCtrl{

    NSNotification * notice = [NSNotification notificationWithName:@"reloadActivityData" object:nil userInfo:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark -- 确定报名
- (void)createSubmitApplyBtn{
    _submitBtn = [[UIButton alloc]initWithFrame:CGRectMake( 10 * ProportionAdapter, screenHeight-44 -64 - 20, screenWidth - 20 * ProportionAdapter, 44)];
    _submitBtn.layer.cornerRadius = 6 * ProportionAdapter;
    _submitBtn.clipsToBounds = YES;
    [_submitBtn setTitle:@"确认报名" forState:UIControlStateNormal];
    _submitBtn.titleLabel.font = [UIFont systemFontOfSize:17 *ProportionAdapter];
    [_submitBtn addTarget:self action:@selector(didJustApplyListApplyBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_submitBtn];
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
