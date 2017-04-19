//
//  JGDOrderDetailViewController.m
//  DagolfLa
//
//  Created by 東 on 16/12/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDOrderDetailViewController.h"
#import "JGDOrderDetailTableViewCell.h"

#import "JGDConfirmPayViewController.h"
#import "JGDPaySuccessViewController.h"
#import "JGDCourtDetailViewController.h"

@interface JGDOrderDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *orderTableViwe;

@property (nonatomic, strong) NSMutableArray *orderTitleArray;
@property (nonatomic, strong) NSArray *reserveTitleArray;

@property (nonatomic, strong) NSMutableArray *orderDetailArray;
@property (nonatomic, strong) NSMutableArray *reserveDetailArray;

@property (nonatomic, assign) NSInteger serviceDetailsHeight;

@property (nonatomic, strong) NSMutableDictionary *dataDic;

@property (nonatomic, copy) NSString *customerTelephone;

@property (nonatomic, strong) UIView *cancelView; // 取消订单的弹窗
@property (nonatomic, strong) UIView *shitaView; // 底部按钮
@property (nonatomic, strong) UIView *cancelBackView;

@property (nonatomic, strong) NSMutableArray *reasonArray;

@end

@implementation JGDOrderDetailViewController


//  解析数据
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:(UIBarButtonItemStyleDone) target:self action:@selector(backBtn)];
    leftBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBar;
    
    [self loadData];
}

