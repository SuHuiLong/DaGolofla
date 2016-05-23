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

#import "JGTeamDetailStylelTwoViewController.h"

#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"
#import "JGTeamDetail.h"


#import "JGLMyTeamModel.h"
@interface JGLMyTeamViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    JGTeamChannelTableView* _tableView;
    
    NSMutableArray* _dataArray;
    NSInteger _page;
}
@end

@implementation JGLMyTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 0;
    _dataArray = [[NSMutableArray alloc]init];
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
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    [_tableView.header beginRefreshing];
}


#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
    [dict setObject:[NSNumber numberWithInt:page] forKey:@"offset"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getMyTeamList" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            if (page == 0)
            {
                //清除数组数据
                [_dataArray removeAllObjects];
            }
            //数据解析
            for (NSDictionary *dataDic in [data objectForKey:@"teamList"]) {
                JGLMyTeamModel *model = [[JGLMyTeamModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDic];
                [_dataArray addObject:model];
            }
            _page++;
            [_tableView reloadData];
        }else {
            [Helper alertViewWithTitle:@"失败" withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
        [_tableView reloadData];
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    }];
}

#pragma mark 开始进入刷新状态
- (void)headRereshing
{
    _page = 0;
    [self downLoadData:_page isReshing:YES];
}

- (void)footRereshing
{
    [self downLoadData:_page isReshing:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGTeamChannelTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"cell"];
//        cell.nameLabel.text = _dataArray[indexPath.row%3];
    [cell showData:_dataArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@244 forKey:@"userKey"];
    JGLMyTeamModel *model = _dataArray[indexPath.row];
    [dic setObject: model.teamKey forKey:@"teamKey"];
    
    [[JsonHttp jsonHttp] httpRequest:@"team/getTeamInfo" JsonKey:nil withData:dic requestMethod:@"POST" failedBlock:^(id errType) {
        NSLog(@"getTeamInfo ******** %@", errType);
    } completionBlock:^(id data) {
        
        JGTeamDetailStylelTwoViewController *detailVC = [[JGTeamDetailStylelTwoViewController alloc] init];
        NSDictionary *dataDic = [data objectForKey:@"team"];
        detailVC.detailDic = dataDic;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }];
    
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
