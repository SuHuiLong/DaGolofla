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

{
    NSInteger _iscatoryVlaue;//类型值0:嘉宾  1:球队队员 2: 球场会员记名  3: 球场会员不记名
}

@property (nonatomic, strong) UITableView *addTeamGuestTableView;

@property (nonatomic, assign)NSInteger sex;//0-1女，1-男，默认男－1

//@property (nonatomic, assign)NSInteger isPlaysCatory;//

@property (nonatomic, strong)UIView *catoryView;//类型列表

@end

@implementation JGAddTeamGuestViewController

- (UIView *)catoryView{
    if (_catoryView == nil) {
        self.catoryView = [[UIView alloc]init];
        self.catoryView.backgroundColor = [UIColor whiteColor];
        _catoryView.frame = CGRectMake(_catoryBtn.frame.origin.x, _catoryBtn.frame.origin.y, _catoryBtn.frame.size.width + 50, _catoryArray.count * 44);
        for (int i=0; i<_catoryArray.count; i++) {
            UIButton *catoryBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 44*i, _catoryBtn.frame.size.width+50, 44)];
            catoryBtn.tag = 200 + i;
            catoryBtn.backgroundColor = [UIColor whiteColor];
            [catoryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            catoryBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [catoryBtn setTitle:[[_catoryArray[i] componentsSeparatedByString:@"-"]objectAtIndex:1] forState:UIControlStateNormal];
            [catoryBtn addTarget:self action:@selector(catoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_catoryView addSubview:catoryBtn];
        }
        
        [self.view addSubview:self.catoryView];
    }
    return _catoryView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"添加打球人";
    _iscatoryVlaue = 0;
    self.catoryName.text = @"普通嘉宾资费";
    self.addGuestBtn.layer.borderWidth = 1.0;
    self.addGuestBtn.layer.borderColor = [UIColor colorWithHexString:@"#7DDFFD"].CGColor;
    self.addGuestBtn.layer.masksToBounds = YES;
    
    self.sex = 1;//男－默认
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(hideCatoryView:)];
    [self.view addGestureRecognizer:tap];
    
    [self createAddGuestTableview];
}

#pragma mark -- 手势
- (void)hideCatoryView:(UITapGestureRecognizer *)tap{
    self.catoryView.hidden = YES;
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
    
    [applyDict setObject:[NSString stringWithFormat:@"%td", _iscatoryVlaue] forKey:@"type"];
    //payMoney
    [applyDict setObject:[[_catoryArray[_iscatoryVlaue] componentsSeparatedByString:@"-"] objectAtIndex:0] forKey:@"payMoney"];
    
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
#pragma mark -- 选择资费
- (IBAction)catoryBtn:(UIButton *)sender {
    
    self.catoryView.hidden = NO;
    self.catoryImageView.image = [UIImage imageNamed:@")-1"];
    
}

#pragma mark -- 类型选择事件
- (void)catoryBtnClick:(UIButton *)btn{
    NSLog(@"%@", btn.currentTitle);
    _iscatoryVlaue = btn.tag - 200;
    self.catoryName.text = btn.currentTitle;
    self.catoryView.hidden = YES;
}




@end