- (void)backBtn{
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        // 取消订单
        if ([vc isKindOfClass:[JGDCourtDetailViewController class]] && [[self.dataDic objectForKey:@"stateButtonString"] isEqualToString:@"订单失效"]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.orderKey forKey:@"orderKey"];
    [dic setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"orderKey=%@dagolfla.com", self.orderKey]] forKey:@"md5"];
    
    [[ShowHUD showHUD] showAnimationWithText:@"加载中…" FromView:self.view];
    
    [[JsonHttp jsonHttp]httpRequest:@"bookingOrder/getOrderInfo" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        
    } completionBlock:^(id data) {
        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            if ([data objectForKey:@"customerTelephone"]) {
                self.customerTelephone = [data objectForKey:@"customerTelephone"];
            }else{
                self.customerTelephone = @"";
            }
            
            if ([data objectForKey:@"order"]) {
                self.dataDic = [data objectForKey:@"order"];
                
                self.orderDetailArray = [[NSMutableArray alloc] init];
                self.reserveDetailArray = [[NSMutableArray alloc] init];
                
                NSArray *orderKeyArray = [NSArray arrayWithObjects: @"ordersn", @"stateShowString", @"createTime", @"totalMoney", @"payType", @"payMoney", nil];
                NSArray *reserveKeyArray = [NSArray arrayWithObjects:@"ballName", [self.dataDic objectForKey:@"confirmedTeeTime"] ? @"confirmedTeeTime" : @"teeTime", @"userSum", @"playPersonNames", @"userMobile", @"servicePj", nil];
                
                // section 0
                for (int i = 0; i < [orderKeyArray count]; i ++) {
                    if ([self.dataDic objectForKey:orderKeyArray[i]]) {
                        
                        
                        if (i == 0) {
                            [self.orderDetailArray addObject:[NSString stringWithFormat:@"%@", [self.dataDic objectForKey:orderKeyArray[i]]]];
                            
                        }else if (i == 1) {
                            [self.orderDetailArray addObject:[NSString stringWithFormat:@"%@", [self.dataDic objectForKey:orderKeyArray[i]]]];
                            
                        }else if (i == 2) {
                            [self.orderDetailArray addObject:[Helper stringFromDateString:[self.dataDic objectForKey:@"createTime"] withFormater:@"yyyy.MM.dd  HH:mm"]];
                            
                            
                        }else if (i == 3) {
                            [self.orderDetailArray addObject:[NSString stringWithFormat:@"¥ %@", [self.dataDic objectForKey:orderKeyArray[i]]]];
                            
                        }else if (i == 4) {
                            if ([[self.dataDic objectForKey:@"payType"] integerValue] == 0) {
                                [self.orderDetailArray addObject:@"全额预付"];
                            }else if ([[self.dataDic objectForKey:@"payType"] integerValue] == 1) {
                                [self.orderDetailArray addObject:@"部分预付"];
                            }else if ([[self.dataDic objectForKey:@"payType"] integerValue] == 2) {
                                [self.orderDetailArray addObject:@"球场现付"];
                                self.orderTitleArray[5] = @"已付押金：";
                            }
                        }else if (i == 5) {
                            
                            NSInteger payManey = [[self.dataDic objectForKey:@"dedBalanceMoney"] integerValue] + [[self.dataDic objectForKey:@"payMoney"] integerValue];
                            
                            [self.orderDetailArray addObject:[NSString stringWithFormat:@"¥ %td", payManey]];
                            
                        }
                        
                    }else{
                        [self.orderDetailArray addObject:@""];
                    }
                }
                
                // section 1
                for (int i = 0; i < [reserveKeyArray count]; i ++) {
                    if ([self.dataDic objectForKey:reserveKeyArray[i]]) {
                        NSString *dateString = [self.dataDic objectForKey:reserveKeyArray[i]];
                        
                        if (i == 1) {
                            
                            [self.reserveDetailArray addObject:[Helper stringFromDateString:dateString withFormater:@"yyyy.MM.dd EEE HH:mm"]];
                            
                        }else{
                            [self.reserveDetailArray addObject:[NSString stringWithFormat:@"%@", [self.dataDic objectForKey:reserveKeyArray[i]]]];
                            
                        }
                        
                        
                    }else{
                        [self.reserveDetailArray addObject:@""];
                    }
                }
                
                //                // 底部按钮
                
                self.shitaView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight - 64 - 50 * ProportionAdapter, screenWidth, 50 * ProportionAdapter)];
                self.shitaView.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
                NSString *stateString = [self.dataDic objectForKey:@"stateButtonString"];
                
                if ([stateString isEqualToString:@"待付款"]) {
                    NSArray *tilteArray = [NSArray arrayWithObjects:@"立即支付", @"取消订单", nil];
                    for (int i = 0; i < 2; i ++) {
                        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 * ProportionAdapter + i * 230 * ProportionAdapter, 10 * ProportionAdapter, 125 * ProportionAdapter, 30 * ProportionAdapter)];
                        [cancelBtn setTitle:tilteArray[i] forState:(UIControlStateNormal)];
                        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14 * ProportionAdapter];
                        cancelBtn.layer.borderWidth = 0.5 * ProportionAdapter;
                        cancelBtn.layer.borderColor = [[UIColor colorWithHexString:@"#fc5a01"] CGColor];
                        cancelBtn.layer.cornerRadius = 6;
                        cancelBtn.clipsToBounds = YES;
                        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#fc5a01"] forState:(UIControlStateNormal)];
                        cancelBtn.tag = 200 + i;
                        [cancelBtn addTarget:self action:@selector(confirORwaitAct:) forControlEvents:(UIControlEventTouchUpInside)];
                        [self.shitaView addSubview:cancelBtn];
                    }
                    
                    [self.view addSubview:self.shitaView];
                    
                }else if ([@"已付款，待分配，待确认，已确认" containsString:stateString] && [[data objectForKey:@"isCancelOrder"] integerValue] == 1) {
                    
                    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake( 240 * ProportionAdapter, 10 * ProportionAdapter, 125 * ProportionAdapter, 30 * ProportionAdapter)];
                    [cancelBtn setTitle:@"取消订单" forState:(UIControlStateNormal)];
                    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14 * ProportionAdapter];
                    cancelBtn.layer.borderWidth = 0.5 * ProportionAdapter;
                    cancelBtn.layer.borderColor = [[UIColor colorWithHexString:@"#fc5a01"] CGColor];
                    cancelBtn.layer.cornerRadius = 6;
                    cancelBtn.clipsToBounds = YES;
                    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#fc5a01"] forState:(UIControlStateNormal)];
                    cancelBtn.tag = 201;
                    [cancelBtn addTarget:self action:@selector(confirORwaitAct:) forControlEvents:(UIControlEventTouchUpInside)];
                    [self.shitaView addSubview:cancelBtn];
                    
                    [self.view addSubview:self.shitaView];
                    
                }else{
                    self.orderTableViwe.frame = CGRectMake(0, 0, screenWidth, screenHeight - 64 * ProportionAdapter);
                }
                
                [self.orderTableViwe reloadData];
                
            }
        }
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单详情";
    
    [self orderTableV];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"consult"] style:(UIBarButtonItemStyleDone) target:self action:@selector(askAct)];
    rightBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)askAct{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@", self.customerTelephone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)confirORwaitAct:(UIButton *)btn {
    // pay
    if (btn.tag == 200) {
        JGDConfirmPayViewController *payVC = [[JGDConfirmPayViewController alloc] init];
        payVC.payMoney = [[self.dataDic objectForKey:@"money"] floatValue];
        payVC.orderKey = [self.dataDic objectForKey:@"timeKey"];
        [self.navigationController pushViewController:payVC animated:YES];
        
    }else{
        // cancel
        [self.view addSubview:self.cancelBackView];
    }
}

