//
//  JGDAllianceCommitOrderViewController.m
//  DagolfLa
//
//  Created by 東 on 17/3/7.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGDAllianceCommitOrderViewController.h"

#import "JGDCostumTableViewCell.h"
#import "JGDBallPlayTableViewCell.h"
#import "JGDNormalWithLabelTableViewCell.h" // --

#import "JGDConfirmPayViewController.h"
#import "JGDContactViewController.h"
#import "LGLCalenderViewController.h"
#import "JGDPaySuccessViewController.h"

#import "SelectRedPacketTableViewCell.h"
#import "BookCourtPriceTableViewCell.h"
#import "BookCourtTotalPriceTableViewCell.h"
#import "SelectRedPacketViewController.h"

@interface JGDAllianceCommitOrderViewController () <UITableViewDelegate, UITableViewDataSource ,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *commitOrderTableView;

@property (nonatomic, strong) NSMutableArray *playerArray;

@property (nonatomic, strong) UILabel *countLB;

@property (nonatomic, strong) UILabel *placeHoler;

@property (nonatomic, strong) UILabel *payMoneyLB; // 支付金额

@property (nonatomic, strong) UILabel *scenePayMoneyLB;  // 现场支付

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, strong) UITextField *noteTF; // 备注

@property (nonatomic, copy) NSString *remark; // 备注信息

@property (nonatomic, strong) NSMutableArray *vipCardArray;

@property (nonatomic, strong) UILabel *allianceCardLB;

@property (nonatomic, strong) NSNumber *vipTimekey;
//打球人数据
@property (nonatomic,strong) NSMutableArray *addPlayerArray;
//选中的红包
@property (nonatomic, strong) RedPacketModel *selectModel;
//是否显示选择红包界面
@property (nonatomic,assign) BOOL showRedPacket;


@end

@implementation JGDAllianceCommitOrderViewController

