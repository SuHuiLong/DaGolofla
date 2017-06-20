//
//  ActivityMyApplyViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/5/16.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "ActivityMyApplyViewController.h"
#import "ActivityMyApplyTableViewCell.h"
#import "ActivityMyApplyViewModel.h"
#import "ActivityDetailViewController.h"
@interface ActivityMyApplyViewController ()<UITableViewDelegate,UITableViewDataSource>

//主视图
@property (nonatomic,copy) UITableView *mainTableView;
//数据源
@property (nonatomic,strong) NSMutableArray *dataArray;
//页数
@property (nonatomic,assign) NSInteger off;
@end

@implementation ActivityMyApplyViewController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - CreateView
-(void)createView{
    [self createNavigationView];
    [self createTableView];
    
}
//创建导航
-(void)createNavigationView{
    self.title = @"我的报名";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    //设置导航背景
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //backL
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    leftItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
//创建tableview
-(void)createTableView{
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-64)];
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [mainTableView registerClass:[ActivityMyApplyTableViewCell class] forCellReuseIdentifier:@"ActivityMyApplyTableViewCellID"];
    [self.view addSubview:mainTableView];
    _mainTableView = mainTableView;

}

#pragma mark - MJRefresh
-(void)createRefresh{
    _mainTableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerAdd)];
}
-(void)headerRefresh{
    _off = 0;
    [self loadListData];
}
-(void)footerAdd{
    _off ++ ;
    [self loadListData];
}

#pragma mark - InitData
-(void)initData{
    [self loadListData];
}
//获取列表数据
-(void)loadListData{

    NSDictionary *dict = @{
                           @"userKey":DEFAULF_USERID,
                           @"offset":[NSString stringWithFormat:@"%ld",(long)_off]
                           };
    
    [[JsonHttp jsonHttp]httpRequest:@"team/getMyTeamActivityList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
            [_mainTableView.mj_header endRefreshing];
            [_mainTableView.mj_footer endRefreshing];
    } completionBlock:^(id data) {
        [_mainTableView.mj_header endRefreshing];
        [_mainTableView.mj_footer endRefreshing];
        BOOL packSuccess = [[data objectForKey:@"packSuccess"] boolValue];
        
        if (packSuccess) {
            if (_off == 0){
                self.dataArray = [NSMutableArray array];
            }            
            for (NSDictionary *dicModel in data[@"activityList"]) {
                ActivityMyApplyViewModel *model = [ActivityMyApplyViewModel modelWithDictionary:dicModel];

                [self.dataArray addObject:model];
            }
            [self.mainTableView reloadData];
            
        }
    }];

}
#pragma mark - Action
-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableviewDelegate&Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.dataArray.count==0) {
        return screenHeight-64;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return kHvertical(91);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityMyApplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityMyApplyTableViewCellID"];
    if (cell==nil) {
        cell = [[ActivityMyApplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellStyleDefaultID"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    ActivityMyApplyViewModel *model = self.dataArray[indexPath.row];
    [cell configModel:model];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *backView = [Factory createViewWithBackgroundColor:Back_Color frame:CGRectMake(0, 0, screenWidth, screenHeight-64)];
    //无订单提示图片
    UIImageView *picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWvertical(75),kWvertical(102), kWvertical(246), kWvertical(178))];
    picImageView.image = [UIImage imageNamed:@"bg_set_photo"];
    [backView addSubview:picImageView];
    
    UILabel *descLabel = [Factory createLabelWithFrame:CGRectMake(0, picImageView.y_height + kHvertical(29), screenWidth, kHvertical(15)) textColor:RGB(98,98,98) fontSize:kHorizontal(15) Title:@"暂无球队活动内容！"];
    [descLabel setTextAlignment:NSTextAlignmentCenter];
    [backView addSubview:descLabel];
    
    return backView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityDetailViewController *vc = [[ActivityDetailViewController alloc] init];
    ActivityMyApplyViewModel *model = self.dataArray[indexPath.item];
    vc.activityKey = [NSString stringWithFormat:@"%ld",(long)model.teamActivityKey];
    vc.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:vc animated:YES];

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
