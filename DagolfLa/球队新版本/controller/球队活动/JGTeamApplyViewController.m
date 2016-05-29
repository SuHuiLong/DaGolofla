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
    
    UINib *signUoPromptNib = [UINib nibWithNibName:@"JGSignUoPromptCell" bundle: [NSBundle mainBundle]];
    [self.teamApplyTableView registerNib:signUoPromptNib forCellReuseIdentifier:JGSignUoPromptCellIdentifier];
    
    UINib *totalPriceCellNib = [UINib nibWithNibName:@"JGHTotalPriceCell" bundle: [NSBundle mainBundle]];
    [self.teamApplyTableView registerNib:totalPriceCellNib forCellReuseIdentifier:JGHTotalPriceCellIdentifier];
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
            static int i = 0;
            static int y = 0;
            for (NSDictionary *dict in _applyArray) {
                if ([[dict objectForKey:@"isOnlinePay"]integerValue] == 1) {
                    i += 1;
                }else{
                    y += 1;
                }
            }
            
            _realPayPrice = _modelss.memberPrice * i + _modelss.guestPrice * y;
            _subsidiesPrice = _modelss.subsidyPrice * i;
            
            i = 0;
            y = 0;
            [totalPriceCell configTotalPrice:_realPayPrice];
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
            if ([_invoiceKey isEqual:[NSNull class]]) {
                [activityNameCell configInvoiceIfo:_invoiceName];
            }
        }else{
            activityNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [activityNameCell congiftitles:@"实付金额："];
            static int i = 0;
            static int y = 0;
            for (NSDictionary *dict in _applyArray) {
                if ([[dict objectForKey:@"isOnlinePay"]integerValue] == 1) {
                    i += 1;
                }else{
                    y += 1;
                }
            }
            
            _realPayPrice = _modelss.memberPrice * i + _modelss.guestPrice * y;
            _subsidiesPrice = _modelss.subsidyPrice * i;
            
            i = 0;
            y = 0;
            
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
        [dict setObject:@0 forKey:@"orderType"];
        [dict setObject:@527 forKey:@"srcKey"];
        [[JsonHttp jsonHttp]httpRequest:@"pay/doPayWeiXin" JsonKey:@"payInfo" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
            NSLog(@"errType == %@", errType);
        } completionBlock:^(id data) {
            
            NSDictionary *dict = [data objectForKey:@"pay"];
            //微信
            //创建支付签名对象
            //        payRequsestHandler *req = [payRequsestHandler alloc];
            
            //初始化支付签名对象
            //        [req init:@"wxdcdc4e20544ed728" mch_id:[dict objectForKey:@"partnerid"]];
            //设置秘钥
            //        [req setKey:[[data objectForKey:@"rows"] objectForKey:@"key"]];
            
            //        NSMutableDictionary *dict1 = [req sendPay_demoPrePayid:[dict objectForKey:@"prepayid"]];
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
    }];
    
    UIAlertAction *zhifubaoAction = [UIAlertAction actionWithTitle:@"支付宝支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"支付宝支付");
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        [dict setObject:@0 forKey:@"orderType"];
        [dict setObject:@527 forKey:@"srcKey"];
        [[JsonHttp jsonHttp]httpRequest:@"pay/doPayByAliPay" JsonKey:@"payInfo" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
            NSLog(@"errType == %@", errType);
        } completionBlock:^(id data) {
            
            /*
             partner="2088911674587712"&seller_id="2088911674587712"&out_trade_no="Order_583"&subject="测试"&body="奶奶的"&total_fee="0.01"&notify_url="http://xiaoar.oicp.net:16681/pay/onCallbackAlipay"&service="mobile.securitypay.pay"&payment_type="1"&_input_charset="utf-8"&it_b_pay="30m"&sign="EbYezU%2BZDT%2FFwDDMTRnxgHztxZ9U2r%2BuB9hzo874Tkp1qSY1z3Nyean2%2B%2BPwFocbXg64VpYF4hNvnNYxAVF8NsSJRgZhghGsDf8XVqV3Q9Z%2FvJOchyUjalgl9D8EPoxLWaedkmT%2Bygvkbuekm5Q2VLU%2BOiuL8ofslX79eKNzQFE%3D"&sign_type="RSA"
             */
            
            NSLog(@"%@",[data objectForKey:@"query"]);
            [[AlipaySDK defaultService] payOrder:[data objectForKey:@"query"] fromScheme:@"dagolfla" callback:^(NSDictionary *resultDic) {
                
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
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] removeObserver:self];
            }];
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
    if ([_invoiceKey isKindOfClass:[NSNull class]]) {
        [self.info setObject:_invoiceKey forKey:@"invoiceKey"];//发票Key
        //地址Key
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
    [dict setObject:@"0" forKey:@"isOnlinePay"];
    [dict setObject:@"0" forKey:@"select"];
    [self.applyArray replaceObjectAtIndex:btn.tag withObject:dict];
    [self.teamApplyTableView reloadData];
}
#pragma mark -- 删除嘉宾
- (void)didSelectDeleteBtn:(UIButton *)btn{
    NSLog(@"%ld", (long)btn.tag);
    
    [self.applyArray removeObjectAtIndex:btn.tag - 100];
    [self.teamApplyTableView reloadData];
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
