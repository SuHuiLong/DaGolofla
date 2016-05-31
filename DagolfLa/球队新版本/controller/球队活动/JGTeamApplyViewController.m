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
#import "JGSignUoPromptCell.h"
#import "JGHTotalPriceCell.h"
//微信
#import "WXApi.h"
#import "payRequsestHandler.h"

#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"

static NSString *const JGActivityBaseInfoCellIdentifier = @"JGActivityBaseInfoCell";
static NSString *const JGTableViewCellIdentifier = @"JGTableViewCell";
static NSString *const JGApplyPepoleCellIdentifier = @"JGApplyPepoleCell";
static NSString *const JGHHeaderLabelCellIdentifier = @"JGHHeaderLabelCell";
static NSString *const JGHApplyListCellIdentifier = @"JGHApplyListCell";
static NSString *const JGSignUoPromptCellIdentifier = @"JGSignUoPromptCell";
static NSString *const JGHTotalPriceCellIdentifier = @"JGHTotalPriceCell";

@interface JGTeamApplyViewController ()<JGApplyPepoleCellDelegate, JGHApplyListCellDelegate, JGAddTeamGuestViewControllerDelegate, JGHAddInvoiceViewControllerDelegate>
{
    UIAlertController *_actionView;
    
    NSInteger _w;
    NSInteger _z;
    NSString *_infoKey;
}

//@property (strong, nonatomic)JGTeamAcitivtyModel *model;//数据模型

@property (nonatomic, strong)NSArray *titleArray;//标题

@property (nonatomic, strong)NSMutableArray *applyArray;//成员数组----添加成员字典

@property (nonatomic, strong)NSMutableDictionary *info;

@property (nonatomic, strong)UIButton *cellClickBtn;//拦截cell点击事件

@property (nonatomic, assign)NSInteger amountPayable;//应付金额
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
//    self.model = [[JGTeamAcitivtyModel alloc]init];
    self.applyArray = [NSMutableArray array];
    self.info = [NSMutableDictionary dictionary];
    self.titleArray = @[@"活动名称", @"活动地址", @"活动日期", @"活动费用", @"嘉宾费用"];
    _realPayPrice = 0;
    _subsidiesPrice = 0;
    _amountPayable = 0;

    //默认添加自己的信息
    if (self.applyArray.count == 0) {
        NSMutableDictionary *applyDict = [NSMutableDictionary dictionary];
        [applyDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:TeamKey] forKey:TeamKey];//球队key
        [applyDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:ActivityKey] forKey:ActivityKey];//球队活动id
        [applyDict setObject:@1 forKey:@"type"];//"是否是球队成员 0: 不是  1：是
        
        [applyDict setObject:[NSString stringWithFormat:@"%ld", (long)_modelss.memberPrice] forKey:@"payMoney"];//实际付款金额
        
        [applyDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];//报名用户key , 没有则是嘉宾
        
        [applyDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"] forKey:@"name"];//姓名
        [applyDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"] forKey:@"mobile"];//手机号
        [applyDict setObject:@"1" forKey:@"isOnlinePay"];//是否线上付款 1-线上
        [applyDict setObject:@0 forKey:@"signUpInfoKey"];//报名信息的timeKey
        [applyDict setObject:@0 forKey:@"timeKey"];//timeKey
        [applyDict setObject:@"1" forKey:@"select"];//付款勾选默认勾
        [self.applyArray addObject:applyDict];
        
        [self countAmountPayable];
    }
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
    
    UINib *signUoPromptNib = [UINib nibWithNibName:@"JGSignUoPromptCell" bundle: [NSBundle mainBundle]];
    [self.teamApplyTableView registerNib:signUoPromptNib forCellReuseIdentifier:JGSignUoPromptCellIdentifier];
    
    UINib *totalPriceCellNib = [UINib nibWithNibName:@"JGHTotalPriceCell" bundle: [NSBundle mainBundle]];
    [self.teamApplyTableView registerNib:totalPriceCellNib forCellReuseIdentifier:JGHTotalPriceCellIdentifier];
}
#pragma mark -- tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        //人员个数
        if (self.applyArray.count > 0) {
            return self.applyArray.count + 2;
        }
        return 2;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
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
    if (self.applyArray.count > 0) {
        if (indexPath.row == self.applyArray.count){
            JGHTotalPriceCell *totalPriceCell = [tableView dequeueReusableCellWithIdentifier:JGHTotalPriceCellIdentifier forIndexPath:indexPath];
            totalPriceCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [totalPriceCell configTotalPrice:_amountPayable];
            return totalPriceCell;
        }else if (indexPath.row == self.applyArray.count+1){
            JGSignUoPromptCell *signUoPromptCell = [tableView dequeueReusableCellWithIdentifier:JGSignUoPromptCellIdentifier forIndexPath:indexPath];
            signUoPromptCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return signUoPromptCell;
        }else{
            JGHApplyListCell *applyListCel = [tableView dequeueReusableCellWithIdentifier:JGHApplyListCellIdentifier forIndexPath:indexPath];
            applyListCel.chooseBtn.tag = indexPath.row;
            applyListCel.deleteBtn.tag = indexPath.row + 100;
            applyListCel.delegate = self;
            applyListCel.selectionStyle = UITableViewCellSelectionStyleNone;
            [applyListCel configDict:_applyArray[indexPath.row]];
            return applyListCel;
        }
    }else{
        if (indexPath.row == 0) {
            JGHTotalPriceCell *totalPriceCell = [tableView dequeueReusableCellWithIdentifier:JGHTotalPriceCellIdentifier];
            totalPriceCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [totalPriceCell configTotalPrice:0];
            return totalPriceCell;
        }else{
            JGSignUoPromptCell *signUoPromptCell = [tableView dequeueReusableCellWithIdentifier:JGSignUoPromptCellIdentifier forIndexPath:indexPath];
            signUoPromptCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return signUoPromptCell;
        }
    }
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
//            if ([_invoiceKey isEqual:[NSNull class]]) {
            [activityNameCell configInvoiceIfo:_invoiceName];
