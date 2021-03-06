//
//  JGDCommitOrderViewController.m
//  DagolfLa
//
//  Created by 東 on 16/12/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDCommitOrderViewController.h"

#import "JGDCostumTableViewCell.h"
#import "JGDBallPlayTableViewCell.h"

#import "JGDConfirmPayViewController.h"
#import "JGDContactViewController.h"
#import "LGLCalenderViewController.h"
#import "JGDPaySuccessViewController.h"

//选择红包
#import "SelectRedPacketViewController.h"
#import "RedPacketModel.h"
#import "SelectRedPacketTableViewCell.h"

@interface JGDCommitOrderViewController () <UITableViewDelegate, UITableViewDataSource ,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *commitOrderTableView;

@property (nonatomic, strong) NSMutableArray *playerArray;

@property (nonatomic, strong) UILabel *countLB;

@property (nonatomic, strong) UILabel *placeHoler;

@property (nonatomic, strong) UILabel *payMoneyLB; // 支付金额

@property (nonatomic, strong) UILabel *scenePayMoneyLB;  // 现场支付

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, strong) UITextField *noteTF; // 备注

@property (nonatomic, copy) NSString *remark; // 备注信息
//选中的红包
@property (nonatomic, strong) RedPacketModel *selectModel;

@end

@implementation JGDCommitOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提交订单";
    
    [self commitOrderTable];
    
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"consult"] style:(UIBarButtonItemStyleDone) target:self action:@selector(phoneAct)];
    rightBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    // Do any additional setup after loading the view.
}

- (void)phoneAct{

    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@", Company400];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

}


- (void)commitOrderTable{
    
    self.commitOrderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64 ) style:(UITableViewStylePlain)];
    self.commitOrderTableView.delegate = self;
    self.commitOrderTableView.dataSource = self;
    [self.view addSubview:self.commitOrderTableView];
    
    self.commitOrderTableView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    self.commitOrderTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.commitOrderTableView registerClass:[JGDBallPlayTableViewCell class] forCellReuseIdentifier:@"ballPlayCell"];
    [self.commitOrderTableView registerClass:[SelectRedPacketTableViewCell class] forCellReuseIdentifier:@"SelectRedPacketTableViewCellID"];
    // "付款类型 0: 全额预付  1: 部分预付  2: 球场现付"
    if ([[self.detailDic objectForKey:@"payType"] integerValue] == 0) {
        
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 130 * ProportionAdapter)];
        
        self.payMoneyLB = [self lablerect:CGRectMake(220 * ProportionAdapter, 0, 140 * ProportionAdapter, 40 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(16 * ProportionAdapter) text:[NSString stringWithFormat:@"全额预付  ¥%@", self.selectMoney] textAlignment:(NSTextAlignmentRight)];
        NSMutableAttributedString *mutaAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"全额预付  ¥%@", self.selectMoney]];
        [mutaAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 * ProportionAdapter] range:NSMakeRange(6, 1)];
        [mutaAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#fc5a01"] range:NSMakeRange(6, [[NSString stringWithFormat:@"%@",self.selectMoney] length] + 1)];
        self.payMoneyLB.attributedText = mutaAttStr;
        [footView addSubview:self.payMoneyLB];
        
        UIButton *commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 41 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 45 * ProportionAdapter)];
        [commitBtn setTitle:@"确定预订" forState:(UIControlStateNormal)];
        commitBtn.backgroundColor = [UIColor colorWithHexString:@"#fc5a01"];
        [commitBtn addTarget:self action:@selector(ConfirmAct) forControlEvents:(UIControlEventTouchUpInside)];
        commitBtn.layer.cornerRadius = 6;
        commitBtn.clipsToBounds = YES;
        [footView addSubview:commitBtn];
        self.commitOrderTableView.tableFooterView = footView;
        
    }else if ([[self.detailDic objectForKey:@"payType"] integerValue] == 1) {
        
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 130 * ProportionAdapter)];
        
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
        
        UIButton *commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 41 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 45 * ProportionAdapter)];
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
        
        UIButton *commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, height +  70 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 45 * ProportionAdapter)];
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
//获取可用红包
-(NSInteger)getCanUseNum{
    NSInteger totalNum = _myCouponList.count;
    //订单金额
    CGFloat money = [self.selectMoney integerValue] * ([self.playerArray count]) ;
    NSMutableArray *mArray = [NSMutableArray array];
    for (RedPacketModel *model in _myCouponList) {
        model.unusable = false;
        if (model.minSellMoney>=money) {
            model.unusable = true;
            totalNum -- ;
        }
        [mArray addObject:model];
    }
    _myCouponList = mArray;
    return totalNum;
}
//更新金额
-(void)updatePrice{
    [self payMoneySet];
    [self reloadCellData];
}
//刷新cell
-(void)reloadCellData{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 + self.playerArray.count inSection:0];
    
    SelectRedPacketTableViewCell *cell = [_commitOrderTableView cellForRowAtIndexPath:indexPath];
    [cell hidenGrayView];
    if (_selectModel.timeKey) {
        [cell configSelectData:_selectModel];
    }else{
        NSInteger canUseNum = [self getCanUseNum];
        [cell configData:canUseNum];
    }
}

