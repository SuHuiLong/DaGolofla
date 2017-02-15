//
//  JGHNewCancelApplyViewController.m
//  DagolfLa
//
//  Created by 黄安 on 17/1/16.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHNewCancelApplyViewController.h"
#import "JGTeamActivityCell.h"
#import "JGTeamAcitivtyModel.h"
#import "JGActivityNameBaseCell.h"
#import "JGHButtonCell.h"
#import "JGTeamAcitivtyModel.h"
#import "JGTeamActivityViewController.h"
#import "JGLCancelDrawbackViewController.h"
#import "JGHNewCancelApplyCell.h"
#import "JGHNewCancelAppListCell.h"

#define ActivityRefundrules @"提示：请勾选退出活动的打球人"

static NSString *const JGTeamActivityCellIdentifier = @"JGTeamActivityCell";
static NSString *const JGActivityNameBaseCellIdentifier = @"JGActivityNameBaseCell";
static NSString *const JGHButtonCellIdentifier = @"JGHButtonCell";
static NSString *const JGHNewCancelApplyCellIdentifier = @"JGHNewCancelApplyCell";
static NSString *const JGHNewCancelAppListCellIdentifier = @"JGHNewCancelAppListCell";

@interface JGHNewCancelApplyViewController ()<UITableViewDelegate, UITableViewDataSource, JGHButtonCellDelegate, JGHNewCancelAppListCellDelegate>

@property (nonatomic, strong)UITableView *cancelApplyTableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation JGHNewCancelApplyViewController

