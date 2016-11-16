//
//  JGLPaySignUpViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/6/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLPaySignUpViewController.h"
#import "JGLPayHeaderTableViewCell.h"
#import "JGLSignPeoTableViewCell.h"
#import "JGLPayListTableViewCell.h"

#import "UITool.h"

#import "MJRefresh.h"
#import "MJDIYHeader.h"

#import "JGTeamAcitivtyModel.h"
#import "JGHRepeatApplyView.h"
#import "JGTeamGroupViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "JGTeamApplyViewController.h"
#import "JGHAddInvoiceViewController.h"
#import "UITool.h"
#import "JGDSetBusinessPWDViewController.h"
#import "WCLPassWordView.h"
#import "JGHbalanceView.h"

@interface JGLPaySignUpViewController ()<UITableViewDelegate,UITableViewDataSource, JGHRepeatApplyViewDelegate,JGHAddInvoiceViewControllerDelegate, WCLPassWordViewDelegate, JGHbalanceViewDelegate>
{
    UITableView* _tableView;
    UIView* _viewFoott;
    
    NSInteger _page;
    
    NSMutableArray* _dataArrayYet;//已付款
    NSMutableArray* _dataArrayWait;//代付款
    
    UIAlertController *_actionView;
    NSMutableDictionary* _numDict;//用来记录被删除的数组下表
    NSString *_infoKey;//支付用
    
    UIView *_bgView;
}

@property (nonatomic, strong)JGHbalanceView *balanceView;

@property (nonatomic, strong)JGHRepeatApplyView *applyListView;//报名人列表

@property (nonatomic, strong)UIView *tranView;

@property (nonatomic, strong)NSMutableDictionary *info;

@property (nonatomic, strong)NSMutableArray *applyDataArray;

@property (nonatomic, strong)NSMutableDictionary *payDict;

@property (nonatomic, strong)WCLPassWordView *passWordView;

@end

@implementation JGLPaySignUpViewController

- (instancetype)init{
    if (self == [super init]) {
        self.model = [[JGTeamAcitivtyModel alloc]init];
        self.applyDataArray = [NSMutableArray array];
        self.info = [NSMutableDictionary dictionary];
        self.payDict = [NSMutableDictionary dictionary];
    }
    return self;
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

- (JGHRepeatApplyView *)applyListView{
    if (_applyListView == nil) {
        self.applyListView = [[JGHRepeatApplyView alloc]init];
        self.applyListView.delegate = self;
        self.applyListView.subsidiesPrice = [_model.subsidyPrice floatValue];
        [self.view addSubview:_applyListView];
    }
    return _applyListView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:view];
    
    _page = 0;
    self.title = @"报名/支付";
    _dataArrayYet = [[NSMutableArray alloc]init];
    _dataArrayWait = [[NSMutableArray alloc]init];
    _numDict = [[NSMutableDictionary alloc]init];
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self createFooterView];
    [self uiConfig];
    
    [self createBtn];
    
}

-(void)createBtn
{
    UIButton* btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDelete.backgroundColor = [UIColor orangeColor];
    [btnDelete setTitle:@"继续报名" forState:UIControlStateNormal];
    [btnDelete setTintColor:[UIColor whiteColor]];
    if ([[Helper returnCurrentDateString] compare:_model.signUpEndTime] < 0) {
        [btnDelete addTarget:self action:@selector(addPeopleClick) forControlEvents:UIControlEventTouchUpInside];
    }else{
        //判断活动是否结束 endDate
        if ([[Helper returnCurrentDateString] compare:_model.endDate] < 0) {
            [btnDelete setBackgroundColor:[UIColor lightGrayColor]];
        }else{
            _tableView.frame = CGRectMake(0, 0, screenWidth, screenHeight -64);
        }
    }
    
    [self.view addSubview:btnDelete];
    btnDelete.titleLabel.font = [UIFont systemFontOfSize:17];
    btnDelete.frame = CGRectMake(10*screenWidth/375, screenHeight - 54*screenWidth/375-64, screenWidth-20*screenWidth/375, 44*screenWidth/375);
    btnDelete.layer.cornerRadius = 8*screenWidth/375;
    btnDelete.layer.masksToBounds = YES;
    
}
#pragma mark --添加报名人点击事件
-(void)addPeopleClick
{
    JGTeamApplyViewController *applyCtrl = [[JGTeamApplyViewController alloc]init];
    applyCtrl.modelss = _model;
    applyCtrl.userName = _userName;
    applyCtrl.isApply = _isApply;
    applyCtrl.canSubsidy = _canSubsidy;
    applyCtrl.costListArray = _costListArray;
    [self.navigationController pushViewController:applyCtrl animated:YES];
}

