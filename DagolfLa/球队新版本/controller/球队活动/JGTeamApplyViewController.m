//
//  JGTeamApplyViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamApplyViewController.h"
#import "JGHActivityBaseInfoCell.h"
#import "JGTableViewCell.h"
#import "JGApplyPepoleCell.h"
#import "JGHAddInvoiceViewController.h"
#import "JGTeamGroupViewController.h"
#import "JGTeamAcitivtyModel.h"
#import "JGHHeaderLabelCell.h"
#import "JGHApplyNewCell.h"
#import "JGSignUoPromptCell.h"
#import "JGHTotalPriceCell.h"
//微信
#import "WXApi.h"
#import "payRequsestHandler.h"

#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"

#import "JGHApplyListView.h"
#import "JGHJustApplyListView.h"
#import "JGActivityBaseInfoCell.h"
#import "JGHApplyCatoryPriceView.h"
#import "JGHAddTeamPlaysViewController.h"
#import "JGTeamActibityNameViewController.h"
#import "JGHbalanceView.h"
#import "WCLPassWordView.h"
#import "JGDSetBusinessPWDViewController.h"

static NSString *const JGHActivityBaseInfoCellIdentifier = @"JGHActivityBaseInfoCell";
static NSString *const JGActivityBaseInfoCellIdentifier = @"JGActivityBaseInfoCell";
static NSString *const JGTableViewCellIdentifier = @"JGTableViewCell";
static NSString *const JGApplyPepoleCellIdentifier = @"JGApplyPepoleCell";
static NSString *const JGHHeaderLabelCellIdentifier = @"JGHHeaderLabelCell";
static NSString *const JGHApplyNewCellIdentifier = @"JGHApplyNewCell";
static NSString *const JGSignUoPromptCellIdentifier = @"JGSignUoPromptCell";
static NSString *const JGHTotalPriceCellIdentifier = @"JGHTotalPriceCell";

@interface JGTeamApplyViewController ()<JGApplyPepoleCellDelegate, JGHApplyNewCellDelegate, JGHAddInvoiceViewControllerDelegate, JGHApplyListViewDelegate, JGHJustApplyListViewDelegate, JGHApplyCatoryPriceViewDelegate, WCLPassWordViewDelegate, JGHbalanceViewDelegate>
{
    UIAlertController *_actionView;
    
    NSInteger _w;
    NSInteger _z;
    NSString *_infoKey;
    
    NSInteger _editorPlayId;//修改价格 ID -0
    
    NSMutableArray *_relApplistArray;
    
    NSString *_balance;//余额
}

@property (nonatomic, strong)NSArray *titleArray;//标题

@property (nonatomic, strong)NSMutableArray *applyArray;//成员数组----添加成员字典

@property (nonatomic, strong)NSMutableArray *baseInfoArray;//基本信息

@property (nonatomic, strong)NSMutableDictionary *info;

@property (nonatomic, strong)UIButton *cellClickBtn;//拦截cell点击事件

@property (nonatomic, assign)float amountPayable;//应付金额
@property (nonatomic, assign)float realPayPrice;//实付金额
@property (nonatomic, assign)float subsidiesPrice;//补贴金额

@property (nonatomic, strong)UIView *tranView;
@property (nonatomic, strong)JGHApplyListView *applyListView;//报名人列表
@property (nonatomic, strong)JGHJustApplyListView *justApplyListView;//仅报名列表

@property (nonatomic, strong)JGHApplyCatoryPriceView *applyCatoryPriceView;//价格类型列表

@property (nonatomic, strong)JGHbalanceView *balanceView;

@property (nonatomic, strong)WCLPassWordView *passWordView;

@end

@implementation JGTeamApplyViewController

- (UIView *)tranView{
    if (_tranView == nil) {
        self.tranView = [[UIView alloc]init];
        self.tranView.backgroundColor = [UIColor lightGrayColor];
        self.tranView.alpha = 0.5;
        [self.view addSubview:_tranView];
    }
    return _tranView;
}

