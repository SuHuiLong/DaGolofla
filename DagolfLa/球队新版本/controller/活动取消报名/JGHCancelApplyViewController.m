//
//  JGHCancelApplyViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHCancelApplyViewController.h"
#import "JGTeamActivityCell.h"
#import "JGTeamAcitivtyModel.h"
#import "JGHCancelApplyBaseCell.h"
#import "JGApplyPepoleCell.h"
#import "JGHHeaderLabelCell.h"
#import "JGHApplyListCell.h"
#import "JGActivityNameBaseCell.h"
#import "JGHButtonCell.h"
#import "JGTeamAcitivtyModel.h"
#import "JGTeamActivityViewController.h"
#import "JGLCancelDrawbackViewController.h"

#define ActivityRefundrules @"提示：活动取消后缴纳的费用将退还到个人账户中，实际退款金额为用户实际缴纳金额，平台补贴金额不在退款范围。如有疑问请与活动组织者联系。"

static NSString *const JGTeamActivityCellIdentifier = @"JGTeamActivityCell";
static NSString *const JGHCancelApplyBaseCellIdentifier = @"JGHCancelApplyBaseCell";
static NSString *const JGApplyPepoleCellIdentifier = @"JGApplyPepoleCell";
static NSString *const JGHHeaderLabelCellIdentifier = @"JGHHeaderLabelCell";
static NSString *const JGHApplyListCellIdentifier = @"JGHApplyListCell";
static NSString *const JGActivityNameBaseCellIdentifier = @"JGActivityNameBaseCell";
static NSString *const JGHButtonCellIdentifier = @"JGHButtonCell";

@interface JGHCancelApplyViewController ()<UITableViewDelegate, UITableViewDataSource, JGHApplyListCellDelegate, JGHButtonCellDelegate>

@property (nonatomic, strong)UITableView *cancelApplyTableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation JGHCancelApplyViewController

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
    self.navigationItem.title = @"取消报名";
    
    [self createTableView];
}

#pragma mark -- 创建Tableview
- (void)createTableView{
    self.cancelApplyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 44)];
    self.cancelApplyTableView.dataSource = self;
    self.cancelApplyTableView.delegate = self;
    
    self.cancelApplyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.cancelApplyTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    UINib *activityNib = [UINib nibWithNibName:@"JGTeamActivityCell" bundle: [NSBundle mainBundle]];
    [self.cancelApplyTableView registerNib:activityNib forCellReuseIdentifier:JGTeamActivityCellIdentifier];
    
    UINib *applyNib = [UINib nibWithNibName:@"JGHCancelApplyBaseCell" bundle: [NSBundle mainBundle]];
    [self.cancelApplyTableView registerNib:applyNib forCellReuseIdentifier:JGHCancelApplyBaseCellIdentifier];
    
    UINib *signUoNib = [UINib nibWithNibName:@"JGApplyPepoleCell" bundle: [NSBundle mainBundle]];
    [self.cancelApplyTableView registerNib:signUoNib forCellReuseIdentifier:JGApplyPepoleCellIdentifier];
    
    UINib *headerNib = [UINib nibWithNibName:@"JGHHeaderLabelCell" bundle: [NSBundle mainBundle]];
    [self.cancelApplyTableView registerNib:headerNib forCellReuseIdentifier:JGHHeaderLabelCellIdentifier];
    
    UINib *applyListNib = [UINib nibWithNibName:@"JGHApplyListCell" bundle: [NSBundle mainBundle]];
    [self.cancelApplyTableView registerNib:applyListNib forCellReuseIdentifier:JGHApplyListCellIdentifier];
    
    UINib *detailsNib = [UINib nibWithNibName:@"JGActivityNameBaseCell" bundle: [NSBundle mainBundle]];
    [self.cancelApplyTableView registerNib:detailsNib forCellReuseIdentifier:JGActivityNameBaseCellIdentifier];
    
    UINib *btnNib = [UINib nibWithNibName:@"JGHButtonCell" bundle: [NSBundle mainBundle]];
    [self.cancelApplyTableView registerNib:btnNib forCellReuseIdentifier:JGHButtonCellIdentifier];
    
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
    if (section == 2) {
        //参赛费用列表
        return _dataArray.count;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return 30;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 80;
    }else if (section == 4){
        static JGActivityNameBaseCell *cell;
        if (!cell) {
            cell = [self.cancelApplyTableView dequeueReusableCellWithIdentifier:JGActivityNameBaseCellIdentifier];
        }
        
        cell.baseLabel.font = [UIFont systemFontOfSize:13.0];
        cell.baseLabel.text = ActivityRefundrules;
        NSLog(@"%lf", [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1);
        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        JGHApplyListCell *applyListCel = [tableView dequeueReusableCellWithIdentifier:JGHApplyListCellIdentifier forIndexPath:indexPath];
        applyListCel.chooseBtn.tag = indexPath.row + 100;
        applyListCel.delegate = self;
        applyListCel.selectionStyle = UITableViewCellSelectionStyleNone;
        [applyListCel configCancelApplyDict:_dataArray[indexPath.row]];
        return applyListCel;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        JGTeamActivityCell *activityCell = [tableView dequeueReusableCellWithIdentifier:JGTeamActivityCellIdentifier];
        [activityCell setJGTeamActivityCellWithModel:_model fromCtrl:1];
        return (UIView *)activityCell;
    }else if (section == 1){
        JGHCancelApplyBaseCell *applyBaseCell = [tableView dequeueReusableCellWithIdentifier:JGHCancelApplyBaseCellIdentifier];
        for (int i=0; i<_dataArray.count; i++) {
            NSMutableDictionary *dict = _dataArray[i];
            if ([[dict objectForKey:@"userKey"] integerValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:userID] integerValue]) {
                [applyBaseCell configDict:_dataArray[i]];
            }
        }
        return (UIView *)applyBaseCell;
    }else if (section == 2){
        JGApplyPepoleCell *signUoPromptCell = [tableView dequeueReusableCellWithIdentifier:JGApplyPepoleCellIdentifier];
        [signUoPromptCell configCancelApplyTitles:@"选择取消报名人"];
        return (UIView *)signUoPromptCell;
    }else if (section == 3){
        JGHHeaderLabelCell *activityNameCell = [tableView dequeueReusableCellWithIdentifier:JGHHeaderLabelCellIdentifier];
        activityNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [activityNameCell congiftitles:@"应退金额"];
        //计算退款金额
        [activityNameCell configRefoundMonay:[self calculateRefundMonay]];
        return (UIView *)activityNameCell;
    }else if (section == 4){
        JGActivityNameBaseCell *promptDetailsCell = [tableView dequeueReusableCellWithIdentifier:JGActivityNameBaseCellIdentifier];
        promptDetailsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [promptDetailsCell configActivityRefundRulesString:ActivityRefundrules];
        return (UIView *)promptDetailsCell;
    }else{
        JGHButtonCell *buttonCell = [tableView dequeueReusableCellWithIdentifier:JGHButtonCellIdentifier];
        buttonCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [buttonCell.clickBtn setTitle:@"取消报名" forState:UIControlStateNormal];
        buttonCell.delegate = self;
        buttonCell.backgroundColor = [UIColor colorWithHexString:BG_color];
        return (UIView *)buttonCell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10)];
    footView.backgroundColor = [UIColor colorWithHexString:BG_color];
    return footView;
}

