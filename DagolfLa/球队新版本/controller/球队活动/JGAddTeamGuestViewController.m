//
//  JGAddTeamGuestViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGAddTeamGuestViewController.h"
#import "JGAlreadyAddGuestCell.h"

@interface JGAddTeamGuestViewController ()<UITableViewDelegate, UITableViewDataSource, JGAlreadyAddGuestCellDelegate>

@property (nonatomic, strong) UITableView *addTeamGuestTableView;

@property (nonatomic, assign)NSInteger sex;//0-1女，1-男，默认男－1

@property (nonatomic, assign)NSInteger isPlays;//0-不是，1-是，默认是

@end

@implementation JGAddTeamGuestViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"添加打球人";
    
    self.addGuestBtn.layer.borderWidth = 1.0;
    self.addGuestBtn.layer.borderColor = [UIColor colorWithHexString:@"#7DDFFD"].CGColor;
    self.addGuestBtn.layer.masksToBounds = YES;
    
    self.sex = 1;//男－默认
    self.isPlays = 1;
        
    [self createAddGuestTableview];
}
#pragma mark --创建tableView
- (void)createAddGuestTableview{
    self.addTeamGuestTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.alrealyAddGuestLabel.frame.origin.y + self.alrealyAddGuestLabel.frame.size.height + 3, screenWidth, screenHeight - (self.alrealyAddGuestLabel.frame.origin.y + self.alrealyAddGuestLabel.frame.size.height + 3 )-64-44) style:UITableViewStyleGrouped];
    self.addTeamGuestTableView.delegate = self;
    self.addTeamGuestTableView.dataSource = self;
    self.addTeamGuestTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.addTeamGuestTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _applyArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * JGAlreadyAddGuestCellID = @"JGAlreadyAddGuestCell";
    JGAlreadyAddGuestCell *alreadyGuestCell = [tableView dequeueReusableCellWithIdentifier:JGAlreadyAddGuestCellID];
    if (alreadyGuestCell == nil) {
        alreadyGuestCell = [[[NSBundle mainBundle]loadNibNamed:@"JGAlreadyAddGuestCell" owner:self options:nil]lastObject];
    }
    
    alreadyGuestCell.selectionStyle = UITableViewCellSelectionStyleNone;
    alreadyGuestCell.deleteGuest.tag = indexPath.section + 100;
    alreadyGuestCell.delegate = self;
    [alreadyGuestCell configDict:self.applyArray[indexPath.section]];
    
    return alreadyGuestCell;
}
#pragma mark -- 添加按钮事件
- (IBAction)addGuestBtnClick:(UIButton *)sender {
    [self.nameText resignFirstResponder];
    [self.poorPointText resignFirstResponder];
    [self.photoNumber resignFirstResponder];
    
    NSString *namestring = self.nameText.text;
    namestring = [namestring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"%@", namestring);
    if (namestring.length == 0) {
        [[ShowHUD showHUD]showToastWithText:@"姓名不能为空或者空格！" FromView:self.view];
        return;
    }
    
    NSMutableDictionary *applyDict = [NSMutableDictionary dictionary];
    [applyDict setObject:[NSString stringWithFormat:@"%ld", (long)_isPlays] forKey:@"type"];//"是否是球队成员 0: 不是  1：是
    if (_isPlays == 0) {
        //嘉宾
        [applyDict setObject:[NSString stringWithFormat:@"%.2f", self.guestPrice] forKey:@"payMoney"];//实际付款金额
    }else{
        //队员
        [applyDict setObject:[NSString stringWithFormat:@"%.2f", self.memberPrice] forKey:@"payMoney"];//实际付款金额
    }
    
    [applyDict setObject:@0 forKey:@"userKey"];//报名用户key , 没有则是嘉宾
    
    [applyDict setObject:_nameText.text forKey:@"name"];//姓名
    if (_photoNumber.text.length>0) {
        [applyDict setObject:_photoNumber.text forKey:@"mobile"];//手机号
    }
    
    if (_poorPointText.text.length>0) {
        [applyDict setObject:_poorPointText.text forKey:@"almost"];//差点
    }
    
    [applyDict setObject:@1 forKey:@"isOnlinePay"];//是否线上付款 1-线上
    [applyDict setObject:[NSString stringWithFormat:@"%ld", (long)self.sex] forKey:@"sex"];//性别 0: 女 1: 男
    [applyDict setObject:@0 forKey:@"signUpInfoKey"];//报名信息的timeKey
    [applyDict setObject:@0 forKey:@"timeKey"];//timeKey
    [applyDict setObject:@"1" forKey:@"select"];//付款勾选默认勾
    
    [self.applyArray addObject:applyDict];
    [[ShowHUD showHUD]showToastWithText:@"添加成功！" FromView:self.view];
    
    [self.addTeamGuestTableView reloadData];
    self.nameText.text = nil;
    self.poorPointText.text = nil;
    self.photoNumber.text = nil;
    
}
#pragma mark -- 完成按钮事件
- (IBAction)finishBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate addGuestListArray:self.applyArray];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark -- 男
- (IBAction)manBtn:(UIButton *)sender {
    self.sex = 1;
    [self.manBtn setImage:[UIImage imageNamed:@"gou_x"] forState:UIControlStateNormal];
    [self.womenBtn setImage:[UIImage imageNamed:@"xuan_w"] forState:UIControlStateNormal];
}
#pragma mark -- 女
- (IBAction)womenBtn:(UIButton *)sender {
    self.sex = 0;
    [self.womenBtn setImage:[UIImage imageNamed:@"gou_x"] forState:UIControlStateNormal];
    [self.manBtn setImage:[UIImage imageNamed:@"xuan_w"] forState:UIControlStateNormal];
}
#pragma mark -- 删除好友 －－ JGAlreadyAddGuestCellDelegate
- (void)didSelecctDeleteGuestId:(NSInteger)guesId{
    NSLog(@"删除好友");
    [self.applyArray removeObjectAtIndex:guesId];
    [self.addTeamGuestTableView reloadData];
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
#pragma mark -- 是否是球队成员
- (IBAction)isPlayersBtn:(UIButton *)sender {
    if (self.isPlays == 1) {
        self.isPlays = 0;
        [self.isPlayersBtn setImage:[UIImage imageNamed:@"kuang"] forState:UIControlStateNormal];
    }else{
        self.isPlays = 1;
        [self.isPlayersBtn setImage:[UIImage imageNamed:@"kuang_xz"] forState:UIControlStateNormal];
    }
    
    NSLog(@"是否是球员＝＝%ld", (long)self.isPlays);
}
@end
