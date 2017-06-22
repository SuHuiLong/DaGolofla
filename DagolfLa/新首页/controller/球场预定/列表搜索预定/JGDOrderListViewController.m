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

@property (nonatomic, strong) NSMutableArray *countAarray;

@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger currentType;

/*
 // 填充数量
 response.putInt("count", count);                        // 总数量
 response.putInt("waitConfirmCount", waitConfirmCount);  // 待确认
 response.putInt("waitPayCount", waitPayCount);          // 待付款
 response.putInt("finishedCount", finishedCount);        // 已完成
 */
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *waitConfirmCount;
@property (nonatomic, copy) NSString *waitPayCount;
@property (nonatomic, copy) NSString *finishedCount;



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
    [dic setObject:[NSNumber numberWithInteger:self.currentType] forKey:@"bType"];
    [dic setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]] forKey:@"md5"];
    
    [[JsonHttp jsonHttp]httpRequest:@"bookingOrder/getOrderList" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        [self.orderTableView.mj_header endRefreshing];
        [self.orderTableView.mj_footer endRefreshing];
    } completionBlock:^(id data) {
        [self.orderTableView.mj_header endRefreshing];
        [self.orderTableView.mj_footer endRefreshing];
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            if (self.offset == 0) {
                [self.dataArray removeAllObjects];
                [self.countAarray removeAllObjects];
                NSArray *nameArray = [NSArray arrayWithObjects:@"count", @"waitPayCount", @"waitConfirmCount", @"finishedCount", nil];
                for (int i = 0; i < 4; i ++) {
                    [self.countAarray addObject:[data objectForKey:nameArray[i]]];
                }

            }
            if ([data objectForKey:@"list"]) {
                
                [self.dataArray addObjectsFromArray:[data objectForKey:@"list"]];
                
            }
            [self createHeaderView];
            [self.orderTableView reloadData];
            
        }
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.offset = 0;
    self.currentType = -1;
    [self dataSet:0];
    [self createHeaderView];
    [self orderTableSet];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(afterDelay) name:@"orderStateChange" object:nil];
}


-(void)createHeaderView{
    
    if ([self.countAarray count] == 4) {
        for (UIButton *btn in self.headView.subviews) {
            
            switch (btn.tag) {
                case 300:
                    [btn setTitle:[self.countAarray[0] stringValue] forState:(UIControlStateNormal)];
                    break;
                case 301:
                    [btn setTitle:[self.countAarray[1] stringValue] forState:(UIControlStateNormal)];
                    
                    break;
                case 302:
                    [btn setTitle:[self.countAarray[2] stringValue] forState:(UIControlStateNormal)];
                    
                    break;
                case 303:
                    [btn setTitle:[self.countAarray[3] stringValue] forState:(UIControlStateNormal)];
                    
                    break;
                    
                default:
                    break;
            }
            
        }
        
    }
    [self.view addSubview:self.headView];
}

- (void)orderTableSet{
    
    self.orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60 * ProportionAdapter, screenWidth, screenHeight - 20 - 60 * ProportionAdapter) style:(UITableViewStylePlain)];
    self.orderTableView.delegate = self;
    self.orderTableView.dataSource = self;
    self.orderTableView.rowHeight = 112 * ProportionAdapter;
    self.orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:self.orderTableView];
    [self.orderTableView registerClass:[JGDOrderListTableViewCell class] forCellReuseIdentifier:@"orderListCell"];

    self.orderTableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    self.orderTableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    [self.orderTableView.mj_header beginRefreshing];

}


