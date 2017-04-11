
//
//  VipCardOrderListViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/4/10.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "VipCardOrderListViewController.h"
#import "VipCardOrderListModel.h"
#import "VipCardOrderListTableViewCell.h"
@interface VipCardOrderListViewController ()<UITableViewDelegate,UITableViewDataSource>
/**
 主视图列表
 */
@property(nonatomic, copy)UITableView *mainTableView;
/**
 数据源
 */
@property(nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation VipCardOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - CreateView
-(void)createView{
    [self createTableView];
}
/**
 创建tableView
 */
-(void)createTableView{
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-64)];
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    [mainTableView registerClass:[VipCardOrderListTableViewCell class] forCellReuseIdentifier:@"VipCardOrderListTableViewCellId"];
    [self.view addSubview:mainTableView];
    _mainTableView = mainTableView;
}

#pragma mark - UITableViewDelegate&&DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHvertical(210);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VipCardOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VipCardOrderListTableViewCellId"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

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
