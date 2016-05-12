//
//  JGAddTeamGuestViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGAddTeamGuestViewController.h"
#import "JGAlreadyAddGuestCell.h"

@interface JGAddTeamGuestViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *addTeamGuestTableView;

@end

@implementation JGAddTeamGuestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.navigationItem.title = @"添加嘉宾";
    
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
    
    
    return alreadyGuestCell;
}
#pragma mark -- 添加事件
- (IBAction)addGuestBtnClick:(UIButton *)sender {
    
}
#pragma mark -- 完成按钮事件
- (IBAction)finishBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
