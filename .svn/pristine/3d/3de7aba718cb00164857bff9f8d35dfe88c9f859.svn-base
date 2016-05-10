//
//  AccountDetailController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/28.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "AccountDetailController.h"


@interface AccountDetailController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _dataArray;
}
@end

@implementation AccountDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"账目详情";
    
    [self createTableView];
    [self createHeaderView];
}

-(void)createHeaderView
{
    UIView* viewHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 150*ScreenWidth/375)];
    _tableView.tableHeaderView = viewHead;
    
    
    UILabel* labelTit = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 0, 70*ScreenWidth/375, 50*ScreenWidth/375)];
    labelTit.text = @"账户金额:";
    labelTit.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [viewHead addSubview:labelTit];
    
    UILabel* labelJin = [[UILabel alloc]initWithFrame:CGRectMake(80*ScreenWidth/375, 0, 200*ScreenWidth/375, 50*ScreenWidth/375)];
    labelJin.text = _strMoney;
    labelJin.textColor = [UIColor orangeColor];
    labelJin.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [viewHead addSubview:labelJin];
    
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, 49*ScreenWidth/375, ScreenWidth, 1*ScreenWidth/375)];
    line.backgroundColor = [UIColor lightGrayColor];
    [viewHead addSubview:line];
    
    
    
    UIButton* btnDate = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewHead addSubview:btnDate];
    btnDate.frame = CGRectMake(0, 50*ScreenWidth/375, 100*ScreenWidth/375, 100*ScreenWidth/375);
    
    
}
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
