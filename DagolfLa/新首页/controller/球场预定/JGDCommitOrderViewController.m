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

@interface JGDCommitOrderViewController () <UITableViewDelegate, UITableViewDataSource ,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *commitOrderTableView;

@property (nonatomic, strong) NSMutableArray *playerArray;

@property (nonatomic, strong) UILabel *countLB;

@property (nonatomic, strong) UILabel *placeHoler;

@property (nonatomic, strong) UILabel *payMoneyLB; // 支付金额

@property (nonatomic, strong) UILabel *scenePayMoneyLB;  // 现场支付

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, strong) UITextField *noteTF; // 备注

@end

@implementation JGDCommitOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提交订单";
    
    [self commitOrderTable];
    // Do any additional setup after loading the view.
}


- (void)commitOrderTable{
    
    self.commitOrderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64 * ProportionAdapter) style:(UITableViewStylePlain)];
    self.commitOrderTableView.delegate = self;
    self.commitOrderTableView.dataSource = self;
    [self.view addSubview:self.commitOrderTableView];
    
    self.commitOrderTableView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    self.commitOrderTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.commitOrderTableView registerClass:[JGDBallPlayTableViewCell class] forCellReuseIdentifier:@"ballPlayCell"];
    
    // "付款类型 0: 全额预付  1: 部分预付  2: 球场现付"
    if ([[self.detailDic objectForKey:@"payType"] integerValue] == 0) {
        
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 120 * ProportionAdapter)];
        
        self.payMoneyLB = [self lablerect:CGRectMake(220 * ProportionAdapter, 0, 140 * ProportionAdapter, 40 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(16 * ProportionAdapter) text:[NSString stringWithFormat:@"支付金额  ¥%@", self.selectMoney] textAlignment:(NSTextAlignmentRight)];
        NSMutableAttributedString *mutaAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"支付金额  ¥%@", self.selectMoney]];
        [mutaAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 * ProportionAdapter] range:NSMakeRange(6, 1)];
        [mutaAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#fc5a01"] range:NSMakeRange(6, [[NSString stringWithFormat:@"%@",self.selectMoney] length] + 1)];
        self.payMoneyLB.attributedText = mutaAttStr;
        [footView addSubview:self.payMoneyLB];
        
        UIButton *commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 41 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 40 * ProportionAdapter)];
        [commitBtn setTitle:@"确定预定" forState:(UIControlStateNormal)];
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
        
        
        self.payMoneyLB = [self lablerect:CGRectMake(220 * ProportionAdapter, 0, 140 * ProportionAdapter, 40 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(16 * ProportionAdapter) text:[NSString stringWithFormat:@"支付金额  ¥%@", self.selectMoney] textAlignment:(NSTextAlignmentRight)];
        NSMutableAttributedString *mutaAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"支付金额  ¥%@", self.selectMoney]];
        [mutaAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 * ProportionAdapter] range:NSMakeRange(6, 1)];
        [mutaAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#fc5a01"] range:NSMakeRange(6, [[NSString stringWithFormat:@"%@",self.selectMoney] length] + 1)];
        self.payMoneyLB.attributedText = mutaAttStr;
        [footView addSubview:self.payMoneyLB];
        
        UIButton *commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 41 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 40 * ProportionAdapter)];
        [commitBtn setTitle:@"确定预定" forState:(UIControlStateNormal)];
        commitBtn.backgroundColor = [UIColor colorWithHexString:@"#fc5a01"];
        [commitBtn addTarget:self action:@selector(ConfirmAct) forControlEvents:(UIControlEventTouchUpInside)];
        commitBtn.layer.cornerRadius = 6;
        commitBtn.clipsToBounds = YES;
        [footView addSubview:commitBtn];
        self.commitOrderTableView.tableFooterView = footView;
        
    }else if ([[self.detailDic objectForKey:@"payType"] integerValue] == 2) {
        
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 130 * ProportionAdapter)];
        
        NSString *ruleString = @"押金退还规则：\n1、预订日打完球后48小时内，系统自动退还押金至您付款账户；\n2、成功取消订单后48小时内，系统自动退还押金到您付款账户；";
        
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
        [commitBtn setTitle:@"确定预定" forState:(UIControlStateNormal)];
        commitBtn.backgroundColor = [UIColor colorWithHexString:@"#fc5a01"];
        [commitBtn addTarget:self action:@selector(ConfirmAct) forControlEvents:(UIControlEventTouchUpInside)];
        commitBtn.layer.cornerRadius = 6;
        commitBtn.clipsToBounds = YES;
        [footView addSubview:commitBtn];
        footView.frame = CGRectMake(0, 0, screenWidth, height + 110 * ProportionAdapter);
        self.commitOrderTableView.tableFooterView = footView;
        
    }
}





