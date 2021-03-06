
//
//  VipCardOrderListViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/4/10.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "VipCardOrderListViewController.h"
#import "VipCardOrderListModel.h"
#import "VipCardOrderListTableViewCell.h"
#import "VipCardOrderDetailViewController.h"
@interface VipCardOrderListViewController ()<UITableViewDelegate,UITableViewDataSource>
/**
 主视图列表
 */
@property(nonatomic, copy)UITableView *mainTableView;
/**
 数据源
 */
@property(nonatomic, strong)NSMutableArray *dataArray;
/**
 页数
 */
@property(nonatomic, assign)NSInteger off;
@end

@implementation VipCardOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - CreateView
-(void)createView{
    [self createNavagationBar];
    [self createTableView];
    [self createRefreash];
}
/**
 上导航
 */
-(void)createNavagationBar{
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    self.title = @"联盟会籍订单";
}
/**
 创建tableView
 */
-(void)createTableView{
    UIView *line = [Factory createViewWithBackgroundColor:ClearColor frame:CGRectMake(0, 0, 1, 1)];
    [self.view addSubview:line];
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-64)];
    mainTableView.backgroundColor = Back_Color;
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    [mainTableView registerClass:[VipCardOrderListTableViewCell class] forCellReuseIdentifier:@"VipCardOrderListTableViewCellId"];
    [mainTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:mainTableView];
    _mainTableView = mainTableView;
}


/**
 创建刷新
 */
-(void)createRefreash{
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
}

#pragma mark - initData;
-(void)initViewWillApperData{
    [self loadListData:0];
}
-(void)initData{

}

/**
 请求列表数据

 @param off 页数
 */
-(void)loadListData:(NSInteger)off{
    NSString *md5Value =[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com",DEFAULF_USERID]];
    NSDictionary *dict = @{
                           @"userKey":DEFAULF_USERID,
                           @"off":@(off),
                           @"md5":md5Value,
                           };
    [[JsonHttp jsonHttp] httpRequest:@"league/getSystemCardOrderList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        [self.mainTableView.mj_footer endRefreshing];
        [self.mainTableView.mj_header endRefreshing];
    } completionBlock:^(id data) {
        [self.mainTableView.mj_footer endRefreshing];
        [self.mainTableView.mj_header endRefreshing];
        BOOL Success = [[data objectForKey:@"packSuccess"] boolValue];
        if (Success) {
            if (off == 0) {
                self.dataArray = [[NSMutableArray alloc] init];
            }
            NSArray *orderList = [data objectForKey:@"orderList"];
            for (NSDictionary *orderDict in orderList) {
                VipCardOrderListModel *model = [VipCardOrderListModel modelWithDictionary:orderDict];
                [self.dataArray addObject:model];
            }
            [_mainTableView reloadData];
        }
    }];
}

#pragma mark - Action
/**
 刷新
 */
-(void)headerRefresh{
     [_mainTableView.mj_footer resetNoMoreData];
    _off = 0;
    [self loadListData:_off];
}
/**
 加载
 */
-(void)footerRefresh{
    if (self.dataArray.count==0) {
        [_mainTableView.mj_footer endRefreshing];
    }
    _off ++ ;
    [self loadListData:_off];
}

#pragma mark - UITableViewDelegate&&DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHvertical(210);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.dataArray.count==0) {
        return screenHeight-64;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VipCardOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VipCardOrderListTableViewCellId"];
    if (cell == nil) {
        cell = [[VipCardOrderListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VipCardOrderListTableViewCellId"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    VipCardOrderListModel *model = self.dataArray[indexPath.row];
    [cell configModel:model];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *backView = [Factory createViewWithBackgroundColor:ClearColor frame:_mainTableView.frame];
    //无订单提示图片
    UIImageView *picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWvertical(75),kWvertical(102), kWvertical(246), kWvertical(178))];
    picImageView.image = [UIImage imageNamed:@"bg_set_photo"];
    [backView addSubview:picImageView];

    UILabel *descLabel = [Factory createLabelWithFrame:CGRectMake(0, picImageView.y_height + kHvertical(29), screenWidth, kHvertical(15)) textColor:RGB(98,98,98) fontSize:kHorizontal(15) Title:@"暂无君高会籍订单！"];
    [descLabel setTextAlignment:NSTextAlignmentCenter];
    [backView addSubview:descLabel];
    return backView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VipCardOrderListModel *model = self.dataArray[indexPath.row];
    VipCardOrderDetailViewController *vc = [[VipCardOrderDetailViewController alloc] init];
    vc.orderKey = model.timeKey;
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
