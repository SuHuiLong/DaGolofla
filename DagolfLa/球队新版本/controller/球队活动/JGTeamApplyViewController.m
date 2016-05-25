//
//  JGTeamApplyViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamApplyViewController.h"
#import "JGActivityBaseInfoCell.h"
#import "JGTableViewCell.h"
#import "JGApplyPepoleCell.h"
#import "JGAddTeamGuestViewController.h"
#import "JGInvoiceViewController.h"
#import "JGTeamGroupViewController.h"
#import "JGTeamAcitivtyModel.h"
#import "JGHHeaderLabelCell.h"
#import "JGHApplyListCell.h"

static NSString *const JGActivityBaseInfoCellIdentifier = @"JGActivityBaseInfoCell";
static NSString *const JGTableViewCellIdentifier = @"JGTableViewCell";
static NSString *const JGApplyPepoleCellIdentifier = @"JGApplyPepoleCell";
static NSString *const JGHHeaderLabelCellIdentifier = @"JGHHeaderLabelCell";
static NSString *const JGHApplyListCellIdentifier = @"JGHApplyListCell";

@interface JGTeamApplyViewController ()<JGApplyPepoleCellDelegate, JGHApplyListCellDelegate>
{
    UIAlertController *_actionView;
}

@property (strong, nonatomic)JGTeamAcitivtyModel *model;//数据模型

@property (nonatomic, strong)NSArray *titleArray;//标题

@property (nonatomic, strong)NSMutableArray *applyArray;//成员数组----添加成员字典

@property (nonatomic, strong)NSMutableDictionary *info;

@property (nonatomic, strong)UIButton *cellClickBtn;//拦截cell点击事件

@end

@implementation JGTeamApplyViewController

- (UIButton *)cellClickBtn{
    if (_cellClickBtn == nil) {
        self.cellClickBtn = [[UIButton alloc]init];
    }
    return _cellClickBtn;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"报名缴费";
    self.model = [[JGTeamAcitivtyModel alloc]init];
    self.applyArray = [NSMutableArray array];
    self.info = [NSMutableDictionary dictionary];
    self.titleArray = @[@"活动名称", @"活动地址", @"活动日期", @"活动费用", @"嘉宾费用"];
    //注册cell
    UINib *activityNameNib = [UINib nibWithNibName:@"JGActivityBaseInfoCell" bundle: [NSBundle mainBundle]];
    [self.teamApplyTableView registerNib:activityNameNib forCellReuseIdentifier:JGActivityBaseInfoCellIdentifier];
    
    UINib *tableViewNib = [UINib nibWithNibName:@"JGTableViewCell" bundle: [NSBundle mainBundle]];
    [self.teamApplyTableView registerNib:tableViewNib forCellReuseIdentifier:JGTableViewCellIdentifier];
    
    UINib *applyPepoleNib = [UINib nibWithNibName:@"JGApplyPepoleCell" bundle: [NSBundle mainBundle]];
    [self.teamApplyTableView registerNib:applyPepoleNib forCellReuseIdentifier:JGApplyPepoleCellIdentifier];
    
    UINib *headerLabelNib = [UINib nibWithNibName:@"JGHHeaderLabelCell" bundle: [NSBundle mainBundle]];
    [self.teamApplyTableView registerNib:headerLabelNib forCellReuseIdentifier:JGHHeaderLabelCellIdentifier];
    
    UINib *applyListNib = [UINib nibWithNibName:@"JGHApplyListCell" bundle: [NSBundle mainBundle]];
    [self.teamApplyTableView registerNib:applyListNib forCellReuseIdentifier:JGHApplyListCellIdentifier];
    
//    [self loadData];
    [self createData];
}
#pragma mark -- 创建测试数据
- (void)createData{
    for (int i=0; i<10; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"192" forKey:@"teamKey"];//球队key
        [dict setObject:@"206" forKey:@"activityKey"];//球队活动id
        if (i==0) {
            [dict setObject:@244 forKey:@"userKey"];//报名用户key , 没有则是嘉宾
            [dict setObject:@1 forKey:@"type"];
        }else{
            [dict setObject:@0 forKey:@"userKey"];//报名用户key , 没有则是嘉宾
            [dict setObject:@0 forKey:@"type"];
        }
        [dict setObject:[NSString stringWithFormat:@"test%d", i] forKey:@"name"];//姓名
        [dict setObject:[NSString stringWithFormat:@"1872111036%d", i] forKey:@"mobile"];//手机号
        [dict setObject:[NSString stringWithFormat:@"7%d", i] forKey:@"almost"];//差点
        [dict setObject:@"0" forKey:@"isOnlinePay"];//是否线上 付款
        [dict setObject:@"0" forKey:@"sex"];//性别 0: 女 1: 男
//        [dict setObject:@"192" forKey:@"groupIndex"];//组的索引   每组4 人
//        [dict setObject:@"192" forKey:@"sortIndex"];//排序索引号
//        [dict setObject:@"192" forKey:@"payMoney"];//实际付款金额
//        [dict setObject:@"192" forKey:@"payTime"];//实际付款时间
//        [dict setObject:@"192" forKey:@"subsidyPrice"];//补贴价
//        [dict setObject:@"3500" forKey:@"money"];//报名费
        [dict setObject:@"2016-06-11 10:00:00" forKey:@"createTime"];//报名时间
        [dict setObject:@0 forKey:@"signUpInfoKey"];//报名信息的timeKey
        [dict setObject:@0 forKey:@"timeKey"];//timeKey
        [dict setObject:@"1" forKey:@"select"];
        
        [self.applyArray addObject:dict];
    }
    
    [self.teamApplyTableView reloadData];
}