//            }
        }else{
            activityNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [activityNameCell congiftitles:@"实付金额："];
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
    invoiceCtrl.addressKey = _addressKey;
    [self.navigationController pushViewController:invoiceCtrl animated:YES];
}
#pragma mark -- 立即付款
- (IBAction)nowPayBtnClick:(UIButton *)sender {
    // 分别3个创建操作
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *weiChatAction = [UIAlertAction actionWithTitle:@"微信支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //添加微信支付请求
        [self submitInfo:1];
    }];
    UIAlertAction *zhifubaoAction = [UIAlertAction actionWithTitle:@"支付宝支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //添加支付宝支付请求
        [self submitInfo:2];
    }];
    
    _actionView = [UIAlertController alertControllerWithTitle:@"选择支付方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [_actionView addAction:weiChatAction];
    [_actionView addAction:zhifubaoAction];
    [_actionView addAction:cancelAction];
    [self presentViewController:_actionView animated:YES completion:nil];
}

#pragma mark -- 现场付款
- (IBAction)scenePayBtnClick:(UIButton *)sender {
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.applyArray];
    [self.applyArray removeAllObjects];
    NSInteger count = [array count];
    for (int i=0; i<count; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict = array[i];
        if ([[dict objectForKey:@"isOnlinePay"] integerValue] == 1) {
            [dict setObject:@0 forKey:@"isOnlinePay"];//是否线上付款 1-线上
        }
        
        [self.applyArray addObject:dict];
    }
    
    [self submitInfo:3];
}

