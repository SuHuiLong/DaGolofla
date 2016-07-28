//
//  JGHWithdrawViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHWithdrawViewController.h"
#import "JGHTradRecordImageCell.h"
#import "JGSignUoPromptCell.h"
#import "JGHButtonCell.h"
#import "JGLBankModel.h"
#import "JGHTextFiledCell.h"
#import "JGHSelectBlanKCardView.h"
#import "JGHBlanKCardPasswordViewController.h"
#import "JGHNOBlankPasswordViewController.h"
#import "JGLBankListViewController.h"

static NSString *const JGHButtonCellIdentifier = @"JGHButtonCell";
static NSString *const JGSignUoPromptCellIdentifier = @"JGSignUoPromptCell";
static NSString *const JGHTextFiledCellIdentifier = @"JGHTextFiledCell";
static NSString *const JGHTradRecordImageCellIdentifier = @"JGHTradRecordImageCell";

@interface JGHWithdrawViewController ()<UITableViewDataSource, UITableViewDelegate, JGHButtonCellDelegate, UITextFieldDelegate, JGHSelectBlanKCardViewDelegate>
{
    NSString *_reaplyBalance;
    
}

@property (nonatomic, strong)UITableView *withdrawTableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong)JGLBankModel *model;

@property (nonatomic, strong)JGHSelectBlanKCardView *blankCatoryView;

@property (nonatomic, strong)UIView *tranView;//遮照

@property (nonatomic, strong)UILabel *txtLable;

@end

@implementation JGHWithdrawViewController

- (instancetype)init{
    if (self == [super init]) {
        self.dataArray = [NSMutableArray array];
        self.model = [[JGLBankModel alloc]init];
    }
    return self;
}

- (UILabel *)txtLable{
    if (_txtLable == nil) {
        self.txtLable = [[UILabel alloc]init];
    }
    return _txtLable;
}

- (UIView *)tranView{
    if (_tranView == nil) {
        self.tranView = [[UIView alloc]init];
        self.tranView.backgroundColor = [UIColor lightGrayColor];
        self.tranView.alpha = 0.4;
        [self.view addSubview:_tranView];
    }
    return _tranView;
}

- (JGHSelectBlanKCardView *)blankCatoryView{
    if (_blankCatoryView == nil) {
        self.blankCatoryView = [[JGHSelectBlanKCardView alloc]init];
        self.blankCatoryView.delegate = self;
        [self.view addSubview:_blankCatoryView];
    }
    return _blankCatoryView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"提现";
    
    [self createRefoundTableView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self loadData];
}

- (void)loadData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:userID] forKey:@"userKey"];
    [[JsonHttp jsonHttp]httpRequest:@"user/getUserBankCardList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        NSLog(@"data == %@", data);
        [self.dataArray removeAllObjects];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            NSMutableArray *array = [NSMutableArray array];
            array = [data objectForKey:@"userBankCardList"];
            for (NSMutableDictionary *dict in array) {
                JGLBankModel *model = [[JGLBankModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
            }
        }
        
        if (_dataArray.count > 0) {
            _model = [_dataArray objectAtIndex:0];
        }
        
        [_blankCatoryView configViewData:_dataArray];
        
        [self.withdrawTableView reloadData];
    }];
}

- (void)createRefoundTableView{
    self.withdrawTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) style:UITableViewStyleGrouped];
    self.withdrawTableView.delegate = self;
    self.withdrawTableView.dataSource = self;
    self.withdrawTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *promptNib = [UINib nibWithNibName:@"JGSignUoPromptCell" bundle: [NSBundle mainBundle]];
    [self.withdrawTableView registerNib:promptNib forCellReuseIdentifier:JGSignUoPromptCellIdentifier];
    
    UINib *catoryNib = [UINib nibWithNibName:@"JGHButtonCell" bundle: [NSBundle mainBundle]];
    [self.withdrawTableView registerNib:catoryNib forCellReuseIdentifier:JGHButtonCellIdentifier];
    
    UINib *cellNib = [UINib nibWithNibName:@"JGHTextFiledCell" bundle: [NSBundle mainBundle]];
    [self.withdrawTableView registerNib:cellNib forCellReuseIdentifier:JGHTextFiledCellIdentifier];
    
    UINib *recordNib = [UINib nibWithNibName:@"JGHTradRecordImageCell" bundle: [NSBundle mainBundle]];
    [self.withdrawTableView registerNib:recordNib forCellReuseIdentifier:JGHTradRecordImageCellIdentifier];
    
    [self.view addSubview:self.withdrawTableView];
}

