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
#import "JGHAddInvoiceViewController.h"
#import "JGTeamGroupViewController.h"
#import "JGTeamAcitivtyModel.h"
#import "JGHHeaderLabelCell.h"
#import "JGHApplyListCell.h"


//微信
#import "WXApi.h"
#import "payRequsestHandler.h"

static NSString *const JGActivityBaseInfoCellIdentifier = @"JGActivityBaseInfoCell";
static NSString *const JGTableViewCellIdentifier = @"JGTableViewCell";
static NSString *const JGApplyPepoleCellIdentifier = @"JGApplyPepoleCell";
static NSString *const JGHHeaderLabelCellIdentifier = @"JGHHeaderLabelCell";
static NSString *const JGHApplyListCellIdentifier = @"JGHApplyListCell";

@interface JGTeamApplyViewController ()<JGApplyPepoleCellDelegate, JGHApplyListCellDelegate, JGAddTeamGuestViewControllerDelegate, JGHAddInvoiceViewControllerDelegate>
{
    UIAlertController *_actionView;
}

@property (strong, nonatomic)JGTeamAcitivtyModel *model;//数据模型

@property (nonatomic, strong)NSArray *titleArray;//标题

@property (nonatomic, strong)NSMutableArray *applyArray;//成员数组----添加成员字典

@property (nonatomic, strong)NSMutableDictionary *info;

@property (nonatomic, strong)UIButton *cellClickBtn;//拦截cell点击事件

@property (nonatomic, assign)NSInteger realPayPrice;//实付金额
@property (nonatomic, assign)NSInteger subsidiesPrice;//补贴金额


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
    _realPayPrice = 0;
    _subsidiesPrice = 0;
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
//    [self createData];
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
        //getTeamActivity
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
    JGHApplyListCell *applyListCel = [tableView dequeueReusableCellWithIdentifier:JGHApplyListCellIdentifier forIndexPath:indexPath];
    applyListCel.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [applyListCel configDict:_applyArray[indexPath.row]];
    
    return applyListCel;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        JGActivityBaseInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:JGActivityBaseInfoCellIdentifier];
        [infoCell configJGTeamAcitivtyModel:self.modelss];
        infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return (UIView *)infoCell;
    }else if (section == 1){
        JGApplyPepoleCell *applyPepoleCell = [tableView dequeueReusableCellWithIdentifier:JGApplyPepoleCellIdentifier];
        applyPepoleCell.delegate = self;
        return (UIView *)applyPepoleCell;
    }else{
        JGHHeaderLabelCell *activityNameCell = [tableView dequeueReusableCellWithIdentifier:JGHHeaderLabelCellIdentifier];
        if (section == 2) {
            self.cellClickBtn.frame = CGRectMake(0, 0, screenWidth, activityNameCell.frame.size.height);
            [self.cellClickBtn addTarget:self action:@selector(cellClickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [activityNameCell congiftitles:@"发票信息："];
            [activityNameCell.contentView addSubview:self.cellClickBtn];
            activityNameCell.accessoryType = UITableViewCellSelectionStyleBlue;
            if ([_invoiceKey isEqual:[NSNull class]]) {
                [activityNameCell configInvoiceIfo:_invoiceName];
            }
        }else{
            activityNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [activityNameCell congiftitles:@"实付金额："];
            int i = 0;
            int y = 0;
            for (NSDictionary *dict in _applyArray) {
                if ([[dict objectForKey:@"type"]integerValue] == 1) {
                    i += 1;
                }else{
                    y += 1;
                }
            }
            
            _realPayPrice = _modelss.memberPrice * i + _modelss.guestPrice * y;
            _subsidiesPrice = _modelss.subsidyPrice * i;
            
            [activityNameCell congifContact:[NSString stringWithFormat:@"%ld", (long)_realPayPrice] andNote:[NSString stringWithFormat:@"%ld", (long)_subsidiesPrice]];
        }
        
        return (UIView *)activityNameCell;
    }
}
#pragma mark -- 发票点击事件
- (void)cellClickBtn:(UIButton *)btn{
    JGHAddInvoiceViewController *invoiceCtrl = [[JGHAddInvoiceViewController alloc]init];
    invoiceCtrl.delegate = self;
    invoiceCtrl.invoiceKey = _invoiceKey;
    [self.navigationController pushViewController:invoiceCtrl animated:YES];
}
#pragma mark -- 立即付款
- (IBAction)nowPayBtnClick:(UIButton *)sender {
    // 分别3个创建操作
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        _photos = 1;
    }];
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
    
    UIAlertAction *zhifubaoAction = [UIAlertAction actionWithTitle:@"微信支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"支付宝支付");
        
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
    
    _actionView = [UIAlertController alertControllerWithTitle:@"选择支付方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
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
    if ([_invoiceKey isEqual:[NSNull class]]) {
        [self.info setObject:_invoiceKey forKey:@"invoiceKey"];//发票Key
    }
    
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
//    NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
    [self.info setObject:@"192" forKey:@"teamKey"];//球队key
    [self.info setObject:@"206" forKey:@"activityKey"];//球队活动key
    [self.info setObject:@"球球" forKey:@"userName"];//报名人名称
    
    [self.info setObject:[userdef objectForKey:userID] forKey:@"userKey"];//用户Key
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
    addTeamGuestCtrl.delegate = self;
    addTeamGuestCtrl.applyArray = self.applyArray;
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
#pragma mark -- 添加打球人页面代理－－－返回打球人数组
- (void)addGuestListArray:(NSArray *)guestListArray{
    self.applyArray = [NSMutableArray arrayWithArray:guestListArray];
    
    [self.teamApplyTableView reloadData];
}
#pragma mark -- 发票代理
- (void)backAddressKey:(NSString *)addressKey andInvoiceName:(NSString *)name{
    self.invoiceKey = addressKey;
    _invoiceName = name;
    [self.teamApplyTableView reloadData];
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