//判断当前红包是否可用
-(void)checkRedpacket{
    if (_selectModel.timeKey) {
        CGFloat money = [self.selectMoney integerValue] * ([self.playerArray count]) ;
        if (money<_selectModel.minSellMoney) {
            _selectModel = nil;
        }
    }
    [self updatePrice];

}

//确定预定支付
- (void)ConfirmAct{
    
    [self.view endEditing:YES];
    for (NSString *player in self.playerArray) {
        if ([player isEqualToString:@""] || [self.mobile isEqualToString:@""]) {
            [LQProgressHud showMessage:@"请完善打球人信息"];
            return;
        }
    }
   
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *orderDic = [NSMutableDictionary dictionary];
    
    [orderDic setObject:self.noteTF.text forKey:@"remark"];
    [orderDic setObject:self.selectDate forKey:@"teeTime"];
    [orderDic setObject:@([self.playerArray count]) forKey:@"userSum"];
    [orderDic setObject:self.playerArray[0] forKey:@"userName"];
    [orderDic setObject:self.mobile forKey:@"userMobile"];
    if (_selectModel.timeKey) {
        [orderDic setObject:_selectModel.timeKey forKey:@"couponKey"];
        
    }

    UITextField *noteTF = [self.commitOrderTableView viewWithTag:999]; // 备注
    [orderDic setObject:noteTF.text forKey:@"remark"];
    
    NSMutableString *nameString = [[NSMutableString alloc] init];
    for (NSString *name in self.playerArray) {
        nameString = [NSMutableString stringWithFormat:@"%@、 %@",nameString, name];
    }
    [orderDic setObject:[nameString substringFromIndex:2] forKey:@"playPersonNames"];
    
    [dic setObject:orderDic forKey:@"order"];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    [dic setObject:[self.detailDic objectForKey:@"timeKey"] forKey:@"bookBallParkKey"];
    
    [[ShowHUD showHUD] showAnimationWithText:@"加载中…" FromView:self.view];
    
    [[JsonHttp jsonHttp] httpRequestHaveSpaceWithMD5:@"bookingOrder/doCreateBookingOrder" JsonKey:nil withData:dic failedBlock:^(id errType) {
        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        
    } completionBlock:^(id data) {
        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            [MobClick event:@"booking_ball_normal_click"];

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
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
    
    
}


#pragma mark - UITableViewDelegate&&UItableviewDatasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 0) {
        JGDCostumTableViewCell *cell = [[JGDCostumTableViewCell alloc] init];
        UILabel *titleLB = [self lablerect:CGRectMake(5 * ProportionAdapter, 0, 90 * ProportionAdapter, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:(16 * ProportionAdapter) text:@"球场：" textAlignment:(NSTextAlignmentRight)];
        [cell.contentView addSubview:titleLB];
        
        UILabel *ballNameLB = [self lablerect:CGRectMake(100 * ProportionAdapter, 0, 260 * ProportionAdapter, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(16 * ProportionAdapter) text:[self.detailDic objectForKey:@"ballName"] textAlignment:(NSTextAlignmentLeft)];
        [cell.contentView addSubview:ballNameLB];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 49.5 * ProportionAdapter, screenWidth - 10 * ProportionAdapter, 0.5 * ProportionAdapter)];
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

        // 带圆角背景
        UIView *layerView = [Factory createViewWithBackgroundColor:RGB(254,250,243) frame:CGRectMake(10 * ProportionAdapter, 0, (int)(screenWidth - 20 * ProportionAdapter), (int) 35 * ProportionAdapter)];
        layerView.layer.cornerRadius = 6;
        layerView.clipsToBounds = YES;
        
        UILabel *tipLB = [self lablerect:layerView.bounds labelColor:RGB(99,99,99) labelFont:(15 * ProportionAdapter) text:begainDate textAlignment:(NSTextAlignmentCenter)];
        [layerView addSubview:tipLB];
        
        NSMutableAttributedString *mutabeAtr = [[NSMutableAttributedString alloc] initWithString:begainDate];
        
        UIImage *img = [UIImage imageNamed:@"order_icn_remark"];
        NSTextAttachment *textAttach = [[NSTextAttachment alloc]init];
        textAttach.image = img;
        textAttach.bounds = CGRectMake(-3 * ProportionAdapter, -1 * ProportionAdapter, 14 * ProportionAdapter, 14 * ProportionAdapter);
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:textAttach];
        [mutabeAtr insertAttributedString:string atIndex:0];
        
        tipLB.attributedText = mutabeAtr;
        
        [cell.contentView addSubview:layerView];
        
        UILabel *lB = [[UILabel alloc] initWithFrame:CGRectMake(0, 40 * ProportionAdapter, screenWidth, 10 * ProportionAdapter)];
        lB.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [cell.contentView addSubview:lB];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.row == 3) {
        JGDCostumTableViewCell *cell = [[JGDCostumTableViewCell alloc] init];
        UILabel *titleLB = [self lablerect:CGRectMake(5 * ProportionAdapter, 0, 90 * ProportionAdapter, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:(16 * ProportionAdapter) text:@"打球人数：" textAlignment:(NSTextAlignmentRight)];
        [cell.contentView addSubview:titleLB];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(262 * ProportionAdapter, 10 * ProportionAdapter, 30 * ProportionAdapter, 30 * ProportionAdapter)];
        if ([self.playerArray count] == 1) {
            [leftBtn setImage:[UIImage imageNamed:@"order_minus"] forState:(UIControlStateNormal)]; // 灰色
        }else{
            [leftBtn setImage:[UIImage imageNamed:@"order_minus-color"] forState:(UIControlStateNormal)];
        }
        leftBtn.tag = 500;
        [leftBtn addTarget:self action:@selector(countChanege:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.contentView addSubview:leftBtn];
        
        self.countLB = [self lablerect:CGRectMake(290 * ProportionAdapter, 12 * ProportionAdapter, 50 * ProportionAdapter, 26 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(17 * ProportionAdapter) text:[NSString stringWithFormat:@"%td人", [self.playerArray count]] textAlignment:(NSTextAlignmentCenter)];
        [cell.contentView addSubview:self.countLB];
        
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(338 * ProportionAdapter, 10 * ProportionAdapter, 30 * ProportionAdapter, 30 * ProportionAdapter)];
        rightBtn.tag = 501;
        [rightBtn addTarget:self action:@selector(countChanege:) forControlEvents:(UIControlEventTouchUpInside)];
        [rightBtn setImage:[UIImage imageNamed:@"order_add"] forState:(UIControlStateNormal)]; // 黑色
        [cell.contentView addSubview:rightBtn];
        
        
        return cell;
        
    }else if (indexPath.row == 5 + [self.playerArray count]) {
        
        SelectRedPacketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectRedPacketTableViewCellID"];
        if (_selectModel.timeKey) {
            [cell configSelectData:_selectModel];
        }else{
            NSInteger canUseNum = [self getCanUseNum];
            [cell configData:canUseNum];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 6 + [self.playerArray count]) {
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
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        JGDBallPlayTableViewCell *cell = [[JGDBallPlayTableViewCell alloc] init];
        NSString *title;
        indexPath.row == 4 ? (title = @"联系方式：") : (title = @"打球人：");
        if (indexPath.row == 4) {
            cell.nameTF.text = [def objectForKey:Mobile];
            self.mobile = [def objectForKey:Mobile];
            [cell.phoneImageV removeFromSuperview];
        }else {
            cell.nameTF.text = self.playerArray[indexPath.row - 5];
            
        }
        
        [cell.nameTF.text length] > 0 ? (cell.phoneImageV.hidden = YES) : (cell.phoneImageV.hidden = NO);
        cell.titleLB.text = title;
        cell.nameTF.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.phoneImageV addTarget:self action:@selector(contactAdd:) forControlEvents:(UIControlEventTouchUpInside)];
        return cell;
        
    }
    
    
}