#pragma mark -- 添加嘉宾
- (void)addApplyPeopleClick{
    JGAddTeamGuestViewController *addTeamGuestCtrl = [[JGAddTeamGuestViewController alloc]initWithNibName:@"JGAddTeamGuestViewController" bundle:nil];
    addTeamGuestCtrl.delegate = self;
    
    addTeamGuestCtrl.applyArray = self.applyArray;
    addTeamGuestCtrl.guestPrice = self.modelss.guestPrice;
    addTeamGuestCtrl.memberPrice = self.modelss.memberPrice;
    [self.navigationController pushViewController:addTeamGuestCtrl animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --  选择嘉宾
- (void)didChooseBtn:(UIButton *)btn{
    NSLog(@"%ld", (long)btn.tag);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict = [self.applyArray objectAtIndex:btn.tag];
    if ([[dict objectForKey:@"select"] integerValue] == 0) {
        [btn setImage:[UIImage imageNamed:@"kuangwx"] forState:UIControlStateNormal];
        [dict setObject:@"1" forKey:@"isOnlinePay"];
        [dict setObject:@"1" forKey:@"select"];
        [self.applyArray replaceObjectAtIndex:btn.tag withObject:dict];
    }else{
        [btn setImage:[UIImage imageNamed:@"kuang"] forState:UIControlStateNormal];
        [dict setObject:@"0" forKey:@"isOnlinePay"];
        [dict setObject:@"0" forKey:@"select"];
        [self.applyArray replaceObjectAtIndex:btn.tag withObject:dict];
    }
    
    //计算价格
    [self countAmountPayable];
}
#pragma mark -- 删除嘉宾
- (void)didSelectDeleteBtn:(UIButton *)btn{
    NSLog(@"%ld", (long)btn.tag);
    [self.applyArray removeObjectAtIndex:btn.tag - 100];
    //计算价格
    [self countAmountPayable];
}
#pragma mark -- 添加打球人页面代理－－－返回打球人数组
- (void)addGuestListArray:(NSArray *)guestListArray{
    self.applyArray = [NSMutableArray arrayWithArray:guestListArray];
    //计算价格
    [self countAmountPayable];
}
#pragma mark -- 计算应付价格
- (void)countAmountPayable{
    _w = 0;
    _z = 0;
    _subsidiesPrice = 0;
    _amountPayable = 0;
    _realPayPrice = 0;
    for (int i=0; i<_applyArray.count; i++) {
        NSDictionary *dict = [NSDictionary dictionary];
        dict = _applyArray[i];
        if ([[dict objectForKey:@"select"]integerValue] == 1) {
            _amountPayable += [[dict objectForKey:@"payMoney"] integerValue];
            
            if ([[dict objectForKey:@"type"]integerValue] == 1) {
                _subsidiesPrice += _modelss.subsidyPrice;
//                _w += 1;
//            }else{
//                _z += 1;
            }
        }
    }

//    _subsidiesPrice = _modelss.subsidyPrice * _w;
//    _amountPayable = _modelss.memberPrice * _w + _modelss.guestPrice * _z;
    _realPayPrice = _amountPayable - _subsidiesPrice;
    
    [self.teamApplyTableView reloadData];
}

#pragma mark -- 发票代理
- (void)backAddressKey:(NSString *)invoiceKey andInvoiceName:(NSString *)name andAddressKey:(NSString *)addressKey{
    self.invoiceKey = invoiceKey;
    self.addressKey = addressKey;
    _invoiceName = name;
    [self.teamApplyTableView reloadData];
}
#pragma mark -- 提交报名信息
- (void)submitInfo:(NSInteger)type{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (_invoiceKey != nil) {
        [self.info setObject:_invoiceKey forKey:@"invoiceKey"];//发票Key
        [self.info setObject:_addressKey forKey:@"addressKey"];//地址Key
    }
    
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    [dict setObject:[userdef objectForKey:userID] forKey:@"appUserKey"];
    
    [self.info setObject:[userdef objectForKey:TeamKey] forKey:TeamKey];//球队key
    [self.info setObject:[userdef objectForKey:ActivityKey] forKey:@"activityKey"];//球队活动key
    [self.info setObject:[userdef objectForKey:@"userName"] forKey:@"userName"];//报名人名称
    
    [self.info setObject:[userdef objectForKey:userID] forKey:@"userKey"];//用户Key
    [self.info setObject:@0 forKey:@"timeKey"];//timeKey
    
    [dict setObject:_applyArray forKey:@"teamSignUpList"];//报名人员数组
    [dict setObject:_info forKey:@"info"];
    [[JsonHttp jsonHttp]httpRequest:@"team/doTeamActivitySignUp" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        NSLog(@"data == %@", data);
        _infoKey = [data objectForKey:@"infoKey"];
        if (type == 1) {
            [self weChatPay];
        }else if (type == 2){
            [self zhifubaoPay];
        }else{
            //跳转分组页面
            JGTeamGroupViewController *groupCtrl = [[JGTeamGroupViewController alloc]init];
            groupCtrl.teamActivityKey = [_modelss.timeKey integerValue];
            [self.navigationController pushViewController:groupCtrl animated:YES];
        }
    }];
}
#pragma mark -- 微信支付
- (void)weChatPay{
    NSLog(@"微信支付");
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"weChatNotice" object:nil];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@2 forKey:@"orderType"];
    [dict setObject:_infoKey forKey:@"srcKey"];
    [dict setObject:@"活动报名" forKey:@"name"];
    [dict setObject:@"活动微信订单" forKey:@"otherInfo"];