-(void)createFooterView
{
    _viewFoott = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 30*screenWidth/375)];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/375, 5*screenWidth/375, screenWidth, 20*screenWidth/375)];
    label.font = [UIFont systemFontOfSize:15*screenWidth/375];
    label.text = @"提示：当前报名者在线支付，本人可享受平台补贴。";
    label.textColor = [UITool colorWithHexString:@"#F19725" alpha:1];
    [_viewFoott addSubview:label];
}
#pragma mark --uitableview创建
-(void)uiConfig
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-65*screenWidth/375-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = _viewFoott;
    _tableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    [_tableView.header beginRefreshing];
}


#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
    [dict setObject:[NSString stringWithFormat:@"%td", _activityKey] forKey:@"activityKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getUserActivitySignUpList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_tableView.header endRefreshing];
        }
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            if (page == 0)
            {
                //清除数组数据
                [_dataArrayYet removeAllObjects];
                [_dataArrayWait removeAllObjects];
                [_numDict removeAllObjects];
            }
            //数据解析
            for (NSDictionary *dicList in [data objectForKey:@"teamSignUpList"])
            {
                JGTeamAcitivtyModel *model = [[JGTeamAcitivtyModel alloc] init];
                [model setValuesForKeysWithDictionary:dicList];
                model.isClick = NO;
                if ([model.payMoney floatValue] > 0) {
                    [_dataArrayYet addObject:model];
                }
                else
                {
                    [_dataArrayWait addObject:model];
                }
            }
        }else {
            [Helper alertViewWithTitle:[dict objectForKey:@"message"] withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
        [_tableView reloadData];
        if (isReshing) {
            [_tableView.header endRefreshing];
        }
    }];
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _page = 0;
    [self downLoadData:_page isReshing:YES];
}