- (void)contactAdd:(UIButton *)btn{
    [self.commitOrderTableView endEditing:YES];
    JGDContactViewController *contactVC = [[JGDContactViewController alloc] init];
    contactVC.blockAddressUserName = ^(NSString *userName){
        JGDBallPlayTableViewCell *cell = (JGDBallPlayTableViewCell *)[[btn superview] superview];
        NSIndexPath *index = [self.commitOrderTableView indexPathForCell:cell];
        cell.nameTF.text = userName;
        self.playerArray[index.row - 5] = userName;
        cell.phoneImageV.hidden = YES;
    };
    [self.navigationController pushViewController:contactVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 7 + [self.playerArray count];
}




- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 25 * ProportionAdapter)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *lB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 10 * ProportionAdapter)];
    lB.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [view addSubview:lB];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 0 : 10 * ProportionAdapter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 2) {
        return 50 * ProportionAdapter;
    }else if (indexPath.row > 4 + [self.playerArray count]) {
        return 60 * ProportionAdapter;
    }
    else{
        return 50 * ProportionAdapter;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        LGLCalenderViewController *caleVC = [[LGLCalenderViewController alloc] init];
        caleVC.dateString = self.selectDate;
        caleVC.ballKey = self.timeKey;
        caleVC.isLeagueUser = NO;
        caleVC.blockTimeWithPrice = ^(NSString *selectTime, NSString *pay, NSString *scenePay, NSString *deductionMoney, NSString *leagueMoney){

            self.selectDate = selectTime;
            
            
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
//                self.selectMoney = pay;
                
            }else if ([[self.detailDic objectForKey:@"payType"] integerValue] == 1) {
                //         部分预付
                if ([self.selectSceneMoney isEqualToString:@""]) {
                    self.selectMoney = pay;
                }else{
                    self.selectMoney = [NSString stringWithFormat:@"%td", [pay integerValue] - [self.selectSceneMoney integerValue]];
                }
                
            }else{
                //         全额预付
                if ([self.selectSceneMoney isEqualToString:@""]) {
                    self.selectMoney = pay;
                }else{
                    self.selectMoney = [NSString stringWithFormat:@"%td", [pay integerValue] - [self.selectSceneMoney integerValue]];
                }
            }
            
            [self payMoneySet];
            
            
            NSIndexPath *indexPath0 = [NSIndexPath indexPathForRow:2 inSection:0];
            NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:0];
            
            [self.commitOrderTableView reloadRowsAtIndexPaths:@[indexPath0, indexPath1] withRowAnimation:NO];

            
            };
        [self.navigationController pushViewController:caleVC animated:YES];

    }else if (indexPath.row == 5 + [self.playerArray count]){
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
    }else{
        JGDBallPlayTableViewCell *cell = (JGDBallPlayTableViewCell *)[[textField superview] superview];
        NSIndexPath *index = [self.commitOrderTableView indexPathForCell:cell];
        if ([textField.text length] > 0) {
            cell.phoneImageV.hidden = YES;
        }else{
            cell.phoneImageV.hidden = NO;
        }
        if (index.row >=5) {
            self.playerArray[index.row - 5] = textField.text;
        }else if (index.row == 4) {
            self.mobile = textField.text;
        }

    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField.tag != 999) {
        JGDBallPlayTableViewCell *cell = (JGDBallPlayTableViewCell *)[[textField superview] superview];
        if ([textField.text length] > 0) {
            cell.phoneImageV.hidden = YES;
        }
    }
}


