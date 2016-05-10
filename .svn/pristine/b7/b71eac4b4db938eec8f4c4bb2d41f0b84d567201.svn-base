//
//  ActiveNumViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/7.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ActiveNumViewController.h"
#import "ZanNumTableViewCell.h"

#import "PostDataRequest.h"
#import "Helper.h"
#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"

#import "TeamPeopleModel.h"

@interface ActiveNumViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSArray* _arrayNum;
    
    NSMutableArray* _dataArray;
    NSInteger _page;
}
@end

@implementation ActiveNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"活动成员";
    _page = 1;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"ZanNumTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZanNumTableViewCell"];
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    [_tableView.header beginRefreshing];
}




#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    
    [[PostDataRequest sharedInstance] postDataRequest:@"tTeamApply/queryPage.do" parameter:@{@"teamId":@3,@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"page":[NSNumber numberWithInt:page],@"rows":@10,@"applyType":@11} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (page == 1)[_dataArray removeAllObjects];
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                TeamPeopleModel *model = [[TeamPeopleModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                [_dataArray addObject:model];
            }
            _page++;
            [_tableView reloadData];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        [_tableView reloadData];
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    } failed:^(NSError *error) {
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
    _page = 1;
    [self downLoadData:_page isReshing:YES];
}

- (void)footRereshing
{
    [self downLoadData:_page isReshing:NO];
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44*ScreenWidth/320;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZanNumTableViewCell* cellid = [tableView dequeueReusableCellWithIdentifier:@"ZanNumTableViewCell" forIndexPath:indexPath];
    [cellid showTeamPeopleData:_dataArray[indexPath.row]];
    return cellid;
}

@end