#pragma mark --- 确定预定支付

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
    [orderDic setObject:[self.detailDic objectForKey:@"timeKey"] forKey:@"srcKey"];
    [orderDic setObject:self.noteTF.text forKey:@"remark"];
    [orderDic setObject:self.selectDate forKey:@"teeTime"];
    [orderDic setObject:@([self.playerArray count]) forKey:@"userSum"];
    [orderDic setObject:self.playerArray[0] forKey:@"userName"];
    [orderDic setObject:self.mobile forKey:@"userMobile"];
    
    NSMutableString *nameString = [[NSMutableString alloc] init];
    for (NSString *name in self.playerArray) {
        nameString = [NSMutableString stringWithFormat:@"%@, %@",nameString, name];
    }
    [orderDic setObject:[nameString substringFromIndex:2] forKey:@"playPersonNames"];
    
    [dic setObject:orderDic forKey:@"order"];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    
    [[ShowHUD showHUD] showAnimationWithText:@"加载中…" FromView:self.view];
    
    [[JsonHttp jsonHttp] httpRequestHaveSpaceWithMD5:@"bookingOrder/doCreateBookingOrder" JsonKey:nil withData:dic failedBlock:^(id errType) {
        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        
    } completionBlock:^(id data) {
        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            if ([data objectForKey:@"orderKey"]) {
                
                JGDConfirmPayViewController *confirVC = [[JGDConfirmPayViewController alloc] init];
                confirVC.payMoney = [[data objectForKey:@"money"] integerValue];
                confirVC.orderKey = [data objectForKey:@"orderKey"];
                [self.navigationController pushViewController:confirVC animated:YES];
            }
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 0) {
        JGDCostumTableViewCell *cell = [[JGDCostumTableViewCell alloc] init];
        UILabel *titleLB = [self lablerect:CGRectMake(5 * ProportionAdapter, 0, 90 * ProportionAdapter, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:(16 * ProportionAdapter) text:@"球场：" textAlignment:(NSTextAlignmentRight)];
        [cell.contentView addSubview:titleLB];
        
        UILabel *ballNameLB = [self lablerect:CGRectMake(100 * ProportionAdapter, 0, 260 * ProportionAdapter, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(17 * ProportionAdapter) text:[self.detailDic objectForKey:@"ballName"] textAlignment:(NSTextAlignmentLeft)];
        [cell.contentView addSubview:ballNameLB];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 49.5 * ProportionAdapter, screenWidth - 10 * ProportionAdapter, 0.5 * ProportionAdapter)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#a0a0a0"];
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
        
        UILabel *tipLB = [self lablerect:CGRectMake(10 * ProportionAdapter, 0, screenWidth - 20 * ProportionAdapter, 35 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#636363"] labelFont:(15 * ProportionAdapter) text:begainDate textAlignment:(NSTextAlignmentRight)];
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
    }else if (indexPath.row == 3) {
        JGDCostumTableViewCell *cell = [[JGDCostumTableViewCell alloc] init];
        UILabel *titleLB = [self lablerect:CGRectMake(5 * ProportionAdapter, 0, 90 * ProportionAdapter, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:(16 * ProportionAdapter) text:@"打球人数：" textAlignment:(NSTextAlignmentRight)];
        [cell.contentView addSubview:titleLB];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(264 * ProportionAdapter, 12 * ProportionAdapter, 26 * ProportionAdapter, 26 * ProportionAdapter)];
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
        
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(340 * ProportionAdapter, 12 * ProportionAdapter, 26 * ProportionAdapter, 26 * ProportionAdapter)];
        rightBtn.tag = 501;
        [rightBtn addTarget:self action:@selector(countChanege:) forControlEvents:(UIControlEventTouchUpInside)];
        [rightBtn setImage:[UIImage imageNamed:@"order_add"] forState:(UIControlStateNormal)]; // 黑色
        [cell.contentView addSubview:rightBtn];
        
        
        return cell;
        
    }else if (indexPath.row == 5 + [self.playerArray count]) {
        JGDCostumTableViewCell *cell = [[JGDCostumTableViewCell alloc] init];
        UILabel *lB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 10 * ProportionAdapter)];
        lB.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [cell addSubview:lB];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.noteTF = [[UITextField alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 10 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 50 * ProportionAdapter)];
        self.noteTF.placeholder = @"请输入备注信息";
        self.noteTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.noteTF.font = [UIFont systemFontOfSize:16 * ProportionAdapter];
        [cell.contentView addSubview:self.noteTF];
        //        UITextView *noteView = [[UITextView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 20 * ProportionAdapter, screenWidth - 20 * ProportionAdapter, 60 * ProportionAdapter)];
        //        [cell addSubview:noteView];
        //
        //        self.placeHoler = [self lablerect:CGRectMake(0, 0, 200, 20) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:(15 * ProportionAdapter) text:@"请输入备注信息" textAlignment:(NSTextAlignmentLeft)];
        //        [noteView addSubview:self.placeHoler];
        
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
    
    return 6 + [self.playerArray count];
}


//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 3;
//}

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
    }
    else if (indexPath.row == 5 + [self.playerArray count]) {
        return 60 * ProportionAdapter;
    }
    else{
        return 50 * ProportionAdapter;
    }
    
    
    
    //    return indexPath.section == 2 ? 70 * ProportionAdapter : 50 * ProportionAdapter;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@""] && [textField.text length] == 1) {
        // 全删
        JGDBallPlayTableViewCell *cell = (JGDBallPlayTableViewCell *)[[textField superview] superview];
        cell.phoneImageV.hidden = NO;
        
    }else{
        JGDBallPlayTableViewCell *cell = (JGDBallPlayTableViewCell *)[[textField superview] superview];
        cell.phoneImageV.hidden = YES;
    }
    
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    JGDBallPlayTableViewCell *cell = (JGDBallPlayTableViewCell *)[[textField superview] superview];
    NSIndexPath *index = [self.commitOrderTableView indexPathForCell:cell];
    cell.phoneImageV.hidden = NO;
    if (index.row >=5) {
        self.playerArray[index.row - 5] = @"";
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
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

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    JGDBallPlayTableViewCell *cell = (JGDBallPlayTableViewCell *)[[textField superview] superview];
    if ([textField.text length] > 0) {
        cell.phoneImageV.hidden = YES;
    }
}


