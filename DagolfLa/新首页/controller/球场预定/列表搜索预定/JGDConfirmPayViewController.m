//
//  JGDConfirmPayViewController.m
//  DagolfLa
//
//  Created by 東 on 16/12/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDConfirmPayViewController.h"
#import "JGDPaySuccessViewController.h"

#import "JGDCostumTableViewCell.h"

#import "JGDSetBusinessPWDViewController.h"
#import "VipCardOrderDetailViewController.h"

#import "WCLPassWordView.h"
#import <AlipaySDK/AlipaySDK.h>

@interface JGDConfirmPayViewController () <UITableViewDelegate, UITableViewDataSource, WCLPassWordViewDelegate>

@property (nonatomic, strong) UITableView *payTableView;

@property (nonatomic, assign) NSInteger section2Num;

@property (nonatomic, assign) CGFloat money;

@property (nonatomic, strong) UILabel *leftMoneyTitle; // 账户余额

@property (nonatomic, strong) UIImageView *selectView;

@property (nonatomic, strong) NSMutableDictionary *commitDic;

@property (nonatomic, strong)WCLPassWordView *passWordView;

@property (nonatomic, strong)UIView *bgView;

@property (nonatomic, strong)UISwitch *empowerSwitch;

@property (nonatomic, assign) NSInteger numberOfSections;

@property (nonatomic, copy) NSString *PWDString;

@property (nonatomic, assign) NSInteger payType;

@end

@implementation JGDConfirmPayViewController


#pragma mark -- 监听输入的改变
- (void)passWordDidChange:(WCLPassWordView *)passWord{
    
}
#pragma mark -- 监听输入的完成时
- (void)passWordCompleteInput:(WCLPassWordView *)passWord{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    [dic setObject:[Helper md5HexDigest:_passWordView.textStore] forKey:@"password"];
    
    [[JsonHttp jsonHttp] httpRequestWithMD5:@"user/doCheckPayPassword" JsonKey:nil withData:dic failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            if ([[data objectForKey:@"check"] boolValue]) {
                [self.bgView removeFromSuperview];
                
                self.PWDString = [Helper md5HexDigest:_passWordView.textStore];
                
                NSIndexPath *index1 = [NSIndexPath indexPathForRow:1 inSection:1];
                NSIndexPath *index2 = [NSIndexPath indexPathForRow:2 inSection:1];
                
                if (self.money >= self.payMoney) {
                    
                    self.numberOfSections = 2;
                    [self.payTableView deleteSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:NO];
                    
                    self.section2Num = 2;
                    [self.payTableView insertRowsAtIndexPaths:@[index1] withRowAnimation:NO];
                    

                }else{
                    self.section2Num = 3;
                    [self.payTableView insertRowsAtIndexPaths:@[index1, index2] withRowAnimation:NO];
                    

                }
                self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithTitle:@"" style:(UIBarButtonItemStyleDone) target:self action:nil];

            }else{
                [LQProgressHud showMessage:@"密码输入有误"];
            }
        }
    }];
}
#pragma mark -- 监听开始输入
- (void)passWordBeginInput:(WCLPassWordView *)passWord{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithTitle:@"" style:(UIBarButtonItemStyleDone) target:self action:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"在线支付";
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"consult"] style:(UIBarButtonItemStylePlain) target:self action:@selector(askAct)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    [self balanceDownd];
    
    [self tableViewDraw];
    
    
    // Do any additional setup after loading the view.
}

- (void)balanceDownd{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    
    [[ShowHUD showHUD] showAnimationWithText:@"加载中…" FromView:self.view];
    
    [[JsonHttp jsonHttp]httpRequest:@"user/getUserBalance" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        
    } completionBlock:^(id data) {
        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            self.money = [[data objectForKey:@"money"] floatValue];
            //            self.hasUserRealName = [data objectForKey:@"hasUserRealName"];
            //            self.isSetPayPassWord = [data objectForKey:@"isSetPayPassWord"];
            //            self.hasUserBankCard = [data objectForKey:@"hasUserBankCard"];
            //            self.name = [data objectForKey:@"name"];
            //
            self.leftMoneyTitle.text = [NSString stringWithFormat:@"可用余额 ¥ %.0f",self.money];
            
        }
    }];
}

