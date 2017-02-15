//
//  JGDBookCourtViewController.m
//  DagolfLa
//
//  Created by 東 on 16/12/21.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDBookCourtViewController.h"
#import "JGDBookCourtTableViewCell.h"

#import "JGDCourtNameSearchViewController.h"  // 球场名字搜索

#import "JGDCourtDetailViewController.h" // 球场详情

#import "JGDOrderDetailViewController.h" //  订单详情

#import "JGDOrderListViewController.h"   // 订单列表

#import "JGDCitySearchViewController.h"

#import "JGDCourtModel.h"

@interface JGDBookCourtViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *courtTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger currentType;

@property (nonatomic, assign) NSInteger offset;

@property (nonatomic, strong) UIButton *titleBtn;

@property (nonatomic, strong) UILabel *cityLitleLB;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIView *backTitleView;

@property (nonatomic, copy) NSString *cityString;

@end

@implementation JGDBookCourtViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cityString = [[NSUserDefaults standardUserDefaults] objectForKey:CITYNAME];
    self.offset = 0;
//    [self dataSet:0];
    [self  tableViewSet];
    
    // Do any additional setup after loading the view. type  [def objectForKey:CITYNAME]
}


- (void)dataSet:(NSInteger) type{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    [dic setObject:[NSNumber numberWithInteger:self.offset] forKey:@"offset"];
    [dic setObject:[NSNumber numberWithInteger:type] forKey:@"sortType"];
    [dic setObject:self.cityString forKey:@"cityName"];
    [dic setObject:[def objectForKey:BDMAPLAT] forKey:@"latitude"];
    [dic setObject:[def objectForKey:BDMAPLNG] forKey:@"longitude"];
    //    [dic setObject:DEFAULF_USERID forKey:@"ballName"];
    if (self.offset == 0) {
        [[ShowHUD showHUD] showAnimationWithText:@"加载中…" FromView:self.view];
    }
    [[JsonHttp jsonHttp] httpRequest:@"bookball/getBallBookingList" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
//        [self.courtTableView.header endRefreshing];
        [self.courtTableView.footer endRefreshing];

        [[ShowHUD showHUD] hideAnimationFromView:self.view];

    } completionBlock:^(id data) {
//        [self.courtTableView.header endRefreshing];
        [self.courtTableView.footer endRefreshing];
        
        [[ShowHUD showHUD] hideAnimationFromView:self.view];

        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            if (self.offset == 0) {
                [self.dataArray removeAllObjects];
            }

            if ([data objectForKey:@"list"]) {
                for (NSDictionary *dic in [data objectForKey:@"list"]) {
                    JGDCourtModel *model = [[JGDCourtModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.dataArray addObject:model];
                }
            }
            [self.courtTableView reloadData];

        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
    
}

- (void)headRefresh{
    self.offset = 0;
    [self dataSet:self.currentType];
}

- (void)footRefresh{
    self.offset ++;
    [self dataSet:self.currentType];
}

- (void)tableViewSet{
    
    self.courtTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64 * ProportionAdapter)];
    self.courtTableView.delegate = self;
    self.courtTableView.dataSource = self;
    self.courtTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.courtTableView];
    
    self.courtTableView.rowHeight = 90 * ProportionAdapter;
    [self.courtTableView registerClass:[JGDBookCourtTableViewCell class] forCellReuseIdentifier:@"bookCourtCell"];
    
//    self.courtTableView.header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    self.courtTableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
//    [self.courtTableView.header beginRefreshing];
    [self dataSet:0];

    
    CGFloat width = [Helper textWidthFromTextString:[[NSUserDefaults standardUserDefaults] objectForKey:CITYNAME] height:30 * ProportionAdapter fontSize:17];
    
    self.backTitleView = [[UIView alloc] initWithFrame:CGRectMake((screenWidth - width + 30 * ProportionAdapter ) / 2, 0, width + 30 * ProportionAdapter, 30 * ProportionAdapter)];

    self.cityLitleLB = [self lablerect:CGRectMake(0, 0, width, 30 * ProportionAdapter) labelColor:[UIColor whiteColor] labelFont:(17) text:[[NSUserDefaults standardUserDefaults] objectForKey:CITYNAME] textAlignment:(NSTextAlignmentRight)];
    
    self.titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(width, 0, 30 * ProportionAdapter, 30 * ProportionAdapter)];
    [self.titleBtn setImage:[UIImage imageNamed:@"booking_arrow"] forState:(UIControlStateNormal)];
    [self.titleBtn addTarget:self action:@selector(citySearchAct) forControlEvents:(UIControlEventTouchUpInside)];
    [self.cityLitleLB addSubview:self.titleBtn];
    
    
    [self.backTitleView addSubview:self.cityLitleLB];
    [self.backTitleView addSubview:self.titleBtn];
    self.navigationItem.titleView = self.backTitleView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(citySearchAct)];
    self.cityLitleLB.userInteractionEnabled = YES;
    [self.backTitleView addGestureRecognizer:tap];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"booking_Search"] style:(UIBarButtonItemStylePlain) target:self action:@selector(searchAct)];
    [rightBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    
}