#pragma MARK -- tableview
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10*screenWidth/375;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 75*ScreenWidth/320;
    }
    else{
        return 44*ScreenWidth/320;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return 1 + _dataArrayYet.count + _dataArrayWait.count;
    }
    else
    {
        return 1;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  头视图
     */
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"JGLPayHeaderTableViewCell";
        JGLPayHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[JGLPayHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell showData:_model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    /**
     报名人视图
     */
    else if (indexPath.section == 1)
    {
        
        static NSString *CellIdentifier = @"JGLSignPeoTableViewCell";
        JGLSignPeoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
             cell = [[[NSBundle mainBundle]loadNibNamed:@"JGLSignPeoTableViewCell" owner:self options:nil] lastObject];
        }
        [cell showData:_dictRealDetail showModel:_model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            
            static NSString *CellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/320];
            cell.textLabel.text = [NSString stringWithFormat:@"打球人名单(%td)",_dataArrayYet.count + _dataArrayWait.count];
            return cell;
            
            
            
        }
        else{
            
            static NSString *CellIdentifier = @"JGLPayListTableViewCell";
            JGLPayListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                  cell = [[[NSBundle mainBundle]loadNibNamed:@"JGLPayListTableViewCell" owner:self options:nil] lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            //cell从1开始
            if (indexPath.row - 1 < _dataArrayYet.count) {//已付款的cell，个数为数组0 ----- count-1 个
                [cell showData1:_dataArrayYet[indexPath.row - 1]];
                cell.modelData = _dataArrayYet[indexPath.row - 1];
                cell.stateBtn.hidden = YES;
                cell.payBtn.hidden = YES;
                if (indexPath.row == 1) {
                    cell.titleLabel.text = @"已付款";
                }
                else{
                    cell.titleLabel.hidden = YES;
                }
            }
            else{
                if (_dataArrayWait.count != 0) {
                    [cell showData:_dataArrayWait[indexPath.row-_dataArrayYet.count-1]];
                    cell.modelData = _dataArrayWait[indexPath.row-_dataArrayYet.count-1];
                    NSString* strNum = [NSString stringWithFormat:@"%td",indexPath.row-_dataArrayYet.count-1];
                    [_numDict setObject:_dataArrayWait[indexPath.row-_dataArrayYet.count-1] forKey:strNum];
                }
                //删除未勾选的内容
                cell.chooseNoNum = ^(){
                    //                    [_numDict setObject:_dataArrayWait[indexPath.row-_dataArrayYet.count-1] forKey:strNum];
                    [_numDict removeObjectForKey:[NSString stringWithFormat:@"%td",indexPath.row-_dataArrayYet.count-1]];
                    

                };
                //添加勾选的内容
                cell.chooseYesNum = ^(){
                    [_numDict setObject:_dataArrayWait[indexPath.row-_dataArrayYet.count-1] forKey:[NSString stringWithFormat:@"%td",indexPath.row-_dataArrayYet.count-1]];

                };
                
                
                if (indexPath.row == _dataArrayYet.count+1) {
                    cell.titleLabel.text = @"待付款";
                    cell.payBtn.hidden = NO;
                    [cell.payBtn addTarget:self action:@selector(payMoneyClick) forControlEvents:UIControlEventTouchUpInside];
                }
                else{
                    cell.titleLabel.hidden = YES;
                    cell.payBtn.hidden = YES;
                }
            }
            return cell;
        }
    }
    else{

        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"发票信息";
        cell.textLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/320];
        return cell;
        
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        JGHAddInvoiceViewController *invoiceCtrl = [[JGHAddInvoiceViewController alloc]init];
        invoiceCtrl.delegate = self;
        invoiceCtrl.invoiceKey = _invoiceKey;
        invoiceCtrl.addressKey = _addressKey;
        [self.navigationController pushViewController:invoiceCtrl animated:YES];
    }
    
}

