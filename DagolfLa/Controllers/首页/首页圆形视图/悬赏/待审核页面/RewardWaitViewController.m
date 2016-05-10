//
//  YueWaitViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/10/8.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "RewardWaitViewController.h"
#import "RewardArravelTableViewCell.h"

#import "PostDataRequest.h"
#import "Helper.h"
#define kWait_URl @"aboutBallRewardJoin/queryPage.do"

#import "MJRefresh.h"
#import "MJDIYHeader.h"
#import "MJDIYBackFooter.h"

#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

#import "RewordCheckModel.h"

@interface RewardWaitViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _dataArray;
    NSInteger _page;
}

@end

@implementation RewardWaitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _page = 1;
    self.title = @"申请审批";
    _dataArray = [[NSMutableArray alloc]init];
    ////NSLog(@"%@",_BallIdNum);
    
    
    [self createTableView];
    
    
}



-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
//    [_tableView registerNib:[UINib nibWithNibName:@"TeamApplyViewCell" bundle:nil] forCellReuseIdentifier:@"TeamApplyViewCell"];
    [_tableView registerClass:[RewardArravelTableViewCell class] forCellReuseIdentifier:@"RewardArravelTableViewCell"];
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    [_tableView.header beginRefreshing];
}


#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    NSString *netStr;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    netStr = kWait_URl;
    [dic setObject:_BallIdNum forKey:@"aboutBallReId"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
    [[PostDataRequest sharedInstance] postDataRequest:netStr parameter:dic success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        ////NSLog(@"%@",dict);
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (page == 1)[_dataArray removeAllObjects];
            [self getInfoFromArray:[[dict objectForKey:@"rows"] objectForKey:@"type0"]];
            
            _page++;
            [_tableView reloadData];
        }
        else {
            if (page == 1)[_dataArray removeAllObjects];
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
- (void)getInfoFromArray:(NSMutableArray *)arr {
    for (int i = 0; i<arr.count; i++) {
        NSDictionary *sportDic = arr[i];
        RewordCheckModel *model = [[RewordCheckModel alloc] init];
        [model setValuesForKeysWithDictionary:sportDic];
        [_dataArray addObject:model];
        
        
    }
    
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55*ScreenWidth/375;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RewardArravelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RewardArravelTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell showRewardDetail:_dataArray[indexPath.row]];
//    cell.indexState = 10;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
