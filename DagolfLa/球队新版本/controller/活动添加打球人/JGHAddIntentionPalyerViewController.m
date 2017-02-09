//
//  JGHAddIntentionPalyerViewController.m
//  DagolfLa
//
//  Created by 黄安 on 17/2/9.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHAddIntentionPalyerViewController.h"
#import "JGHAddPlaysCell.h"
#import "JGHAddPlaysButtonCell.h"
#import "JGHPlayBaseInfoCell.h"
#import "JGHAddressBookPlaysViewController.h"
#import "JGHAddTeamMemberViewController.h"
#import "JGHAddApplyTeamPlaysViewController.h"
#import "TKAddressModel.h"
#import "JGLTeamMemberModel.h"
#import "MyattenModel.h"
#import "JGHApplyerHeaderCell.h"
#import "JGHNewApplyerListCell.h"

static NSString *const JGHAddPlaysCellIdentifier = @"JGHAddPlaysCell";
static NSString *const JGHAddPlaysButtonCellIdentifier = @"JGHAddPlaysButtonCell";
static NSString *const JGHPlayBaseInfoCellIdentifier = @"JGHPlayBaseInfoCell";
static NSString *const JGHApplyerHeaderCellIdentifier = @"JGHApplyerHeaderCell";
static NSString *const JGHNewApplyerListCellIdentifier = @"JGHNewApplyerListCell";

@interface JGHAddIntentionPalyerViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, JGHAddPlaysCellDelegate, JGHAddPlaysButtonCellDelegate, JGHPlayBaseInfoCellDelegate, JGHNewApplyerListCellDelegate>
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
    self.navigationItem.title = @"添加意向成员";
    
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
//    _blockPlayListArray(_playListArray);
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@(_teamKey) forKey:@"teamKey"];
    [dict setObject:@(_activityKey) forKey:@"activityKey"];
    [dict setObject:_playListArray forKey:@"teamActivitySignUpList"];
    [[JsonHttp jsonHttp]httpRequestWithMD5:@"team/batchAddLineTeamActivitySignUp" JsonKey:@"teamActivitySignUp" withData:dict failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
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
    
    /*
     for (int i=0; i<_costListArray.count; i++) {
     NSMutableDictionary *dict = [NSMutableDictionary dictionary];
     dict = [NSMutableDictionary dictionaryWithDictionary:_costListArray[i]];
     [dict setObject:@0 forKey:@"select"];
     
     [_costListArray replaceObjectAtIndex:i withObject:dict];
     }
     */
}
- (void)createAddTeamPlaysTableView{
    self.addTeamPlaysTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    UINib *addPlaysCellNib = [UINib nibWithNibName:@"JGHAddPlaysCell" bundle: [NSBundle mainBundle]];
    [self.addTeamPlaysTableView registerNib:addPlaysCellNib forCellReuseIdentifier:JGHAddPlaysCellIdentifier];
    
    UINib *addPlaysButtonCellNib = [UINib nibWithNibName:@"JGHAddPlaysButtonCell" bundle: [NSBundle mainBundle]];
    [self.addTeamPlaysTableView registerNib:addPlaysButtonCellNib forCellReuseIdentifier:JGHAddPlaysButtonCellIdentifier];
    
    UINib *playBaseInfoCellNib = [UINib nibWithNibName:@"JGHPlayBaseInfoCell" bundle: [NSBundle mainBundle]];
    [self.addTeamPlaysTableView registerNib:playBaseInfoCellNib forCellReuseIdentifier:JGHPlayBaseInfoCellIdentifier];
    
    [self.addTeamPlaysTableView registerClass:[JGHApplyerHeaderCell class] forCellReuseIdentifier:JGHApplyerHeaderCellIdentifier];
    
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
        JGHAddPlaysCell *addPlaysCell = [tableView dequeueReusableCellWithIdentifier:JGHAddPlaysCellIdentifier];
        addPlaysCell.delegate = self;
        return (UIView *)addPlaysCell;
    }else if (section == 1) {
        JGHApplyerHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:JGHApplyerHeaderCellIdentifier];
        [headerCell configHeaderName:@"基本信息"];
        return (UIView *)headerCell;
    }else if (section == 2){
        JGHAddPlaysButtonCell *addPlaysButtonCell = [tableView dequeueReusableCellWithIdentifier:JGHAddPlaysButtonCellIdentifier];
        addPlaysButtonCell.delegate = self;
        return (UIView *)addPlaysButtonCell;
    }else {
        JGHApplyerHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:JGHApplyerHeaderCellIdentifier];
        [headerCell configHeaderName:@"已添加意向成员"];
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
    
    JGHAddApplyTeamPlaysViewController *applyPlaysCtrl = [[JGHAddApplyTeamPlaysViewController alloc]init];
    applyPlaysCtrl.teamKey = _teamKey;
    applyPlaysCtrl.activityKey = _activityKey;
    applyPlaysCtrl.userKeyArray = [self returnUserKeyString];
    
    __weak JGHAddIntentionPalyerViewController *weakSelf = self;
    applyPlaysCtrl.blockFriendDict = ^(JGLTeamMemberModel *model){
        
        if (model.userName) {
            [_playsBaseDict setObject:model.userName forKey:@"name"];
        }
        
        if (model.mobile) {
            [_playsBaseDict setObject:model.mobile forKey:@"mobile"];
        }
        
        [_playsBaseDict setObject:@"0" forKey:@"userKey"];
        
        if (model.almost) {
            [_playsBaseDict setObject:[NSString stringWithFormat:@"%@", model.almost] forKey:@"almost"];
        }
        
        if ([model.sex integerValue] == 0) {
            [_playsBaseDict setObject:model.sex forKey:@"sex"];
        }else{
            [_playsBaseDict setObject:@1 forKey:@"sex"];
        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        NSArray *indexArray=[NSArray arrayWithObject:indexPath];
        [weakSelf.addTeamPlaysTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    [self.navigationController pushViewController:applyPlaysCtrl animated:YES];
}
#pragma mark -- 添加球友
- (void)selectAddBallPlays:(UIButton *)btn{
    NSLog(@"添加球友");
    [_playsBaseDict removeAllObjects];
    
    [self initPlaysBaseInfo];//初始化打球人信息
    
    JGHAddTeamMemberViewController *addTeamMemberCtrl = [[JGHAddTeamMemberViewController alloc]init];
    addTeamMemberCtrl.userKeyArray = [self returnUserKeyString];
    
    __weak JGHAddIntentionPalyerViewController *weakSelf = self;
    addTeamMemberCtrl.blockFriendModel = ^(MyattenModel *model){
        
        if (model.userName) {
            [_playsBaseDict setObject:model.userName forKey:@"name"];
        }
        
        [_playsBaseDict setObject:@0 forKey:@"userKey"];
        
        if ([model.sex integerValue] == 0) {
            [_playsBaseDict setObject:model.sex forKey:@"sex"];
        }else{
            [_playsBaseDict setObject:@1 forKey:@"sex"];
        }
        
        if (model.almost) {
            [_playsBaseDict setObject:model.almost forKey:@"almost"];
        }
        
        if (model.fMobile) {
            [_playsBaseDict setObject:model.fMobile forKey:@"mobile"];
        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        NSArray *indexArray=[NSArray arrayWithObject:indexPath];
        [weakSelf.addTeamPlaysTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
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
        [_playsBaseDict setObject:textField.text forKey:@"almost"];
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