-(NSMutableArray *)addPlayerArray{
    if (_addPlayerArray==nil) {
        _addPlayerArray = [NSMutableArray array];
    }
    return _addPlayerArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提交订单";
    
    [self commitOrderTable];
    
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"consult"] style:(UIBarButtonItemStyleDone) target:self action:@selector(phoneAct)];
    rightBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    [dic setObject:[self.detailDic objectForKey:@"ballKey"] forKey:@"ballKey"];
    [dic setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@&ballKey=%@dagolfla.com",DEFAULF_USERID, [self.detailDic objectForKey:@"ballKey"]]] forKey:@"md5"];
    [[ShowHUD showHUD] showAnimationWithText:@"加载中…" FromView:self.view];
    [[JsonHttp jsonHttp] httpRequest:@"league/getSelectUserCardList" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        
        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        
    } completionBlock:^(id data) {
        
        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            if ([data objectForKey:@"userCardList"]) {
                
                self.vipCardArray = [NSMutableArray arrayWithArray:[data objectForKey:@"userCardList"]];
                _playerArray = [NSMutableArray arrayWithObjects:[self.vipCardArray[0] objectForKey:@"lUserName"], [[NSUserDefaults standardUserDefaults] objectForKey:Mobile], [self.vipCardArray[0] objectForKey:@"name"] ,nil];
                self.vipTimekey = [self.vipCardArray[0] objectForKey:@"timeKey"];
                
                [self.commitOrderTableView reloadData];
            }
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
    
    // Do any additional setup after loading the view.
}

- (void)phoneAct{
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@", Company400];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}


- (void)commitOrderTable{
    
    self.commitOrderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64 * ProportionAdapter) style:(UITableViewStylePlain)];
    self.commitOrderTableView.delegate = self;
    self.commitOrderTableView.dataSource = self;
    [self.view addSubview:self.commitOrderTableView];
    
    self.commitOrderTableView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    self.commitOrderTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.commitOrderTableView registerClass:[JGDBallPlayTableViewCell class] forCellReuseIdentifier:@"ballPlayCell"];
    [self.commitOrderTableView registerClass:[SelectRedPacketTableViewCell class] forCellReuseIdentifier:@"SelectRedPacketTableViewCellID"];
    [self.commitOrderTableView registerClass:[BookCourtPriceTableViewCell class] forCellReuseIdentifier:@"BookCourtPriceTableViewCellID"];
    [self.commitOrderTableView registerClass:[BookCourtTotalPriceTableViewCell class] forCellReuseIdentifier:@"BookCourtTotalPriceTableViewCellID"];
    
    
    
    // "付款类型 0: 全额预付  1: 部分预付  2: 球场现付"
    if ([[self.detailDic objectForKey:@"payType"] integerValue] == 0) {
        
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 120 * ProportionAdapter)];
        
        self.payMoneyLB = [self lablerect:CGRectMake(220 * ProportionAdapter, 40 * ProportionAdapter, 140 * ProportionAdapter, 40 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(16 * ProportionAdapter) text:[NSString stringWithFormat:@"全额预付  ¥%@", self.selectMoney] textAlignment:(NSTextAlignmentRight)];
        NSMutableAttributedString *mutaAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"全额预付  ¥%@", self.selectMoney]];
        [mutaAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 * ProportionAdapter] range:NSMakeRange(6, 1)];
        [mutaAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#fc5a01"] range:NSMakeRange(6, [[NSString stringWithFormat:@"%@",self.selectMoney] length] + 1)];
        self.payMoneyLB.attributedText = mutaAttStr;
        [footView addSubview:self.payMoneyLB];
        
        UIButton *commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 80 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 40 * ProportionAdapter)];
        [commitBtn setTitle:@"确定预订" forState:(UIControlStateNormal)];
        commitBtn.backgroundColor = [UIColor colorWithHexString:@"#fc5a01"];
        [commitBtn addTarget:self action:@selector(ConfirmAct) forControlEvents:(UIControlEventTouchUpInside)];
        commitBtn.layer.cornerRadius = 6;
        commitBtn.clipsToBounds = YES;
        [footView addSubview:commitBtn];
        self.commitOrderTableView.tableFooterView = footView;
        
    }else if ([[self.detailDic objectForKey:@"payType"] integerValue] == 1) {
        
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 120 * ProportionAdapter)];
        
        self.scenePayMoneyLB = [self lablerect:CGRectMake(10 * ProportionAdapter, 0, 140 * ProportionAdapter, 40 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(16 * ProportionAdapter) text:[NSString stringWithFormat:@"现场支付  ¥%@", self.selectSceneMoney] textAlignment:(NSTextAlignmentLeft)];
        NSMutableAttributedString *sceneAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"现场支付  ¥%@", self.selectSceneMoney]];
        [sceneAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 * ProportionAdapter] range:NSMakeRange(6, 1)];
        self.scenePayMoneyLB.attributedText = sceneAttStr;
        [footView addSubview:self.scenePayMoneyLB];
        
        
        self.payMoneyLB = [self lablerect:CGRectMake(220 * ProportionAdapter, 0, 140 * ProportionAdapter, 40 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(16 * ProportionAdapter) text:[NSString stringWithFormat:@"线上预付  ¥%@", self.selectMoney] textAlignment:(NSTextAlignmentRight)];
        NSMutableAttributedString *mutaAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"线上预付  ¥%@", self.selectMoney]];
        [mutaAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 * ProportionAdapter] range:NSMakeRange(6, 1)];
        [mutaAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#fc5a01"] range:NSMakeRange(6, [[NSString stringWithFormat:@"%@",self.selectMoney] length] + 1)];
        self.payMoneyLB.attributedText = mutaAttStr;
        [footView addSubview:self.payMoneyLB];
        
        UIButton *commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 41 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 40 * ProportionAdapter)];
        [commitBtn setTitle:@"确定预订" forState:(UIControlStateNormal)];
        commitBtn.backgroundColor = [UIColor colorWithHexString:@"#fc5a01"];
        [commitBtn addTarget:self action:@selector(ConfirmAct) forControlEvents:(UIControlEventTouchUpInside)];
        commitBtn.layer.cornerRadius = 6;
        commitBtn.clipsToBounds = YES;
        [footView addSubview:commitBtn];
        self.commitOrderTableView.tableFooterView = footView;
        
    }else if ([[self.detailDic objectForKey:@"payType"] integerValue] == 2) {
        
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 130 * ProportionAdapter)];
        
        NSString *ruleString = @"押金退还规则：\n1、预订日打完球后三个工作日内，系统自动退还押金至您付款账户；\n2、成功取消订单后三个工作日内，系统自动退还押金到您付款账户；";
        
        CGFloat height = [Helper textHeightFromTextString:ruleString width:screenWidth - 20 * ProportionAdapter fontSize:14 * ProportionAdapter];
        
        
        UILabel *tipLB = [self lablerect:CGRectMake(10 * ProportionAdapter, 15 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, height) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:(14 * ProportionAdapter) text:ruleString textAlignment:(NSTextAlignmentLeft)];
        tipLB.numberOfLines = 0;
        [footView addSubview:tipLB];
        
        
        self.scenePayMoneyLB = [self lablerect:CGRectMake(10 * ProportionAdapter, height + 20, 140 * ProportionAdapter, 40 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#626262"] labelFont:(16 * ProportionAdapter) text:[NSString stringWithFormat:@"现场支付  ¥%@", self.selectSceneMoney] textAlignment:(NSTextAlignmentLeft)];
        NSMutableAttributedString *sceneAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"现场支付  ¥%@", self.selectSceneMoney]];
        [sceneAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 * ProportionAdapter] range:NSMakeRange(6, 1)];
        self.scenePayMoneyLB.attributedText = sceneAttStr;
        [footView addSubview:self.scenePayMoneyLB];
        
        
        self.payMoneyLB = [self lablerect:CGRectMake(220 * ProportionAdapter, height + 20, 140 * ProportionAdapter, 40 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(16 * ProportionAdapter) text:[NSString stringWithFormat:@"预付押金  ¥%@", self.selectMoney] textAlignment:(NSTextAlignmentRight)];
        NSMutableAttributedString *mutaAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"预付押金  ¥%@", self.selectMoney]];
        [mutaAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 * ProportionAdapter] range:NSMakeRange(6, 1)];
        [mutaAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#fc5a01"] range:NSMakeRange(6, [[NSString stringWithFormat:@"%@",self.selectMoney] length] + 1)];
        self.payMoneyLB.attributedText = mutaAttStr;
        [footView addSubview:self.payMoneyLB];
        
        UIButton *commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, height +  70 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 40 * ProportionAdapter)];
        [commitBtn setTitle:@"确定预订" forState:(UIControlStateNormal)];
        commitBtn.backgroundColor = [UIColor colorWithHexString:@"#fc5a01"];
        [commitBtn addTarget:self action:@selector(ConfirmAct) forControlEvents:(UIControlEventTouchUpInside)];
        commitBtn.layer.cornerRadius = 6;
        commitBtn.clipsToBounds = YES;
        [footView addSubview:commitBtn];
        footView.frame = CGRectMake(0, 0, screenWidth, height + 160 * ProportionAdapter);
        self.commitOrderTableView.tableFooterView = footView;
        
    }
}

