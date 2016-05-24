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
#import "JGTeamAcitivtyModel.h"

static NSString *const JGTeamActivityWithAddressCellIdentifier = @"JGTeamActivityWithAddressCell";
static NSString *const JGTeamActivityDetailsCellIdentifier = @"JGTeamActivityDetailsCell";
static NSString *const JGCostsDescriptionCellIdentifier = @"JGCostsDescriptionCell";
static NSString *const JGActivityNameBaseCellIdentifier = @"JGActivityNameBaseCell";

@interface JGTeamActibityNameViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    CGFloat _tableViewHeight;
}
@property (nonatomic, strong)UITableView *teamActibityNameTableView;
@property (nonatomic, strong)NSMutableArray *dataArray;//数据源

@end

@implementation JGTeamActibityNameViewController

- (instancetype)init{
    if (self == [super init]) {
        self.dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"活动预览";
    
    if ([self.isAdmin isEqualToString:@"0"]) {
        _tableViewHeight = screenHeight -64 -44 - 48;
        [self createSaveAndLaunchBtn];
    }else{
        _tableViewHeight = screenHeight -64 -44;
        [self createApplyBtn];
    }
    
    
    
//    [self loadData];
}
#pragma mark -- 下载数据
- (void)loadData{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%ld", (long)self.teamActivityKey] forKey:@"activityKey"];
//    [dict setObject:[userDef objectForKey:userID] forKey:@"userKey"];
    [dict setObject:@"244" forKey:@"userKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamActivity" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"error == %@", errType);
    } completionBlock:^(id data) {
        NSLog(@"data == %@", data);
        NSDictionary *dict = [NSDictionary dictionary];
        dict = [data objectForKey:@"activity"];
        JGTeamAcitivtyModel *model = [[JGTeamAcitivtyModel alloc]init];
        [model setValuesForKeysWithDictionary:dict];
        [self.dataArray addObject:model];
        
        [self createTeamActibityNameTableView];
    }];
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
#pragma mark -- 发布活动
- (void)applyBtnClick:(UIButton *)btn{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"0" forKey:@"timeKey"];//timeKey
    [dict setObject:@"192" forKey:@"teamKey"];//球队key
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [dict setObject:@"244" forKey:@"userKey"];//用户key
    //121212
//    [dict setObject:@"244" forKey:@"userKey"];
    
    [dict setObject:@"高尔夫友谊聚会活动" forKey:@"name"];//活动名字
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *date = [dateFormatter dateFromString:@"2016-05-14 16:01:03"];
    [dict setObject:@"2016-06-01 12:01:00" forKey:@"signUpEndTime"];//活动报名截止时间
    [dict setObject:@"2016-05-01 12:01:00" forKey:@"beginDate"];//活动开始时间
    [dict setObject:@"2016-08-01 12:01:00" forKey:@"endDate"];//活动结束时间
    [dict setObject:@"400" forKey:@"ballKey"];//球场id
    [dict setObject:@"浦东新车球场" forKey:@"ballName"];//球场名称
    [dict setObject:@"" forKey:@"ballGeohash"];//球场坐标
    [dict setObject:@"护士繁华的风格变化的腐败黄金时代不好的发布时间的封闭不会是绝大部分黄金时代不废江河百货商店减肥百货商店发布时间地方保护手机的发布" forKey:@"info"];//活动简介
    [dict setObject:@"每人100元" forKey:@"costInfo"];//费用说明
    [dict setObject:@"120" forKey:@"memberPrice"];//会员价
    [dict setObject:@"220" forKey:@"guestPrice"];//嘉宾价
    [dict setObject:@"2016-05-01 12:01:00" forKey:@"subsidyBeginTime"];//补贴开始时间
    [dict setObject:@"2016-06-01 12:01:00" forKey:@"subsidyEndTime"];//补贴结束时间
    [dict setObject:@"30" forKey:@"subsidyPrice"];//补贴价
    [dict setObject:@"100" forKey:@"maxCount"];//最大人员数
    [dict setObject:@"0" forKey:@"isClose"];//活动是否结束 0 : 开始 , 1 : 已结束
    [dict setObject:@"2016-04-01 12:01:00" forKey:@"createTime"];//活动创建时间
    [dict setObject:@"50" forKey:@"sumCount"];//活动报名总人数
    [dict setObject:@"5000" forKey:@"sumMoney"];//活动总金额
    [dict setObject:@"5000" forKey:@"WithdrawalsMoney"];//提现金额

    //createTeamActivity
    [[JsonHttp jsonHttp]httpRequest:@"team/createTeamActivity" JsonKey:@"teamActivity" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"%@", errType);
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
    }];
    
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
        static JGTeamActivityDetailsCell *cell;
        if (!cell) {
            cell = [self.teamActibityNameTableView dequeueReusableCellWithIdentifier:JGTeamActivityDetailsCellIdentifier];
        }
        
        JGTeamAcitivtyModel *model = [[JGTeamAcitivtyModel alloc]init];
        model = self.dataArray[0];
        cell.activityDetails.text = model.info;
        
        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
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
    JGTeamAcitivtyModel *model = [[JGTeamAcitivtyModel alloc]init];
    model = self.dataArray[0];
    if (indexPath.section == 0) {
        JGTeamActivityWithAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:JGTeamActivityWithAddressCellIdentifier forIndexPath:indexPath];
        addressCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [addressCell configModel:model];
        return addressCell;
    }else if (indexPath.section == 1 || indexPath.section == 3){
        JGTeamActivityDetailsCell *detailsCell = [tableView dequeueReusableCellWithIdentifier:JGTeamActivityDetailsCellIdentifier forIndexPath:indexPath];
        detailsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [detailsCell configDetailsText:@"活动详情" AndActivityDetailsText:model.info];
        return detailsCell;
    }else if (indexPath.section == 2){
        JGCostsDescriptionCell *costDescriptionCell = [tableView dequeueReusableCellWithIdentifier:JGCostsDescriptionCellIdentifier forIndexPath:indexPath];
        costDescriptionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [costDescriptionCell configModel:model];
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