- (void)loadData{
    NSUserDefaults *userdf = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"244" forKey:userID];
    [dict setObject:self.activityKey forKey:@"activityKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamActivity" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        NSLog(@"data == %@", data);
        NSMutableDictionary *datadict = [NSMutableDictionary dictionary];
        datadict = [data objectForKey:@"activity"];
        [self.model setValuesForKeysWithDictionary:datadict];
        
        [self.teamApplyTableView reloadData];
    }];
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
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 165;
    }else if (section == 1){
        return 40;
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        JGActivityBaseInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:JGActivityBaseInfoCellIdentifier];
//        infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return infoCell;
//    }else if (indexPath.section == 1){
//        JGApplyPepoleCell *applyPepoleCell = [tableView dequeueReusableCellWithIdentifier:JGApplyPepoleCellIdentifier forIndexPath:indexPath];
//        applyPepoleCell.delegate = self;
//        applyPepoleCell.guestList.text = @"绝代风华\n哈哈哈\n嘿嘿嘿\n鸡尾酒\n贝多芬";
//        
//        applyPepoleCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return applyPepoleCell;
//    }else{
        JGHApplyListCell *applyListCel = [tableView dequeueReusableCellWithIdentifier:JGHApplyListCellIdentifier forIndexPath:indexPath];
        applyListCel.selectionStyle = UITableViewCellSelectionStyleNone;
    
        [applyListCel configDict:_applyArray[indexPath.row]];
    
        return applyListCel;
//    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        JGActivityBaseInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:JGActivityBaseInfoCellIdentifier];
        infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return (UIView *)infoCell;
    }else if (section == 1){
        JGApplyPepoleCell *applyPepoleCell = [tableView dequeueReusableCellWithIdentifier:JGApplyPepoleCellIdentifier];
        applyPepoleCell.delegate = self;
        return (UIView *)applyPepoleCell;
    }else{
        JGHHeaderLabelCell *activityNameCell = [tableView dequeueReusableCellWithIdentifier:JGHHeaderLabelCellIdentifier];
        activityNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (section == 2) {
            self.cellClickBtn.frame = CGRectMake(0, 0, screenWidth, activityNameCell.frame.size.height);
            [self.cellClickBtn addTarget:self action:@selector(cellClickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [activityNameCell.contentView addSubview:self.cellClickBtn];
        }
        
        return (UIView *)activityNameCell;
    }
}
#pragma mark -- 发票cell点击事件
- (void)cellClickBtn:(UIButton *)btn{
    JGInvoiceViewController *invoiceCtrl = [[JGInvoiceViewController alloc]init];
    [self.navigationController pushViewController:invoiceCtrl animated:YES];
}
#pragma mark -- 立即付款
- (IBAction)nowPayBtnClick:(UIButton *)sender {
    _actionView = [UIAlertController alertControllerWithTitle:@"选择支付方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // 分别3个创建操作
    UIAlertAction *weiChatAction = [UIAlertAction actionWithTitle:@"微信支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"微信支付");
        JGTeamGroupViewController *groupCtrl = [[JGTeamGroupViewController alloc]init];
        [self.navigationController pushViewController:groupCtrl animated:YES];
    }];
    UIAlertAction *zhifubaoAction = [UIAlertAction actionWithTitle:@"支付宝支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"支付宝支付");
        JGTeamGroupViewController *groupCtrl = [[JGTeamGroupViewController alloc]init];
        [self.navigationController pushViewController:groupCtrl animated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消支付");
    }];
    [_actionView addAction:weiChatAction];
    [_actionView addAction:zhifubaoAction];
    [_actionView addAction:cancelAction];
    [self presentViewController:_actionView animated:YES completion:nil];
}
#pragma mark -- 现场付款
- (IBAction)scenePayBtnClick:(UIButton *)sender {
    JGTeamGroupViewController *groupCtrl = [[JGTeamGroupViewController alloc]init];
    [self.navigationController pushViewController:groupCtrl animated:YES];
    
    [self submitInfo];
}
#pragma mark -- 提交报名信息
- (void)submitInfo{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
//    NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
    [self.info setObject:@"192" forKey:@"teamKey"];//球队key
    [self.info setObject:@"206" forKey:@"activityKey"];//球队活动key
    [self.info setObject:@"球球" forKey:@"userName"];//报名人名称
    [self.info setObject:@"" forKey:@"invoiceKey"];//发票Key
    [self.info setObject:@244 forKey:@"userKey"];//用户Key
    [self.info setObject:@0 forKey:@"timeKey"];//timeKey
//    [self.info setObject:self.info forKey:@"info"];
    
    [dict setObject:_applyArray forKey:@"teamSignUpList"];//报名人员数组
    [dict setObject:_info forKey:@"info"];
    [[JsonHttp jsonHttp]httpRequest:@"team/doTeamActivitySignUp" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        NSLog(@"data == %@", data);
    }];
}
#pragma mark -- 添加嘉宾
- (void)addApplyPeopleClick{
    JGAddTeamGuestViewController *addTeamGuestCtrl = [[JGAddTeamGuestViewController alloc]initWithNibName:@"JGAddTeamGuestViewController" bundle:nil];
    [self.navigationController pushViewController:addTeamGuestCtrl animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --  选择嘉宾
- (void)didChooseBtn:(UIButton *)btn{
    
}
#pragma mark -- 删除嘉宾
- (void)didSelectDeleteBtn:(UIButton *)btn{
    
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
