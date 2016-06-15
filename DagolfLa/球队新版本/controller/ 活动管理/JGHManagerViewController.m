//
//  JGHManagerViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHManagerViewController.h"
#import "JGTeamAcitivtyModel.h"
#import "JGTeamActivityCell.h"
#import "JGTeamActibityNameViewController.h"
#import "JGHLaunchActivityViewController.h"
#import "JGTeamGroupViewController.h"
#import "JGHActicityDetailsViewController.h"
#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"

@interface JGHManagerViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSString *_urlString;
}
@property (nonatomic, strong)UITableView *teamActivityTableView;
@property (nonatomic, strong)NSMutableArray *dataArray;//数据模型数组
@property (nonatomic, assign)NSInteger page;

@end

@implementation JGHManagerViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}

- (instancetype)init{
    if (self = [super init]) {
        self.dataArray = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"球队活动";
    self.page = 1;
    [self createTeamActivityTabelView];
    
    [self createAdminBtn];
    
    [self loadData];
    
}

#pragma mark -- 下载数据
- (void)loadData{
    //获取球队活动
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];//3619
    //189781710290821120  http://192.168.2.6:8888
    [dict setObject:@"0" forKey:@"offset"];
    [dict setObject:[NSString stringWithFormat:@"%td", _timeKey] forKey:@"teamKey"];
    
    //球队活动
    _urlString = @"team/getTeamActivityList";
    
    [[JsonHttp jsonHttp]httpRequest:_urlString JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        NSLog(@"data == %@", data);
        [self.dataArray removeAllObjects];
        
        NSArray *array = [data objectForKey:@"activityList"];
        
        for (NSDictionary *dict in array) {
            JGTeamAcitivtyModel *model = [[JGTeamAcitivtyModel alloc]init];
            
            [model setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:model];
        }
        
        [self.teamActivityTableView reloadData];
    }];
}

#pragma mark -- 创建发布活动
- (void)createAdminBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = RightNavItemFrame;
    btn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    [btn setTitle:@"发布活动" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(launchActivityBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark -- 发布活动
- (void)launchActivityBtnClick:(UIButton *)btn{
    JGHLaunchActivityViewController * launchCtrl = [[JGHLaunchActivityViewController alloc]init];
    launchCtrl.teamKey = _timeKey;
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@", [userdef objectForKey:@"TeamActivityArray"]);
    NSMutableArray *activityArray = [NSMutableArray array];
    activityArray = [userdef objectForKey:@"TeamActivityArray"];
    if ([activityArray count]) {
        [Helper alertViewWithTitle:@"是否继续上次未完成的操作！" withBlockCancle:^{
            NSLog(@"不继续，清除数据");
            [userdef removeObjectForKey:@"TeamActivityArray"];
            [userdef synchronize];
            [self.navigationController pushViewController:launchCtrl animated:YES];
        } withBlockSure:^{
            JGTeamAcitivtyModel *model = [[JGTeamAcitivtyModel alloc]init];
            model = [[userdef objectForKey:@"TeamActivityArray"]objectAtIndex:0];
            launchCtrl.model = model;
            [self.navigationController pushViewController:launchCtrl animated:YES];
        } withBlock:^(UIAlertController *alertView) {
            [self.navigationController presentViewController:alertView animated:YES completion:nil];
        }];
    }
    
    [self.navigationController pushViewController:launchCtrl animated:YES];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    footView.backgroundColor = [UIColor colorWithHexString:BG_color];
    return footView;
}
#pragma mark -- 创建TableView
- (void)createTeamActivityTabelView{
    self.teamActivityTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStyleGrouped];
    self.teamActivityTableView.delegate = self;
    self.teamActivityTableView.dataSource = self;
    self.teamActivityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.teamActivityTableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    self.teamActivityTableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    [self.teamActivityTableView.header beginRefreshing];
    
    [self.view addSubview:self.teamActivityTableView];
}

#pragma mark 开始进入刷新状态
- (void)headRereshing
{
    self.page = 0;
    [self downLoadData:self.page isReshing:YES];
}

- (void)footRereshing
{
    [self downLoadData:self.page isReshing:NO];
}

#pragma mark - 下载数据
- (void)downLoadData:(NSInteger)page isReshing:(BOOL)isReshing{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [dict setObject:[def objectForKey:@"userId"] forKey:@"userKey"];//3619
    [dict setObject:@(self.page) forKey:@"offset"];
    [dict setObject:[NSString stringWithFormat:@"%td", _timeKey] forKey:@"teamKey"];
    [[JsonHttp jsonHttp]httpRequest:_urlString JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [self.teamActivityTableView.header endRefreshing];
        }else {
            [self.teamActivityTableView.footer endRefreshing];
        }
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            if (page == 0)
            {
                //清除数组数据
                [self.dataArray removeAllObjects];
            }
            if ([data objectForKey:@"activityList"]) {
                NSArray *array = [data objectForKey:@"activityList"];
                for (NSDictionary *dict in array) {
                    JGTeamAcitivtyModel *model = [[JGTeamAcitivtyModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.dataArray addObject:model];
                }
                self.page++;
                
                [self.teamActivityTableView reloadData];
            }
            
        }
        
        [self.teamActivityTableView reloadData];
        if (isReshing) {
            [self.teamActivityTableView.header endRefreshing];
        }else {
            [self.teamActivityTableView.footer endRefreshing];
        }
    }];
}


#pragma mark -- tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 81;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *teamActivityCellID = @"JGTeamActivityCell";
    JGTeamActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:teamActivityCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JGTeamActivityCell" owner:self options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JGTeamAcitivtyModel *model = [[JGTeamAcitivtyModel alloc]init];
    model = self.dataArray[indexPath.section];
 
    [cell setJGTeamActivityCellWithModel:model fromCtrl:2];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JGHActicityDetailsViewController *detailsCtrl = [[JGHActicityDetailsViewController alloc]init];
//    detailsCtrl.isTeamChannal = 2;
    JGTeamAcitivtyModel *model = [[JGTeamAcitivtyModel alloc]init];
    model = self.dataArray[indexPath.section];
//    activityNameCtrl.teamKey = [model.timeKey integerValue];
    detailsCtrl.model = model;
    [self.navigationController pushViewController:detailsCtrl animated:YES];
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