- (void)orderTableV{
    
    self.orderTableViwe = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64 - 50 * ProportionAdapter) style:(UITableViewStyleGrouped)];
    self.orderTableViwe.delegate = self;
    self.orderTableViwe.dataSource = self;
    
    [self.view addSubview:self.orderTableViwe];
    self.orderTableViwe.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.orderTableViwe registerClass:[JGDOrderDetailTableViewCell class] forCellReuseIdentifier:@"orderCell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //  JGDOrderDetailTableViewCell * cell = [self.orderTableViwe dequeueReusableCellWithIdentifier:@"orderCell"];
    JGDOrderDetailTableViewCell * cell = [[JGDOrderDetailTableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        
        cell.titleLB.text = self.orderTitleArray[indexPath.row];
        cell.detailLB.text = self.orderDetailArray[indexPath.row];
    }else{
        if (indexPath.row == 0) {
            cell.detailLB.textColor = [UIColor colorWithHexString:@"#32b14d"];
        }else if (indexPath.row == 1) {
            cell.detailLB.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:15 * ProportionAdapter];
        }else if (indexPath.row == 3) {
            CGFloat height = [Helper textHeightFromTextString:self.reserveDetailArray[3] width:270 * ProportionAdapter fontSize:15 * ProportionAdapter];
            cell.detailLB.frame = CGRectMake(90 * ProportionAdapter, 0, 270 * ProportionAdapter, height >= 22 * ProportionAdapter ? height : 22 * ProportionAdapter);
        }
        cell.titleLB.text = self.reserveTitleArray[indexPath.row];
        cell.detailLB.text = self.reserveDetailArray[indexPath.row];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 6;
    }else if (section == 1) {
        return 6;
    }else{
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = 0.0;
    if ([self.reserveDetailArray count] > 3) {
        height = [Helper textHeightFromTextString:self.reserveDetailArray[3] width:270 * ProportionAdapter fontSize:15 * ProportionAdapter];
    }
    
    if (indexPath.section == 1 && indexPath.row == 3) {
        return height >= 22 * ProportionAdapter ? height : 22 * ProportionAdapter;
        
    }else{
        return 22 * ProportionAdapter;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 70 * ProportionAdapter;
}

- (UIView * )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 70 * ProportionAdapter)];
    backView.backgroundColor = [UIColor whiteColor];
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 10 * ProportionAdapter)];
    grayView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [backView addSubview:grayView];
    
    UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0 * ProportionAdapter, 10 * ProportionAdapter, screenWidth, 50 * ProportionAdapter)];
    titleLB.backgroundColor = [UIColor whiteColor];
    titleLB.font = [UIFont systemFontOfSize:17 * ProportionAdapter];
    
    
    NSString *textString;
    if (section == 0) {
        textString = @"订单信息";
    }else if (section == 1) {
        textString = @"预订内容";
    }else{
        textString = @"其他";
    }
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:textString];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.firstLineHeadIndent = 10 * ProportionAdapter;
    [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    titleLB.attributedText = text;
    [backView addSubview:titleLB];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59.5 * ProportionAdapter, screenWidth, 0.5 * ProportionAdapter)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [backView addSubview:lineView];
    
    return backView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        return 10 * ProportionAdapter;
    }else if (section == 1) {
        
        CGFloat noteDetailsHeight = [Helper textHeightFromTextString:[self.dataDic objectForKey:@"remark"] width:screenWidth - 110 * ProportionAdapter fontSize:15 * ProportionAdapter];
        if ((noteDetailsHeight + 25 * ProportionAdapter) >= 50 * ProportionAdapter) {
            return noteDetailsHeight + 25 * ProportionAdapter;
        }else{
            return 50 * ProportionAdapter;
        }
    }else{
        
        CGFloat serviceDetailsHeight = [Helper textHeightFromTextString:[self.dataDic objectForKey:@"serviceDetails"] width:screenWidth - 110 * ProportionAdapter fontSize:15];
        
        return serviceDetailsHeight + 10 * ProportionAdapter;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 10 * ProportionAdapter)];
        backView.backgroundColor = [UIColor whiteColor];
        return backView;
        
    }else if (section == 1) {
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 55 * ProportionAdapter)];
        backView.backgroundColor = [UIColor whiteColor];
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 5 * ProportionAdapter, screenWidth, 0.5 * ProportionAdapter)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [backView addSubview:lineView];
        
        UILabel *noteLB = [[UILabel alloc] initWithFrame:CGRectMake(8 * ProportionAdapter, 10 * ProportionAdapter, 80 * ProportionAdapter, 40 * ProportionAdapter)];
        noteLB.text = @"我的备注：";
        noteLB.textAlignment = NSTextAlignmentRight;
        noteLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
        noteLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        [backView addSubview:noteLB];
        
        CGFloat noteDetailsHeight = [Helper textHeightFromTextString:[self.dataDic objectForKey:@"remark"] width:screenWidth - 100 * ProportionAdapter fontSize:15 * ProportionAdapter];
        
        UILabel *noteDetailLB = [self lablerect:CGRectMake(90 * ProportionAdapter, 20 * ProportionAdapter, screenWidth - 100 * ProportionAdapter, noteDetailsHeight) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:(15 * ProportionAdapter) text:[self.dataDic objectForKey:@"remark"] textAlignment:NSTextAlignmentLeft];
        noteDetailLB.numberOfLines = 0;
        [backView addSubview:noteDetailLB];
        return backView;
    }else{
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 100 * ProportionAdapter)];
        backView.backgroundColor = [UIColor whiteColor];
        UILabel *oderLB = [[UILabel alloc] initWithFrame:CGRectMake(8 * ProportionAdapter, 0, 80 * ProportionAdapter, 22 * ProportionAdapter)];
        oderLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
        oderLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        oderLB.textAlignment = NSTextAlignmentRight;
        oderLB.text = @"预订说明：";
        
        [backView addSubview:oderLB];
        
        CGFloat serviceDetailsHeight = [Helper textHeightFromTextString:[self.dataDic objectForKey:@"serviceDetails"] width:screenWidth - 110 * ProportionAdapter fontSize:15];
        
        
        UILabel *oderDetailLB = [[UILabel alloc] initWithFrame:CGRectMake(90 * ProportionAdapter, serviceDetailsHeight >= 22 * ProportionAdapter ? 5 * ProportionAdapter : 0, screenWidth - 110 * ProportionAdapter, serviceDetailsHeight >= 22 * ProportionAdapter ? serviceDetailsHeight : 22 * ProportionAdapter)];
        oderDetailLB.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
        oderDetailLB.font = [UIFont systemFontOfSize:15];
        oderDetailLB.textAlignment = NSTextAlignmentLeft;
        oderDetailLB.text = [self.dataDic objectForKey:@"serviceDetails"];
        oderDetailLB.numberOfLines = 0;
        [backView addSubview:oderDetailLB];
        backView.frame = CGRectMake(0, 0, screenWidth, serviceDetailsHeight + 10 * ProportionAdapter);
        return backView;
    }
    
}



