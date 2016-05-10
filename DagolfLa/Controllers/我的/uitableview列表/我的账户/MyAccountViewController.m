//
//  MyAccountViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/28.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "MyAccountViewController.h"
#import "AccountDetailController.h"


@interface MyAccountViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSArray* _titleArray;
}

@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f];
    
    
    
    [self uiConfig];
    
    // [self prepareData];
    
    UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-169*ScreenWidth/375, 14*ScreenWidth/375, 31*ScreenWidth/375, 16*ScreenWidth/375)];
    imgv.image = [UIImage imageNamed:@"yue"];
    [_tableView addSubview:imgv];
    
    UILabel* labelMoney = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-140*ScreenWidth/375, 12*ScreenWidth/375, 100*ScreenWidth/375, 20*ScreenWidth/375)];
    labelMoney.textColor = [UIColor orangeColor];
    labelMoney.text = _strMoney;
    labelMoney.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    labelMoney.textAlignment = NSTextAlignmentCenter;
    [_tableView addSubview:labelMoney];
    
}

-(void)uiConfig
{
    _titleArray = @[@"账户余额",@"账户详情"];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44*2*ScreenWidth/375)];
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
    return 2;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cellid = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    cellid.textLabel.text = _titleArray[indexPath.row];
    cellid.textLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    cellid.selectionStyle = UITableViewCellSelectionStyleNone;
    //    cellid.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 1) {
        cellid.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    return cellid;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        AccountDetailController* accVc = [[AccountDetailController alloc]init];
        accVc.title = @"账目详情";
        accVc.strMoney = _strMoney;
        [self.navigationController pushViewController:accVc animated:YES];
    }
}

@end