- (void)afterDelay{
    [self performSelector:@selector(headRefresh) withObject:self afterDelay:1];
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
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if ([self.countAarray count] == 4) {
        for (UIButton *btn in self.headView.subviews) {
            
            switch (btn.tag) {
                case 300:
                    [btn setTitle:[self.countAarray[0] stringValue] forState:(UIControlStateNormal)];
                    break;
                case 301:
                    [btn setTitle:[self.countAarray[1] stringValue] forState:(UIControlStateNormal)];
                    
                    break;
                case 302:
                    [btn setTitle:[self.countAarray[2] stringValue] forState:(UIControlStateNormal)];
                    
                    break;
                case 303:
                    [btn setTitle:[self.countAarray[3] stringValue] forState:(UIControlStateNormal)];
                    
                    break;
                    
                default:
                    break;
            }
            
        }

    }
    
    return self.headView;
}
*/
- (UIView *)headView{
    if (!_headView) {
        self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 60 * ProportionAdapter)];
        self.headView.backgroundColor = [UIColor whiteColor];
        
        NSArray *array = [NSArray arrayWithObjects:@"全部", @"待付款", @"待确认", @"已完成", nil];
        for (int i = 0; i < 4; i ++) {
            
            UIButton *countbtn = [[UIButton alloc] initWithFrame:CGRectMake(i * screenWidth/4, 2 * ProportionAdapter, screenWidth/4, 25 * ProportionAdapter)];
            countbtn.tag = 300 + i;
            if ([self.countAarray count] == 4) {
                [countbtn setTitle:self.countAarray[i] forState:(UIControlStateNormal)];
            }
            countbtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(17)];
            [self.headView addSubview:countbtn];

            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i * screenWidth/4, 20 * ProportionAdapter, screenWidth/4, 30 * ProportionAdapter)];
            
            btn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(17)];
            btn.tag = 200 + i;
            [btn addTarget:self action:@selector(clickAct:) forControlEvents:(UIControlEventTouchUpInside)];
            [btn setTitle:array[i] forState:(UIControlStateNormal)];
            if (i == 0) {
                [btn setTitleColor:BarRGB_Color forState:(UIControlStateNormal)];
                [countbtn setTitleColor:BarRGB_Color forState:(UIControlStateNormal)];
            }else{
                [btn setTitleColor:[UIColor colorWithHexString:@"#a0a0a0"] forState:(UIControlStateNormal)];
                [countbtn setTitleColor:[UIColor colorWithHexString:@"#a0a0a0"] forState:(UIControlStateNormal)];
            }
            [self.headView addSubview:btn];
        }
        
        self.greenView = [[UIView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 47.5 * ProportionAdapter, 70 * ProportionAdapter, 2.5 * ProportionAdapter)];
        self.greenView.backgroundColor = BarRGB_Color;
        [self.headView addSubview:self.greenView];
        
        UILabel *lB = [[UILabel alloc] initWithFrame:CGRectMake(0, 50 * ProportionAdapter, screenWidth, 10 * ProportionAdapter)];
        lB.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [self.headView addSubview:lB];

    }
    return _headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderListCell"];
    cell.dataDic = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    UIButton *titleBtn = [self.headView viewWithTag:btn.tag + 100];
    [btn setTitleColor:[UIColor colorWithHexString:@"#32b14d"] forState:(UIControlStateNormal)];
    [titleBtn setTitleColor:[UIColor colorWithHexString:@"#32b14d"] forState:(UIControlStateNormal)];

    
    // 0: 待付款  1:待确认  3: 待取消  4: 待退款  5: 已完成
    if (btn.tag == 200) {
        self.greenView.frame = CGRectMake(10 * ProportionAdapter, 47.5* ProportionAdapter, 70 * ProportionAdapter, 2.5 * ProportionAdapter);
        self.currentType = -1;
        
    }else if (btn.tag == 201) {
        self.greenView.frame = CGRectMake(101 * ProportionAdapter, 47.5 * ProportionAdapter, 70 * ProportionAdapter, 2.5 * ProportionAdapter);
        self.currentType = 1;
        
    }else if (btn.tag == 202) {
        self.greenView.frame = CGRectMake(192 * ProportionAdapter, 47.5 * ProportionAdapter, 70 * ProportionAdapter, 2.5 * ProportionAdapter);
        self.currentType = 0;

    }
    else if (btn.tag == 203) {
        self.greenView.frame = CGRectMake(285 * ProportionAdapter, 47.5 * ProportionAdapter, 70 * ProportionAdapter, 2.5 * ProportionAdapter);
        self.currentType = 2;

    }
    
    [self.orderTableView.mj_header beginRefreshing];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JGDOrderDetailViewController *detailVC = [[JGDOrderDetailViewController alloc] init];
    detailVC.orderKey = [self.dataArray[indexPath.row] objectForKey:@"timeKey"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (NSMutableArray *)countAarray{
    if (!_countAarray) {
        _countAarray = [[NSMutableArray alloc] init];
    }
    return _countAarray;
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
