//
//  JGLTeamSignUpMemViewController.m
//  DagolfLa
//
//  Created by Madridlee on 16/10/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLTeamSignUpMemViewController.h"
#import "JGLTeamAdviceTableViewCell.h"
@interface JGLTeamSignUpMemViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tableView;
    NSMutableArray* _dataArray;
}
@end

@implementation JGLTeamSignUpMemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报名成员";
    self.view.backgroundColor = [UITool colorWithHexString:BG_color alpha:1];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    //    _tableView.bounces = NO;
    //    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[JGLTeamAdviceTableViewCell class] forCellReuseIdentifier:@"JGLTeamAdviceTableViewCell"];
}


#pragma mark -- tableview代理方法
//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

//重设分区头的视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44*ScreenWidth/375)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10*ProportionAdapter)];
    backView.backgroundColor = [UITool colorWithHexString:@"eeeeee" alpha:1];
    [headerView addSubview:backView];
    
    UILabel* labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(20*ProportionAdapter, 10*ProportionAdapter, 250*ProportionAdapter, 40*ProportionAdapter)];
    labelTitle.textColor = [UITool colorWithHexString:@"eb6100" alpha:1];
    labelTitle.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    labelTitle.text = @"上海君高高尔夫俱乐部";
    [headerView addSubview:labelTitle];
    
    UILabel* labelNum = [[UILabel alloc]initWithFrame:CGRectMake(270*ProportionAdapter, 10*ProportionAdapter, 100*ProportionAdapter, 40*ProportionAdapter)];
    labelNum.textColor = [UITool colorWithHexString:@"a0a0a0" alpha:1];
    labelNum.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    labelNum.text = @"（07人）";
    [headerView addSubview:labelNum];
    
    UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - 30*ProportionAdapter, 27*ProportionAdapter, 20*ProportionAdapter, 16*ProportionAdapter)];
    imgv.image = [UIImage imageNamed:@")-1"];
    [headerView addSubview:imgv];
    return headerView;
}
#pragma mark -  表开合
- (void)headerButtonClick:(id)sender
{
//    if (![Helper isBlankString:_strBall]) {
        UIButton *button = (UIButton *)sender;
        //根据button 获取区号
        NSInteger section = button.tag;
        //改变BOOL数组中 该区的开合状态
        //    BOOL isOpen = [[_openOrCloses objectAtIndex:section] boolValue];
        //    [_openOrCloses replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!isOpen]];
        _isOpen[section] = !_isOpen[section];
        //刷新表  表的相关代理方法会重新执行
        //    [_tableView reloadData];
        //    NSIndexSet 索引集合 非负整数
        //刷新某些区
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        //刷新某些特定行
        
//    }
//    else
//    {
//        ////NSLog(@"1");
//    }
}



//每个区中有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //如果当前区为打开状态
    if (_isOpen[section])
    {
        //取出字典中的所有值 一个数组中放着三个小数组
//        NSArray *allValues = [_dataArray objectAtIndex:section];
        
        //根据每个区 返回行数
        return 7;
    }
    else//如果不等于当前打开的区号 就是合闭状态 用返回0行来模拟出闭合状态
        return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62 * screenWidth / 375;
}

//显示行
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGLTeamAdviceTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JGLTeamAdviceTableViewCell" forIndexPath:indexPath];
    cell.iconImage.layer.cornerRadius = cell.iconImage.frame.size.width/2;
    cell.iconImage.layer.masksToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.agreeBtn.hidden = YES;
    cell.disMissBtn.hidden = YES;
    cell.stateLabel.hidden = NO;
    cell.timeLabel.hidden = NO;
    cell.stateLabel.textColor = [UITool colorWithHexString:@"#a0a0a0" alpha:1];
    cell.stateLabel.text = @"仍未审核";
    cell.stateLabel.textColor = [UIColor lightGrayColor];
    return cell;
}



//返回各个分区的头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44*ScreenWidth/375;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

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