#pragma mark -- Action
//人数加减
- (void)countChanege:(UIButton *)btn{
    
    UIButton *leftBtn = [self.commitOrderTableView viewWithTag:500];
    if (btn.tag == 500) { // －
        
        if (self.playerArray.count > 1) {
            self.countLB.text = [NSString stringWithFormat:@"%td人", [self.playerArray count] - 1];
            
            [self.playerArray removeLastObject];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 + [self.playerArray count] inSection:0];
            [self.commitOrderTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
        }
        
        [self.playerArray count] == 1 ?[leftBtn setImage:[UIImage imageNamed:@"order_minus"] forState:(UIControlStateNormal)] : @"";
        //判断当前红包是否可用
        [self checkRedpacket];
    }else{ // +
        
        if ([self.playerArray count] == 1) {
            [leftBtn setImage:[UIImage imageNamed:@"order_minus-color"] forState:(UIControlStateNormal)];
        }
        self.countLB.text = [NSString stringWithFormat:@"%td人", [self.playerArray count] + 1];
        
        [self.playerArray addObject:@""];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 + [self.playerArray count] inSection:0];
        [self.commitOrderTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
        
    }
    
    [self payMoneySet];
}



#pragma mark --- 单人删除


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = 5 + [self.playerArray count];
    
    if (indexPath.row > 5 && indexPath.row != row) {
        return YES;
    }else{
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UIButton *leftBtn = [tableView viewWithTag:500];

    
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        if (self.playerArray.count > 1) {
            self.countLB.text = [NSString stringWithFormat:@"%td人", [self.playerArray count] - 1];
            NSLog(@"%td" ,indexPath.row);
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
    
    NSInteger money = [self.selectMoney integerValue] * ([self.playerArray count]) - _selectModel.money;
    NSString *moneyStr = [NSString stringWithFormat:@"%@  ¥%td", paytypeString, money];
    NSMutableAttributedString *mutaAttStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    [mutaAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 * ProportionAdapter] range:NSMakeRange(6, 1)];
    [mutaAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#fc5a01"] range:NSMakeRange(6, moneyStr.length-6)];
    self.payMoneyLB.attributedText = mutaAttStr;
    
    
    self.scenePayMoneyLB.text = [NSString stringWithFormat:@"%@  ¥%td", paytypeString, [self.selectSceneMoney integerValue] * ([self.playerArray count])];
    NSMutableAttributedString *sceneAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"现场支付  ¥%td", [self.selectSceneMoney integerValue] * ([self.playerArray count])]];
    [sceneAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 * ProportionAdapter] range:NSMakeRange(6, 1)];
    self.scenePayMoneyLB.attributedText = sceneAttStr;
    
    [self reloadCellData];
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




- (NSMutableArray *)playerArray{
    if (!_playerArray) {
        _playerArray = [NSMutableArray arrayWithObjects:@"", nil];
    }
    return _playerArray;
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