#pragma mark --立即支付
-(void)payMoneyClick
{
    NSLog(@"%@",_numDict);
    //所有勾选上的球员
    self.applyDataArray = [NSMutableArray arrayWithArray:[_numDict allValues]];
    
    if (self.applyDataArray.count == 0) {
        [[ShowHUD showHUD]showToastWithText:@"请勾选报名人，再支付！" FromView:self.view];
        return;
    }
    
    self.tranView.hidden = NO;
    self.applyListView.hidden = NO;
    if (screenHeight < ((self.applyDataArray.count * 30) + 108)){
        self.tranView.frame = CGRectMake(0, 0, screenWidth, 0);
        self.applyListView.frame = CGRectMake(0, 0, screenWidth, screenHeight -64);
        [_applyListView configViewData:self.applyDataArray];
    }else{
        self.tranView.frame = CGRectMake(0, 0, screenWidth, screenHeight - (152 + self.applyDataArray.count * 30)-64 -44);
        self.applyListView.frame = CGRectMake(0, screenHeight - (196 + self.applyDataArray.count * 30)-64, screenWidth, 196 + 44 + self.applyDataArray.count * 30);
        [_applyListView configViewData:self.applyDataArray];
    }
}
#pragma mark -- 提交报名信息
- (void)submitInfo:(NSInteger)type{
    [[ShowHUD showHUD]showAnimationWithText:@"报名中..." FromView:self.view];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (_invoiceKey != nil) {
        [self.info setObject:_invoiceKey forKey:@"invoiceKey"];//发票Key
        [self.info setObject:_addressKey forKey:@"addressKey"];//地址Key
    }
    
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    //    [dict setObject:[userdef objectForKey:userID] forKey:@"appUserKey"];
    [self.info setObject:[NSString stringWithFormat:@"%td", _model.teamKey] forKey:@"teamKey"];//球队key
    if (_model.teamActivityKey == 0) {
        [self.info setObject:[NSString stringWithFormat:@"%td", [_model.timeKey integerValue]] forKey:@"activityKey"];//球队活动key
    }else{
        [self.info setObject:[NSString stringWithFormat:@"%td", _model.teamActivityKey] forKey:@"activityKey"];//球队活动key
    }
    
    
    [self.info setObject:[userdef objectForKey:@"userName"] forKey:@"userName"];//报名人名称//teamkey 156
    [self.info setObject:[userdef objectForKey:userID] forKey:@"userKey"];//用户Key
    [self.info setObject:@0 forKey:@"timeKey"];//timeKey
    NSMutableArray *teamSignUpList = [NSMutableArray array];
    NSMutableString *otherInfo = [[NSMutableString alloc]init];
    for (int i=0; i<_applyDataArray.count; i++) {
        
        JGTeamAcitivtyModel *model = [[JGTeamAcitivtyModel alloc]init];
        model = _applyDataArray[i];
        [teamSignUpList addObject:model.timeKey];
        if (i==0) {
            otherInfo = [NSMutableString stringWithFormat:@"%@,", model.timeKey];
        }else{
            [otherInfo appendFormat:@"%@,", model.timeKey];
        }
    }
    
    [dict setObject:teamSignUpList forKey:@"signupKeyList"];//报名人员数组
    [dict setObject:_info forKey:@"info"];
    //支付字典
    [self.payDict setObject:@4 forKey:@"orderType"];
    [self.payDict setObject:@"活动报名" forKey:@"name"];
    [self.payDict setObject:otherInfo forKey:@"otherInfo"];
    [self.payDict setObject:[userdef objectForKey:userID] forKey:@"userKey"];
    
    [[JsonHttp jsonHttp]httpRequest:@"team/doTeamActivitySignUpPay" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        NSLog(@"data == %@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            _infoKey = [data objectForKey:@"infoKey"];
            [self.payDict setObject:_infoKey forKey:@"srcKey"];
            if (type == 1) {
                [self weChatPay];
            }else if (type == 2){
                [self zhifubaoPay];
            }else if (type == 3){
                [self balancePay];
            }else{
                //跳转分组页面
                JGTeamGroupViewController *groupCtrl = [[JGTeamGroupViewController alloc]init];
                groupCtrl.activityFrom = 1;
                groupCtrl.teamActivityKey = [_model.timeKey integerValue];
                [self.navigationController pushViewController:groupCtrl animated:YES];
            }
        }else{
            if ([data count]== 2) {
                [Helper alertViewWithTitle:@"报名失败！" withBlock:^(UIAlertController *alertView) {
                    [self.navigationController presentViewController:alertView animated:YES completion:^{
                        
                    }];
                }];
            }else{
                [Helper alertViewWithTitle:[data objectForKey:@"packResultMsg"] withBlock:^(UIAlertController *alertView) {
                    [self.navigationController presentViewController:alertView animated:YES completion:^{
                        
                    }];
                }];
            }
        }
    }];
}
#pragma mark -- 取消
- (void)selectCancelRepeatApply:(UIButton *)btn{
    NSLog(@"取消");
    self.applyListView.hidden = YES;
    self.tranView.hidden = YES;
}
#pragma mark -- 立即支付
- (void)selectRepeatApply:(UIButton *)btn{
    NSLog(@"立即支付");
    [[ShowHUD showHUD]showAnimationWithText:@"加载中..." FromView:self.view];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [[JsonHttp jsonHttp]httpRequest:@"user/getUserBalance" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        [_bgView removeFromSuperview];
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            NSString *balanceString;
            if ([[data objectForKey:@"money"] floatValue] >= [self countAmountPayable]) {
                balanceString = [NSString stringWithFormat:@"余额支付（¥%.2f）", [[data objectForKey:@"money"] floatValue]];
            }else{
                balanceString = [NSString stringWithFormat:@"余额支付（余额不足 ¥%.2f）", [[data objectForKey:@"money"] floatValue]];
            }
            
            //
            _actionView = [UIAlertController alertControllerWithTitle:@"选择支付方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
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
            UIAlertAction *balanceAction = [UIAlertAction actionWithTitle:balanceString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //余额支付
                if ([[data objectForKey:@"money"] floatValue] >= [self countAmountPayable]) {
                    if ([[data objectForKey:@"isSetPayPassWord"] integerValue] == 0) {
                        JGDSetBusinessPWDViewController *setpassCtrl = [[JGDSetBusinessPWDViewController alloc]init];
                        [self.navigationController pushViewController:setpassCtrl animated:YES];
                    }else{
                        [self dreawBalance:[NSString stringWithFormat:@"%.2f", [[data objectForKey:@"money"] floatValue]]];
                    }
                }else{
                    return ;
                }
                
            }];
            _actionView = [UIAlertController alertControllerWithTitle:@"选择支付方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [_actionView addAction:weiChatAction];
            [_actionView addAction:zhifubaoAction];
            [_actionView addAction:balanceAction];
            [_actionView addAction:cancelAction];
            [self presentViewController:_actionView animated:YES completion:nil];
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
            
            [_bgView removeFromSuperview];
        }
    }];
}
#pragma mark -- 余额支付
- (void)dreawBalance:(NSString *)balance{
    self.navigationItem.leftBarButtonItem.enabled = NO;
    //
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight -64)];
    _bgView.backgroundColor = [UIColor lightGrayColor];
    _bgView.alpha = 0.5;
    [self.view addSubview:_bgView];
    
    _balanceView = [[JGHbalanceView alloc]initWithFrame:CGRectMake(15 *ProportionAdapter, 50 *ProportionAdapter, screenWidth -30*ProportionAdapter, 286*ProportionAdapter)];
    _balanceView.layer.masksToBounds = YES;
    _balanceView.layer.cornerRadius = 5.0*ProportionAdapter;
    _balanceView.alpha = 1.0;
    _balanceView.delegate = self;
    [_balanceView configJGHbalanceViewPrice:[self countAmountPayable] andBalance:balance andDetail:_model.name];
    //密码输入框
    _passWordView = [[[NSBundle mainBundle]loadNibNamed:@"WCLPassWordView" owner:self options:nil]lastObject];
    _passWordView.frame = CGRectMake(13 *ProportionAdapter, 222 *ProportionAdapter, _balanceView.frame.size.width -26*ProportionAdapter, 45 *ProportionAdapter);
    _passWordView.delegate = self;
    _passWordView.backgroundColor = [UIColor whiteColor];
    [_balanceView addSubview:_passWordView];
    [self.view bringSubviewToFront:_balanceView];
    
    [self.view addSubview:_balanceView];
}
#pragma mark -- 监听输入的改变
- (void)passWordDidChange:(WCLPassWordView *)passWord{
    
}
#pragma mark -- 监听输入的完成时
- (void)passWordCompleteInput:(WCLPassWordView *)passWord{
    [self submitInfo:3];
}
#pragma mark -- 监听开始输入
- (void)passWordBeginInput:(WCLPassWordView *)passWord{
    
}
#pragma mark -- 删除支付密码页面
- (void)deleteBalanceView:(UIButton *)btn{
    [_bgView removeFromSuperview];
    [_passWordView removeFromSuperview];
    [_balanceView removeFromSuperview];
    self.navigationItem.leftBarButtonItem.enabled = YES;
}
#pragma mark -- 余额支付
- (void)balancePay{
    self.navigationItem.leftBarButtonItem.enabled = NO;
    [LQProgressHud showLoading:@"支付中..."];
    
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"pay/doPayByUserAccount" JsonKey:@"payInfo" withData:_payDict failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
        self.navigationItem.leftBarButtonItem.enabled = YES;
        [_bgView removeFromSuperview];
        [LQProgressHud hide];
    } completionBlock:^(id data) {
        NSLog(@"%@",[data objectForKey:@"query"]);
        self.navigationItem.leftBarButtonItem.enabled = YES;
        [_bgView removeFromSuperview];
        [_balanceView removeFromSuperview];
        [LQProgressHud hide];
        //跳转分组页面
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            [[ShowHUD showHUD]showAnimationWithText:@"支付成功！" FromView:self.view];
        }else{
            _passWordView.textStore = [@"" mutableCopy];
            [_passWordView deleteBackward];
            [_passWordView becomeFirstResponder];
            
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showAnimationWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }else{
                [[ShowHUD showHUD]showAnimationWithText:@"支付失败！" FromView:self.view];
            }            
        }
        
        JGTeamGroupViewController *groupCtrl = [[JGTeamGroupViewController alloc]init];
        groupCtrl.activityFrom = 1;
        groupCtrl.teamActivityKey = [_model.timeKey integerValue];
        [self.navigationController pushViewController:groupCtrl animated:YES];
    }];
}
#pragma mark -- 计算应付价格
- (float)countAmountPayable{
    //判断成员中是否包含自己
    NSInteger isMember = 0;
    float amountPayable = 0.0;//总价格
    float realSubPrice = 0.0;//应付
    float subsidyPrice = 0.0;
    
    for (int i=0; i<_applyDataArray.count; i++) {
        JGTeamAcitivtyModel *model = [[JGTeamAcitivtyModel alloc]init];
        model = _applyDataArray[i];
        NSLog(@"%@", model.money);
        float value = [model.money floatValue];
        amountPayable += value;
        
        if ([model.subsidyPrice floatValue] != 0) {
            isMember = 1;
            subsidyPrice = [model.subsidyPrice floatValue];
        }
    }
    
    //仅当前报名人[在线支付]享受平台补贴
    if (isMember == 1) {
        realSubPrice = amountPayable - subsidyPrice;
    }else{
        realSubPrice = amountPayable;
    }
    
    return realSubPrice;
}
#pragma mark -- 微信支付
- (void)weChatPay{
    NSLog(@"微信支付");
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"weChatNotice" object:nil];
    
    [[JsonHttp jsonHttp]httpRequest:@"pay/doPayWeiXin" JsonKey:@"payInfo" withData:_payDict requestMethod:@"POST" failedBlock:^(id errType) {
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
    //跳转分组页面
//    JGTeamGroupViewController *groupCtrl = [[JGTeamGroupViewController alloc]init];
//    groupCtrl.teamActivityKey = [_model.timeKey integerValue];
//    groupCtrl.activityFrom = 1;
//    [self.navigationController pushViewController:groupCtrl animated:YES];
    NSInteger secess = [[not.userInfo objectForKey:@"secess"] integerValue];
    if (secess == 1) {
        
    }else if (secess == 2){
        [[ShowHUD showHUD]showToastWithText:@"支付已取消！" FromView:self.view];
    }else{
        [[ShowHUD showHUD]showToastWithText:@"支付失败！" FromView:self.view];
    }
    
    //跳转分组页面
    JGTeamGroupViewController *groupCtrl = [[JGTeamGroupViewController alloc]init];
    groupCtrl.teamActivityKey = [_model.timeKey integerValue];
    groupCtrl.activityFrom = 1;
    [self.navigationController pushViewController:groupCtrl animated:YES];
}
#pragma mark -- 支付宝
- (void)zhifubaoPay{
    NSLog(@"支付宝支付");
    
    [[JsonHttp jsonHttp]httpRequest:@"pay/doPayByAliPay" JsonKey:@"payInfo" withData:_payDict requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        NSLog(@"%@",[data objectForKey:@"query"]);
        [[AlipaySDK defaultService] payOrder:[data objectForKey:@"query"] fromScheme:@"dagolfla" callback:^(NSDictionary *resultDic) {
            
            //跳转分组页面
            JGTeamGroupViewController *groupCtrl = [[JGTeamGroupViewController alloc]init];
            groupCtrl.activityFrom = 1;
            groupCtrl.teamActivityKey = [_model.timeKey integerValue];
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
#pragma mark -- 发票代理
- (void)backAddressKey:(NSString *)invoiceKey andInvoiceName:(NSString *)name andAddressKey:(NSString *)addressKey{
    self.invoiceKey = invoiceKey;
    self.addressKey = addressKey;
    _invoiceName = name;
    [_tableView reloadData];
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