#pragma mark -- tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 70 *ProportionAdapter;
    }else if (indexPath.section == 1){
        return 40*ProportionAdapter;
    }
    return 45 * ProportionAdapter;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        return 25 * ProportionAdapter;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGHTradRecordImageCell *tradCell = [tableView dequeueReusableCellWithIdentifier:JGHTradRecordImageCellIdentifier];
        tradCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_dataArray.count > 0) {
            [self.txtLable removeFromSuperview];
            [tradCell configJGLBankModel:_model];
        }else{
            self.txtLable.frame =CGRectMake((screenWidth- 100)/2, (tradCell.frame.size.height-20)/2, 100, 20);
            _txtLable.text = @"请添加银行卡";
            _txtLable.font = [UIFont systemFontOfSize:15.0*ProportionAdapter];
            [tradCell addSubview:_txtLable];
        }
        
        return tradCell;
    }else if (indexPath.section == 1){
        
        JGSignUoPromptCell *promptCell = [tableView dequeueReusableCellWithIdentifier:JGSignUoPromptCellIdentifier];
        
        promptCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [promptCell configPromptString:@"提示：每笔金额提现最少为10元，预计两小时到账"];
        return promptCell;
    }else if (indexPath.section == 2){
        JGHTextFiledCell *withdrawCell = [tableView dequeueReusableCellWithIdentifier:JGHTextFiledCellIdentifier];
        
        withdrawCell.selectionStyle = UITableViewCellSelectionStyleNone;
        withdrawCell.titlefileds.delegate = self;
        [withdrawCell configViewWithDraw:_balance];
        
        return withdrawCell;
    }else{
        JGHButtonCell *btnCell = [tableView dequeueReusableCellWithIdentifier:JGHButtonCellIdentifier];
        
        btnCell.selectionStyle = UITableViewCellSelectionStyleNone;
        btnCell.delegate = self;
        btnCell.backgroundColor = [UIColor colorWithHexString:BG_color];
        [btnCell.clickBtn setTitle:@"下一步" forState:UIControlStateNormal];
        return btnCell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        self.tranView.hidden = NO;
        self.blankCatoryView.hidden = NO;
        if (screenHeight <= (((_dataArray.count +1) * 60)*ProportionAdapter + 108 + 30*ProportionAdapter)){
            self.tranView.frame = CGRectMake(0, 0, screenWidth, 0);
            self.tranView.hidden = YES;
            self.blankCatoryView.frame = CGRectMake(0, 0, screenWidth, screenHeight -64);
            [_blankCatoryView configViewData:_dataArray];
        }else{
            self.tranView.frame = CGRectMake(0, 0, screenWidth, screenHeight - ((_dataArray.count+1) * 60)*ProportionAdapter-64 -44-30*ProportionAdapter);
            NSLog(@"%f", 30*ProportionAdapter);
            self.blankCatoryView.frame = CGRectMake(0, screenHeight - ((_dataArray.count+1) * 60)*ProportionAdapter-64-44-30*ProportionAdapter, screenWidth, 30*ProportionAdapter + 44 + ((_dataArray.count+1) * 60)*ProportionAdapter);
            [_blankCatoryView configViewData:_dataArray];
        }
    }
}

#pragma mark -- 下一步
- (void)selectCommitBtnClick:(UIButton *)btn{
    NSLog(@"下一步");
    [self.view endEditing:YES];
    
    if (_reaplyBalance.length == 0) {
        [[ShowHUD showHUD]showToastWithText:@"请输入提现金额！" FromView:self.view];
        return;
    }
    
    if (![Helper isPureNumandCharacters:_reaplyBalance]) {
        [[ShowHUD showHUD]showToastWithText:@"提现金额必须为纯数字！" FromView:self.view];
        return;
    }
    
    if ([_reaplyBalance floatValue] < 10.0) {
        [[ShowHUD showHUD]showToastWithText:@"提现金额最少为10元！" FromView:self.view];
        return;
    }
    
    if ([_reaplyBalance floatValue] > [_balance floatValue]) {
        [[ShowHUD showHUD]showToastWithText:@"提现金额大于账户余额！" FromView:self.view];
        return;
    }
    
    btn.enabled = NO;
    [[ShowHUD showHUD]showAnimationWithText:@"提交中..." FromView:self.view];
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
                JGHBlanKCardPasswordViewController *passCtrl = [[JGHBlanKCardPasswordViewController alloc]init];
                passCtrl.reaplyBalance = [_reaplyBalance floatValue];
                passCtrl.bankCardKey = [_model.timeKey floatValue];
                [self.navigationController pushViewController:passCtrl animated:YES];
            }else{
                
                [Helper alertViewWithTitle:@"您还没有交易密码，无法提现，是否现在设置？" withBlockCancle:^{
                    
                } withBlockSure:^{
                    JGHNOBlankPasswordViewController *passNOCtrl = [[JGHNOBlankPasswordViewController alloc]init];
                    passNOCtrl.reaplyBalance = [_reaplyBalance floatValue];
                    [self.navigationController pushViewController:passNOCtrl animated:YES];
                } withBlock:^(UIAlertController *alertView) {
                    [self presentViewController:alertView animated:YES completion:nil];
                }];
            }
        }
    }];
    
    btn.enabled = YES;
}

#pragma mark -- 选择银行卡－－取消
- (void)seleCancelBtn:(UIButton *)btn{
    NSLog(@"取消");
    _tranView.hidden = YES;
    _blankCatoryView.hidden = YES;
}
#pragma mark -- 选择银行卡－－确定
- (void)selectSubmitBtn:(UIButton *)btn{
    NSLog(@"确定");
    _tranView.hidden = YES;
    _blankCatoryView.hidden = YES;
    if (_dataArray.count > 0) {
        _model = [_dataArray objectAtIndex:btn.tag];
    }
    
    [self.withdrawTableView reloadData];
}
#pragma mark -- 添加银行卡
- (void)addBlankCard{
    JGLBankListViewController* userVc = [[JGLBankListViewController alloc]init];
    _tranView.hidden = YES;
    _blankCatoryView.hidden = YES;
    [self.navigationController pushViewController:userVc animated:YES];
}
#pragma mark -- UITextFliaView
- (void)textFieldDidEndEditing:(UITextField *)textField{
    _reaplyBalance = textField.text;
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