- (instancetype)init{
    if (self == [super init]) {
        self.dataArray = [NSMutableArray array];
        self.model = [[JGTeamAcitivtyModel alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"退出活动";
    
    [self createTableView];
}

#pragma mark -- 创建Tableview
- (void)createTableView{
    self.cancelApplyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10*ProportionAdapter, ScreenWidth, ScreenHeight - 44)];
    self.cancelApplyTableView.dataSource = self;
    self.cancelApplyTableView.delegate = self;
    
    self.cancelApplyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.cancelApplyTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    UINib *activityNib = [UINib nibWithNibName:@"JGTeamActivityCell" bundle: [NSBundle mainBundle]];
    [self.cancelApplyTableView registerNib:activityNib forCellReuseIdentifier:JGTeamActivityCellIdentifier];
    
    UINib *detailsNib = [UINib nibWithNibName:@"JGActivityNameBaseCell" bundle: [NSBundle mainBundle]];
    [self.cancelApplyTableView registerNib:detailsNib forCellReuseIdentifier:JGActivityNameBaseCellIdentifier];
    
    UINib *btnNib = [UINib nibWithNibName:@"JGHButtonCell" bundle: [NSBundle mainBundle]];
    [self.cancelApplyTableView registerNib:btnNib forCellReuseIdentifier:JGHButtonCellIdentifier];
    
    [self.cancelApplyTableView registerClass:[JGHNewCancelApplyCell class] forCellReuseIdentifier:JGHNewCancelApplyCellIdentifier];
    
    [self.cancelApplyTableView registerClass:[JGHNewCancelAppListCell class] forCellReuseIdentifier:JGHNewCancelAppListCellIdentifier];
    
    [self.view addSubview:self.cancelApplyTableView];
    
    //下载数据
    [self loadData];
}
- (void)loadData{
    [[ShowHUD showHUD]showAnimationWithText:loadingString FromView:self.view];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
    [dict setObject:[NSString stringWithFormat:@"%td", _activityKey] forKey:@"activityKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getUserActivitySignUpList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"err = %@", errType);
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        NSLog(@"data = %@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            NSArray *dataArray = [data objectForKey:@"teamSignUpList"];
            for (NSMutableDictionary *dataDict in dataArray) {
                NSMutableDictionary *applyDict = [NSMutableDictionary dictionaryWithDictionary:dataDict];
                [applyDict setObject:@"1" forKey:@"select"];//付款勾选默认勾
                [self.dataArray addObject:applyDict];
            }
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
        
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        [self.cancelApplyTableView reloadData];
    }];
}

#pragma mark -- tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return _dataArray.count;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 35*ProportionAdapter;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10*ProportionAdapter;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 80*ProportionAdapter;
    }
    return 44*ProportionAdapter;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGHNewCancelAppListCell *applyListCel = [tableView dequeueReusableCellWithIdentifier:JGHNewCancelAppListCellIdentifier forIndexPath:indexPath];
    applyListCel.chooseBtn.tag = indexPath.row + 100;
    applyListCel.delegate = self;
    applyListCel.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArray.count > 0) {
        [applyListCel configCancelApplyDict:_dataArray[indexPath.row]];
    }
    
    return applyListCel;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        JGTeamActivityCell *activityCell = [tableView dequeueReusableCellWithIdentifier:JGTeamActivityCellIdentifier];
        [activityCell setJGTeamActivityCellWithModel:_model fromCtrl:1];
        
        activityCell.activityTime.textColor = [UIColor lightGrayColor];
        activityCell.activityAddress.textColor = [UIColor lightGrayColor];
        return (UIView *)activityCell;
    }else if (section == 1){
        JGHNewCancelApplyCell *applyPepoleCell = [tableView dequeueReusableCellWithIdentifier:JGHNewCancelApplyCellIdentifier];
        for (int i=0; i<_dataArray.count; i++) {
            NSMutableDictionary *dict = _dataArray[i];
            if ([[dict objectForKey:@"userKey"] integerValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:userID] integerValue]) {
                [applyPepoleCell configDict:_dataArray[i]];
            }
        }
        return (UIView *)applyPepoleCell;
    }else if (section == 2){
        JGActivityNameBaseCell *promptDetailsCell = [tableView dequeueReusableCellWithIdentifier:JGActivityNameBaseCellIdentifier];
        promptDetailsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [promptDetailsCell configActivityRefundRulesString:ActivityRefundrules];
        return (UIView *)promptDetailsCell;
    }else{
        JGHButtonCell *buttonCell = [tableView dequeueReusableCellWithIdentifier:JGHButtonCellIdentifier];
        buttonCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [buttonCell.clickBtn setTitle:@"确认退出" forState:UIControlStateNormal];
        buttonCell.delegate = self;
        buttonCell.backgroundColor = [UIColor colorWithHexString:BG_color];
        return (UIView *)buttonCell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10*ProportionAdapter)];
    footView.backgroundColor = [UIColor colorWithHexString:BG_color];
    return footView;
}
#pragma mark -- 勾选事件代理
- (void)chooseCancelApplyClick:(UIButton *)btn{
    NSLog(@"%ld", (long)btn.tag);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict = [_dataArray objectAtIndex:btn.tag-100];
    if ([[dict objectForKey:@"select"] integerValue] == 0) {
        [dict setObject:@"1" forKey:@"select"];
        [_dataArray replaceObjectAtIndex:btn.tag-100 withObject:dict];
    }else{
        [dict setObject:@"0" forKey:@"select"];
        [_dataArray replaceObjectAtIndex:btn.tag-100 withObject:dict];
    }
    
    //计算价格
    [self.cancelApplyTableView reloadData];
}
#pragma mark --确认退出
- (void)selectCommitBtnClick:(UIButton *)btn{
    NSInteger applyCount = 0;
    for (NSMutableDictionary *dict in _dataArray) {
        if ([[dict objectForKey:@"select"] integerValue] == 1) {
            applyCount += 1;
        }
    }
    
    if (applyCount == 0) {
        [[ShowHUD showHUD]showToastWithText:@"请选择确认退出人！" FromView:self.view];
    }else{
        [Helper alertViewWithTitle:@"是否确认退出？" withBlockCancle:^{
            NSLog(@"确认退出");
        } withBlockSure:^{
            [self cancelApply:btn];
        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }
}

- (void)cancelApply:(UIButton *)btn{
    btn.enabled = NO;
    //    [[ShowHUD showHUD]showAnimationWithText:@"提交中..." FromView:self.view];
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    NSMutableArray *signupKeyArray = [NSMutableArray array];
    for (NSMutableDictionary *dict in _dataArray) {
        if ([[dict objectForKey:@"select"] integerValue] == 1) {
            if ([[dict objectForKey:@"timeKey"] integerValue] != 0) {
                [signupKeyArray addObject:[dict objectForKey:@"timeKey"]];
            }else{
                [signupKeyArray addObject:[dict objectForKey:@"teamActivityKey"]];
            }
        }
    }
    //signupKeyList
    [postDict setObject:signupKeyArray forKey:@"signupKeyList"];
    //activityKey
    [postDict setObject:[NSString stringWithFormat:@"%td", _activityKey] forKey:@"activityKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/doUnSignUpTeamActivity" JsonKey:nil withData:postDict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
        //        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        NSLog(@"data == %@", data);
        //        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            [LQProgressHud showMessage:@"成功退出！"];

            [self performSelector:@selector(pushCtrl) withObject:self afterDelay:0.3];
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
    
    btn.enabled = YES;
}

- (void)pushCtrl{
    NSNotification * notice = [NSNotification notificationWithName:@"reloadActivityData" object:nil userInfo:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    [self.navigationController popViewControllerAnimated:YES];
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