#pragma mark --- 人数加减

- (void)countChanege:(UIButton *)btn{
    
    UIButton *leftBtn = [self.commitOrderTableView viewWithTag:500];
    //    UIButton *rightBtn = [self.commitOrderTableView viewWithTag:501];
    
    if (btn.tag == 500) { // －
        
        if (self.playerArray.count > 1) {
            self.countLB.text = [NSString stringWithFormat:@"%td人", [self.playerArray count] - 1];
            
            [self.playerArray removeLastObject];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 + [self.playerArray count] inSection:0];
            [self.commitOrderTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
        }
        
        [self.playerArray count] == 1 ?[leftBtn setImage:[UIImage imageNamed:@"order_minus"] forState:(UIControlStateNormal)] : @"";
        
    }else{ // +
        
        if ([self.playerArray count] == 1) {
            [leftBtn setImage:[UIImage imageNamed:@"order_minus-color"] forState:(UIControlStateNormal)];
        }
        self.countLB.text = [NSString stringWithFormat:@"%td人", [self.playerArray count] + 1];
        
        [self.playerArray addObject:@""];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 + [self.playerArray count] inSection:0];
        [self.commitOrderTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
        
    }
    
    NSString *paytypeString = @"";
    
    if ([[self.detailDic objectForKey:@"payType"] integerValue] == 2) {
        paytypeString = @"预付押金";
    }else{
        paytypeString = @"支付金额";
    }
    
    
    self.payMoneyLB.text = [NSString stringWithFormat:@"%@  ¥%td", paytypeString, [[self.detailDic objectForKey:@"payMoney"] integerValue] * ([self.playerArray count])];
    NSMutableAttributedString *mutaAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  ¥%td", paytypeString, [[self.detailDic objectForKey:@"payMoney"] integerValue] * ([self.playerArray count])]];
    [mutaAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 * ProportionAdapter] range:NSMakeRange(6, 1)];
    [mutaAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#fc5a01"] range:NSMakeRange(6, [[NSString stringWithFormat:@"%td", [[self.detailDic objectForKey:@"payMoney"] integerValue] * ([self.playerArray count])] length] + 1)];
    self.payMoneyLB.attributedText = mutaAttStr;
    
    
    self.scenePayMoneyLB.text = [NSString stringWithFormat:@"%@  ¥%td", paytypeString, [[self.detailDic objectForKey:@"unitPaymentMoney"] integerValue] * ([self.playerArray count])];
    NSMutableAttributedString *sceneAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"现场支付  ¥%td", [[self.detailDic objectForKey:@"unitPaymentMoney"] integerValue] * ([self.playerArray count])]];
    [sceneAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 * ProportionAdapter] range:NSMakeRange(6, 1)];
    self.scenePayMoneyLB.attributedText = sceneAttStr;
    
    
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
        _playerArray = [NSMutableArray arrayWithObjects:[[NSUserDefaults standardUserDefaults] objectForKey:UserName], nil];
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