//    if (_invoiceKey != nil) {
//        [dict setObject:_addressKey forKey:@"addressKey"];
//        [dict setObject:_invoiceKey forKey:@"invoiceKey"];
//    }
    
    [[JsonHttp jsonHttp]httpRequest:@"pay/doPayWeiXin" JsonKey:@"payInfo" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        NSDictionary *dict = [data objectForKey:@"pay"];
        //微信
        if (dict) {
            PayReq *request = [[PayReq alloc] init];
            request.openID       = [dict objectForKey:@"appid"];
            request.partnerId    = [dict objectForKey:@"partnerid"];
            request.prepayId     = [dict objectForKey:@"prepayid"];
            request.package      = [dict objectForKey:@"Package"];
            request.nonceStr     = [dict objectForKey:@"noncestr"];
            request.timeStamp    =[[dict objectForKey:@"timestamp"] intValue];
            request.sign         = [dict objectForKey:@"sign"];
            
            [WXApi sendReq:request];
        }
    }];
}
#pragma mark -- 微信支付成功后返回的通知
- (void)notice:(id)not{
    //跳转分组页面
    JGTeamGroupViewController *groupCtrl = [[JGTeamGroupViewController alloc]init];
    groupCtrl.teamActivityKey = [_modelss.timeKey integerValue];
    [self.navigationController pushViewController:groupCtrl animated:YES];
}
#pragma mark -- 支付宝
- (void)zhifubaoPay{
    NSLog(@"支付宝支付");
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@2 forKey:@"orderType"];
    [dict setObject:_infoKey forKey:@"srcKey"];
    [dict setObject:@"活动报名" forKey:@"name"];
    [dict setObject:@"活动支付宝订单" forKey:@"otherInfo"];
    if (_invoiceKey != nil) {
        [dict setObject:_addressKey forKey:@"addressKey"];
        [dict setObject:_invoiceKey forKey:@"invoiceKey"];
    }
    
    [[JsonHttp jsonHttp]httpRequest:@"pay/doPayByAliPay" JsonKey:@"payInfo" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        NSLog(@"%@",[data objectForKey:@"query"]);
        [[AlipaySDK defaultService] payOrder:[data objectForKey:@"query"] fromScheme:@"dagolfla" callback:^(NSDictionary *resultDic) {
            
            //跳转分组页面
            JGTeamGroupViewController *groupCtrl = [[JGTeamGroupViewController alloc]init];
            groupCtrl.teamActivityKey = [_modelss.timeKey integerValue];
            [self.navigationController pushViewController:groupCtrl animated:YES];
            NSLog(@"支付宝=====%@",resultDic[@"resultStatus"]);
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                NSLog(@"陈公");
                
            } else if ([resultDic[@"resultStatus"] isEqualToString:@"4000"]) {
                NSLog(@"失败");
            } else if ([resultDic[@"resultStatus"] isEqualToString:@"6002"]) {
                NSLog(@"网络错误");
            } else if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
                NSLog(@"取消支付");
            } else {
                NSLog(@"支付失败");
            }
        }];
    }];
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
