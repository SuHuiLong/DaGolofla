//
//  SelectRedPacketViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/6/8.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "SelectRedPacketViewController.h"
#import "RedPacketTableViewCell.h"
#import "RedPacketModel.h"

@interface SelectRedPacketViewController ()<UITableViewDelegate,UITableViewDataSource>
//主视图
@property (nonatomic, strong) UITableView *mainTableView;
@end

@implementation SelectRedPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Back_Color;
    // Do any additional setup after loading the view.
}
#pragma mark - CreateView
-(void)createView{
    [self createNavigationView];
    [self createTableView];
}
//导航
-(void)createNavigationView{
    self.title = @"我的红包";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
//主视图
-(void)createTableView{
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) style:UITableViewStyleGrouped];
    mainTableView.backgroundColor = Back_Color;
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [mainTableView registerClass:[RedPacketTableViewCell class] forCellReuseIdentifier:@"RedPacketTableViewCellID"];
    [self.view addSubview:mainTableView];
    _mainTableView = mainTableView;
}

#pragma mark - Action
//返回
-(void)backButtonClcik{
    [self.navigationController popViewControllerAnimated:YES];
}
//不使用红包
-(void)unUseBtnClick{
    RedPacketModel *model = [[RedPacketModel alloc] init];
    if (_selectModelBlock) {
        _selectModelBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark - UITableviewDelegate&&Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_dataArray.count==0) {
        return screenHeight - 64;
    }
    return kHvertical(50);
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHvertical(136);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RedPacketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RedPacketTableViewCellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RedPacketModel *model = self.dataArray[indexPath.row];
    [cell configSelectModel:model selectModel:_selectModel];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [Factory createViewWithBackgroundColor:Back_Color frame:CGRectMake(0, 0, screenWidth, kHvertical(33))];
    //图标
    NSString *imageName = @"icon_unselect_lucky";
    if (1) {
        imageName = @"icon_select_lucky";
    }
    UIImageView *iconView = [Factory createImageViewWithFrame:CGRectMake(kWvertical(11), kHvertical(17), kHvertical(21), kHvertical(21)) Image:[UIImage imageNamed:@"icon_unselect_lucky"]];
    if (_selectModel.timeKey==nil) {
        [iconView setImage:[UIImage imageNamed:@"icon_select_lucky"]];
    }
    [headerView addSubview:iconView];
    //红包说明
    UILabel *descLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(55), kHvertical(17), kWvertical(90), kHvertical(21)) textColor:RGB(49,49,49) fontSize:kHorizontal(15) Title:@"不使用红包"];
    [headerView addSubview:descLabel];
    //添加点击事件
    UIButton *unUseBtn = [Factory createButtonWithFrame:CGRectMake(0, 0, kWvertical(100), kHvertical(33)) target:self selector:@selector(unUseBtnClick) Title:nil];
    unUseBtn.backgroundColor = ClearColor;
    [headerView addSubview:unUseBtn];

    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RedPacketModel *model = _dataArray[indexPath.row];
    if (_selectModelBlock) {
        _selectModelBlock(model);
    }
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
