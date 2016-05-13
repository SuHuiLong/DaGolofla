//
//  JGLMyTeamViewController.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLMyTeamViewController.h"
#import "JGTeamChannelTableView.h"
#import "JGTeamChannelTableViewCell.h"
@interface JGLMyTeamViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    JGTeamChannelTableView* _tableView;
    
    NSMutableArray* _dataArray;
}
@end

@implementation JGLMyTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray arrayWithObjects:@"qwer",@"werq",@"asdfsdfs", nil];
    
    self.title = @"我的球队";
    [self uiConfig];
    
    
}

-(void) uiConfig
{
    _tableView = [[JGTeamChannelTableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellAccessoryNone;
    _tableView.rowHeight = 83 * screenWidth / 320;
    [self.view addSubview:_tableView];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        JGTeamChannelTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.nameLabel.text = _dataArray[indexPath.row%3];
        cell.adressLabel.text = @"测试数据 Test";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

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
