//
//  TeamDetailViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/14.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "TeamDetailViewController.h"

@interface TeamDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSArray* _dataArray;
}
@end

@implementation TeamDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _strTitle;
    
    [self uiConfig];
    [self createBtn];

}
-(void)createBtn
{
    UIButton* btnQuit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnQuit.backgroundColor = [UIColor orangeColor];
    btnQuit.frame = CGRectMake(10*ScreenWidth/375, 230*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 44*ScreenWidth/375);
    btnQuit.layer.cornerRadius = 10;
    btnQuit.layer.masksToBounds = YES;
    [self.view addSubview:btnQuit];
    [btnQuit setTitle:@"退出球队" forState:UIControlStateNormal];
    [btnQuit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btnQuit addTarget:self action:@selector(quitClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)quitClick
{
    
}

-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 220*ScreenWidth/375) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
    
    
    _dataArray = [[NSArray alloc]init];
    _dataArray = @[@"球队成员",@"球队活动",@"球队信息",@"入会申请审批",@"邀请新成员"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44*ScreenWidth/375;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}




@end
