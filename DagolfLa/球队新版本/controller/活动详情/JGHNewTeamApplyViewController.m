//
//  JGHNewTeamApplyViewController.m
//  DagolfLa
//
//  Created by 黄安 on 17/1/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHNewTeamApplyViewController.h"
#import "JGHAddInvoiceViewController.h"
#import "JGTeamGroupViewController.h"
#import "JGTeamAcitivtyModel.h"
#import "JGHApplyNewCell.h"

#import "JGHApplyListView.h"
#import "JGHJustApplyListView.h"
#import "JGHApplyCatoryPriceView.h"
#import "JGHAddTeamPlaysViewController.h"
#import "JGTeamActibityNameViewController.h"
#import "JGDSetBusinessPWDViewController.h"
#import "JGHNewApplyActivityDetailCell.h"
#import "JGHNewApplyPepoleCell.h"

static NSString *const JGHApplyNewCellIdentifier = @"JGHApplyNewCell";
static NSString *const JGHNewApplyActivityDetailCellIdentifier = @"JGHNewApplyActivityDetailCell";
static NSString *const JGHNewApplyPepoleCellIdentifier = @"JGHNewApplyPepoleCell";

@interface JGHNewTeamApplyViewController ()<JGHApplyNewCellDelegate, JGHAddInvoiceViewControllerDelegate, JGHApplyListViewDelegate, JGHJustApplyListViewDelegate, JGHApplyCatoryPriceViewDelegate, UITableViewDelegate, UITableViewDataSource, JGHNewApplyPepoleCellDelegate>
{
    UIAlertController *_actionView;
    
    NSInteger _w;
    NSInteger _z;
    NSString *_infoKey;
    
    NSInteger _editorPlayId;//修改价格 ID -0
    
    NSMutableArray *_relApplistArray;
    
    NSString *_balance;//余额
}
@property (retain, nonatomic) UITableView *teamApplyTableView;

@property (nonatomic, strong)NSArray *titleArray;//标题

@property (nonatomic, strong)NSMutableArray *applyArray;//成员数组----添加成员字典

@property (nonatomic, strong)NSMutableDictionary *info;

@property (nonatomic, strong)UIButton *cellClickBtn;//拦截cell点击事件

@property (nonatomic, strong)UIView *tranView;
@property (nonatomic, strong)JGHApplyListView *applyListView;//报名人列表
@property (nonatomic, strong)JGHJustApplyListView *justApplyListView;//仅报名列表

@property (nonatomic, strong)JGHApplyCatoryPriceView *applyCatoryPriceView;//价格类型列表

@end