#pragma mark InitData
//确定预定支付
- (void)ConfirmAct{
    
    [self.view endEditing:YES];
    
    if ([self.allianceCardLB.text isEqualToString:@"请选择会员卡"]) {
        [LQProgressHud showMessage:@"请选择会员卡"];
        return;
    }

    NSString *name = self.playerArray[0];
    NSString *phone = self.playerArray[1];
    
    if ([name isEqualToString:@""] || [phone isEqualToString:@""]) {
        [LQProgressHud showMessage:@"请完善打球人信息"];
        return;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *orderDic = [NSMutableDictionary dictionary];
    
    if (_selectModel.timeKey) {
        [orderDic setObject:_selectModel.timeKey forKey:@"couponKey"];
        
    }
    
    NSMutableString *nameString = [NSMutableString stringWithString:name];
    for (NSString *name in self.addPlayerArray) {
        if (name.length==0) {
            [LQProgressHud showMessage:@"请完善打球人信息"];
            return;
        }
        nameString = [NSMutableString stringWithFormat:@"%@、 %@",nameString, name];
    }

    [orderDic setObject:nameString forKey:@"playPersonNames"];
    [orderDic setObject:self.vipTimekey forKey:@"userCardKey"];
    [orderDic setObject:self.noteTF.text forKey:@"remark"];
    [orderDic setObject:self.selectDate forKey:@"teeTime"];
    //打球人数
    NSString *userSUm = [NSString stringWithFormat:@"%ld",self.addPlayerArray.count + 1];
    [orderDic setObject:userSUm forKey:@"userSum"];
    [orderDic setObject:DEFAULF_UserName forKey:@"userName"];
    [orderDic setObject:phone forKey:@"userMobile"];
    UITextField *noteTF = [self.commitOrderTableView viewWithTag:999]; // 备注
    [orderDic setObject:noteTF.text forKey:@"remark"];
    

    [dic setObject:orderDic forKey:@"order"];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    [dic setObject:[self.detailDic objectForKey:@"timeKey"] forKey:@"bookBallParkKey"];
    [[ShowHUD showHUD] showAnimationWithText:@"加载中…" FromView:self.view];
    
    [[JsonHttp jsonHttp] httpRequestHaveSpaceWithMD5:@"bookingOrder/doCreateBookingOrder" JsonKey:nil withData:dic failedBlock:^(id errType) {
        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        
    } completionBlock:^(id data) {
        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            [MobClick event:@"booking_ball_membership_click"];
            
            if ([data objectForKey:@"orderKey"]) {
                
                if ([[data objectForKey:@"stateButtonString"] isEqualToString:@"待付款"]) {
                    JGDConfirmPayViewController *confirVC = [[JGDConfirmPayViewController alloc] init];
                    confirVC.payMoney = [[data objectForKey:@"money"] integerValue];
                    confirVC.orderKey = [data objectForKey:@"orderKey"];
                    [self.navigationController pushViewController:confirVC animated:YES];
                }else{
                    JGDPaySuccessViewController *payVC = [[JGDPaySuccessViewController  alloc] init];
                    payVC.payORlaterPay = 4;
                    payVC.orderKey = [data objectForKey:@"orderKey"];
                    [self.navigationController pushViewController:payVC animated:YES];
                }
            }
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [LQProgressHud showInfoMsg:[data objectForKey:@"packResultMsg"]];
            }
        }
    }];
    
}