- (UIView *)cancelBackView{
    if (!_cancelBackView) {
        
        
        _cancelBackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _cancelBackView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5f];
        
        
        _cancelView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight - 394 * ProportionAdapter, screenWidth, 380 * ProportionAdapter)];
        _cancelView.backgroundColor = [UIColor whiteColor];
        
        UILabel *lineLB = [self lablerect:CGRectMake(0, 0, screenWidth, 0.5 * ProportionAdapter) labelColor:[UIColor whiteColor] labelFont:0 text:@"" textAlignment:(NSTextAlignmentCenter)];
        lineLB.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        [_cancelView addSubview:lineLB];
        
        UIButton *popBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 44 * ProportionAdapter, 10 * ProportionAdapter, 22 * ProportionAdapter, 22 * ProportionAdapter)];
        [popBtn setImage:[UIImage imageNamed:@"date_close"] forState:(UIControlStateNormal)];
        [popBtn addTarget:self action:@selector(popAct) forControlEvents:(UIControlEventTouchUpInside)];
        popBtn.tag = 88;
        [_cancelView addSubview:popBtn];
        
        UILabel *titleLB = [self lablerect:CGRectMake(0, 0, screenWidth, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#626262"] labelFont:(17 * ProportionAdapter) text:@"取消订单" textAlignment:(NSTextAlignmentCenter)];
        [_cancelView addSubview:titleLB];
        
        UILabel *selectLB = [self lablerect:CGRectMake(55 * ProportionAdapter, 50 * ProportionAdapter, screenWidth, 30 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(15 * ProportionAdapter) text:@"请勾选取消订单的原因（必选）：" textAlignment:(NSTextAlignmentLeft)];
        [_cancelView addSubview:selectLB];
        
        
        for (int i = 0; i < 4; i ++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(53 * ProportionAdapter, 80 * ProportionAdapter + 50 * ProportionAdapter * i, 220 * ProportionAdapter, 50 * ProportionAdapter)];
            btn.tag = 600 + i;
            [btn addTarget:self action:@selector(selectAct:) forControlEvents:(UIControlEventTouchUpInside)];
            [btn setImage:[UIImage imageNamed:@"unselect"] forState:(UIControlStateNormal)];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -190 * ProportionAdapter, 0, 0)];
            [_cancelView addSubview:btn];
            
            if (i != 3) {
                UILabel *lineLB = [self lablerect:CGRectMake(10 * ProportionAdapter, 129.5 * ProportionAdapter + i * 50 * ProportionAdapter, screenWidth - 10 * ProportionAdapter, 0.5 * ProportionAdapter) labelColor:[UIColor whiteColor] labelFont:0 text:@"" textAlignment:(NSTextAlignmentCenter)];
                lineLB.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
                [_cancelView addSubview:lineLB];
            }
            
            
            UILabel *reasonLB = [self lablerect:CGRectMake(90 * ProportionAdapter, 80 * ProportionAdapter + 50 * ProportionAdapter * i, 200 * ProportionAdapter, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#626262"] labelFont:(15 * ProportionAdapter) text:self.reasonArray[i] textAlignment:(NSTextAlignmentLeft)];
            [_cancelView addSubview:reasonLB];
        }
        
        
        UIButton *commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 280 * ProportionAdapter, screenWidth, 50 * ProportionAdapter)];
        commitBtn.backgroundColor = [UIColor orangeColor];
        commitBtn.tag = 89;
        [commitBtn addTarget:self action:@selector(commitAct) forControlEvents:(UIControlEventTouchUpInside)];
        [commitBtn setTitle:@"提交" forState:(UIControlStateNormal)];
        [_cancelView addSubview:commitBtn];
        [_cancelBackView addSubview:_cancelView];
        
    }
    return _cancelBackView;
}