- (JGHApplyListView *)applyListView{
    if (_applyListView == nil) {
        self.applyListView = [[JGHApplyListView alloc]init];
        self.applyListView.delegate = self;
        if (_canSubsidy == 1) {
            self.applyListView.subsidiesPrice = [_modelss.subsidyPrice floatValue];
        }else{
            self.applyListView.subsidiesPrice = 0.00;
        }
        
        [self.view addSubview:_applyListView];
    }
    return _applyListView;
}

- (JGHJustApplyListView *)justApplyListView{
    if (_justApplyListView == nil) {
        self.justApplyListView = [[JGHJustApplyListView alloc]init];
        self.justApplyListView.delegate = self;
        [self.view addSubview:_justApplyListView];
    }
    return _justApplyListView;
}

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
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.applyArray = [NSMutableArray array];
    self.info = [NSMutableDictionary dictionary];
    self.baseInfoArray = [NSMutableArray array];
    self.titleArray = @[@"活动名称", @"活动地址", @"活动日期", @"活动费用", @"嘉宾费用"];
    _realPayPrice = 0;
    _subsidiesPrice = 0;
    _amountPayable = 0;
    _editorPlayId = 0;
    
    _relApplistArray = [NSMutableArray array];

    [_baseInfoArray addObject:[NSString stringWithFormat:@"%@-活动名称", _modelss.name]];
    [_baseInfoArray addObject:[NSString stringWithFormat:@"%@-活动地址", _modelss.ballName]];
    [_baseInfoArray addObject:[NSString stringWithFormat:@"%@-活动日期", [Helper returnDateformatString:_modelss.endDate]]];
    //基础信息
    for (NSDictionary *dict in _costListArray) {
        NSString *string = nil;
        string = [NSString stringWithFormat:@"%@-%@", [dict objectForKey:@"money"], [dict objectForKey:@"costName"]];
        [_baseInfoArray addObject:string];
    }
    
    //默认添加自己的信息
    if (!_isApply) {
        NSMutableDictionary *applyDict = [NSMutableDictionary dictionary];
        [applyDict setObject:[NSString stringWithFormat:@"%td", _modelss.teamKey] forKey:@"teamKey"];//球队key
        [applyDict setObject:_modelss.timeKey forKey:@"activityKey"];//球队活动id
        
        NSDictionary *costDict = [NSDictionary dictionary];
        costDict = _costListArray[0];
        [applyDict setObject:[NSString stringWithFormat:@"%@", [costDict objectForKey:@"costType"]] forKey:@"type"];//资费类型
        [applyDict setObject:[NSString stringWithFormat:@"%@", [costDict objectForKey:@"money"]] forKey:@"money"];//实际付款金额
        
        [applyDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];//报名用户key , 没有则是嘉宾
        
        [applyDict setObject:[NSString stringWithFormat:@"%.2f", [_modelss.subsidyPrice floatValue]] forKey:@"subsidyPrice"];
        //先判断是否存在球队真是姓名，否则给用户名
        if (self.userName == nil) {
            [applyDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"] forKey:@"name"];//姓名
        }else{
            [applyDict setObject:self.userName forKey:@"name"];//姓名
        }
        
        if ([self.teamMember objectForKey:@"mobile"]) {
            [applyDict setObject:[self.teamMember objectForKey:@"mobile"] forKey:@"mobile"];//手机号
        }
        
        [applyDict setObject:@"1" forKey:@"isOnlinePay"];//是否线上付款 1-线上
        [applyDict setObject:@0 forKey:@"signUpInfoKey"];//报名信息的timeKey
        [applyDict setObject:@0 forKey:@"timeKey"];//timeKey
        [applyDict setObject:@"1" forKey:@"select"];//付款勾选默认勾
        
        if ([self.teamMember objectForKey:@"almost"]) {
            [applyDict setObject:[self.teamMember objectForKey:@"almost"] forKey:@"almost"];
        }
        
        //性别
        if ([self.teamMember objectForKey:@"sex"]) {
            [applyDict setObject:[self.teamMember objectForKey:@"sex"] forKey:@"sex"];
        }
        
        [self.applyArray addObject:applyDict];
        
        [self countAmountPayable];
    }
    //注册cell
    UINib *activityNameNib = [UINib nibWithNibName:@"JGHActivityBaseInfoCell" bundle: [NSBundle mainBundle]];
    [self.teamApplyTableView registerNib:activityNameNib forCellReuseIdentifier:JGHActivityBaseInfoCellIdentifier];
    
    UINib *activityBaseInfoNib = [UINib nibWithNibName:@"JGActivityBaseInfoCell" bundle: [NSBundle mainBundle]];
    [self.teamApplyTableView registerNib:activityBaseInfoNib forCellReuseIdentifier:JGActivityBaseInfoCellIdentifier];
    
    UINib *tableViewNib = [UINib nibWithNibName:@"JGTableViewCell" bundle: [NSBundle mainBundle]];
    [self.teamApplyTableView registerNib:tableViewNib forCellReuseIdentifier:JGTableViewCellIdentifier];
    
    UINib *applyPepoleNib = [UINib nibWithNibName:@"JGApplyPepoleCell" bundle: [NSBundle mainBundle]];
    [self.teamApplyTableView registerNib:applyPepoleNib forCellReuseIdentifier:JGApplyPepoleCellIdentifier];
    
    UINib *headerLabelNib = [UINib nibWithNibName:@"JGHHeaderLabelCell" bundle: [NSBundle mainBundle]];
    [self.teamApplyTableView registerNib:headerLabelNib forCellReuseIdentifier:JGHHeaderLabelCellIdentifier];
    
    UINib *applyListNib = [UINib nibWithNibName:@"JGHApplyNewCell" bundle: [NSBundle mainBundle]];
    [self.teamApplyTableView registerNib:applyListNib forCellReuseIdentifier:JGHApplyNewCellIdentifier];
    
    UINib *signUoPromptNib = [UINib nibWithNibName:@"JGSignUoPromptCell" bundle: [NSBundle mainBundle]];
    [self.teamApplyTableView registerNib:signUoPromptNib forCellReuseIdentifier:JGSignUoPromptCellIdentifier];
    
    UINib *totalPriceCellNib = [UINib nibWithNibName:@"JGHTotalPriceCell" bundle: [NSBundle mainBundle]];
    [self.teamApplyTableView registerNib:totalPriceCellNib forCellReuseIdentifier:JGHTotalPriceCellIdentifier];
    self.teamApplyTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
}
#pragma mark -- tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _baseInfoArray.count;
    }else if (section == 1) {
        //人员个数
        if (self.applyArray.count > 0) {
            return self.applyArray.count + 2;
        }
        return 2;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGHActivityBaseInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:JGHActivityBaseInfoCellIdentifier];
        [infoCell configBaseInfo:_baseInfoArray[indexPath.row] andIndexRow:indexPath.row];
        infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return infoCell;
    }else{
        if (self.applyArray.count > 0) {
            if (indexPath.row == self.applyArray.count){
                JGHTotalPriceCell *totalPriceCell = [tableView dequeueReusableCellWithIdentifier:JGHTotalPriceCellIdentifier forIndexPath:indexPath];
                totalPriceCell.selectionStyle = UITableViewCellSelectionStyleNone;
                [totalPriceCell configTotalPrice:_realPayPrice];
                return totalPriceCell;
            }else if (indexPath.row == self.applyArray.count+1){
                JGSignUoPromptCell *signUoPromptCell = [tableView dequeueReusableCellWithIdentifier:JGSignUoPromptCellIdentifier forIndexPath:indexPath];
                signUoPromptCell.selectionStyle = UITableViewCellSelectionStyleNone;
                [signUoPromptCell configPromptString:@"提示：当前报名者在线支付，本人可享受平台补贴。"];
                return signUoPromptCell;
            }else{
                JGHApplyNewCell *applyListCel = [tableView dequeueReusableCellWithIdentifier:JGHApplyNewCellIdentifier forIndexPath:indexPath];
                applyListCel.editorBtn.tag = indexPath.row;
                applyListCel.deleBtn.tag = indexPath.row + 100;
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
                [signUoPromptCell configPromptString:@"提示：当前报名者在线支付，本人可享受平台补贴。"];
                return signUoPromptCell;
            }
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        JGActivityBaseInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:JGActivityBaseInfoCellIdentifier];
        infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return (UIView *)infoCell;
    }else if (section == 1){
        JGApplyPepoleCell *applyPepoleCell = [tableView dequeueReusableCellWithIdentifier:JGApplyPepoleCellIdentifier];
        applyPepoleCell.delegate = self;
        return (UIView *)applyPepoleCell;
    }else{
        JGHHeaderLabelCell *activityNameCell = [tableView dequeueReusableCellWithIdentifier:JGHHeaderLabelCellIdentifier];
        self.cellClickBtn.frame = CGRectMake(0, 0, screenWidth, activityNameCell.frame.size.height);
        [self.cellClickBtn addTarget:self action:@selector(cellClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [activityNameCell congiftitles:@"发票信息"];
        [activityNameCell.contentView addSubview:self.cellClickBtn];
        activityNameCell.accessoryType = UITableViewCellSelectionStyleBlue;
        [activityNameCell configInvoiceIfo:_invoiceName];
        
        return (UIView *)activityNameCell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10)];
    footView.backgroundColor = [UIColor colorWithHexString:BG_color];
    return footView;
}
#pragma mark -- 发票点击事件
- (void)cellClickBtn:(UIButton *)btn{
    JGHAddInvoiceViewController *invoiceCtrl = [[JGHAddInvoiceViewController alloc]init];
    invoiceCtrl.delegate = self;
    invoiceCtrl.invoiceKey = _invoiceKey;
    invoiceCtrl.addressKey = _addressKey;
    [self.navigationController pushViewController:invoiceCtrl animated:YES];
}
#pragma mark -- 报名并支付
- (IBAction)nowPayBtnClick:(UIButton *)sender {
    if (_applyArray.count == 0) {
        [[ShowHUD showHUD]showToastWithText:@"请添加打球人，再支付！" FromView:self.view];
        return;
    }
    //如果价格为空
    if (_realPayPrice == 0) {
        // 分别3个创建操作
        [[ShowHUD showHUD]showToastWithText:@"无可支付金额，如有疑问请联系客服！" FromView:self.view];
        return;
    }
    
    self.tranView.hidden = NO;
    self.applyListView.hidden = NO;
    if (screenHeight < ((_applyArray.count * 30) + 108)){
        self.tranView.frame = CGRectMake(0, 0, screenWidth, 0);
        self.applyListView.frame = CGRectMake(0, 0, screenWidth, screenHeight -64);
        [_applyListView configViewData:_applyArray andCanSubsidy:_canSubsidy];
    }else{
        self.tranView.frame = CGRectMake(0, 0, screenWidth, screenHeight - (152 + _applyArray.count * 30)-64 -44);
        self.applyListView.frame = CGRectMake(0, screenHeight - (196 + _applyArray.count * 30)-64, screenWidth, 196 + 44 + _applyArray.count * 30);
        [_applyListView configViewData:_applyArray andCanSubsidy:_canSubsidy];
//        [_applyListView configViewData:_applyArray];
    }
}

