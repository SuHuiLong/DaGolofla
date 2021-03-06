//
//  JGHAddIntentionPalyerViewController.m
//  DagolfLa
//
//  Created by 黄安 on 17/2/9.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHAddIntentionPalyerViewController.h"
//#import "JGHAddPlaysCell.h"
#import "JGHAddPlaysButtonCell.h"
#import "JGHPlayBaseInfoCell.h"
#import "JGHAddressBookPlaysViewController.h"
#import "JGHNewAddTeamMemberViewController.h"
#import "JGHNewAddApplyTeamPlaysViewController.h"
#import "TKAddressModel.h"
#import "JGLTeamMemberModel.h"
#import "MyattenModel.h"
#import "JGHApplyerHeaderCell.h"
#import "JGHNewApplyerListCell.h"
#import "JGLAddActiivePlayModel.h"
#import "JGHNewAddPlaysCell.h"
#import "JGHNewApplyerHeaderCell.h"

static NSString *const JGHNewAddPlaysCellIdentifier = @"JGHNewAddPlaysCell";
static NSString *const JGHAddPlaysButtonCellIdentifier = @"JGHAddPlaysButtonCell";
static NSString *const JGHPlayBaseInfoCellIdentifier = @"JGHPlayBaseInfoCell";
static NSString *const JGHNewApplyerHeaderCellIdentifier = @"JGHNewApplyerHeaderCell";
static NSString *const JGHNewApplyerListCellIdentifier = @"JGHNewApplyerListCell";
static NSString *const JGHApplyerHeaderCellIdentifier = @"JGHApplyerHeaderCell";

@interface JGHAddIntentionPalyerViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, JGHNewAddPlaysCellDelegate, JGHAddPlaysButtonCellDelegate, JGHPlayBaseInfoCellDelegate, JGHNewApplyerListCellDelegate, JGHNewApplyerHeaderCellDelegate>
{
    NSMutableDictionary *_playsBaseDict;
}

@property (strong, nonatomic)UITableView *addTeamPlaysTableView;

@end

@implementation JGHAddIntentionPalyerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"添加打球人";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeBtnClick)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
    
    _playListArray = [NSMutableArray array];
    _playsBaseDict = [NSMutableDictionary dictionary];
    [self initPlaysBaseInfo];
    
    [self createAddTeamPlaysTableView];
}
#pragma mark -- 完成
- (void)completeBtnClick{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@(_teamKey) forKey:@"teamKey"];//球队key
    [info setObject:@(_activityKey) forKey:@"activityKey"];//球队活动key
    
    [info setObject:DEFAULF_UserName forKey:@"userName"];//报名人名称//teamkey 156
    
    [info setObject:DEFAULF_USERID forKey:@"userKey"];//用户Key
    [info setObject:@0 forKey:@"timeKey"];//timeKey
    
    [dict setObject:info forKey:@"info"];
    [dict setObject:@0 forKey:@"srcType"];//报名类型－－0非嘉宾通道
    [dict setObject:_playListArray forKey:@"teamSignUpList"];
    NSString * uuid= [FCUUID getUUID];
    [dict setObject:uuid forKey:@"deviceID"];
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"team/doTeamActivitySignUp" JsonKey:nil withData:dict failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            _blockRefresh();
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
        }
    }];
    