- (void)citySearchAct{
    JGDCitySearchViewController *citySearchVC = [[JGDCitySearchViewController alloc] init];
    citySearchVC.blockAddress = ^(NSString *city){
        CGFloat width = [Helper textWidthFromTextString:city height:screenWidth - 20 * ProportionAdapter fontSize:17];
        self.cityLitleLB.text = city;
        self.cityString = city;
        
        self.backTitleView.frame =  CGRectMake((screenWidth - width + 30 * ProportionAdapter ) / 2, 0, width + 30 * ProportionAdapter, 30 * ProportionAdapter);
        self.cityLitleLB.frame = CGRectMake(0, 0, width, 30 * ProportionAdapter);
        self.titleBtn.frame = CGRectMake(width, 0, 30 * ProportionAdapter, 30 * ProportionAdapter);
        self.offset = 0;
        [self dataSet:self.currentType];
    };
    [self.navigationController pushViewController:citySearchVC animated:YES];
}

#pragma mark -- 排序方式

- (void)sortCourt:(UIButton *)btn{
 
    for (UIView *sView in [btn.superview subviews]) {
        if (sView.tag != sView.tag || [[sView class] isSubclassOfClass:[UIButton class]]) {
            UIButton *sBtn = (UIButton *)sView;
            [sBtn setTitleColor:[UIColor colorWithHexString:@"#313131"] forState:(UIControlStateNormal)];
        }
    }
    
    //    [self dataSet:btn.tag - 300];
    //    [self.courtTableView.header beginRefreshing];

    self.currentType = btn.tag - 300;
    [btn setTitleColor:[UIColor colorWithHexString:@"#32b14d"] forState:(UIControlStateNormal)];
    self.offset = 0;
    [self dataSet:self.currentType];
}

// 最右搜索按钮
- (void)searchAct{
    JGDCourtNameSearchViewController *nameSearchVC = [[JGDCourtNameSearchViewController alloc] init];

    [self.navigationController pushViewController:nameSearchVC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JGDBookCourtTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookCourtCell"];
    if ([self.dataArray count] > indexPath.row) {
        cell.model = self.dataArray[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50 * ProportionAdapter;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JGDCourtDetailViewController *courtVC = [[JGDCourtDetailViewController alloc] init];
    courtVC.timeKey = [self.dataArray[indexPath.row] timeKey];
    [self.navigationController pushViewController:courtVC animated:YES];
}

#pragma mark --- @"推荐排序",@"距离优先",@"价格优先"
- (UIView *)headerView{
    if (!_headerView) {
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 50 * ProportionAdapter)];
        self.headerView.backgroundColor = [UIColor whiteColor];
        
        NSArray *sortStyleArray = [NSArray arrayWithObjects:@"推荐排序",@"距离优先",@"价格优先", nil];
        for (int i = 0; i < 3; i ++) {
            UIButton *sortBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 * ProportionAdapter + i * 139 * ProportionAdapter, 0, 76 * ProportionAdapter, 49 * ProportionAdapter)];
            sortBtn.tag = 300 + i;
            [sortBtn setTitleColor:i == 0 ? [UIColor colorWithHexString:@"#32b14b"] : [UIColor blackColor] forState:(UIControlStateNormal)];
            [sortBtn setTitle:sortStyleArray[i] forState:(UIControlStateNormal)];
            [sortBtn addTarget:self action:@selector(sortCourt:) forControlEvents:(UIControlEventTouchUpInside)];
            sortBtn.titleLabel.font = [UIFont systemFontOfSize:17 * ProportionAdapter];
            
            if (i == 0) {
                sortBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            }else if (i == 2) {
                sortBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            }
            
            
            [self.headerView addSubview:sortBtn];
        }
        UILabel *lineLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 49.5 * ProportionAdapter, screenWidth, 0.5 * ProportionAdapter)];
        lineLB.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [self.headerView addSubview:lineLB];
    }
    return _headerView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

//  封装cell方法
- (UILabel *)lablerect:(CGRect)rect labelColor:(UIColor *)color labelFont:(NSInteger)font text:(NSString *)text textAlignment:(NSTextAlignment )alignment{
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = alignment;
    label.frame = rect;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font];
    label.text = text;
    return label;
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
