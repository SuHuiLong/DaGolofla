//
//  JGHAddTeamPlaysViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHAddTeamPlaysViewController.h"
#import "JGHHeaderLabelCell.h"
#import "JGHAddPlaysCell.h"
#import "JGHAddPlaysButtonCell.h"
#import "JGHPlayBaseInfoCell.h"
#import "JGHPalyTypeListCell.h"
#import "JGPlayPayBaseCell.h"
#import "JGHAddressBookPlaysViewController.h"
#import "JGHAddTeamMemberViewController.h"
#import "JGHAddApplyTeamPlaysViewController.h"

static NSString *const JGHHeaderLabelCellIdentifier = @"JGHHeaderLabelCell";
static NSString *const JGHAddPlaysCellIdentifier = @"JGHAddPlaysCell";
static NSString *const JGHAddPlaysButtonCellIdentifier = @"JGHAddPlaysButtonCell";
static NSString *const JGHPlayBaseInfoCellIdentifier = @"JGHPlayBaseInfoCell";
static NSString *const JGHPalyTypeListCellIdentifier = @"JGHPalyTypeListCell";
static NSString *const JGPlayPayBaseCellIdentifier = @"JGPlayPayBaseCell";

@interface JGHAddTeamPlaysViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, JGHAddPlaysCellDelegate, JGHAddPlaysButtonCellDelegate, JGHPlayBaseInfoCellDelegate, JGHPalyTypeListCellDelegate, JGPlayPayBaseCellDelegate>

{
    NSMutableDictionary *_playsBaseDict;
}

@property (strong, nonatomic)UITableView *addTeamPlaysTableView;





@end

@implementation JGHAddTeamPlaysViewController

- (instancetype)init{
    if (self == [super init]) {
//        self.playListArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"添加打球人";
    _playsBaseDict = [NSMutableDictionary dictionary];
    [self initPlaysBaseInfo];
    
    [self createAddTeamPlaysTableView];
}
#pragma mark -- 初始化报名人信息
- (void)initPlaysBaseInfo{
    [_playsBaseDict setObject:@0 forKey:@"sex"];//默认性别女-0
    NSMutableDictionary *costDict = [NSMutableDictionary dictionary];
    costDict = [_costListArray objectAtIndex:0];
    
    [_playsBaseDict setObject:[costDict objectForKey:@"costType"] forKey:@"type"];//默认资费类型
    [_playsBaseDict setObject:[costDict objectForKey:@"money"] forKey:@"money"];//默认资费价格
    
    for (int i=0; i<_costListArray.count; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict = [NSMutableDictionary dictionaryWithDictionary:_costListArray[i]];
        if (i == 0) {
            [dict setObject:@1 forKey:@"select"];
        }else{
            [dict setObject:@0 forKey:@"select"];
        }
        
        [_costListArray replaceObjectAtIndex:i withObject:dict];
    }
}
- (void)createAddTeamPlaysTableView{
    self.addTeamPlaysTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    UINib *addPlaysCellNib = [UINib nibWithNibName:@"JGHAddPlaysCell" bundle: [NSBundle mainBundle]];
    [self.addTeamPlaysTableView registerNib:addPlaysCellNib forCellReuseIdentifier:JGHAddPlaysCellIdentifier];
    
    UINib *headerLabelCellNib = [UINib nibWithNibName:@"JGHHeaderLabelCell" bundle: [NSBundle mainBundle]];
    [self.addTeamPlaysTableView registerNib:headerLabelCellNib forCellReuseIdentifier:JGHHeaderLabelCellIdentifier];
    
    UINib *addPlaysButtonCellNib = [UINib nibWithNibName:@"JGHAddPlaysButtonCell" bundle: [NSBundle mainBundle]];
    [self.addTeamPlaysTableView registerNib:addPlaysButtonCellNib forCellReuseIdentifier:JGHAddPlaysButtonCellIdentifier];
    
    UINib *playBaseInfoCellNib = [UINib nibWithNibName:@"JGHPlayBaseInfoCell" bundle: [NSBundle mainBundle]];
    [self.addTeamPlaysTableView registerNib:playBaseInfoCellNib forCellReuseIdentifier:JGHPlayBaseInfoCellIdentifier];
    
    UINib *palyTypeListCellNib = [UINib nibWithNibName:@"JGHPalyTypeListCell" bundle: [NSBundle mainBundle]];
    [self.addTeamPlaysTableView registerNib:palyTypeListCellNib forCellReuseIdentifier:JGHPalyTypeListCellIdentifier];
    
    UINib *playPayBaseCellNib = [UINib nibWithNibName:@"JGPlayPayBaseCell" bundle: [NSBundle mainBundle]];
    [self.addTeamPlaysTableView registerNib:playPayBaseCellNib forCellReuseIdentifier:JGPlayPayBaseCellIdentifier];
    
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
    }else if (section == 2){
        return _costListArray.count;//参赛费用列表
    }else if (section == 4){
        return _playListArray.count;//报名人列表
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;//详情页面
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 100 *ProportionAdapter;
    }else if (indexPath.section == 2 || indexPath.section == 4){
        return 30 *ProportionAdapter;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1 || section == 2) {
        return 1;
    }else if (section == 4){
        return 0;
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
    }else if (indexPath.section == 2){
        JGHPalyTypeListCell *playBaseInfoCell = [tableView dequeueReusableCellWithIdentifier:JGHPalyTypeListCellIdentifier];
        playBaseInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        playBaseInfoCell.delegate = self;
        playBaseInfoCell.selectBtn.tag = indexPath.row + 100;
        
        [playBaseInfoCell configJGHPalyTypeListCell:_costListArray[indexPath.row]];
        return playBaseInfoCell;
    }else{
        JGPlayPayBaseCell *playPayBaseCell = [tableView dequeueReusableCellWithIdentifier:JGPlayPayBaseCellIdentifier];
        playPayBaseCell.selectionStyle = UITableViewCellSelectionStyleNone;
        playPayBaseCell.delegate = self;
        playPayBaseCell.deletePalyBtn.tag = indexPath.row + 1000;
        [playPayBaseCell configJGPlayPayBaseCell:_playListArray[indexPath.row]];
        return playPayBaseCell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        NSLog(@"选择资费类型 == %td", indexPath.row);
        [self selectPalysTypeList:indexPath.row];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        JGHAddPlaysCell *addPlaysCell = [tableView dequeueReusableCellWithIdentifier:JGHAddPlaysCellIdentifier];
        addPlaysCell.delegate = self;
        return (UIView *)addPlaysCell;
    }else if (section == 1) {
        JGHHeaderLabelCell *headerCell = [tableView dequeueReusableCellWithIdentifier:JGHHeaderLabelCellIdentifier];
        [headerCell congiftitles:@"基本信息"];
        return (UIView *)headerCell;
    }else if (section == 2){
        JGHHeaderLabelCell *headerCell = [tableView dequeueReusableCellWithIdentifier:JGHHeaderLabelCellIdentifier];
        [headerCell congiftitles:@"请根据实际情况选择付费方式"];
        return (UIView *)headerCell;
    }else if (section == 3){
        JGHAddPlaysButtonCell *addPlaysButtonCell = [tableView dequeueReusableCellWithIdentifier:JGHAddPlaysButtonCellIdentifier];
        addPlaysButtonCell.delegate = self;
        return (UIView *)addPlaysButtonCell;
    }else {
        JGHHeaderLabelCell *headerCell = [tableView dequeueReusableCellWithIdentifier:JGHHeaderLabelCellIdentifier];
        [headerCell congiftitles:@"已添加打球人"];
        return (UIView *)headerCell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10*ProportionAdapter)];
    footView.backgroundColor = [UIColor colorWithHexString:BG_color];
    return footView;
}

