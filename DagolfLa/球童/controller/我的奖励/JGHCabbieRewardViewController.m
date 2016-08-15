//
//  JGHCabbieRewardViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/12.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHCabbieRewardViewController.h"
#import "JGHCabbieAwaredCell.h"
#import "JGHTransDetailListModel.h"
#import "JGDPrivateAccountViewController.h"
#import "JGHCabbieWalletViewController.h"

static NSString *const JGHCabbieAwaredCellIdentifier = @"JGHCabbieAwaredCell";

@interface JGHCabbieRewardViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UIView *_barView;
    NSInteger _page;
    UILabel *_totalLable;
    UIView *_noDataView;
}

@property (nonatomic, strong)UITableView *cabbieRewardTableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation JGHCabbieRewardViewController

- (instancetype)init{
    if (self == [super init]) {
        self.dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的奖励";
    _page = 0;
    
    [self createCabbieRewardTableView];
    
    [self loadRewardData];
}
#pragma mark -- 下载
- (void)loadRewardData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:@7 forKey:@"orderType"];
    [dict setObject:@(_page) forKey:@"offset"];
    [dict setObject:[JGReturnMD5Str getUserTransDetailOrderTypeListUserKey:[DEFAULF_USERID integerValue] andOrderType:7] forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"user/getUserTransDetailOrderTypeList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        [self.cabbieRewardTableView.header endRefreshing];
        [self.cabbieRewardTableView.footer endRefreshing];
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            if ([data objectForKey:@"transDetailList"]) {
                float totalCount = 0.00;
                JGHTransDetailListModel *model = [[JGHTransDetailListModel alloc]init];
                NSArray *dataArray = [NSArray array];
                dataArray = [data objectForKey:@"transDetailList"];
                for (NSDictionary *dict in dataArray) {
                    [model setValuesForKeysWithDictionary:dict];
                    totalCount += [model.balance floatValue];
                    [self.dataArray addObject:model];
                }
                
                [self createBarView:0 andTotalPrice:totalCount];
                [self.cabbieRewardTableView reloadData];
            }else{
                if (self.dataArray.count == 0) {
                    [self createBarView:1 andTotalPrice:1.0];
                }
                
            }
        }else{
            [self createBarView:1 andTotalPrice:1.0];
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
        
        [self.cabbieRewardTableView.header endRefreshing];
        [self.cabbieRewardTableView.footer endRefreshing];
    }];
}
- (void)createBarView:(NSInteger)barId andTotalPrice:(float)price{
    if (barId == 0) {
        self.cabbieRewardTableView.frame = CGRectMake(0, 0, screenWidth, screenHeight - 64 -44*ProportionAdapter);
        if (_totalLable != nil) {
            [_totalLable removeFromSuperview];
            [_barView removeFromSuperview];
        }
        
        _barView = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight -64 -44*ProportionAdapter, screenWidth, 44*ProportionAdapter)];
        _totalLable = [[UILabel alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 10 *ProportionAdapter, screenWidth/2, 20*ProportionAdapter)];
        _totalLable.text = [NSString stringWithFormat:@"合计：¥%.2f", price];
        [_barView addSubview:_totalLable];
        
        UIButton *myAccountBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth - 120*ProportionAdapter, 4*ProportionAdapter, 110*ProportionAdapter, 36 *ProportionAdapter)];
        [myAccountBtn setTitle:@"查看个人账户" forState:UIControlStateNormal];
        [myAccountBtn setTintColor:[UIColor orangeColor]];
        [myAccountBtn addTarget:self action:@selector(pushToMyAmount:) forControlEvents:UIControlEventTouchUpInside];
        [_barView addSubview:myAccountBtn];
        
        [self.view addSubview:_barView];
    }else{
        self.cabbieRewardTableView.frame = CGRectMake(0, 0, 0, 0);
        if (_totalLable != nil) {
            [_totalLable removeFromSuperview];
            [_barView removeFromSuperview];
        }
        
        _noDataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
        UIImageView *nodataImageView = [[UIImageView alloc]initWithFrame:CGRectMake(134*ProportionAdapter, 94*ProportionAdapter, 107 *ProportionAdapter, 107 *ProportionAdapter)];
        nodataImageView.image = [UIImage imageNamed:@"emjoembarrassed"];
        [_noDataView addSubview:nodataImageView];
        
        UILabel *proLable = [[UILabel alloc]initWithFrame:CGRectMake(20*ProportionAdapter, 267 *ProportionAdapter, screenWidth - 40*ProportionAdapter, 25 *ProportionAdapter)];
        proLable.font = [UIFont systemFontOfSize:18 *ProportionAdapter];
        proLable.textAlignment = NSTextAlignmentCenter;
        proLable.text = @"您还没有奖励记录哦";
        [_noDataView addSubview:proLable];
        
        UIButton *amountBtn = [[UIButton alloc]initWithFrame:CGRectMake(130 *ProportionAdapter, 300 *ProportionAdapter, screenWidth - 260*ProportionAdapter, 30*ProportionAdapter)];
        [amountBtn setTitle:@"查看个人账户" forState:UIControlStateNormal];
        [amountBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        amountBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [amountBtn addTarget:self action:@selector(pushToMyAmount:) forControlEvents:UIControlEventTouchUpInside];
        [_noDataView addSubview:amountBtn];
        
        [self.view addSubview:_noDataView];
    }
}
#pragma mark -- 查看个人账户
- (void)pushToMyAmount:(UIButton *)btn{
    btn.enabled = NO;
    NSLog(@"查看个人账户");
    JGDPrivateAccountViewController *priveCtrl = [[JGDPrivateAccountViewController alloc]init];
    
    [self.navigationController pushViewController:priveCtrl animated:YES];
    
    btn.enabled = YES;
}
- (void)createCabbieRewardTableView{
    self.cabbieRewardTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64 -44*ProportionAdapter) style:UITableViewStylePlain];
    
    UINib *cabbieAwaredCellNib = [UINib nibWithNibName:@"JGHCabbieAwaredCell" bundle:[NSBundle mainBundle]];
    [self.cabbieRewardTableView registerNib:cabbieAwaredCellNib forCellReuseIdentifier:JGHCabbieAwaredCellIdentifier];
    
    self.cabbieRewardTableView.delegate = self;
    self.cabbieRewardTableView.dataSource = self;
    
    self.cabbieRewardTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.cabbieRewardTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    
    self.cabbieRewardTableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    self.cabbieRewardTableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    [self.cabbieRewardTableView.header beginRefreshing];
    
    [self.view addSubview:self.cabbieRewardTableView];
}
- (void)headRereshing{
    _page = 0;
    [self.dataArray removeAllObjects];
    [self loadRewardData];
}
- (void)footRereshing{
    _page ++;
    [self loadRewardData];
}
#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70 *ProportionAdapter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%td", indexPath.section);
    JGHCabbieAwaredCell *cabbieAwaredCell = [tableView dequeueReusableCellWithIdentifier:JGHCabbieAwaredCellIdentifier];
    cabbieAwaredCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArray.count > 0) {
        [cabbieAwaredCell configJGHTransDetailListModel:self.dataArray[indexPath.section]];
    }
    
    return cabbieAwaredCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    view.backgroundColor = [UIColor colorWithHexString:BG_color];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JGHCabbieWalletViewController *cabCtrl = [[JGHCabbieWalletViewController alloc]init];
    [self.navigationController pushViewController:cabCtrl animated:YES];
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
