//
//  JGTeamActibityNameViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamActibityNameViewController.h"
#import "JGTeamActivityWithAddressCell.h"
#import "JGTeamActivityDetailsCell.h"
#import "JGCostsDescriptionCell.h"
#import "JGActivityNameBaseCell.h"
#import "JGTeamApplyViewController.h"

static NSString *const JGTeamActivityWithAddressCellIdentifier = @"JGTeamActivityWithAddressCell";
static NSString *const JGTeamActivityDetailsCellIdentifier = @"JGTeamActivityDetailsCell";
static NSString *const JGCostsDescriptionCellIdentifier = @"JGCostsDescriptionCell";
static NSString *const JGActivityNameBaseCellIdentifier = @"JGActivityNameBaseCell";

@interface JGTeamActibityNameViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    CGFloat _tableViewHeight;
}
@property (nonatomic, strong)UITableView *teamActibityNameTableView;
@property (nonatomic, strong)UITableView *dataArray;//数据源

@end

@implementation JGTeamActibityNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"活动详情";
    
    if ([self.isAdmin isEqualToString:@"0"]) {
        _tableViewHeight = screenHeight -64 -44 - 48;
        [self createSaveAndLaunchBtn];
    }else{
        _tableViewHeight = screenHeight -64 -44;
        [self createApplyBtn];
    }
    
    [self createTeamActibityNameTableView];
}
#pragma mark -- 创建保存 ＋ 发布 按钮
- (void)createSaveAndLaunchBtn{
    UIButton *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, screenHeight - 64 -44 - 48, screenWidth, 44)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.backgroundColor = [UIColor yellowColor];
    saveBtn.layer.cornerRadius = 8.0;
    [saveBtn addTarget:self action:@selector(applyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    UIButton *launchBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, screenHeight - 64 -44, screenWidth, 44)];
    [launchBtn setTitle:@"发布" forState:UIControlStateNormal];
    launchBtn.backgroundColor = [UIColor yellowColor];
    launchBtn.layer.cornerRadius = 8.0;
    [launchBtn addTarget:self action:@selector(applyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:launchBtn];
}
#pragma mark -- 创建报名按钮
- (void)createApplyBtn{
    UIButton *applyBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, screenHeight - 64 -44, screenWidth, 44)];
    [applyBtn setTitle:@"我要报名" forState:UIControlStateNormal];
    applyBtn.backgroundColor = [UIColor yellowColor];
    applyBtn.layer.cornerRadius = 8.0;
    [applyBtn addTarget:self action:@selector(applyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:applyBtn];
}
- (void)applyBtnClick:(UIButton *)btn{
    JGTeamApplyViewController * applyCtrl = [[JGTeamApplyViewController alloc]initWithNibName:@"JGTeamApplyViewController" bundle:nil];
    [self.navigationController pushViewController:applyCtrl animated:YES];
}
#pragma mark -- 创建TableView
- (void)createTeamActibityNameTableView{
    self.teamActibityNameTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, _tableViewHeight) style:UITableViewStyleGrouped];
    self.teamActibityNameTableView.delegate = self;
    self.teamActibityNameTableView.dataSource = self;
    self.teamActibityNameTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //活动场地cell
    UINib *addressNib = [UINib nibWithNibName:@"JGTeamActivityWithAddressCell" bundle:[NSBundle mainBundle]];
    [self.teamActibityNameTableView registerNib:addressNib forCellReuseIdentifier:JGTeamActivityWithAddressCellIdentifier];
    //活动详情／规则说明
    UINib *detailNib = [UINib nibWithNibName:@"JGTeamActivityDetailsCell" bundle:[NSBundle mainBundle]];
    [self.teamActibityNameTableView registerNib:detailNib forCellReuseIdentifier:JGTeamActivityDetailsCellIdentifier];
    //费用说明cell
    UINib *CostsDescriptionNib = [UINib nibWithNibName:@"JGCostsDescriptionCell" bundle:[NSBundle mainBundle]];
    [self.teamActibityNameTableView registerNib:CostsDescriptionNib forCellReuseIdentifier:JGCostsDescriptionCellIdentifier];
    //基础cell
    UINib *activityNameBaseCellNib = [UINib nibWithNibName:@"JGActivityNameBaseCell" bundle:[NSBundle mainBundle]];
    [self.teamActibityNameTableView registerNib:activityNameBaseCellNib forCellReuseIdentifier:JGActivityNameBaseCellIdentifier];
    [self.view addSubview:self.teamActibityNameTableView];
}
#pragma mark -- tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 110;
    }else if (indexPath.section == 1 || indexPath.section == 3){
        return 70;
    }else if (indexPath.section == 2){
        return 110;
    }else{
        return 44;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGTeamActivityWithAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:JGTeamActivityWithAddressCellIdentifier forIndexPath:indexPath];
        addressCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return addressCell;
    }else if (indexPath.section == 1 || indexPath.section == 3){
        JGTeamActivityDetailsCell *detailsCell = [tableView dequeueReusableCellWithIdentifier:JGTeamActivityDetailsCellIdentifier forIndexPath:indexPath];
        detailsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return detailsCell;
    }else if (indexPath.section == 2){
        JGCostsDescriptionCell *costDescriptionCell = [tableView dequeueReusableCellWithIdentifier:JGCostsDescriptionCellIdentifier forIndexPath:indexPath];
        costDescriptionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return costDescriptionCell;
    }else{
        JGActivityNameBaseCell *activityNameBaseCell = [tableView dequeueReusableCellWithIdentifier:JGActivityNameBaseCellIdentifier forIndexPath:indexPath];
        activityNameBaseCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return activityNameBaseCell;
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