- (void)tableViewDraw{
    
    self.section2Num = 1;
    self.numberOfSections = 3;
    self.payTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64 * ProportionAdapter) style:(UITableViewStyleGrouped)];
    self.payTableView.delegate = self;
    self.payTableView.dataSource = self;
    [self.view addSubview:self.payTableView];
    
    
    self.payTableView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [self.payTableView registerClass:[JGDCostumTableViewCell class] forCellReuseIdentifier:@"custCell"];
    
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, screenHeight - 200 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 45 * ProportionAdapter)];
    confirmBtn.backgroundColor = [UIColor colorWithHexString:@"#fc5a01"];
    [confirmBtn setTitle:@"立即支付" forState:(UIControlStateNormal)
     ];
    [confirmBtn addTarget:self action:@selector(payAct:) forControlEvents:(UIControlEventTouchUpInside)];
    confirmBtn.layer.cornerRadius = 6;
    confirmBtn.clipsToBounds = YES;
    confirmBtn.tag = 300;
    [self.view addSubview:confirmBtn];
    
    UIButton *laterBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, screenHeight - 135 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 45 * ProportionAdapter)];
    [laterBtn setTitleColor:[UIColor colorWithHexString:@"#fc5a01"] forState:(UIControlStateNormal)];
    [laterBtn setTitle:@"稍后支付" forState:(UIControlStateNormal)
     ];
    [laterBtn addTarget:self action:@selector(payAct:) forControlEvents:(UIControlEventTouchUpInside)];
    laterBtn.layer.borderWidth = 0.5 * ProportionAdapter;
    laterBtn.layer.borderColor = [[UIColor colorWithHexString:@"#fc5a01"] CGColor];
    laterBtn.layer.cornerRadius = 6;
    laterBtn.tag = 301;
    laterBtn.clipsToBounds = YES;
    [self.view addSubview:laterBtn];
}


#pragma mark --  1 确认支付  2 稍后支付

- (void)payAct:(UIButton *)btn{
    
    
    if (btn.tag == 300) {
        
        if (self.empowerSwitch.isOn == YES && self.money >= self.payMoney) {
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            
            [self.commitDic setObject:DEFAULF_USERID forKey:@"userKey"];
            [self.commitDic setObject:self.orderKey forKey:@"orderKey"];
            [self.commitDic setObject:@4 forKey:@"payType"];
            [self.commitDic setObject:self.PWDString forKey:@"payPassword"];
            
            [dic setObject:self.commitDic forKey:@"payInfo"];
            [dic setObject:DEFAULF_USERID forKey:@"userKey"];
            
            [[ShowHUD showHUD] showAnimationWithText:@"加载中…" FromView:self.view];
            
            [[JsonHttp jsonHttp] httpRequestHaveSpaceWithMD5:@"orderPay/doPayByUserAccount" JsonKey:nil withData:dic failedBlock:^(id errType) {
                [[ShowHUD showHUD] hideAnimationFromView:self.view];
                
            } completionBlock:^(id data) {
                [[ShowHUD showHUD] hideAnimationFromView:self.view];
                
                if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                    
                    if (_fromWitchVC == 1) {
                        [self pushToVipOrderDetail];
                    }else{
                        JGDPaySuccessViewController *payVC = [[JGDPaySuccessViewController  alloc] init];
                        payVC.payORlaterPay = 1;
                        payVC.orderKey = self.orderKey;
                        [self.navigationController pushViewController:payVC animated:YES];
                    }
                    
                }
            }];
        }else if (self.empowerSwitch.isOn == YES && self.money != 0) {
            
            if (self.payType == 2) {
                [self weChatPay:YES];
            }else if (self.payType == 1){
                [self zhifubaoPay:YES];
                
            }
            
            
        }else if (self.empowerSwitch.isOn == NO || self.money == 0) {
            
            if (self.payType == 2) {
                [self weChatPay:NO];
            }else if (self.payType == 1){
                [self zhifubaoPay:NO];
            }
            
        }
        
        
    }else if (btn.tag == 301) {
        
        if (_fromWitchVC == 1) {
            [self pushToVipOrderDetail];
        }else{
            JGDPaySuccessViewController *payVC = [[JGDPaySuccessViewController  alloc] init];
            payVC.payORlaterPay = 2;
            payVC.orderKey = self.orderKey;
            [self.navigationController pushViewController:payVC animated:YES];
        }
    }
    
    
}