@implementation JGHNewTeamApplyViewController

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
    self.navigationItem.title = @"报名详情";
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.applyArray = [NSMutableArray array];
    self.info = [NSMutableDictionary dictionary];
    self.titleArray = @[@"活动名称", @"活动地址", @"活动日期", @"活动费用", @"嘉宾费用"];
    
    _relApplistArray = [NSMutableArray array];
    
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
    }
    
    self.teamApplyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 44)];
    
    UINib *applyListNib = [UINib nibWithNibName:@"JGHApplyNewCell" bundle: [NSBundle mainBundle]];
    [self.teamApplyTableView registerNib:applyListNib forCellReuseIdentifier:JGHApplyNewCellIdentifier];
    
    [self.teamApplyTableView registerClass:[JGHNewApplyActivityDetailCell class] forCellReuseIdentifier:JGHNewApplyActivityDetailCellIdentifier];
    
    [self.teamApplyTableView registerClass:[JGHNewApplyPepoleCell class] forCellReuseIdentifier:JGHNewApplyPepoleCellIdentifier];
    
    self.teamApplyTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.teamApplyTableView.dataSource = self;
    self.teamApplyTableView.delegate = self;
    self.teamApplyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.teamApplyTableView];
}
#pragma mark -- tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        //人员个数
        return self.applyArray.count;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10 *ProportionAdapter;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35 *ProportionAdapter;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 132 *ProportionAdapter;
    }
    return 44 *ProportionAdapter;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGHApplyNewCell *applyListCel = [tableView dequeueReusableCellWithIdentifier:JGHApplyNewCellIdentifier forIndexPath:indexPath];
    applyListCel.editorBtn.tag = indexPath.row;
    applyListCel.deleBtn.tag = indexPath.row + 100;
    applyListCel.delegate = self;
    applyListCel.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_applyArray.count > 0) {
        [applyListCel configDict:_applyArray[indexPath.row]];
    }
    
    return applyListCel;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        JGHNewApplyActivityDetailCell *infoCell = [tableView dequeueReusableCellWithIdentifier:JGHNewApplyActivityDetailCellIdentifier];
        infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [infoCell configJGTeamAcitivtyModel:_modelss];
        return (UIView *)infoCell;
    }else {
        JGHNewApplyPepoleCell *applyPepoleCell = [tableView dequeueReusableCellWithIdentifier:JGHNewApplyPepoleCellIdentifier];
        applyPepoleCell.delegate = self;
        return (UIView *)applyPepoleCell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10*ProportionAdapter)];
    footView.backgroundColor = [UIColor colorWithHexString:BG_color];
    return footView;
}
#pragma mark --
- (void)addApplyerBtn:(UIButton *)addApplyBtn{
    addApplyBtn.enabled = NO;
    JGHAddTeamPlaysViewController *addTeamPlaysCtrl = [[JGHAddTeamPlaysViewController alloc]init];
    addTeamPlaysCtrl.costListArray = [NSMutableArray arrayWithArray:_costListArray];
    addTeamPlaysCtrl.playListArray = [NSMutableArray arrayWithArray:_applyArray];
    if (_modelss.teamActivityKey != 0) {
        addTeamPlaysCtrl.activityKey = _modelss.teamActivityKey;
    }else{
        addTeamPlaysCtrl.activityKey = [_modelss.timeKey integerValue];
    }
    
    addTeamPlaysCtrl.teamKey = _modelss.teamKey;
    
    __weak JGHNewTeamApplyViewController *weakSelf = self;
    addTeamPlaysCtrl.blockPlayListArray = ^(NSMutableArray *listArray){
        _applyArray = listArray;
        [weakSelf.teamApplyTableView reloadData];
    };
    
    [self.navigationController pushViewController:addTeamPlaysCtrl animated:YES];
    addApplyBtn.enabled = YES;
}
#pragma mark -- 报名并支付
- (IBAction)nowPayBtnClick:(UIButton *)sender {
    if (_applyArray.count == 0) {
        [[ShowHUD showHUD]showToastWithText:@"请添加打球人，再支付！" FromView:self.view];
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
/*
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
    
    __weak JGHNewTeamApplyViewController *weakSelf = self;
    addTeamPlaysCtrl.blockPlayListArray = ^(NSMutableArray *listArray){
        _applyArray = listArray;
        [weakSelf.teamApplyTableView reloadData];
    };
    
    [self.navigationController pushViewController:addTeamPlaysCtrl animated:YES];
}
 */
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
            } withBlock:^(UIAlertController *alertView) {
                [self.navigationController presentViewController:alertView animated:YES completion:nil];
            }];
        }else{
            [self.applyArray removeObjectAtIndex:btn.tag - 100];
            //计算价格
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
                //_realPayPrice = [[data objectForKey:@"payMoneyAll"] floatValue];
            }
            
            if (type == 1) {
                //[self weChatPay];
            }else if (type == 2){
                //[self zhifubaoPay];
            }else if (type == 3){
                //余额支付
                //[self dreawBalance];
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
#pragma mark -- 确认页面－－取消 -立即支付
- (void)didSelectCancelBtn:(UIButton *)btn{
    self.applyListView.hidden = YES;
    self.tranView.hidden = YES;
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
