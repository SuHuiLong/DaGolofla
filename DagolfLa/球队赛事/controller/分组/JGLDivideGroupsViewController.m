//
//  JGLDivideGroupsViewController.m
//  DagolfLa
//
//  Created by Madridlee on 16/10/10.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLDivideGroupsViewController.h"

@interface JGLDivideGroupsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tableView;
    UILabel* _labelTitle, *_labelDetile;//分区头
    UIButton* _button;//分区头
}
@end

@implementation JGLDivideGroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分组";
    self.view.backgroundColor = [UITool colorWithHexString:BG_color alpha:1];
    
    [self uiConfig];
//    [self setSectionHeader];
}
/*
 
 */
-(void)uiConfig{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    //    _tableView.bounces = NO;
    //    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView* viewHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 85*ProportionAdapter)];
    
    
    _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 10*ProportionAdapter, screenWidth, 20*ProportionAdapter)];
    _labelTitle.font = [UIFont systemFontOfSize:18*ProportionAdapter];
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    _labelTitle.textColor = [UITool colorWithHexString:@"4da9ff" alpha:1];
    _labelTitle.text = @"第一轮";
    [viewHead addSubview:_labelTitle];
    
    _labelDetile = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 55*ProportionAdapter, 100*ProportionAdapter, 20*ProportionAdapter)];
    _labelDetile.text = @"分组详情";
    _labelDetile.textColor = [UITool colorWithHexString:@"313131" alpha:1];
    [viewHead addSubview:_labelDetile];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(screenWidth-140*ProportionAdapter, 50*ProportionAdapter, 130*ProportionAdapter, 27*ProportionAdapter);
    [_button setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    [viewHead addSubview:_button];
    return viewHead;
}


//每个区中有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44 * screenWidth / 375;
}

//显示行
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



//返回各个分区的头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 85*ScreenWidth/375;
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