#pragma mark -- 微信支付
- (void)weChatPay:(BOOL )isWithBalance{
    NSLog(@"微信支付");
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"weChatNotice" object:nil];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *payInfoDic = [[NSMutableDictionary alloc] init];
    
    [payInfoDic setObject:DEFAULF_USERID forKey:@"userKey"];
    [payInfoDic setObject:self.orderKey forKey:@"orderKey"];
    [payInfoDic setObject:[NSNumber numberWithInteger:self.payType] forKey:@"payType"];
    if (isWithBalance) {
        [payInfoDic setObject:self.PWDString forKey:@"payPassword"];
    }
    
    [dic setObject:payInfoDic forKey:@"payInfo"];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    
    
    [[JsonHttp jsonHttp]httpRequest:@"orderPay/doPayWeiXin" JsonKey:nil withData:dic requestMethod:@"POST" failedBlock:^(id errType) {
        [[ShowHUD showHUD]showToastWithText:@"请检查您的网络" FromView:self.view];
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
        else
        {
            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
        }
    }];
}
#pragma mark -- 微信支付成功后返回的通知
- (void)notice:(NSNotification *)not{
    NSInteger secess = [[not.userInfo objectForKey:@"secess"] integerValue];
    if (secess == 1) {
        
        if (_fromWitchVC == 1) {
            [self pushToVipOrderDetail];
        }else{
            JGDPaySuccessViewController *payVC = [[JGDPaySuccessViewController  alloc] init];
            payVC.payORlaterPay = 1;
            payVC.orderKey = self.orderKey;
            [self.navigationController pushViewController:payVC animated:YES];
        }
    }else if (secess == 2){
        [[ShowHUD showHUD]showToastWithText:@"支付已取消！" FromView:self.view];
        [self doCancelOrderPay];
    }else{
        [[ShowHUD showHUD]showToastWithText:@"支付失败！" FromView:self.view];
        [self doCancelOrderPay];
    }
    
    //跳转
    
}


#pragma mark -- 支付宝
- (void)zhifubaoPay:(BOOL )isWithBalance{
    NSLog(@"支付宝支付");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *payInfoDic = [[NSMutableDictionary alloc] init];
    
    [payInfoDic setObject:DEFAULF_USERID forKey:@"userKey"];
    [payInfoDic setObject:self.orderKey forKey:@"orderKey"];
    [payInfoDic setObject:[NSNumber numberWithInteger:self.payType] forKey:@"payType"];
    if (isWithBalance) {
        [payInfoDic setObject:self.PWDString forKey:@"payPassword"];
    }
    
    [dic setObject:payInfoDic forKey:@"payInfo"];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    
    
    [[JsonHttp jsonHttp]httpRequest:@"orderPay/doPayByAliPay" JsonKey:nil withData:dic requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        NSLog(@"%@",[data objectForKey:@"query"]);
        
        [[AlipaySDK defaultService] payOrder:[data objectForKey:@"query"] fromScheme:@"dagolfla" callback:^(NSDictionary *resultDic) {
            
            NSLog(@"支付宝=====%@",resultDic[@"resultStatus"]);
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                NSLog(@"成功！");
                if (_fromWitchVC == 1) {
                    [self pushToVipOrderDetail];
                }else{
                    JGDPaySuccessViewController *payVC = [[JGDPaySuccessViewController  alloc] init];
                    payVC.payORlaterPay = 1;
                    payVC.orderKey = self.orderKey;
                    [self.navigationController pushViewController:payVC animated:YES];
                }
            } else if ([resultDic[@"resultStatus"] isEqualToString:@"4000"]) {
                NSLog(@"失败");
                [[ShowHUD showHUD]showToastWithText:@"支付失败！" FromView:self.view];
                [self doCancelOrderPay];
                
            } else if ([resultDic[@"resultStatus"] isEqualToString:@"6002"]) {
                NSLog(@"网络错误");
                [[ShowHUD showHUD]showToastWithText:@"网络异常，支付失败！" FromView:self.view];
                [self doCancelOrderPay];

            } else if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
                NSLog(@"取消支付");
                [[ShowHUD showHUD]showToastWithText:@"支付已取消！" FromView:self.view];
                [self doCancelOrderPay];

            } else {
                NSLog(@"支付失败");
                [[ShowHUD showHUD]showToastWithText:@"支付失败！" FromView:self.view];
                [self doCancelOrderPay];

            }
            
            //跳转
            
            
        }];
    }];
}

