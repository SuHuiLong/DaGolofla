//
//  JGHSystemNotViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/11/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHSystemNotViewController.h"
#import "JGHSysInformCell.h"
#import "JGHInformModel.h"
#import "JGHNotDetailViewController.h"

static NSString *const JGHSysInformCellIdentifier = @"JGHSysInformCell";

@interface JGHSystemNotViewController ()<UITableViewDelegate, UITableViewDataSource>
{
//    NSInteger _selectCatory;//0-全选；1-取消全选
    NSInteger _page;
}

@property (nonatomic, retain)UITableView *systemNotTableView;

@property (nonatomic, retain)NSMutableArray *dataArray;

@end

@implementation JGHSystemNotViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"全选" style:UIBarButtonItemStylePlain target:self action:@selector(selectAllBtn)];
//    item.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = item;
    
//    _selectCatory = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"系统通知";
    
    self.dataArray = [NSMutableArray array];
    
    _page = 0;
    
    [self createSystemNotTableView];
    
    [self loadData];
}
#pragma mark -- 全选 取消全选
//- (void)selectAllBtn{
//    if (_selectCatory == 0) {
//        self.navigationItem.rightBarButtonItem.title = @"取消全选";
//        _selectCatory = 1;
//    }else{
//        self.navigationItem.rightBarButtonItem.title = @"全选";
//        _selectCatory = 0;
//    }
//}
#pragma mark -- 下载数据
- (void)loadData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //[Helper md5HexDigest:[NSString stringWithFormat:@"ballKey=%td&region1=%@&region2=%@dagolfla.com", ballKey, region1, region2]];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:@0 forKey:@"nSrc"];
    [dict setObject:@(_page) forKey:@"offset"];
    [dict setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@&nSrc=0dagolfla.com", DEFAULF_USERID]] forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"msg/getMsgList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        [self.systemNotTableView.header endRefreshing];
        [self.systemNotTableView.footer endRefreshing];
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if (_page == 0) {
            [self.dataArray removeAllObjects];
        }
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            NSArray *list = [data objectForKey:@"list"];
            for (int i=0; i<list.count; i++) {
                JGHInformModel *model = [[JGHInformModel alloc]init];
                [model setValuesForKeysWithDictionary:list[i]];
                [self.dataArray addObject:model];
            }
            
            [self.systemNotTableView reloadData];
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
        
        [self.systemNotTableView.header endRefreshing];
        [self.systemNotTableView.footer endRefreshing];
    }];
    
}
#pragma mark -- 创建TableView
- (void)createSystemNotTableView{
    self.systemNotTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight -64) style:UITableViewStylePlain];
    self.systemNotTableView.delegate = self;
    self.systemNotTableView.dataSource = self;
    [self.systemNotTableView registerClass:[JGHSysInformCell class] forCellReuseIdentifier:JGHSysInformCellIdentifier];
    
    self.systemNotTableView.header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    self.systemNotTableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    self.systemNotTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.systemNotTableView];
}
#pragma mark -- headRereshing
- (void)headRereshing{
    _page = 0;
    [self loadData];
}
#pragma mark -- footerRefreshing
- (void)footerRefreshing{
    _page++;
    [self loadData];
}
#pragma mark -- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGHInformModel *model = [[JGHInformModel alloc]init];
    model = _dataArray[indexPath.row];
    CGSize titleSize = [model.title boundingRectWithSize:CGSizeMake(screenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17*ProportionAdapter]} context:nil].size;
    
    CGSize contentSize = [model.content boundingRectWithSize:CGSizeMake(screenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15*ProportionAdapter]} context:nil].size;
    
    return 70 *ProportionAdapter + contentSize.height +titleSize.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGHSysInformCell *teamInformCell = [tableView dequeueReusableCellWithIdentifier:JGHSysInformCellIdentifier forIndexPath:indexPath];
    teamInformCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [teamInformCell configJGHSysInformCell:_dataArray[indexPath.row]];
    
    return teamInformCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JGHNotDetailViewController *noteCtrl = [[JGHNotDetailViewController alloc]init];
    noteCtrl.model = _dataArray[indexPath.row];
    [self.navigationController pushViewController:noteCtrl animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

    }
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