- (void)selectAct:(UIButton *)btn{
    for (UIView *sView in self.cancelView.subviews) {
        if (sView.tag != sView.tag || [[sView class] isSubclassOfClass:[UIButton class]]) {
            UIButton *sBtn = (UIButton *)sView;
            if (sBtn.tag != 88 && sBtn.tag != 89) { // 叉号按钮 和 提交按钮
                [sBtn setImage:[UIImage imageNamed:@"unselect"] forState:(UIControlStateNormal)];
            }
        }
    }
    
    [btn setImage:[UIImage imageNamed:@"select"] forState:(UIControlStateNormal)];
    self.reasonArray[4] = self.reasonArray[btn.tag - 600];
}

#pragma mark ----- 提交取消订单

- (void)commitAct{
    
    
    if ([[NSString stringWithFormat:@"%@", self.reasonArray[4]] isEqualToString:@""]) {
        [LQProgressHud showMessage:@"未选择理由"];
        return;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.orderKey forKey:@"orderKey"];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    [dic setObject:self.reasonArray[4] forKey:@"cancelReason"];
    
    //    [dic setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"orderKey=%@dagolfla.com", self.orderKey]] forKey:@"md5"];
    
//    [[ShowHUD showHUD] showAnimationWithText:@"加载中…" FromView:self.view];
    
    [[JsonHttp jsonHttp] httpRequestWithMD5:@"bookingOrder/doCancelBookingOrder" JsonKey:nil withData:dic failedBlock:^(id errType) {
//        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        
    } completionBlock:^(id data) {
//        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"orderStateChange" object:nil];
            
            [self.cancelBackView removeFromSuperview];
            
            if ([[self.dataDic objectForKey:@"stateButtonString"] isEqualToString:@"待付款"]) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"orderStateChange" object:nil];
                
                [LQProgressHud showMessage:@"订单已取消并关闭"];
                [self.shitaView removeFromSuperview];
                [self loadData];
                
            }else{
                
                JGDPaySuccessViewController *cancelVC = [[JGDPaySuccessViewController alloc] init];
                if ([[self.dataDic objectForKey:@"payType"] integerValue] == 2 && [[self.dataDic objectForKey:@"depositMoney"] integerValue] == 0) {
                    cancelVC.payORlaterPay = 5;
                }else{
                    cancelVC.payORlaterPay = 3;
                }
                cancelVC.orderKey = self.orderKey;
                [self.navigationController pushViewController:cancelVC animated:YES];
                
            }
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [LQProgressHud showMessage:[data objectForKey:@"packResultMsg"]];
            }
        }
    }
     ];
    
}

- (void)popAct{
    
    [self.cancelBackView removeFromSuperview];
    
}

- (NSMutableArray *)reasonArray{
    if (!_reasonArray) {
        _reasonArray = [NSMutableArray arrayWithObjects:@"行程有变", @"天气原因", @"改订其他球场", @"身体不适", @"",nil];
    }
    return _reasonArray;
}

- (NSMutableArray *)orderTitleArray{
    if (!_orderTitleArray) {
        _orderTitleArray = [NSMutableArray arrayWithObjects:@"订单编号：", @"订单状态：", @"下单时间：", @"订单总价：", @"付款方式：", @"已付金额：", nil];
    }
    return _orderTitleArray;
}

- (NSArray *)reserveTitleArray{
    if (!_reserveTitleArray) {
        _reserveTitleArray = [NSArray arrayWithObjects:@"预订球场：", @"开球时间：", @"打球人数：", @"打球人：", @"联系电话：", @"价格包含：", nil];
    }
    return _reserveTitleArray;
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