//    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 初始化报名人信息
- (void)initPlaysBaseInfo{
    [_playsBaseDict setObject:@1 forKey:@"sex"];//默认性别女-0
    [_playsBaseDict setObject:@"0" forKey:@"isOnlinePay"];//是否线上付款 1-线上
}
- (void)createAddTeamPlaysTableView{
    self.addTeamPlaysTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10*ProportionAdapter, screenWidth, screenHeight - 64)];

    [self.addTeamPlaysTableView registerClass:[JGHNewAddPlaysCell class] forCellReuseIdentifier:JGHNewAddPlaysCellIdentifier];
    
    [self.addTeamPlaysTableView registerClass:[JGHApplyerHeaderCell class] forCellReuseIdentifier:JGHApplyerHeaderCellIdentifier];
    
    UINib *addPlaysButtonCellNib = [UINib nibWithNibName:@"JGHAddPlaysButtonCell" bundle: [NSBundle mainBundle]];
    [self.addTeamPlaysTableView registerNib:addPlaysButtonCellNib forCellReuseIdentifier:JGHAddPlaysButtonCellIdentifier];
    
    UINib *playBaseInfoCellNib = [UINib nibWithNibName:@"JGHPlayBaseInfoCell" bundle: [NSBundle mainBundle]];
    [self.addTeamPlaysTableView registerNib:playBaseInfoCellNib forCellReuseIdentifier:JGHPlayBaseInfoCellIdentifier];
    
    [self.addTeamPlaysTableView registerClass:[JGHNewApplyerHeaderCell class] forCellReuseIdentifier:JGHNewApplyerHeaderCellIdentifier];
    
    [self.addTeamPlaysTableView registerClass:[JGHNewApplyerListCell class] forCellReuseIdentifier:JGHNewApplyerListCellIdentifier];
    
    self.addTeamPlaysTableView.dataSource = self;
    self.addTeamPlaysTableView.delegate = self;
    self.addTeamPlaysTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.addTeamPlaysTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self.view addSubview:self.addTeamPlaysTableView];
}
#pragma mark -- tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 1;
    }else if (section == 3){
        return _playListArray.count;//报名人列表
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;//详情页面
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 100 *ProportionAdapter;
    }else if (indexPath.section == 3){
        return 35 *ProportionAdapter;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 1;
    }
    return 10 *ProportionAdapter;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 106 *ProportionAdapter;
    }
    return 44 *ProportionAdapter;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        JGHPlayBaseInfoCell *playBaseInfoCell = [tableView dequeueReusableCellWithIdentifier:JGHPlayBaseInfoCellIdentifier];
        playBaseInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        playBaseInfoCell.delegate = self;
        playBaseInfoCell.nameText.delegate = self;
        playBaseInfoCell.nameText.tag = 200;
        playBaseInfoCell.almostFext.delegate = self;
        playBaseInfoCell.almostFext.tag = 201;
        playBaseInfoCell.phoneNumberText.delegate = self;
        playBaseInfoCell.phoneNumberText.tag = 202;
        [playBaseInfoCell configJGHPlayBaseInfoCell:_playsBaseDict];
        return playBaseInfoCell;
    }else{
        JGHNewApplyerListCell *playPayBaseCell = [tableView dequeueReusableCellWithIdentifier:JGHNewApplyerListCellIdentifier];
        playPayBaseCell.selectionStyle = UITableViewCellSelectionStyleNone;
        playPayBaseCell.delegate = self;
        playPayBaseCell.deleteApplyBtn.tag = indexPath.row + 1000;
        [playPayBaseCell configDict:_playListArray[indexPath.row]];
        return playPayBaseCell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        NSLog(@"选择资费类型 == %td", indexPath.row);
        //[self selectPalysTypeList:indexPath.row];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        JGHNewAddPlaysCell *addPlaysCell = [tableView dequeueReusableCellWithIdentifier:JGHNewAddPlaysCellIdentifier];
        addPlaysCell.delegate = self;
        return (UIView *)addPlaysCell;
    }else if (section == 1) {
        JGHNewApplyerHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:JGHNewApplyerHeaderCellIdentifier];
        //基本信息
        headerCell.delegate = self;
        return (UIView *)headerCell;
    }else if (section == 2){
        JGHAddPlaysButtonCell *addPlaysButtonCell = [tableView dequeueReusableCellWithIdentifier:JGHAddPlaysButtonCellIdentifier];
        addPlaysButtonCell.delegate = self;
        return (UIView *)addPlaysButtonCell;
    }else {
        JGHApplyerHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:JGHApplyerHeaderCellIdentifier];
        [headerCell configHeaderName:@"已添加打球人"];
        return (UIView *)headerCell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10*ProportionAdapter)];
    footView.backgroundColor = [UIColor colorWithHexString:BG_color];
    if (section == 1) {
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 0, screenWidth -20*ProportionAdapter, 1)];
        line.backgroundColor = [UIColor colorWithHexString:BG_color];
        [footView addSubview:line];
        footView.backgroundColor = [UIColor whiteColor];
    }
    
    return footView;
}