//获取可用红包
-(NSInteger)getCanUseNum{
    NSInteger totalNum = _myCouponList.count;
    for (RedPacketModel *model in _myCouponList) {
        if (model.unusable) {
            totalNum--;
        }
    }
    return totalNum;
}
//通讯录添加打球人
- (void)contactAdd:(UIButton *)btn{
    [self.commitOrderTableView endEditing:YES];
    JGDContactViewController *contactVC = [[JGDContactViewController alloc] init];
    contactVC.blockAddressUserName = ^(NSString *userName){
        JGDBallPlayTableViewCell *cell = (JGDBallPlayTableViewCell *)[[btn superview] superview];
        NSIndexPath *index = [self.commitOrderTableView indexPathForCell:cell];
        cell.nameTF.text = userName;
        self.addPlayerArray[index.row - 2] = userName;
        cell.phoneImageV.hidden = YES;
    };
    [self.navigationController pushViewController:contactVC animated:YES];
}
//计算订单总价和实付金额
-(void)countOrderPrice{
    if (self.addPlayerArray.count==0) {
        return;
    }
    NSInteger orderPriceCount = [_selectMoney integerValue] + [_normolPrice integerValue]*self.addPlayerArray.count;
    NSString *orderPrice = [NSString stringWithFormat:@"¥ %lu", orderPriceCount];
    NSString *redpacketMoney = [NSString stringWithFormat:@"-¥ %ld",_selectModel.money];
    NSString *totalPrice = [NSString stringWithFormat:@"¥ %lu",orderPriceCount - _selectModel.money];
    
    BookCourtTotalPriceTableViewCell *cell = [self.commitOrderTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 + self.addPlayerArray.count inSection:1]];
    
    cell.orderPriceLabel.text = orderPrice;
    cell.redpacketLabel.text = redpacketMoney;
    cell.totalPriceLabel.text = totalPrice;
    
}
#pragma mark - UITableViewDelegate&&DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 567) {
        return 1;
    }
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 567) {
        return [self.vipCardArray count];
    }else{
        if (section==0) {
            return 7;
        }else{
            NSInteger num = 0;
            if (_showRedPacket) {
                num = 3;
            }
            return 2 + num + self.addPlayerArray.count;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView.tag == 567) {
        return 58 * ProportionAdapter;
    }
    return section == 0 ? 0 : 10 * ProportionAdapter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 567) {
        return 41 * ProportionAdapter;
    }
    if (indexPath.section == 1) {
        if (indexPath.row > self.addPlayerArray.count ) {
            if (_showRedPacket){
                if (indexPath.row == self.addPlayerArray.count+4) {
                    return 60 * ProportionAdapter;
                }else if (indexPath.row == self.addPlayerArray.count+3){
                    return kHvertical(120);
                }
            }else{
                return 60 * ProportionAdapter;
            }
        }
    }
    return 50 * ProportionAdapter;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 567) {
        JGDNormalWithLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normalCell"];
        cell.cellHeight = 41 * ProportionAdapter;
        cell.nameLB.text = [self.vipCardArray[indexPath.row] objectForKey:@"name"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section==0) {
        if (indexPath.row == 0) {
            JGDCostumTableViewCell *cell = [[JGDCostumTableViewCell alloc] init];
            UILabel *titleLB = [self lablerect:CGRectMake(5 * ProportionAdapter, 0, 90 * ProportionAdapter, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:(16 * ProportionAdapter) text:@"球场：" textAlignment:(NSTextAlignmentRight)];
            [cell.contentView addSubview:titleLB];
            
            UILabel *ballNameLB = [self lablerect:CGRectMake(100 * ProportionAdapter, 0, 260 * ProportionAdapter, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(16 * ProportionAdapter) text:[self.detailDic objectForKey:@"ballName"] textAlignment:(NSTextAlignmentLeft)];
            [cell.contentView addSubview:ballNameLB];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 50 * ProportionAdapter - 1, screenWidth - 10 * ProportionAdapter, 1 )];
            lineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
            [cell.contentView addSubview:lineView];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else if (indexPath.row == 1) {
            JGDCostumTableViewCell *cell = [[JGDCostumTableViewCell alloc] init];
            UILabel *titleLB = [self lablerect:CGRectMake(5 * ProportionAdapter, 0, 90 * ProportionAdapter, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:(16 * ProportionAdapter) text:@"打球时间：" textAlignment:(NSTextAlignmentRight)];
            [cell.contentView addSubview:titleLB];
            
            UILabel *dateLB = [self lablerect:CGRectMake(100 * ProportionAdapter, 0, 260 * ProportionAdapter, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(16 * ProportionAdapter) text:[Helper stringFromDateString:self.selectDate withFormater:@"MM月dd日  EEE  HH:mm"] textAlignment:(NSTextAlignmentLeft)];
            
            NSMutableAttributedString *mutabeAtr = [[NSMutableAttributedString alloc] initWithString:[Helper stringFromDateString:self.selectDate withFormater:@"MM月dd日 EEE HH:mm"]];
            [mutabeAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"a0a0a0"] range:NSMakeRange(7, 2)];
            dateLB.attributedText = mutabeAtr;
            [cell.contentView addSubview:dateLB];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else if (indexPath.row == 2) {
            JGDCostumTableViewCell *cell = [[JGDCostumTableViewCell alloc] init];
            NSString *begainDate = [NSString stringWithFormat:@"将为您提供%@-%@（１小时内的开球时间）", [Helper dateFromDate:self.selectDate timeInterval:-30 * 60], [Helper dateFromDate:self.selectDate timeInterval:30 * 60]];
            UILabel *tipLB = [self lablerect:CGRectMake(10 * ProportionAdapter, 0, screenWidth - 20 * ProportionAdapter, 35 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#636363"] labelFont:(15 * ProportionAdapter) text:begainDate textAlignment:(NSTextAlignmentCenter)];
            tipLB.backgroundColor = [UIColor colorWithHexString:@"#fefaf3"];
            tipLB.layer.cornerRadius = 6;
            tipLB.clipsToBounds = YES;
            
            NSMutableAttributedString *mutabeAtr = [[NSMutableAttributedString alloc] initWithString:begainDate];
            UIImage *img = [UIImage imageNamed:@"order_icn_remark"];
            NSTextAttachment *textAttach = [[NSTextAttachment alloc]init];
            textAttach.image = img;
            textAttach.bounds = CGRectMake(-3 * ProportionAdapter, -1 * ProportionAdapter, 14 * ProportionAdapter, 14 * ProportionAdapter);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:textAttach];
            [mutabeAtr insertAttributedString:string atIndex:0];
            tipLB.attributedText = mutabeAtr;
            [cell.contentView addSubview:tipLB];
            
            UILabel *lB = [[UILabel alloc] initWithFrame:CGRectMake(0, 40 * ProportionAdapter, screenWidth, 10 * ProportionAdapter)];
            lB.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
            [cell.contentView addSubview:lB];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 3 || indexPath.row == 4) {
            JGDBallPlayTableViewCell *cell = [[JGDBallPlayTableViewCell alloc] init];
            [cell.phoneImageV removeFromSuperview];
            NSString *title;
            indexPath.row == 3 ? (title = @"会员姓名：") : (title = @"联系方式：");
            cell.titleLB.text = title;
            if (indexPath.row == 4) {
                cell.nameTF.text = self.playerArray[1];
                cell.nameTF.tag = 777;
                cell.nameTF.delegate = self;
            }else {
                cell.nameTF.text = self.playerArray[0];
                cell.nameTF.tag = 888;
                cell.nameTF.delegate = self;
                cell.nameTF.userInteractionEnabled = NO;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
            
        }else if (indexPath.row == 5) {
            JGDCostumTableViewCell *cell = [[JGDCostumTableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *vipSelectLB = [Helper lableRect:CGRectMake(13 * ProportionAdapter, 0, 90 * ProportionAdapter, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:16 * ProportionAdapter text:@"使用会籍" textAlignment:NSTextAlignmentLeft];
            [cell.contentView addSubview:vipSelectLB];
            
            if ([self.vipCardArray count] > 0) {
                self.allianceCardLB = [Helper lableRect:CGRectMake(103 * ProportionAdapter, 0, screenWidth - 133 * ProportionAdapter, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:16 * ProportionAdapter text:self.playerArray[2] textAlignment:(NSTextAlignmentRight)];
                
                UIImageView *accessView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - 20 * ProportionAdapter, 16 * ProportionAdapter, 9 * ProportionAdapter, 16 * ProportionAdapter)];
                accessView.image = [UIImage imageNamed:@"darkArrow"];
                accessView.tintColor = RGB(160,160,160);
                [cell.contentView addSubview:accessView];
                
                [cell.contentView addSubview:self.allianceCardLB];
            }
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 50 * ProportionAdapter - 1, screenWidth - 10 * ProportionAdapter, 1 )];
            lineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
            [cell.contentView addSubview:lineView];
            return cell;
        }else{
            BookCourtPriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookCourtPriceTableViewCellID"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.titleLabel.text = @"会籍价格";
            cell.priceLabel.text = [NSString stringWithFormat:@"¥ %@",_selectMoney];
            return cell;
        }
        
    }else{
        
        if (indexPath.row == 0) {
            JGDCostumTableViewCell *cell = [[JGDCostumTableViewCell alloc] init];
            UILabel *titleLB = [self lablerect:CGRectMake(5 * ProportionAdapter, 0, 90 * ProportionAdapter, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:(16 * ProportionAdapter) text:@"添加嘉宾：" textAlignment:(NSTextAlignmentRight)];
            [cell.contentView addSubview:titleLB];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(264 * ProportionAdapter, 12 * ProportionAdapter, 26 * ProportionAdapter, 26 * ProportionAdapter)];
            if ([self.addPlayerArray count] == 0) {
                [leftBtn setImage:[UIImage imageNamed:@"order_minus"] forState:(UIControlStateNormal)]; // 灰色
            }else{
                [leftBtn setImage:[UIImage imageNamed:@"order_minus-color"] forState:(UIControlStateNormal)];
            }
            leftBtn.tag = 500;
            [leftBtn addTarget:self action:@selector(countChanege:) forControlEvents:(UIControlEventTouchUpInside)];
            [cell.contentView addSubview:leftBtn];
            
            self.countLB = [self lablerect:CGRectMake(290 * ProportionAdapter, 12 * ProportionAdapter, 50 * ProportionAdapter, 26 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(17 * ProportionAdapter) text:[NSString stringWithFormat:@"%td人", [self.addPlayerArray count]] textAlignment:(NSTextAlignmentCenter)];
            [cell.contentView addSubview:self.countLB];
            
            UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(340 * ProportionAdapter, 12 * ProportionAdapter, 26 * ProportionAdapter, 26 * ProportionAdapter)];
            rightBtn.tag = 501;
            [rightBtn addTarget:self action:@selector(countChanege:) forControlEvents:(UIControlEventTouchUpInside)];
            [rightBtn setImage:[UIImage imageNamed:@"order_add"] forState:(UIControlStateNormal)]; // 黑色
            [cell.contentView addSubview:rightBtn];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 50 * ProportionAdapter , screenWidth - 10 * ProportionAdapter, 1 )];
            lineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
            [cell.contentView addSubview:lineView];

            return cell;
            
        }else if (indexPath.row == 1 + [self.addPlayerArray count]&&self.addPlayerArray.count>0) {
        
            BookCourtPriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookCourtPriceTableViewCellID"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.titleLabel.text = @"嘉宾价格";
            cell.priceLabel.text = _normolPrice;
            return cell;

        }else if (indexPath.row == 2 + [self.addPlayerArray count]&&self.addPlayerArray.count>0) {
            
            SelectRedPacketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectRedPacketTableViewCellID"];
            [cell hidenGrayView];
            if (_selectModel.timeKey) {
                [cell configSelectData:_selectModel];
            }else{
                NSInteger canUseNum = [self getCanUseNum];
                [cell configData:canUseNum];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 3 + [self.addPlayerArray count]&&self.addPlayerArray.count>0) {
            
            BookCourtTotalPriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookCourtTotalPriceTableViewCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else if ((indexPath.row == 4 + [self.addPlayerArray count]&&self.addPlayerArray.count>0)||(self.addPlayerArray.count == 0&&indexPath.row==1)) {
            JGDCostumTableViewCell *cell = [[JGDCostumTableViewCell alloc] init];
            UILabel *lB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 10 * ProportionAdapter)];
            lB.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
            [cell addSubview:lB];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.noteTF = [[UITextField alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 10 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 50 * ProportionAdapter)];
            self.noteTF.placeholder = @"请输入备注信息";
            self.noteTF.tag = 999;
            self.noteTF.delegate = self;
            self.noteTF.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.noteTF.font = [UIFont systemFontOfSize:16 * ProportionAdapter];
            self.noteTF.text = self.remark;
            [cell.contentView addSubview:self.noteTF];
            
            return cell;
        }else{
            
            JGDBallPlayTableViewCell *cell = [[JGDBallPlayTableViewCell alloc] init];
            cell.nameTF.text = self.addPlayerArray[indexPath.row - 1];
            
            [cell.nameTF.text length] > 0 ? (cell.phoneImageV.hidden = YES) : (cell.phoneImageV.hidden = NO);
            cell.titleLB.text = @"打球人";
            cell.nameTF.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.phoneImageV addTarget:self action:@selector(contactAdd:) forControlEvents:(UIControlEventTouchUpInside)];
            return cell;
            
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView.tag == 567) {
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight - 235 * ProportionAdapter - 64 * ProportionAdapter, screenWidth, 58 * ProportionAdapter)];
        backView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLB = [Helper lableRect:CGRectMake(0, 0, screenWidth, 58 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:17 * ProportionAdapter text:@"选择可使用的会员卡" textAlignment:(NSTextAlignmentCenter)];
        
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 42 * ProportionAdapter, 20 * ProportionAdapter, 22 * ProportionAdapter, 22 * ProportionAdapter)];
        [closeBtn setImage:[UIImage imageNamed:@"date_close"] forState:(UIControlStateNormal)];
        [closeBtn addTarget:self action:@selector(closeCardAct:) forControlEvents:(UIControlEventTouchUpInside)];
        
        UILabel *lineLB = [Helper lableRect:CGRectMake(0, 0, screenWidth, 1 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:17 * ProportionAdapter text:@"" textAlignment:(NSTextAlignmentCenter)];
        lineLB.backgroundColor = [UIColor colorWithHexString:@"#a0a0a0"];
        [backView addSubview:lineLB];
        [backView addSubview:titleLB];
        [backView addSubview:closeBtn];
        
        return backView;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 25 * ProportionAdapter)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *lB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 10 * ProportionAdapter)];
    lB.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [view addSubview:lB];
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 567) {
        
        if ([[self.vipCardArray[indexPath.row] objectForKey:@"state"] integerValue] == 5) {
            [LQProgressHud showMessage:@"会员卡不可用"];
            return;
        }
        self.allianceCardLB.text = [self.vipCardArray[indexPath.row] objectForKey:@"name"];
        self.vipTimekey = [self.vipCardArray[indexPath.row] objectForKey:@"timeKey"];
        [tableView removeFromSuperview];
        // lUserName
        JGDBallPlayTableViewCell *cell3 = [self.commitOrderTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        cell3.nameTF.text = [self.vipCardArray[indexPath.row] objectForKey:@"lUserName"];
        return;
    }
    if (indexPath.row == 1) {
        LGLCalenderViewController *caleVC = [[LGLCalenderViewController alloc] init];
        caleVC.dateString = self.selectDate;
        caleVC.ballKey = self.timeKey;
        caleVC.isLeagueUser = YES;
        caleVC.blockTimeWithPrice = ^(NSString *selectTime, NSString *pay, NSString *scenePay, NSString *deductionMoney, NSString *leagueMoney){
            self.selectDate = selectTime;
            self.normolPrice = pay;
            if ([[self.detailDic objectForKey:@"payType"] integerValue] != 2) {
                self.selectMoney = pay;
            }
            self.selectSceneMoney = scenePay;
            if ([deductionMoney isEqualToString:@""]) {
                
            }else{
                self.selectSceneMoney = deductionMoney;
                
            }
            self.selectDate = selectTime;
            
            if ([[self.detailDic objectForKey:@"payType"] integerValue] == 2) {
                //         球场现付
                self.selectMoney = pay;
                
            }else if ([[self.detailDic objectForKey:@"payType"] integerValue] == 1) {
                //         部分预付
                if ([self.selectSceneMoney isEqualToString:@""]) {
                    self.selectMoney = pay;
                }else{
                    self.selectMoney = [NSString stringWithFormat:@"%td", [pay integerValue] - [self.selectSceneMoney integerValue]];
                }
            }else{
                self.selectMoney = leagueMoney;
                
            }
            
            [self payMoneySet];
            
            NSIndexPath *indexPath0 = [NSIndexPath indexPathForRow:2 inSection:0];
            NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:0];
            NSIndexPath *indexpath2 = [NSIndexPath indexPathForRow:6 inSection:0];
            
            [self.commitOrderTableView reloadRowsAtIndexPaths:@[indexPath0, indexPath1,indexpath2] withRowAnimation:NO];
        };
        [self.navigationController pushViewController:caleVC animated:YES];
        
    }else if (indexPath.row == 5) {
        UITableView *cardTaBleView = [[UITableView alloc] initWithFrame:CGRectMake(0, screenHeight - 235 * ProportionAdapter - 64 * ProportionAdapter, screenWidth, 235 * ProportionAdapter)];
        cardTaBleView.delegate = self;
        cardTaBleView.dataSource = self;
        [cardTaBleView registerClass:[JGDNormalWithLabelTableViewCell class] forCellReuseIdentifier:@"normalCell"];
        [self.view addSubview:cardTaBleView];
        cardTaBleView.tag = 567;

    }else if (indexPath.row == 2 + [self.addPlayerArray count]){
        NSInteger canUseNum = [self getCanUseNum];
        if (canUseNum<1) {
            return;
        }
        SelectRedPacketViewController *vc = [[SelectRedPacketViewController alloc] init];
        vc.dataArray = _myCouponList;
        vc.selectModel = _selectModel;
        __weak typeof(self) weakself = self;
        vc.selectModelBlock = ^(RedPacketModel *model) {
            weakself.selectModel = model;
            [weakself updatePrice];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }


}