#pragma mark -- 添加队员
- (void)selectAddPlays:(UIButton *)btn{
    NSLog(@"添加队员");
    JGHAddApplyTeamPlaysViewController *applyPlaysCtrl = [[JGHAddApplyTeamPlaysViewController alloc]init];
    applyPlaysCtrl.teamKey = _teamKey;
    applyPlaysCtrl.activityKey = _activityKey;
    [self.navigationController pushViewController:applyPlaysCtrl animated:YES];
}
#pragma mark -- 添加球友
- (void)selectAddBallPlays:(UIButton *)btn{
    NSLog(@"添加球友");
    JGHAddTeamMemberViewController *addTeamMemberCtrl = [[JGHAddTeamMemberViewController alloc]init];
    
    [self.navigationController pushViewController:addTeamMemberCtrl animated:YES];
}
#pragma mark -- 添加联系人
- (void)selectAddContactPlays:(UIButton *)btn{
    NSLog(@"添加联系人");
    [_playsBaseDict removeAllObjects];
    
    [self initPlaysBaseInfo];//初始化打球人信息
    
    JGHAddressBookPlaysViewController *addressBookCtrl = [[JGHAddressBookPlaysViewController alloc]init];
    
    [self.navigationController pushViewController:addressBookCtrl animated:YES];
}
#pragma mark -- 立即添加--资费类型
- (void)addPlaysButtonCellClick:(UIButton *)btn{
    NSLog(@"立即添加--资费类型");
    [self.view endEditing:YES];
    if (![_playsBaseDict objectForKey:@"name"]) {
        [[ShowHUD showHUD]showToastWithText:@"请输入姓名！" FromView:self.view];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:_playsBaseDict];
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
#pragma mark -- 选择用户资费类型
- (void)selectPalysTypeListBtnClick:(UIButton *)btn{
    NSLog(@"资费类型 == %ld", (long)btn.tag);
    [self selectPalysTypeList:btn.tag -100];
}
- (void)selectPalysTypeList:(NSInteger)listId{
    NSInteger cellid = 0;
    for (int i=0; i<_costListArray.count; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict = [NSMutableDictionary dictionaryWithDictionary:_costListArray[i]];
        if ([[dict objectForKey:@"select"] integerValue] == 1) {
            cellid = i;
        }
        
        if (i == listId) {
            [dict setObject:@1 forKey:@"select"];
            [_playsBaseDict setObject:@(listId) forKey:@"type"];
            [_playsBaseDict setObject:[dict objectForKey:@"money"] forKey:@"money"];
        }else{
            [dict setObject:@0 forKey:@"select"];
        }
        
        [_costListArray replaceObjectAtIndex:i withObject:dict];
    }
    
    [_playsBaseDict setObject:@(listId) forKey:@"type"];
    NSArray *indexArray = [NSArray array];
    if (listId == cellid) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellid inSection:2];
        indexArray=[NSArray arrayWithObject:indexPath];
    }else{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellid inSection:2];
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:listId inSection:2];
        indexArray=[NSArray arrayWithObjects:indexPath, indexPath1, nil];
    }
    
    [self.addTeamPlaysTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark -- 删除打球人
- (void)deletePalyBaseBtn:(UIButton *)btn{
    NSLog(@" 删除打球人 == %ld", (long)btn.tag);
    [_playListArray removeObjectAtIndex:btn.tag];
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
