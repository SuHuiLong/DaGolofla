//
//  JGTeamApplyViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamApplyViewController.h"
#import "JGActivityNameBaseCell.h"
#import "JGTableViewCell.h"
#import "JGApplyPepoleCell.h"
#import "JGAddTeamGuestViewController.h"
#import "JGInvoiceViewController.h"
#import "JGTeamGroupViewController.h"
#import "JGTeamAcitivtyModel.h"

//微信支付
#import "WXApi.h"
#import "payRequsestHandler.h"

static NSString *const JGActivityNameBaseCellIdentifier = @"JGActivityNameBaseCell";
static NSString *const JGTableViewCellIdentifier = @"JGTableViewCell";
static NSString *const JGApplyPepoleCellIdentifier = @"JGApplyPepoleCell";

@interface JGTeamApplyViewController ()<JGApplyPepoleCellDelegate>
{
    UIAlertController *_actionView;
}

@property (strong, nonatomic)JGTeamAcitivtyModel *model;//数据模型

@property (nonatomic, strong)NSArray *titleArray;//标题

@property (nonatomic, strong)NSMutableArray *applyArray;//成员数组--添加成员字典

@property (nonatomic, strong)NSMutableDictionary *info;

@end

@implementation JGTeamApplyViewController

- (instancetype)init{
    if (self == [super init]) {
        self.model = [[JGTeamAcitivtyModel alloc]init];
        self.applyArray = [NSMutableArray array];
        self.info = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"报名缴费";
    
    self.titleArray = @[@"活动名称", @"活动地址", @"活动日期", @"活动费用", @"嘉宾费用"];
    //注册cell
    UINib *activityNameNib = [UINib nibWithNibName:@"JGActivityNameBaseCell" bundle: [NSBundle mainBundle]];
    [self.teamApplyTableView registerNib:activityNameNib forCellReuseIdentifier:JGActivityNameBaseCellIdentifier];
    
    UINib *tableViewNib = [UINib nibWithNibName:@"JGTableViewCell" bundle: [NSBundle mainBundle]];
    [self.teamApplyTableView registerNib:tableViewNib forCellReuseIdentifier:JGTableViewCellIdentifier];
    
    UINib *applyPepoleNib = [UINib nibWithNibName:@"JGApplyPepoleCell" bundle: [NSBundle mainBundle]];
    [self.teamApplyTableView registerNib:applyPepoleNib forCellReuseIdentifier:JGApplyPepoleCellIdentifier];
    
//    [self loadData];
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
    if (section == 0) {
        return 5;
    }
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }else if (indexPath.section == 1){
        static JGApplyPepoleCell *cell;
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:JGApplyPepoleCellIdentifier];
        }
        
        cell.guestList.text = @"绝代风华\n哈哈哈\n嘿嘿嘿\n鸡尾酒\n贝多芬";
        
        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
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
        JGTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:JGTableViewCellIdentifier forIndexPath:indexPath];
        [tableCell configTitlesString:self.titleArray[indexPath.row]];
        [tableCell configJGTeamAcitivtyModel:self.model andIndecPath:indexPath];
        tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return tableCell;
    }else if (indexPath.section == 1){
        JGApplyPepoleCell *applyPepoleCell = [tableView dequeueReusableCellWithIdentifier:JGApplyPepoleCellIdentifier forIndexPath:indexPath];
        applyPepoleCell.delegate = self;
        applyPepoleCell.guestList.text = @"绝代风华\n哈哈哈\n嘿嘿嘿\n鸡尾酒\n贝多芬";
        
        applyPepoleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return applyPepoleCell;
    }else{
        JGActivityNameBaseCell *activityNameCell = [tableView dequeueReusableCellWithIdentifier:JGActivityNameBaseCellIdentifier forIndexPath:indexPath];
        activityNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 2) {
            activityNameCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return activityNameCell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        JGInvoiceViewController *invoiceCtrl = [[JGInvoiceViewController alloc]init];
        [self.navigationController pushViewController:invoiceCtrl animated:YES];
    }
}
#pragma mark -- 立即付款
- (IBAction)nowPayBtnClick:(UIButton *)sender {
    _actionView = [UIAlertController alertControllerWithTitle:@"选择支付方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // 分别3个创建操作
    UIAlertAction *weiChatAction = [UIAlertAction actionWithTitle:@"微信支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"微信支付");

        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        [dict setObject:@0 forKey:@"payInfo"];
        
        [[JsonHttp jsonHttp]httpRequest:@"pay/doPayWeiXin" JsonKey:@"payInfo" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
            NSLog(@"errType == %@", errType);
        } completionBlock:^(id data) {
            
            NSDictionary *dict = [[data objectForKey:@"rows"] objectForKey:@"appRequest"];
            //微信
            //创建支付签名对象
            payRequsestHandler *req = [payRequsestHandler alloc];
            
            //初始化支付签名对象
            [req init:@"wxdcdc4e20544ed728" mch_id:[dict objectForKey:@"partnerid"]];
            //设置秘钥
            [req setKey:[[data objectForKey:@"rows"] objectForKey:@"key"]];
            
            NSMutableDictionary *dict1 = [req sendPay_demoPrePayid:[dict objectForKey:@"prepayid"]];
            if (dict1) {
                PayReq *request = [[PayReq alloc] init];
                request.openID       = [dict1 objectForKey:@"appid"];
                request.partnerId    = [dict1 objectForKey:@"partnerid"];
                request.prepayId     = [dict1 objectForKey:@"prepayid"];
                request.package      = [dict1 objectForKey:@"package"];
                request.nonceStr     = [dict1 objectForKey:@"noncestr"];
                request.timeStamp    =[[dict1 objectForKey:@"timestamp"] intValue];
                request.sign         = [dict1 objectForKey:@"sign"];
                
                [WXApi sendReq:request];
            }
            
            
        }];

        
    }];
    
}
#pragma mark -- 现场付款
- (IBAction)scenePayBtnClick:(UIButton *)sender {
    JGTeamGroupViewController *groupCtrl = [[JGTeamGroupViewController alloc]init];
    [self.navigationController pushViewController:groupCtrl animated:YES];
}
#pragma mark -- 提交报名信息
- (void)submitInfo{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