#pragma mark -- 添加队员
- (void)selectAddPlays:(UIButton *)btn{
    NSLog(@"添加队员");
    [_playsBaseDict removeAllObjects];
    
    [self initPlaysBaseInfo];//初始化打球人信息
    
    JGHNewAddApplyTeamPlaysViewController *applyPlaysCtrl = [[JGHNewAddApplyTeamPlaysViewController alloc]init];
    applyPlaysCtrl.teamKey = _teamKey;
    applyPlaysCtrl.activityKey = _activityKey;
    applyPlaysCtrl.userKeyArray = [self returnUserKeyString];
    applyPlaysCtrl.allListArray = _allListArray;
    
    __weak JGHAddIntentionPalyerViewController *weakSelf = self;
    applyPlaysCtrl.blockFriendArray = ^(NSMutableArray *listArray){
        
        //JGLTeamMemberModel
        
        for (int i=0; i<listArray.count; i++) {
            JGLAddActiivePlayModel *palyModel = [[JGLAddActiivePlayModel alloc]init];
            palyModel = listArray[i];
            if (palyModel.selectID == 1) {
                
                NSInteger isEquelMobile = 1;
                for (int i=0; i<_playListArray.count; i++) {
                    NSDictionary *dict = [NSDictionary dictionary];
                    dict = _playListArray[i];
                    if ([[dict objectForKey:Mobile] isEqualToString:palyModel.mobile]) {
                        isEquelMobile = 0;
                        break;
                    }else{
                        isEquelMobile = 1;
                    }
                }
                
                if (isEquelMobile == 1) {
                    NSMutableDictionary *palyDict = [NSMutableDictionary dictionary];
                    if (palyModel.userName) {
                        [palyDict setObject:palyModel.userName forKey:@"name"];
                    }
                    
                    if (palyModel.mobile) {
                        [palyDict setObject:palyModel.mobile forKey:@"mobile"];
                    }
                    
                    [palyDict setObject:@"0" forKey:@"userKey"];
                    
                    if (palyModel.almost) {
                        [palyDict setObject:[NSString stringWithFormat:@"%@", palyModel.almost] forKey:@"almost"];
                    }
                    
                    if ([palyModel.sex integerValue] == 0) {
                        [palyDict setObject:palyModel.sex forKey:@"sex"];
                    }else{
                        [palyDict setObject:@1 forKey:@"sex"];
                    }
                    
                    [_playListArray addObject:palyDict];
                }
                
            }
        }
        
        [weakSelf.addTeamPlaysTableView reloadData];
    };
    [self.navigationController pushViewController:applyPlaysCtrl animated:YES];
}
#pragma mark -- 添加球友
- (void)selectAddBallPlays:(UIButton *)btn{
    NSLog(@"添加球友");
    [_playsBaseDict removeAllObjects];
    
    [self initPlaysBaseInfo];//初始化打球人信息
    
    JGHNewAddTeamMemberViewController *addTeamMemberCtrl = [[JGHNewAddTeamMemberViewController alloc]init];
    addTeamMemberCtrl.userKeyArray = [self returnUserKeyString];
    addTeamMemberCtrl.allListArray = _allListArray;
    
    __weak JGHAddIntentionPalyerViewController *weakSelf = self;
    addTeamMemberCtrl.blockPalyFriendArray = ^(NSMutableArray *listArray){
        
        for (int i=0; i<listArray.count; i++) {
            JGLAddActiivePlayModel *palyModel = [[JGLAddActiivePlayModel alloc]init];
            palyModel = listArray[i];
            if (palyModel.selectID == 2) {
                
                NSInteger isEquelMobile = 1;
                for (int i=0; i<_playListArray.count; i++) {
                    NSDictionary *dict = [NSDictionary dictionary];
                    dict = _playListArray[i];
                    if ([[dict objectForKey:Mobile] isEqualToString:palyModel.mobile]) {
                        isEquelMobile = 0;
                        break;
                    }else{
                        isEquelMobile = 1;
                    }
                }
                
                if (isEquelMobile == 1) {
                    NSMutableDictionary *palyDict = [NSMutableDictionary dictionary];
                    if (palyModel.userName) {
                        [palyDict setObject:palyModel.userName forKey:@"name"];
                    }
                    
                    if (palyModel.mobile) {
                        [palyDict setObject:palyModel.mobile forKey:@"mobile"];
                    }
                    
                    [palyDict setObject:@"0" forKey:@"userKey"];
                    
                    if (palyModel.almost) {
                        [palyDict setObject:[NSString stringWithFormat:@"%@", palyModel.almost] forKey:@"almost"];
                    }
                    
                    if ([palyModel.sex integerValue] == 0) {
                        [palyDict setObject:palyModel.sex forKey:@"sex"];
                    }else{
                        [palyDict setObject:@1 forKey:@"sex"];
                    }
                    
                    [_playListArray addObject:palyDict];
                }
                
            }
        }
        
        [weakSelf.addTeamPlaysTableView reloadData];
    };
    [self.navigationController pushViewController:addTeamMemberCtrl animated:YES];
}
#pragma mark -- 添加联系人
- (void)selectAddContactPlays:(UIButton *)btn{
    NSLog(@"添加联系人");
    [_playsBaseDict removeAllObjects];
    
    [self initPlaysBaseInfo];//初始化打球人信息
    
    JGHAddressBookPlaysViewController *addressBookCtrl = [[JGHAddressBookPlaysViewController alloc]init];
    
    __weak JGHAddIntentionPalyerViewController *weakSelf = self;
    addressBookCtrl.blockAddressPeople = ^(TKAddressModel *model){
        
        if (model.userName) {
            [_playsBaseDict setObject:model.userName forKey:@"name"];
        }
        
        if (model.mobile) {
            [_playsBaseDict setObject:model.mobile forKey:@"mobile"];
        }
        
        [_playsBaseDict setObject:@0 forKey:@"userKey"];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        NSArray *indexArray=[NSArray arrayWithObject:indexPath];
        [weakSelf.addTeamPlaysTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    [self.navigationController pushViewController:addressBookCtrl animated:YES];
}
#pragma mark -- 获取所有打球人userKey
- (NSMutableArray *)returnUserKeyString{
    NSMutableArray *userKeyArray = [NSMutableArray array];
    for (NSDictionary *dict in _playListArray) {
        if ([dict objectForKey:@"userKey"]) {
            [userKeyArray addObject:[dict objectForKey:@"userKey"]];
        }
    }
    
    return userKeyArray;
}
#pragma mark -- 立即添加
- (void)addPlaysButtonCellClick:(UIButton *)btn{
    NSLog(@"立即添加--资费类型");
    [self.view endEditing:YES];
    if (![_playsBaseDict objectForKey:@"name"]) {
        [[ShowHUD showHUD]showToastWithText:@"请输入姓名！" FromView:self.view];
        return;
    }
    
    if (![_playsBaseDict objectForKey:@"almost"]) {
        [[ShowHUD showHUD]showToastWithText:@"请输入差点！" FromView:self.view];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:_playsBaseDict];
    NSArray *keysArray = [NSArray array];
    keysArray = [_playsBaseDict allKeys];
    NSInteger keyID = 0;
    for (NSString *keysString in keysArray) {
        if ([keysString isEqualToString:@"userKey"]) {
            keyID += 1;
        }
    }
    
    if (keyID == 0) {
        [dict setObject:@0 forKey:@"userKey"];
    }
    
    //[dict setObject:@"1" forKey:@"select"];//付款勾选默认勾
    [_playListArray addObject:dict];
    [_playsBaseDict removeAllObjects];
    [self initPlaysBaseInfo];//初始化打球人信息
    [self.addTeamPlaysTableView reloadData];
}
#pragma mark -- 选择男
- (void)selectManBtn:(UIButton *)btn{
    NSLog(@"男");
    [_playsBaseDict setObject:@1 forKey:@"sex"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    NSArray *indexArray=[NSArray arrayWithObject:indexPath];
    [self.addTeamPlaysTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark -- 选择女
- (void)selectWoManBtn:(UIButton *)btn{
    NSLog(@"女");
    [_playsBaseDict setObject:@0 forKey:@"sex"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    NSArray *indexArray=[NSArray arrayWithObject:indexPath];
    [self.addTeamPlaysTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark -- 删除打球人
- (void)selectApplyDeleteBtn:(UIButton *)btn{
    NSLog(@" 删除打球人 == %ld", (long)btn.tag);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict = _playListArray[btn.tag -1000];
    /*
     if ([DEFAULF_USERID integerValue] == [[dict objectForKey:@"userKey"] integerValue]) {
     [Helper alertViewWithTitle:@"删除后将不享受平台补贴，是否删除？" withBlockCancle:^{
     NSLog(@"取消删除");
     } withBlockSure:^{
     [self delePalys:btn.tag - 1000];
     } withBlock:^(UIAlertController *alertView) {
     [self presentViewController:alertView animated:YES completion:nil];
     }];
     }else{
     [self delePalys:btn.tag - 1000];
     }
     */
    
    [self delePalys:btn.tag - 1000];
    
    [self.addTeamPlaysTableView reloadData];
}
- (void)delePalys:(NSInteger)listId{
    [_playListArray removeObjectAtIndex:listId];
    [self.addTeamPlaysTableView reloadData];
}
#pragma mark -- textDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 200) {
        NSLog(@"名字");
        [_playsBaseDict setObject:textField.text forKey:@"name"];
    }else if (textField.tag == 201){
        NSLog(@"差点");
        if (textField.text.length > 0) {
            [_playsBaseDict setObject:textField.text forKey:@"almost"];
        }
        
    }else{
        NSLog(@"手机号");
        [_playsBaseDict setObject:textField.text forKey:@"mobile"];
    }
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