#pragma mark -- 计算退款金额
- (float)calculateRefundMonay{
    float refoundMonay = 0.0;
    for (NSMutableDictionary *dict in _dataArray) {
        if ([[dict objectForKey:@"select"] integerValue] == 1) {
            refoundMonay += [[dict objectForKey:@"payMoney"] floatValue];
        }
    }
    
    return refoundMonay;
}

#pragma mark -- 勾选事件代理
- (void)didChooseBtn:(UIButton *)btn{
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
#pragma mark --取消报名
- (void)selectCommitBtnClick:(UIButton *)btn{
    NSInteger applyCount = 0;
    for (NSMutableDictionary *dict in _dataArray) {
        if ([[dict objectForKey:@"select"] integerValue] == 1) {
            applyCount += 1;
        }
    }
    
    if (applyCount == 0) {
        [[ShowHUD showHUD]showToastWithText:@"请选择取消报名人！" FromView:self.view];
    }else{
        [Helper alertViewWithTitle:@"确定取消报名？" withBlockCancle:^{
            NSLog(@"取消报名");
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
            [LQProgressHud showMessage:@"取消报名成功！"];
            [self performSelector:@selector(popCtrl) withObject:self afterDelay:0.1];
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
    
    btn.enabled = YES;
}

- (void)popCtrl{
    //创建一个消息对象
//    NSNotification * notice = [NSNotification notificationWithName:@"reloadActivityData" object:nil userInfo:nil];
//    //            发送消息
//    [[NSNotificationCenter defaultCenter]postNotification:notice];
//    [self.navigationController popViewControllerAnimated:YES];

    JGLCancelDrawbackViewController* canVc = [[JGLCancelDrawbackViewController alloc]init];
    canVc.model = self.model;
    canVc.activityKey = self.activityKey;
    
    NSMutableArray *signupKeyArray = [NSMutableArray array];
    for (int i = 0; i < _dataArray.count; i++) {
        if ([[_dataArray[i] objectForKey:@"select"] integerValue] == 1) {
            [signupKeyArray addObject:_dataArray[i]];
        }
    }
    canVc.dataArray = signupKeyArray;
    [self.navigationController pushViewController:canVc animated:YES];
}

- (void)pushCtrl{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[JGTeamActivityViewController class]]) {
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"reloadActivityData" object:nil userInfo:nil];
            //            发送消息
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
