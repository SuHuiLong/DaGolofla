//
//  MyActivityViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/25.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "MyActivityViewController.h"
#import "YueMyBallViewController.h"
#import "MineRewardViewController.h"
#import "MineTeamController.h"
#import "ManageForMeController.h"
@interface MyActivityViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tableView;
    NSArray* _titleArray;
}
@end

@implementation MyActivityViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f];
    
    [self uiConfig];
}
-(void)uiConfig
{
    _titleArray = @[@"我的约球",@"我的球队",@"我的悬赏",@"我的赛事"];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 55*4*ScreenWidth/375)];
    _tableView.bounces = NO;
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55*ScreenWidth/375;
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
    cellid.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cellid.textLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    return cellid;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
    switch (indexPath.row) {
        case 0:{
            YueMyBallViewController* yueVc = [[YueMyBallViewController alloc]init];
            [self.navigationController pushViewController:yueVc animated:YES];
        }
            break;
        case 1:{
            MineTeamController *teamVc = [[MineTeamController alloc]init];
            [self.navigationController pushViewController:teamVc animated:YES];
        }
            break;
        case 2:{
            MineRewardViewController* mineVc = [[MineRewardViewController alloc]init];
            [self.navigationController pushViewController:mineVc animated:YES];
        }
            break;
        case 3:{
            ManageForMeController* yueVc = [[ManageForMeController alloc]init];
            [self.navigationController pushViewController:yueVc animated:YES];
        }
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