#pragma mark --- 咨询

- (void)askAct{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@", Company400];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //JGDCostumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"custCell"];
    JGDCostumTableViewCell *cell = [[JGDCostumTableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        
        UILabel *priceTitle = [self lablerect:CGRectMake(10 * ProportionAdapter, 0, 200, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:(17 * ProportionAdapter) text:@"线上支付金额" textAlignment:(NSTextAlignmentLeft)];
        [cell.contentView addSubview:priceTitle];
        
        UILabel *sumPrice = [self lablerect:CGRectMake(screenWidth - 110 * ProportionAdapter, 0, 100 * ProportionAdapter, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(17 * ProportionAdapter) text:[NSString stringWithFormat:@"¥ %.0f", self.payMoney] textAlignment:(NSTextAlignmentRight)];
        [cell.contentView addSubview:sumPrice];
        
    }else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            UILabel *titleLB = [self lablerect:CGRectMake(10 * ProportionAdapter, 0, 260, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:(17 * ProportionAdapter) text:@"授权系统从君高账户余额抵扣" textAlignment:(NSTextAlignmentLeft)];
            [cell.contentView addSubview:titleLB];
            
            // 是否授权从君高抵扣 20811.45
            self.empowerSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(315 * ProportionAdapter, 10 * ProportionAdapter, 50 * ProportionAdapter, 35 * ProportionAdapter)];
            [self.empowerSwitch addTarget:self action:@selector(empowerAct:) forControlEvents:(UIControlEventTouchUpInside)];
            [cell.contentView addSubview:self.empowerSwitch];
            
            self.leftMoneyTitle = [self lablerect:CGRectMake(10 * ProportionAdapter, 45 * ProportionAdapter, 200, 25 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(14 * ProportionAdapter) text:@"可用余额¥0" textAlignment:(NSTextAlignmentLeft)];
            [cell.contentView addSubview:self.leftMoneyTitle];
            
        }else if (indexPath.row == 1) {
            
            UILabel *leftTitle = [self lablerect:CGRectMake(10 * ProportionAdapter, 0, 100, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:(17 * ProportionAdapter) text:@"抵扣金额" textAlignment:(NSTextAlignmentLeft)];
            [cell.contentView addSubview:leftTitle];
            
            CGFloat deductible = 0;
            if (self.money >= self.payMoney) {
                deductible = self.payMoney;
            }else{
                deductible = self.money;
            }
            UILabel *deductiblePrice = [self lablerect:CGRectMake(screenWidth - 110 * ProportionAdapter, 0, 100 * ProportionAdapter, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(17 * ProportionAdapter) text:[NSString stringWithFormat:@"¥ %.0f",deductible] textAlignment:(NSTextAlignmentRight)];
            [cell.contentView addSubview:deductiblePrice];
            
        } else{
            
            UILabel *leftTitle = [self lablerect:CGRectMake(10 * ProportionAdapter, 0, 100, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#fc5a01"] labelFont:(17 * ProportionAdapter) text:@"还需支付" textAlignment:(NSTextAlignmentLeft)];
            [cell.contentView addSubview:leftTitle];
            
            CGFloat otherPay = 0;
            if (self.money >= self.payMoney) {
                otherPay = 0;
            }else{
                otherPay = self.payMoney - self.money;
            }
            UILabel *leftPrice = [self lablerect:CGRectMake(screenWidth - 110 * ProportionAdapter, 0, 100 * ProportionAdapter, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#fc5a01"] labelFont:(17 * ProportionAdapter) text:[NSString stringWithFormat:@"¥ %.0f",otherPay] textAlignment:(NSTextAlignmentRight)];
            [cell.contentView addSubview:leftPrice];
            
        }
        
    }else{ // section 2
        
        if (indexPath.row == 0) {
            
            UILabel *priceTitle = [self lablerect:CGRectMake(10 * ProportionAdapter, 0, 200, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:(17 * ProportionAdapter) text:@"请选择支付方式" textAlignment:(NSTextAlignmentLeft)];
            [cell.contentView addSubview:priceTitle];
            
        }else if (indexPath.row == 1) {
            
            UIImageView *aliPayIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 6.5 *ProportionAdapter, 40 * ProportionAdapter, 37 * ProportionAdapter)];
            aliPayIcon.image = [UIImage imageNamed:@"zhifu"];
            [cell.contentView addSubview:aliPayIcon];
            
            UILabel *titleLB = [self lablerect:CGRectMake(60 * ProportionAdapter, 0, 200, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(17 * ProportionAdapter) text:@"支付宝" textAlignment:(NSTextAlignmentLeft)];
            [cell.contentView addSubview:titleLB];

            
            [cell.contentView addSubview:self.selectView];
            self.payType = 1;
            
        } else{
            
            UIImageView *wechatIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 5 *ProportionAdapter, 40 * ProportionAdapter, 40 * ProportionAdapter)];
            wechatIcon.image = [UIImage imageNamed:@"weixin-2"];
            [cell.contentView addSubview:wechatIcon];
            
            UILabel *titleLB = [self lablerect:CGRectMake(60 * ProportionAdapter, 0, 200, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(17 * ProportionAdapter) text:@"微信支付" textAlignment:(NSTextAlignmentLeft)];
            [cell.contentView addSubview:titleLB];
 
        }
        
    }
    
    return cell;
}


#pragma mark ----- 是否从君高账户抵扣

- (void)empowerAct:(UISwitch *)mySwitch{
    
    NSIndexPath *index1 = [NSIndexPath indexPathForRow:1 inSection:1];
    NSIndexPath *index2 = [NSIndexPath indexPathForRow:2 inSection:1];
    
    if (mySwitch.on == YES) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
        [[JsonHttp jsonHttp]httpRequest:@"user/isSetPayPassWord" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
            NSLog(@"errType == %@", errType);
            [[ShowHUD showHUD]hideAnimationFromView:self.view];
        } completionBlock:^(id data) {
            NSLog(@"data == %@", data);
            
            [[ShowHUD showHUD]hideAnimationFromView:self.view];
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                if ([[data objectForKey:@"isSetPayPassWord"] integerValue] == 1) {

                    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStyleDone) target:self action:@selector(bgRemoveAct:)];
                    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];

                    // 弹出余额支付
                    
                    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight -64)];
                    _bgView.backgroundColor = [UIColor blackColor];
                    _bgView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
                    [self.view addSubview:_bgView];
                    
                    UILabel *tipLB = [self lablerect:CGRectMake(10 * ProportionAdapter, 90 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 20 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#ffffff"] labelFont:(19 * ProportionAdapter) text:@"请输入APP交易密码，授权从余额扣款。" textAlignment:(NSTextAlignmentCenter)];
                    [_bgView addSubview:tipLB];
                    //密码输入框
                    _passWordView = [[[NSBundle mainBundle]loadNibNamed:@"WCLPassWordView" owner:self options:nil]lastObject];
                    _passWordView.frame = CGRectMake(10 *ProportionAdapter, 130 *ProportionAdapter, screenWidth - 20 * ProportionAdapter, 50 *ProportionAdapter);
                    _passWordView.squareWidth = 59 * ProportionAdapter;
                    _passWordView.delegate = self;
                    _passWordView.backgroundColor = [UIColor whiteColor];
                    [_bgView addSubview:_passWordView];
                    
                    [self.view bringSubviewToFront:self.bgView];
                    
                }else{
                    [mySwitch setOn:NO];
                    [Helper alertViewWithTitle:@"您还没有交易密码，无法提现，是否现在设置？" withBlockCancle:^{
                        
                    } withBlockSure:^{
                        JGDSetBusinessPWDViewController *passNOCtrl = [[JGDSetBusinessPWDViewController alloc]init];
                        [self.navigationController pushViewController:passNOCtrl animated:YES];
                    } withBlock:^(UIAlertController *alertView) {
                        [self presentViewController:alertView animated:YES completion:nil];
                    }];
                }
            }
        }];
        

        
    }else{
        
        if (self.section2Num == 2) {
            self.section2Num = 1;
            [self.payTableView deleteRowsAtIndexPaths:@[index1] withRowAnimation:YES];
        }else if (self.section2Num == 3) {
            self.section2Num = 1;
            [self.payTableView deleteRowsAtIndexPaths:@[index1, index2] withRowAnimation:YES];
        }
        
        
        if (self.numberOfSections == 2) {
            
            self.numberOfSections = 3;
            [self.payTableView insertSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:NO];
            
        }
    }
}

- (void)bgRemoveAct:(UIBarButtonItem *)bar{
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithTitle:@"" style:(UIBarButtonItemStyleDone) target:self action:nil];
    [self.bgView removeFromSuperview];
    [self.empowerSwitch setOn:NO];

}