#pragma mark -- 仅报名
- (IBAction)scenePayBtnClick:(UIButton *)sender {
    if (_applyArray.count == 0) {
        [[ShowHUD showHUD]showToastWithText:@"请添加打球人，再报名！" FromView:self.view];
        return;
    }
    
    self.tranView.hidden = NO;
    self.justApplyListView.hidden = NO;
    if (screenHeight < ((_applyArray.count * 30) + 108)){
        self.tranView.frame = CGRectMake(0, 0, screenWidth, 0);
        self.justApplyListView.frame = CGRectMake(0, 0, screenWidth, screenHeight-64);
        [_justApplyListView configjustApplyViewData:_applyArray];
    }else{
        self.tranView.frame = CGRectMake(0, 0, screenWidth, screenHeight - (88 + _applyArray.count * 30)-64 -44);
        self.justApplyListView.frame = CGRectMake(0, screenHeight - (132 + _applyArray.count * 30)-64, screenWidth, 88 + 44 + _applyArray.count * 30);
        [_justApplyListView configjustApplyViewData:_applyArray];
    }
}
#pragma mark -- 取消 －－ 仅报名
- (void)didJustApplyListCancelBtn:(UIButton *)btn{
    self.tranView.hidden = YES;
    self.justApplyListView.hidden = YES;
}
#pragma mark -- 立即报名 －－ 仅报名
- (void)didJustApplyListApplyBtn:(UIButton *)btn{
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
    
    [self submitInfo:4];
}
#pragma mark -- 添加嘉宾
- (void)addApplyPeopleClick{
    JGHAddTeamPlaysViewController *addTeamPlaysCtrl = [[JGHAddTeamPlaysViewController alloc]init];
    addTeamPlaysCtrl.costListArray = [NSMutableArray arrayWithArray:_costListArray];
    addTeamPlaysCtrl.playListArray = [NSMutableArray arrayWithArray:_applyArray];
    if (_modelss.teamActivityKey != 0) {
        addTeamPlaysCtrl.activityKey = _modelss.teamActivityKey;
    }else{
        addTeamPlaysCtrl.activityKey = [_modelss.timeKey integerValue];
    }
    
    addTeamPlaysCtrl.teamKey = _modelss.teamKey;
    
    __weak JGTeamApplyViewController *weakSelf = self;
    addTeamPlaysCtrl.blockPlayListArray = ^(NSMutableArray *listArray){
        _applyArray = listArray;
        [weakSelf countAmountPayable];
        [weakSelf.teamApplyTableView reloadData];
    };
    
    [self.navigationController pushViewController:addTeamPlaysCtrl animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 删除嘉宾
- (void)selectApplyDeleteBtn:(UIButton *)btn{
    NSLog(@"%td", btn.tag - 100);
    if ([self.applyArray count]) {
        NSDictionary *dict = [NSDictionary dictionary];
        dict = [self.applyArray objectAtIndex:btn.tag-100];
        if ([[dict objectForKey:@"userKey"] integerValue] == [DEFAULF_USERID integerValue]) {
            [Helper alertViewWithTitle:@"删除后将不享受平台补贴，是否删除？" withBlockCancle:^{
                
            } withBlockSure:^{
                [self.applyArray removeObjectAtIndex:btn.tag - 100];
                //计算价格
                [self countAmountPayable];
            } withBlock:^(UIAlertController *alertView) {
                [self.navigationController presentViewController:alertView animated:YES completion:nil];
            }];
        }else{
            [self.applyArray removeObjectAtIndex:btn.tag - 100];
            //计算价格
            [self countAmountPayable];
        }
    }
    
    [self.teamApplyTableView reloadData];
}
#pragma mark -- 修改价格
- (void)selectEditorBtn:(UIButton *)btn{
    NSLog(@"%ld", (long)btn.tag);
    _editorPlayId = btn.tag;
    self.tranView.hidden = NO;
    self.tranView.frame = CGRectMake(0, 0, screenWidth, screenHeight - (64 +_costListArray.count *30 +44));
    self.applyCatoryPriceView = [[JGHApplyCatoryPriceView alloc]init];
    self.applyCatoryPriceView.delegate = self;
    self.applyCatoryPriceView.frame = CGRectMake(0, screenHeight - (64 +_costListArray.count *30 +44), screenWidth, _costListArray.count *30 + 44);
    [self.applyCatoryPriceView configViewData:_costListArray];
    [self.view addSubview:self.applyCatoryPriceView];
}
#pragma mark -- 添加打球人页面代理－－－返回打球人数组
- (void)addGuestListArray:(NSArray *)guestListArray{
    self.applyArray = [NSMutableArray arrayWithArray:guestListArray];
    //计算价格
    [self countAmountPayable];
}
#pragma mark -- 计算应付价格
- (void)countAmountPayable{
    _subsidiesPrice = 0.0;
    _amountPayable = 0.0;
    _realPayPrice = 0.0;
    //判断成员中是否包含自己
    NSInteger isMember = 0;
    for (int i=0; i<_applyArray.count; i++) {
        NSDictionary *dict = [NSDictionary dictionary];
        dict = _applyArray[i];
        if ([[dict objectForKey:@"select"]integerValue] == 1) {
            NSLog(@"%@", [dict objectForKey:@"money"]);
            float value = [[dict objectForKey:@"money"] floatValue];
            _amountPayable += value;
            
            if ([[dict objectForKey:@"userKey"] integerValue] == [DEFAULF_USERID integerValue]) {
                isMember = 1;
                _subsidiesPrice = [[dict objectForKey:@"subsidyPrice"] floatValue];
            }
        }
    }
    
    //仅当前报名人[在线支付]享受平台补贴
    if (isMember == 1) {
        //        _realSubPrice = _subsidiesPrice;
        if (_canSubsidy == 1) {
            _realPayPrice = _amountPayable - _subsidiesPrice;
        }else{
            _realPayPrice = _amountPayable;
        }
        
    }else{
        _realPayPrice = _amountPayable;
        _subsidiesPrice = 0.0;
    }
    
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
    if (![self.applyArray count]) {
        [[ShowHUD showHUD]showToastWithText:@"请添加打球人，再报名！" FromView:self.view];
        return;
    }
    
    [[ShowHUD showHUD]showAnimationWithText:@"报名中..." FromView:self.view];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (_invoiceKey != nil) {
        [self.info setObject:_invoiceKey forKey:@"invoiceKey"];//发票Key
        [self.info setObject:_addressKey forKey:@"addressKey"];//地址Key
    }
    
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    [dict setObject:[userdef objectForKey:userID] forKey:@"appUserKey"];
    [self.info setObject:[NSString stringWithFormat:@"%td", _modelss.teamKey] forKey:@"teamKey"];//球队key
    if (_modelss.teamActivityKey == 0) {
        [self.info setObject:[NSString stringWithFormat:@"%td", [_modelss.timeKey integerValue]] forKey:@"activityKey"];//球队活动key
    }else{
        [self.info setObject:[NSString stringWithFormat:@"%td", _modelss.teamActivityKey] forKey:@"activityKey"];//球队活动key
    }
    
    [self.info setObject:[userdef objectForKey:@"userName"] forKey:@"userName"];//报名人名称//teamkey 156
    
    [self.info setObject:[userdef objectForKey:userID] forKey:@"userKey"];//用户Key
    [self.info setObject:@0 forKey:@"timeKey"];//timeKey
    
    [dict setObject:_applyArray forKey:@"teamSignUpList"];//报名人员数组
    
    if (_relApplistArray.count > 0) {
        NSMutableArray *listArray = [NSMutableArray array];
        listArray = [_relApplistArray mutableCopy];
        [dict setObject:listArray forKey:@"teamSignUpList"];//报名人员数组
        [_relApplistArray removeAllObjects];
    }else{
        [dict setObject:_applyArray forKey:@"teamSignUpList"];//报名人员数组
    }
    
    [dict setObject:_info forKey:@"info"];
    [dict setObject:@0 forKey:@"srcType"];//报名类型－－0非嘉宾通道
    //deviceID
    NSString * uuid= [FCUUID getUUID];
    [dict setObject:uuid forKey:@"deviceID"];
    
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"team/doTeamActivitySignUp" JsonKey:nil withData:dict failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        NSLog(@"data == %@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            _infoKey = [data objectForKey:@"infoKey"];
            if ([data objectForKey:@"payMoneyAll"]) {
                _realPayPrice = [[data objectForKey:@"payMoneyAll"] floatValue];
            }
            
            if (type == 1) {
                [self weChatPay];
            }else if (type == 2){
                [self zhifubaoPay];
            }else if (type == 3){
                //余额支付
                [self dreawBalance];
            }else{
                //跳转分组页面
                JGTeamGroupViewController *groupCtrl = [[JGTeamGroupViewController alloc]init];
                groupCtrl.activityFrom = 1;
                groupCtrl.teamActivityKey = [_modelss.timeKey integerValue];
                //                groupCtrl.teamKey = _modelss.teamKey;
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
    
    [[JsonHttp jsonHttp]httpRequest:@"pay/doPayWeiXin" JsonKey:@"payInfo" withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
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
        
    }else if (secess == 2){
        [[ShowHUD showHUD]showToastWithText:@"支付已取消！" FromView:self.view];
    }else{
        [[ShowHUD showHUD]showToastWithText:@"支付失败！" FromView:self.view];
    }
    
    //跳转分组页面
    JGTeamGroupViewController *groupCtrl = [[JGTeamGroupViewController alloc]init];
    groupCtrl.teamActivityKey = [_modelss.timeKey integerValue];
    groupCtrl.activityFrom = 1;
    [self.navigationController pushViewController:groupCtrl animated:YES];
}
//- (void)popActivityCtrl{
//    //
//    NSNotification * notice = [NSNotification notificationWithName:@"reloadActivityData" object:nil userInfo:nil];
//    //发送消息
//    [[NSNotificationCenter defaultCenter]postNotification:notice];
//    
//    for (UIViewController *controller in self.navigationController.viewControllers) {
//        if ([controller isKindOfClass:[JGTeamActibityNameViewController class]]) {
//            [self.navigationController popToViewController:controller animated:YES];
//        }
//    }
//
//}
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
            
            NSLog(@"支付宝=====%@",resultDic[@"resultStatus"]);
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                NSLog(@"成功！");
                
            } else if ([resultDic[@"resultStatus"] isEqualToString:@"4000"]) {
                NSLog(@"失败");
                [[ShowHUD showHUD]showToastWithText:@"支付失败！" FromView:self.view];
            } else if ([resultDic[@"resultStatus"] isEqualToString:@"6002"]) {
                NSLog(@"网络错误");
                [[ShowHUD showHUD]showToastWithText:@"网络异常，支付失败！" FromView:self.view];
            } else if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
                NSLog(@"取消支付");
                [[ShowHUD showHUD]showToastWithText:@"支付已取消！" FromView:self.view];
            } else {
                NSLog(@"支付失败");
                [[ShowHUD showHUD]showToastWithText:@"支付失败！" FromView:self.view];
            }
            
            //跳转分组页面
            JGTeamGroupViewController *groupCtrl = [[JGTeamGroupViewController alloc]init];
            groupCtrl.activityFrom = 1;
            groupCtrl.teamActivityKey = [_modelss.timeKey integerValue];
            [self.navigationController pushViewController:groupCtrl animated:YES];
        }];
    }];
}
#pragma mark -- 删除密码视图
- (void)deleteBalanceView:(UIButton *)btn{
    
    [_balanceView removeFromSuperview];
    [_passWordView removeFromSuperview];
    _tranView.hidden = YES;
    
    JGTeamGroupViewController *groupCtrl = [[JGTeamGroupViewController alloc]init];
    groupCtrl.activityFrom = 1;
    groupCtrl.teamActivityKey = [_modelss.timeKey integerValue];
    [self.navigationController pushViewController:groupCtrl animated:YES];
}
#pragma mark -- 余额支付
- (void)balancePay{
    [[ShowHUD showHUD]showAnimationWithText:@"支付中..." FromView:self.view];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@2 forKey:@"orderType"];
    [dict setObject:_infoKey forKey:@"srcKey"];
    [dict setObject:@"活动报名" forKey:@"name"];
    [dict setObject:@"活动余额支付订单" forKey:@"otherInfo"];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:[Helper md5HexDigest:_passWordView.textStore] forKey:@"payPassword"];
    NSLog(@"%@", _passWordView.textStore);
    if (_invoiceKey != nil) {
        [dict setObject:_addressKey forKey:@"addressKey"];
        [dict setObject:_invoiceKey forKey:@"invoiceKey"];
    }
    
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"pay/doPayByUserAccount" JsonKey:@"payInfo" withData:dict failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        NSLog(@"%@",[data objectForKey:@"query"]);
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        [_balanceView removeFromSuperview];
        _tranView.hidden = YES;
        //跳转分组页面
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            [LQProgressHud showMessage:@"支付成功！"];
            
        }else{
            _passWordView.textStore = [@"" mutableCopy];
            [_passWordView deleteBackward];
            [_passWordView becomeFirstResponder];
            
            if ([data objectForKey:@"packResultMsg"]) {
                [LQProgressHud showMessage:[data objectForKey:@"packResultMsg"]];
            }else{
                [LQProgressHud showMessage:@"支付失败！"];
            }
        }
        
        JGTeamGroupViewController *groupCtrl = [[JGTeamGroupViewController alloc]init];
        groupCtrl.activityFrom = 1;
        groupCtrl.teamActivityKey = [_modelss.timeKey integerValue];
        [self.navigationController pushViewController:groupCtrl animated:YES];
    }];
}
#pragma mark -- 确认页面－－取消 -立即支付
- (void)didSelectCancelBtn:(UIButton *)btn{
    self.applyListView.hidden = YES;
    self.tranView.hidden = YES;
}
#pragma mark -- 确认页面－－立即支付
- (void)didSelectPayBtn:(UIButton *)btn andApplyListArray:(NSMutableArray *)applistArray{
    [[ShowHUD showHUD]showAnimationWithText:@"加载中..." FromView:self.view];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [[JsonHttp jsonHttp]httpRequest:@"user/getUserBalance" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            _balance = [NSString stringWithFormat:@"%@", [data objectForKey:@"money"]];
            
            NSString *balanceString;
            if ([[data objectForKey:@"money"] floatValue] >= _realPayPrice) {
                balanceString = [NSString stringWithFormat:@"余额支付（¥%.2f）", [[data objectForKey:@"money"] floatValue]];
            }else{
                balanceString = [NSString stringWithFormat:@"余额支付（余额不足 ¥%.2f）", [[data objectForKey:@"money"] floatValue]];
            }
            
            _relApplistArray = [NSMutableArray arrayWithArray:applistArray];
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
            UIAlertAction *balanceAction = [UIAlertAction actionWithTitle:balanceString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //余额支付
                if ([[data objectForKey:@"money"] floatValue] >= _realPayPrice) {
                    if ([[data objectForKey:@"isSetPayPassWord"] integerValue] == 0) {
                        JGDSetBusinessPWDViewController *setpassCtrl = [[JGDSetBusinessPWDViewController alloc]init];
                        [self.navigationController pushViewController:setpassCtrl animated:YES];
                    }else{
                        [self submitInfo:3];
                        //[self dreawBalance:[NSString stringWithFormat:@"%.2f", [[data objectForKey:@"money"] floatValue]]];
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
        }
    }];
}
#pragma mark -- 余额支付
- (void)dreawBalance{
    _tranView.hidden = NO;
    _tranView.frame = CGRectMake(0, 0, screenWidth, screenHeight -64);
    //
    _balanceView = [[JGHbalanceView alloc]initWithFrame:CGRectMake(15 *ProportionAdapter, 50 *ProportionAdapter, screenWidth -30*ProportionAdapter, 286*ProportionAdapter)];
    _balanceView.layer.masksToBounds = YES;
    _balanceView.layer.cornerRadius = 5.0*ProportionAdapter;
    _balanceView.alpha = 1.0;
    _balanceView.delegate = self;
    [_balanceView configJGHbalanceViewPrice:_realPayPrice andBalance:_balance andDetail:_modelss.name];
    //密码输入框
    _passWordView = [[[NSBundle mainBundle]loadNibNamed:@"WCLPassWordView" owner:self options:nil]lastObject];
    _passWordView.frame = CGRectMake(13 *ProportionAdapter, 222 *ProportionAdapter, _balanceView.frame.size.width -26*ProportionAdapter, 45 *ProportionAdapter);
    _passWordView.delegate = self;
    _passWordView.backgroundColor = [UIColor whiteColor];
    [_balanceView addSubview:_passWordView];
    
    [self.view addSubview:_balanceView];
}
#pragma mark -- 监听输入的改变
- (void)passWordDidChange:(WCLPassWordView *)passWord{
    
}
#pragma mark -- 监听输入的完成时
- (void)passWordCompleteInput:(WCLPassWordView *)passWord{
    [self balancePay];
//    [self submitInfo:3];
}
#pragma mark -- 监听开始输入
- (void)passWordBeginInput:(WCLPassWordView *)passWord{
    
}
#pragma mark -- 修改费用
- (void)selectApplyCatory:(NSMutableDictionary *)costDict{
    for (int i=0; i<_applyArray.count; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (i == _editorPlayId) {
            dict = _applyArray[_editorPlayId];
            [dict setObject:[costDict objectForKey:@"costType"] forKey:@"type"];
            [dict setObject:[costDict objectForKey:@"money"] forKey:@"money"];
            [_applyArray replaceObjectAtIndex:i withObject:dict];
        }
    }
    
    [self countAmountPayable];
    
    self.tranView.frame = CGRectMake(0, 0, 0, 0);
    self.tranView.hidden = YES;
    [self.applyCatoryPriceView removeFromSuperview];
    self.applyCatoryPriceView = nil;
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