- (void)closeCardAct:(UIButton *)btn{
    
    UITableView *tableView = [self.view viewWithTag:567];
    [tableView removeFromSuperview];
}

#pragma mark - TextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag != 999) {
        if ([string isEqualToString:@""] && [textField.text length] == 1) {
            // 全删
            JGDBallPlayTableViewCell *cell = (JGDBallPlayTableViewCell *)[[textField superview] superview];
            cell.phoneImageV.hidden = NO;
            
        }else{
            JGDBallPlayTableViewCell *cell = (JGDBallPlayTableViewCell *)[[textField superview] superview];
            cell.phoneImageV.hidden = YES;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if (textField.tag != 999) {
        JGDBallPlayTableViewCell *cell = (JGDBallPlayTableViewCell *)[[textField superview] superview];
        NSIndexPath *index = [self.commitOrderTableView indexPathForCell:cell];
        cell.phoneImageV.hidden = NO;
        if (index.row >=5) {
            self.playerArray[index.row - 5] = @"";
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    
    if (textField.tag == 999) {
        self.remark = textField.text;
        
    }else if (textField.tag == 888) {
        self.playerArray[0] = textField.text;
    }else if (textField.tag == 777) {
        self.playerArray[1] = textField.text;
    }else{
        JGDBallPlayTableViewCell *cell = (JGDBallPlayTableViewCell *)[[textField superview] superview];
        NSIndexPath *index = [self.commitOrderTableView indexPathForCell:cell];
        if ([textField.text length] > 0) {
            cell.phoneImageV.hidden = YES;
        }else{
            cell.phoneImageV.hidden = NO;
        }
        self.addPlayerArray[index.row-1] = textField.text;
    }
}

//更新金额
-(void)updatePrice{
    [self payMoneySet];
    [_commitOrderTableView reloadRow:2 + self.addPlayerArray.count inSection:1 withRowAnimation:UITableViewRowAnimationNone];
}
//判断当前红包是否可用
-(void)checkRedpacket:(NSInteger)totalPrice{
    if (_selectModel.timeKey) {
        if (totalPrice<_selectModel.minSellMoney) {
            _selectModel = nil;
            [self updatePrice];
        }
    }
}

#pragma mark --- 人数加减

- (void)countChanege:(UIButton *)btn{
    
    UIButton *leftBtn = [self.commitOrderTableView viewWithTag:500];
    
    if (btn.tag == 500) { // －
        if (self.addPlayerArray.count > 0) {
            self.countLB.text = [NSString stringWithFormat:@"%td人", [self.addPlayerArray count] - 1];
            [self.addPlayerArray removeLastObject];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 + [self.addPlayerArray count] inSection:1];
            if (self.addPlayerArray.count==0) {
                _showRedPacket = false;
                NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:1];
                NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:indexPath.row + 2 inSection:1];
                NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:indexPath.row + 3 inSection:1];
                [self.commitOrderTableView deleteRowsAtIndexPaths:@[indexPath,indexPath1,indexPath2,indexPath3] withRowAnimation:NO];
                //至少一个嘉宾才能使用红包
                _selectModel = [[RedPacketModel alloc] init];
            }else{
                [self.commitOrderTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
            }
        }
        [self.addPlayerArray count] == 0 ?[leftBtn setImage:[UIImage imageNamed:@"order_minus"] forState:(UIControlStateNormal)] : @"";
        
    }else{ // +
        
        if ([self.addPlayerArray count] == 0) {
            [leftBtn setImage:[UIImage imageNamed:@"order_minus-color"] forState:(UIControlStateNormal)];
        }
        self.countLB.text = [NSString stringWithFormat:@"%td人", [self.addPlayerArray count] + 1];
        [self.addPlayerArray addObject:@""];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.addPlayerArray count] inSection:1];
        if (self.addPlayerArray.count==1) {
            _showRedPacket = true;
            NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:1];
            NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:indexPath.row + 2 inSection:1];
            NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:indexPath.row + 3 inSection:1];
            [self.commitOrderTableView insertRowsAtIndexPaths:@[indexPath,indexPath1,indexPath2,indexPath3] withRowAnimation:NO];
        }else{
        
            [self.commitOrderTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
        }
        
        
    }
    
    [self payMoneySet];
}



