//
//  JGLDrawalRecordViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/7.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLDrawalRecordViewController.h"
#import "JGLDrawalRewardTableViewCell.h"
@interface JGLDrawalRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tableView;
    NSMutableArray* _dataArray;
}
@end

@implementation JGLDrawalRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提现记录";
    _dataArray = [[NSMutableArray alloc]init];
    [self uiConfig];
    
}

-(void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 45*6*ScreenWidth/375 + 30*ScreenWidth/375) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[JGLDrawalRewardTableViewCell class] forCellReuseIdentifier:@"JGLDrawalRewardTableViewCell"];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10*ScreenWidth/320;
}

//指定有多少个分区(Section)，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70*ScreenWidth/320;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JGLDrawalRewardTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLDrawalRewardTableViewCell" forIndexPath:indexPath];
    cell.labelName.text   = @"提现人：罗小安";
    cell.labelAccept.text = @"收款人：罗大安";
    cell.labelTime.text   = @"2015年5月21日 09：55";
    cell.labelMoney.text  = @"1800元";
    cell.labelDetail.text = @"备注信息：这笔钱用于球场遇到过呢和啪啪啪。。。设呢";
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