#pragma mark ---  支付宝 微信 取消支付

- (void)doCancelOrderPay{
    
    [[JsonHttp jsonHttp] httpRequestWithMD5:@"orderPay/doCancelOrderPay" JsonKey:nil withData:@{@"orderKey": self.orderKey} failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
//    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 60 * ProportionAdapter)];
//    backView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
//    
//    UILabel *timeLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 50 * ProportionAdapter)];
//    timeLB.backgroundColor = [UIColor colorWithHexString:@"#fefaf3"];
//    timeLB.text = @"请在30分钟内完成支付";
//    timeLB.textAlignment = NSTextAlignmentCenter;
//    timeLB.textColor = [UIColor colorWithHexString:@"#e88800"];
//    [backView addSubview:timeLB];
    
    if (section == 0) {
        UILabel *backLB = [self lablerect:CGRectMake(0, 0, screenWidth, 10 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#eeeeee"] labelFont:0 text:@"" textAlignment:(NSTextAlignmentCenter)];

        return backLB;
    }else{
        UILabel *backLB = [self lablerect:CGRectMake(0, 0, screenWidth, 10 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#eeeeee"] labelFont:0 text:@"" textAlignment:(NSTextAlignmentCenter)];

        return backLB;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2 && indexPath.row != 0) {
        
        if (indexPath.row == 1) {
            self.payType = 1;
            
        }else if (indexPath.row == 2) {
            self.payType = 2;
            
        }
        
        JGDCostumTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell.contentView addSubview:self.selectView];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return section == 0 ? 0.001 : 10 * ProportionAdapter;
    return 10 * ProportionAdapter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 0) {
        return 75 * ProportionAdapter;
    }else{
        return 50 * ProportionAdapter;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return self.section2Num;
    }else{
        return 3;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.numberOfSections;
}

- (void)pushToVipOrderDetail{
    VipCardOrderDetailViewController *vc = [[VipCardOrderDetailViewController alloc] init];
    vc.orderKey = [NSString stringWithFormat:@"%@", _orderKey];
    [self.navigationController pushViewController:vc animated:YES];
}




- (UIImageView *)selectView{
    if (!_selectView) {
        _selectView = [[UIImageView alloc] initWithFrame:CGRectMake(343 * ProportionAdapter, 13 *ProportionAdapter, 22 * ProportionAdapter, 22 * ProportionAdapter)];
        _selectView.image = [UIImage imageNamed:@"icon-select"];
    }
    
    if ([self.payTableView.subviews containsObject:_selectView]) {
        [_selectView removeFromSuperview];
    }
    
    return _selectView;
}

//  封装cell方法
- (UILabel *)lablerect:(CGRect)rect labelColor:(UIColor *)color labelFont:(NSInteger)font text:(NSString *)text textAlignment:(NSTextAlignment )alignment{
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = alignment;
    label.frame = rect;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font];
    label.text = text;
    return label;
}

- (NSMutableDictionary *)commitDic{
    if (!_commitDic) {
        _commitDic = [[NSMutableDictionary alloc] init];
    }
    return _commitDic;
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
