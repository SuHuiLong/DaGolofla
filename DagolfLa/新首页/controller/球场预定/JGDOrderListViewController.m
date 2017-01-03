//
//  JGDOrderListViewController.m
//  DagolfLa
//
//  Created by 東 on 16/12/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDOrderListViewController.h"
#import "JGDOrderListTableViewCell.h"

#import "JGDOrderDetailViewController.h" // 订单详情

@interface JGDOrderListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *orderTableView;

@property (nonatomic, strong) UIView *greenView;

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger currentType;

@end

@implementation JGDOrderListViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)dataSet:(NSInteger) type{

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    [dic setObject:[NSNumber numberWithInteger:self.offset] forKey:@"offset"];
    [dic setObject:[NSNumber numberWithInteger:self.currentType] forKey:@"state"];
    [dic setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]] forKey:@"md5"];
//    [[ShowHUD showHUD] showAnimationWithText:@"加载中…" FromView:self.view];
    
    [[JsonHttp jsonHttp]httpRequest:@"bookingOrder/getOrderList" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
//        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        [self.orderTableView.header endRefreshing];
        [self.orderTableView.footer endRefreshing];
    } completionBlock:^(id data) {
//        [[ShowHUD showHUD] hideAnimationFromView:self.view];
        [self.orderTableView.header endRefreshing];
        [self.orderTableView.footer endRefreshing];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            if (self.offset == 0) {
                [self.dataArray removeAllObjects];
            }
            if ([data objectForKey:@"list"]) {
                [self.dataArray addObjectsFromArray:[data objectForKey:@"list"]];
            }
            [self.orderTableView reloadData];

        }
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.offset = 0;
    self.currentType = -1;
    [self dataSet:0];
    
    [self orderTableSet];
    
}


- (void)orderTableSet{
    
    self.orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64 * ProportionAdapter) style:(UITableViewStylePlain)];
    self.orderTableView.delegate = self;
    self.orderTableView.dataSource = self;
    self.orderTableView.rowHeight = 112 * ProportionAdapter;
    self.orderTableView.separatorStyle = UITableViewCellAccessoryNone;
    
    [self.view addSubview:self.orderTableView];
    [self.orderTableView registerClass:[JGDOrderListTableViewCell class] forCellReuseIdentifier:@"orderListCell"];

    self.orderTableView.header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    self.orderTableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    [self.orderTableView.header beginRefreshing];

}

- (void)headRefresh{
    self.offset = 0;
    [self dataSet:self.currentType];
}

- (void)footRefresh{
    self.offset ++;
    [self dataSet:self.currentType];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return self.headView;
}

- (UIView *)headView{
    if (!_headView) {
        self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 60 * ProportionAdapter)];
        self.headView.backgroundColor = [UIColor whiteColor];
        
        NSArray *array = [NSArray arrayWithObjects:@"全部", @"待确认", @"待付款", @"已完成", nil];
        for (int i = 0; i < 4; i ++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i * 91 * ProportionAdapter, 20 * ProportionAdapter, 91 * ProportionAdapter, 30 * ProportionAdapter)];
            btn.tag = 200 + i;
            [btn addTarget:self action:@selector(clickAct:) forControlEvents:(UIControlEventTouchUpInside)];
            if (i == 0) {
                [btn setTitle:array[i] forState:(UIControlStateNormal)];
                [btn setTitleColor:[UIColor colorWithHexString:@"#32b14d"] forState:(UIControlStateNormal)];
            }else{
                [btn setTitle:array[i] forState:(UIControlStateNormal)];
                [btn setTitleColor:[UIColor colorWithHexString:@"#a0a0a0"] forState:(UIControlStateNormal)];
            }
            [self.headView addSubview:btn];
        }
        
        self.greenView = [[UIView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 49 * ProportionAdapter, 70 * ProportionAdapter, 1 * ProportionAdapter)];
        self.greenView.backgroundColor = [UIColor colorWithHexString:@"#32b14d"];
        [self.headView addSubview:self.greenView];
        
        UILabel *lB = [[UILabel alloc] initWithFrame:CGRectMake(0, 50 * ProportionAdapter, screenWidth, 10 * ProportionAdapter)];
        lB.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [self.headView addSubview:lB];

    }
    return _headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60 * ProportionAdapter;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderListCell"];
    cell.dataDic = self.dataArray[indexPath.row];
    return cell;
}



#pragma mark -- click

- (void)clickAct:(UIButton *)btn {

    for (UIView *sView in self.headView.subviews) {
        if (sView.tag != sView.tag || [[sView class] isSubclassOfClass:[UIButton class]]) {
            UIButton *sBtn = (UIButton *)sView;
            [sBtn setTitleColor:[UIColor colorWithHexString:@"#a0a0a0"] forState:(UIControlStateNormal)];
        }
    }
    
    [btn setTitleColor:[UIColor colorWithHexString:@"#32b14d"] forState:(UIControlStateNormal)];
    // 0: 待付款  1:待确认  3: 待取消  4: 待退款  5: 已完成
    if (btn.tag == 200) {
        self.greenView.frame = CGRectMake(10 * ProportionAdapter, 47.5* ProportionAdapter, 70 * ProportionAdapter, 2.5 * ProportionAdapter);
        self.currentType = -1;
        
    }else if (btn.tag == 201) {
        self.greenView.frame = CGRectMake(100 * ProportionAdapter, 47.5 * ProportionAdapter, 70 * ProportionAdapter, 2.5 * ProportionAdapter);
        self.currentType = 1;
        
    }else if (btn.tag == 202) {
        self.greenView.frame = CGRectMake(190 * ProportionAdapter, 47.5 * ProportionAdapter, 70 * ProportionAdapter, 2.5 * ProportionAdapter);
        self.currentType = 0;

    }
    else if (btn.tag == 203) {
        self.greenView.frame = CGRectMake(285 * ProportionAdapter, 47.5 * ProportionAdapter, 70 * ProportionAdapter, 2.5 * ProportionAdapter);
        self.currentType = 5;

    }
    
    [self.orderTableView.header beginRefreshing];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDOrderDetailViewController *detailVC = [[JGDOrderDetailViewController alloc] init];
    detailVC.orderKey = [self.dataArray[indexPath.row] objectForKey:@"timeKey"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
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
