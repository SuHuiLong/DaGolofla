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

//@property (nonatomic, strong)NSMutableDictionary *guextDict;//成员字典

@property (nonatomic, assign)NSInteger sex;//0-1女，1-男，默认男－1

@end

@implementation JGAddTeamGuestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.guestArray = [NSMutableArray array];
    self.navigationItem.title = @"添加地球人";
    self.applyArray = [NSMutableArray array];
    self.sex = 1;//男－默认
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
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * JGAlreadyAddGuestCellID = @"JGAlreadyAddGuestCell";
    JGAlreadyAddGuestCell *alreadyGuestCell = [tableView dequeueReusableCellWithIdentifier:JGAlreadyAddGuestCellID];
    if (alreadyGuestCell == nil) {
        alreadyGuestCell = [[[NSBundle mainBundle]loadNibNamed:@"JGAlreadyAddGuestCell" owner:self options:nil]lastObject];
    }
    
    alreadyGuestCell.selectionStyle = UITableViewCellSelectionStyleNone;
    alreadyGuestCell.deleteGuest.tag = indexPath.section + 100;
    
    
    
    return alreadyGuestCell;
}
#pragma mark -- 添加按钮事件
- (IBAction)addGuestBtnClick:(UIButton *)sender {
    if (self.nameText.text.length == 0) {
        self.nameText.layer.borderColor = [UIColor redColor].CGColor;
        self.nameText.layer.borderWidth= 1.0f;
        return;
    }
    
    NSMutableDictionary *applyDict = [NSMutableDictionary dictionary];
    [applyDict setObject:@"192" forKey:@"teamKey"];//球队key
    [applyDict setObject:@"206" forKey:@"activityKey"];//球队活动id
    [applyDict setObject:@244 forKey:@"userKey"];//报名用户key , 没有则是嘉宾
    [applyDict setObject:@1 forKey:@"type"];//"是否是球队成员 0: 不是  1：是

    [applyDict setObject:@0 forKey:@"userKey"];//报名用户key , 没有则是嘉宾
    [applyDict setObject:@0 forKey:@"type"];
    
    [applyDict setObject:_nameText.text forKey:@"name"];//姓名
    if (_photoNumber.text.length>0) {
        [applyDict setObject:_photoNumber.text forKey:@"mobile"];//手机号
    }
    
    if (_poorPointText.text.length>0) {
        [applyDict setObject:_poorPointText.text forKey:@"almost"];//差点
    }
    
    [applyDict setObject:@"1" forKey:@"isOnlinePay"];//是否线上付款 1-线上
    [applyDict setObject:[NSString stringWithFormat:@"%ld", (long)self.sex] forKey:@"sex"];//性别 0: 女 1: 男
    //        [dict setObject:@"192" forKey:@"groupIndex"];//组的索引   每组4 人
    //        [dict setObject:@"192" forKey:@"sortIndex"];//排序索引号
    //        [dict setObject:@"192" forKey:@"payMoney"];//实际付款金额
    //        [dict setObject:@"192" forKey:@"payTime"];//实际付款时间
    //        [dict setObject:@"192" forKey:@"subsidyPrice"];//补贴价
    //        [dict setObject:@"3500" forKey:@"money"];//报名费
//    [self.guextDict setObject:@"2016-06-11 10:00:00" forKey:@"createTime"];//报名时间
    [applyDict setObject:@0 forKey:@"signUpInfoKey"];//报名信息的timeKey
    [applyDict setObject:@0 forKey:@"timeKey"];//timeKey
    [applyDict setObject:@"1" forKey:@"select"];//付款勾选默认勾
    
    [self.guestArray addObject:applyDict];
//    NSMutableDictionary *applyDict = [NSMutableDictionary dictionary];
//    [applyDict setObject:self.teamKey forKey:@"teamKey"];//球队key
//    [applyDict setObject:self.activityKey forKey:@"activityKey"];//活动ID
    
}
#pragma mark -- 完成按钮事件
- (IBAction)finishBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate addGuestListArray:self.guestArray];
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

- (IBAction)isPlayersBtn:(UIButton *)sender {
}
@end