#pragma mark --- 单人删除


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UIButton *leftBtn = [tableView viewWithTag:500];
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (self.playerArray.count > 1) {
            self.countLB.text = [NSString stringWithFormat:@"%td人", [self.playerArray count] - 1];
            [self.playerArray removeObjectAtIndex:indexPath.row - 5];
            [self.commitOrderTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
        }
        
        [self.playerArray count] == 1 ?[leftBtn setImage:[UIImage imageNamed:@"order_minus"] forState:(UIControlStateNormal)] : @"";
        
        
        [self payMoneySet];
    }
}


// 加减完人数后设置金额

- (void)payMoneySet{
    
    NSString *paytypeString = @"";
    
    // "付款类型 0: 全额预付  1: 部分预付  2: 球场现付"
    if ([[self.detailDic objectForKey:@"payType"] integerValue] == 2) {
        paytypeString = @"预付押金";
    }else if ([[self.detailDic objectForKey:@"payType"] integerValue] == 0) {
        paytypeString = @"全额预付";
    }else{
        paytypeString = @"线上预付";
    }
    // 订单实付总价
    NSInteger money = [self.selectMoney integerValue] + [_normolPrice integerValue] * [self.addPlayerArray count] - _selectModel.money;
    //更改价格之后判断红包是否可用
    [self checkRedpacket:money];
    
    NSString *moneyStr = [NSString stringWithFormat:@"%@  ¥%td", paytypeString, money];
    NSMutableAttributedString *mutaAttStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    [mutaAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 * ProportionAdapter] range:NSMakeRange(6, 1)];
    [mutaAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#fc5a01"] range:NSMakeRange(6, moneyStr.length - 6)];
    self.payMoneyLB.attributedText = mutaAttStr;
    
    self.scenePayMoneyLB.text = [NSString stringWithFormat:@"%@  ¥%td", paytypeString, [self.selectSceneMoney integerValue]];
    NSMutableAttributedString *sceneAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"现场支付  ¥%td", [self.selectSceneMoney integerValue]]];
    [sceneAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 * ProportionAdapter] range:NSMakeRange(6, 1)];
    self.scenePayMoneyLB.attributedText = sceneAttStr;
    
    //更改订单总价和红包优惠
    [self countOrderPrice];
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
