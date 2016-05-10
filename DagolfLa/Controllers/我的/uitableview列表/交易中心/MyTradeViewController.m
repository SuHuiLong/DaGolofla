//
//  MyTradeViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/25.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "MyTradeViewController.h"

#import "ShopCarViewController.h"
#import "MyOrderViewController.h"
#import "CollectViewController.h"
#import "ProFileViewController.h"

@interface MyTradeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSArray* _titleArray;
}

@end

@implementation MyTradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f];
    [self uiConfig];
    
   // [self prepareData];
    
    
}

-(void)uiConfig
{
    _titleArray = @[@"我的购物车",@"我的订单",@"我的收藏",@"收货地址"];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44*4*ScreenWidth/375)];
    _tableView.bounces = NO;
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44*ScreenWidth/375;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cellid = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    cellid.textLabel.text = _titleArray[indexPath.row];
//    cellid.selectionStyle = UITableViewCellSelectionStyleNone;
    cellid.textLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    cellid.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cellid.selectionStyle = UITableViewCellSelectionStyleNone;
    return cellid;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *vcArr = @[@"ShopCarViewController",
                       @"MyOrderViewController",
                       @"CollectViewController",
                       @"ProFileViewController"];
    NSArray *titleArr = @[@"购物车",@"我的订单",@"我的收藏",@"收货地址"];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i<vcArr.count; i++) {
        ViewController *vc = [[NSClassFromString(vcArr[i]) alloc]init];
        //        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
        vc.type = i;
        vc.title = titleArr[i];
        [arr addObject:vc];
    }
    [self.navigationController pushViewController:arr[indexPath.row] animated:YES];

    
    
    
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
