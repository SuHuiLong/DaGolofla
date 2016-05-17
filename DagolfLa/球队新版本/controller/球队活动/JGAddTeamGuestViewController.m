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

@end

@implementation JGAddTeamGuestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"添加嘉宾";
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
    
    if (self.poorPointText.text.length == 0) {
        self.poorPointText.layer.borderColor=[[UIColor redColor] CGColor];
        self.poorPointText.layer.borderWidth= 1.0f;
        return;
    }
    
    
}
#pragma mark -- 完成按钮事件
- (IBAction)finishBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

@end
