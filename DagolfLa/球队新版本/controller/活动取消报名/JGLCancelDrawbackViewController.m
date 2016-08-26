//
//  JGHCancelApplyViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLCancelDrawbackViewController.h"
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

#import "JGTeamActibityNameViewController.H"
#import "JGDPrivateAccountViewController.h"
#define ActivityRefundrules @"提示：活动取消后缴纳的费用将退还到个人账户中，实际退款金额为用户实际缴纳金额，平台补贴金额不在退款范围。如有疑问请与活动组织者联系。"

static NSString *const TableViewCellIdentifier = @"tableviewcell";
static NSString *const JGHCancelApplyBaseCellIdentifier = @"JGHCancelApplyBaseCell";
static NSString *const JGApplyPepoleCellIdentifier = @"JGApplyPepoleCell";
static NSString *const JGHHeaderLabelCellIdentifier = @"JGHHeaderLabelCell";
static NSString *const JGHApplyListCellIdentifier = @"JGHApplyListCell";
static NSString *const JGActivityNameBaseCellIdentifier = @"JGActivityNameBaseCell";
static NSString *const JGHButtonCellIdentifier = @"JGHButtonCell";

@interface JGLCancelDrawbackViewController ()<UITableViewDelegate, UITableViewDataSource, JGHApplyListCellDelegate, JGHButtonCellDelegate>

@property (nonatomic, strong)UITableView *cancelApplyTableView;



@end

@implementation JGLCancelDrawbackViewController

- (instancetype)init{
    if (self == [super init]) {
//        self.dataArray = [NSMutableArray array];
        self.model = [[JGTeamAcitivtyModel alloc]init];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(popToViewCtrl)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
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
    [self.cancelApplyTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TableViewCellIdentifier];
    
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

}
#pragma mark -- tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        //参赛费用列表
        return _dataArray.count;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 30;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 44;
    }else if (section == 3){
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
    if (indexPath.section == 1) {
        JGHApplyListCell *applyListCel = [tableView dequeueReusableCellWithIdentifier:JGHApplyListCellIdentifier forIndexPath:indexPath];
        applyListCel.chooseBtn.tag = indexPath.row + 100;
        applyListCel.delegate = self;
        applyListCel.selectionStyle = UITableViewCellSelectionStyleNone;
        [applyListCel configCancelApplyDict:_dataArray[indexPath.row]];
        applyListCel.chooseBtn.hidden = YES;
        applyListCel.backgroundColor = [UIColor clearColor];
        return applyListCel;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
        cell.textLabel.text = @"根据您的要求，如下名单报名/退款已经完成：";
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
        return (UIView *)cell;
    }else if (section == 1){
        JGApplyPepoleCell *signUoPromptCell = [tableView dequeueReusableCellWithIdentifier:JGApplyPepoleCellIdentifier];
        [signUoPromptCell configCancelApplyTitles:@"取消报名人员名单"];
        signUoPromptCell.directionImageView.hidden = YES;
        signUoPromptCell.backgroundColor = [UIColor clearColor];
        return (UIView *)signUoPromptCell;
    }else if (section == 2){
        JGHHeaderLabelCell *activityNameCell = [tableView dequeueReusableCellWithIdentifier:JGHHeaderLabelCellIdentifier];
        activityNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [activityNameCell congiftitles:@"应退金额"];
        activityNameCell.titles.textColor = [UIColor blackColor];
        activityNameCell.backgroundColor = [UIColor clearColor];
        //计算退款金额
        [activityNameCell configRefoundMonay:[self calculateRefundMonay]];
        return (UIView *)activityNameCell;
    }else if (section == 3){
        JGActivityNameBaseCell *promptDetailsCell = [tableView dequeueReusableCellWithIdentifier:JGActivityNameBaseCellIdentifier];
        promptDetailsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [promptDetailsCell configCancelDrawback:ActivityRefundrules];
        return (UIView *)promptDetailsCell;
    }else{
        JGHButtonCell *buttonCell = [tableView dequeueReusableCellWithIdentifier:JGHButtonCellIdentifier];
        buttonCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [buttonCell.clickBtn setTitle:@"查看个人账户" forState:UIControlStateNormal];
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

#pragma mark --取消报名
- (void)selectCommitBtnClick:(UIButton *)btn{
    JGDPrivateAccountViewController* priVc = [[JGDPrivateAccountViewController alloc]init];
    [self.navigationController pushViewController:priVc animated:YES];
}


- (void)popToViewCtrl{
    //创建一个消息对象
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[JGTeamActibityNameViewController class]]) {
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"reloadActivityData" object:nil userInfo:nil];
            //            发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

//- (void)pushCtrl{
//    
//}

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
