//
//  JGHTradRecordViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/27.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHTradRecordViewController.h"
#import "JGHTradRecordCell.h"
#import "JGHWithdrawDetailsViewController.h"
#import "JGHWithDrawModel.h"

static NSString *const JGHTradRecordCellIdentifier = @"JGHTradRecordCell";

@interface JGHTradRecordViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger _page;
}
@property (nonatomic, strong)UITableView *tradRecordTableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation JGHTradRecordViewController

- (instancetype)init{
    if (self == [super init]) {
        self.tradRecordTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-64) style:UITableViewStylePlain];
        self.tradRecordTableView.delegate = self;
        self.tradRecordTableView.dataSource = self;
        self.tradRecordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.tradRecordTableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
        self.tradRecordTableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
        [self.tradRecordTableView.header beginRefreshing];
        
        UINib *recordNib = [UINib nibWithNibName:@"JGHTradRecordCell" bundle: [NSBundle mainBundle]];
        [self.tradRecordTableView registerNib:recordNib forCellReuseIdentifier:JGHTradRecordCellIdentifier];
        [self.view addSubview:self.tradRecordTableView];
        
        self.dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"交易记录";
    _page = 0;
    
    [self loadData];
}

- (void)headRereshing{
    _page = 0;
    [self loadData];
}

- (void)footRereshing{
    _page += 1;
    [self loadData];
}

- (void)loadData{
    [[ShowHUD showHUD]showAnimationWithText:@"加载中..." FromView:self.view];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:[NSString stringWithFormat:@"%td", _page] forKey:@"offset"];
    [[JsonHttp jsonHttp]httpRequest:@"user/getUserTransDetailList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"errtype == %@", errType);
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    } completionBlock:^(id data) {
        NSLog(@"data == %@", data);
        
        if (_page == 0) {
            [self.dataArray removeAllObjects];
        }
        
        //JGHWithDrawModel
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            NSMutableArray *array = [NSMutableArray array];
            array = [data objectForKey:@"transDetailList"];
            for (NSMutableDictionary *dict in array) {
                JGHWithDrawModel *model = [[JGHWithDrawModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
            }
        }
        
        [self.tradRecordTableView reloadData];
        
        if (_page == 0) {
            [self.tradRecordTableView.header endRefreshing];
        }else {
            [self.tradRecordTableView.footer endRefreshing];
        }
        
        [[ShowHUD showHUD]hideAnimationFromView:self.view];
    }];
}

#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70 * ProportionAdapter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGHTradRecordCell *tradCell = [tableView dequeueReusableCellWithIdentifier:JGHTradRecordCellIdentifier];
    
    tradCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArray.count > 0) {
        [tradCell congifData:_dataArray[indexPath.section]];
    }
    
    
    return tradCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JGHWithdrawDetailsViewController *withdrawDetailsCtrl = [[JGHWithdrawDetailsViewController alloc]init];
    withdrawDetailsCtrl.model = _dataArray[indexPath.section];
    [self.navigationController pushViewController:withdrawDetailsCtrl animated:YES];
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
