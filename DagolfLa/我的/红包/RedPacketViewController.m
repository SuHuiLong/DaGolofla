//
//  RedPacketViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/6/6.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "RedPacketViewController.h"
#import "RedPacketTableViewCell.h"
#import "RedPacketModel.h"
#import "HistoryRedPacketViewController.h"
#import "JGDBookCourtViewController.h"
#import "UseMallViewController.h"
@interface RedPacketViewController ()<UITableViewDelegate,UITableViewDataSource>
//主视图
@property (nonatomic, strong) UITableView *mainTableView;
//数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
//当前页数
@property (nonatomic,assign) NSInteger offset;

@end

@implementation RedPacketViewController
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Back_Color;
}

#pragma mark - CreateView
-(void)createView{
    [self createNavigationView];
    [self createTableView];
}
//导航
-(void)createNavigationView{
    self.title = @"我的红包";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
//主视图
-(void)createTableView{
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) style:UITableViewStyleGrouped];
    mainTableView.backgroundColor = Back_Color;
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [mainTableView registerClass:[RedPacketTableViewCell class] forCellReuseIdentifier:@"RedPacketTableViewCellID"];
    [self.view addSubview:mainTableView];
    _mainTableView = mainTableView;
}

#pragma mark - MJRefresh
-(void)createRefresh{
    _mainTableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
}
//刷新
-(void)headerRefresh{
    _offset = 0;
    [self initMainData];
}
//加载
-(void)footerRefresh{
    _offset++;
    [self initMainData];
}

#pragma mark - InitData
-(void)initData{
    [self initMainData];
}
//获取主视图数据
-(void)initMainData{
    NSString *md5Value =[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]];
    NSString *offsetStr = [NSString stringWithFormat:@"%ld",_offset];
    NSDictionary *dict = @{
                            @"userKey":DEFAULF_USERID,
                            @"md5":md5Value,
                            @"offset":offsetStr
                           };
    
    [[JsonHttp jsonHttp] httpRequest:@"coupon/getMyCouponList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        [_mainTableView.mj_header endRefreshing];
        [_mainTableView.mj_footer endRefreshing];
    } completionBlock:^(id data) {
        [_mainTableView.mj_header endRefreshing];
        [_mainTableView.mj_footer endRefreshing];
        BOOL packSuccess = [[data objectForKey:@"packSuccess"] boolValue];
        if (packSuccess) {
            if (_offset==0) {
                self.dataArray = [NSMutableArray array];
            }
            NSArray *listArray = [data objectForKey:@"couponList"];
            for (NSDictionary *indexDict in listArray) {
                RedPacketModel *model = [RedPacketModel modelWithDictionary:indexDict];
                [self.dataArray addObject:model];
            }
            [_mainTableView reloadData];
        }else{
            NSString *packResultMsg = [data objectForKey:@"packResultMsg"];
            [[ShowHUD showHUD] showLinesToastWithText:packResultMsg FromView:self.view];
        }
    }];
    
}

#pragma mark - Action
//返回
-(void)backButtonClcik{
    [self.navigationController popViewControllerAnimated:YES];
}
//红包说明
-(void)explainClick{
    UseMallViewController *vc = [[UseMallViewController alloc]init];
    vc.linkUrl = @"https://imgcache.dagolfla.com/share/redpacket/envelopeRules.html";
    vc.isNewColor = true;
    [self.navigationController pushViewController:vc animated:YES];

}
//查看历史红包
-(void)historyClick{
    HistoryRedPacketViewController *vc = [[HistoryRedPacketViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UITableviewDelegate&&Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_dataArray.count==0) {
        return screenHeight - 64;
    }
    return kHvertical(50);
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHvertical(136);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RedPacketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RedPacketTableViewCellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RedPacketModel *model = self.dataArray[indexPath.row];
    [cell configModel:model];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [Factory createViewWithBackgroundColor:Back_Color frame:CGRectMake(0, 0, screenWidth, kHvertical(33))];
    //图标
    UIImageView *iconView = [Factory createImageViewWithFrame:CGRectMake(kWvertical(10), kHvertical(13), kHvertical(20), kHvertical(20)) Image:[UIImage imageNamed:@"icn_luckydetail"]];
    [headerView addSubview:iconView];
    //红包说明
    UILabel *explainLabel = [Factory createLabelWithFrame:CGRectMake(iconView.x_width+kWvertical(5), kHvertical(13), kWvertical(70), kHvertical(20)) textColor:RGB(0,134,73) fontSize:kHorizontal(15) Title:@"红包说明"];
    [headerView addSubview:explainLabel];
    //添加点击事件
    UIButton *explainBtn = [Factory createButtonWithFrame:CGRectMake(0, 0, kWvertical(100), kHvertical(33)) target:self selector:@selector(explainClick) Title:nil];
    explainBtn.backgroundColor = ClearColor;
    [headerView addSubview:explainBtn];
    //历史红包
    UIButton *historyBtn = [Factory createButtonWithFrame:CGRectMake(screenWidth - kWvertical(110), kHvertical(13), kWvertical(110), kHvertical(20)) titleFont:kHorizontal(15) textColor:RGB(0,134,73) backgroundColor:ClearColor target:self selector:@selector(historyClick) Title:@"查看历史红包"];
    [headerView addSubview:historyBtn];
    if (self.dataArray.count == 0) {
        headerView.height = screenHeight - 64;
        //没卡提示图片
        UIImageView *alertImageView = [Factory createImageViewWithFrame:CGRectMake(screenWidth/2-kWvertical(123),kHvertical(125), kWvertical(246), kHvertical(178)) Image:[UIImage imageNamed:@"bg_set_luckybag"]];
        [headerView addSubview:alertImageView];
        //文字描述
        UILabel *line1 = [Factory createLabelWithFrame:CGRectMake(0, alertImageView.y_height + kHvertical(39), screenWidth, kHvertical(16)) textColor:RGB(98,98,98) fontSize:kHorizontal(15) Title:@"没有红包哎~"];
        [line1 setTextAlignment:NSTextAlignmentCenter];
        [headerView addSubview:line1];
        UILabel *line2 = [Factory createLabelWithFrame:CGRectMake(0, line1.y_height + kHvertical(6), screenWidth, kHvertical(16)) textColor:RGB(98,98,98) fontSize:kHorizontal(15) Title:@"订场成功后有机会获得红包哦~"];
        [line2 setTextAlignment:NSTextAlignmentCenter];
        [headerView addSubview:line2];
    }
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDBookCourtViewController *vc = [[JGDBookCourtViewController alloc] init];
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
