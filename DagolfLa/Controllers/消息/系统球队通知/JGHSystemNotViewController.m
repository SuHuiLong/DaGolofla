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

static NSString *const JGHSysInformCellIdentifier = @"JGHSysInformCell";

@interface JGHSystemNotViewController ()<UITableViewDelegate, UITableViewDataSource>
{
//    NSInteger _selectCatory;//0-全选；1-取消全选
    NSInteger _page;
    
    UILabel *_promptLable;//无数据提示语
}

@property (nonatomic, retain)UITableView *systemNotTableView;

@property (nonatomic, retain)NSMutableArray *dataArray;

@end

@implementation JGHSystemNotViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)backButtonClcik{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [_promptLable removeFromSuperview];
    
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
#pragma mark -- 下载数据
- (void)loadData{

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
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
        
        if (self.dataArray.count == 0) {
            self.systemNotTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            if (_promptLable != nil) {
                [_promptLable removeFromSuperview];
                _promptLable = nil;
            }
            
            _promptLable = [[UILabel alloc]initWithFrame:CGRectMake(0, (screenHeight/2)-10*ProportionAdapter, screenWidth, 20 *ProportionAdapter)];
            
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            _promptLable.center = window.center;
            _promptLable.font = [UIFont systemFontOfSize:16*ProportionAdapter];
            _promptLable.textAlignment = NSTextAlignmentCenter;
            _promptLable.text = @"暂无系统通知";
            [self.systemNotTableView addSubview:_promptLable];
        }else{
            self.systemNotTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            if (_promptLable != nil) {
                [_promptLable removeFromSuperview];
                _promptLable = nil;
            }
        }
        
        [self.systemNotTableView.header endRefreshing];
        [self.systemNotTableView.footer endRefreshing];
    }];
    
}
#pragma mark -- 创建TableView
- (void)createSystemNotTableView{
    self.systemNotTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight -64) style:UITableViewStylePlain];
    self.systemNotTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.systemNotTableView.delegate = self;
    self.systemNotTableView.dataSource = self;
    [self.systemNotTableView registerClass:[JGHSysInformCell class] forCellReuseIdentifier:JGHSysInformCellIdentifier];
    
    UIView *CCCView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 10 * ProportionAdapter)];
    CCCView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    self.systemNotTableView.tableHeaderView = CCCView;
    
    
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
//    CGSize titleSize = [model.title boundingRectWithSize:CGSizeMake(screenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17*ProportionAdapter]} context:nil].size;
    CGSize contentSize;

    if (model.linkURL) {
        
        contentSize = [[NSString stringWithFormat:@"    %@", model.content] boundingRectWithSize:CGSizeMake(screenWidth -50 *ProportionAdapter, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15*ProportionAdapter]} context:nil].size;

        
    }else{
        contentSize = [[NSString stringWithFormat:@"    %@", model.content] boundingRectWithSize:CGSizeMake(screenWidth -30 *ProportionAdapter, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15*ProportionAdapter]} context:nil].size;

        
    }

    
    return 60 *ProportionAdapter + contentSize.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGHSysInformCell *teamInformCell = [tableView dequeueReusableCellWithIdentifier:JGHSysInformCellIdentifier forIndexPath:indexPath];
    teamInformCell.selectionStyle = UITableViewCellSelectionStyleNone;

    JGHInformModel *model = _dataArray[indexPath.row];

    [teamInformCell configJGHSysInformCell:_dataArray[indexPath.row]];
    
    if (model.linkURL) {
        teamInformCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIImageView *accImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10 * ProportionAdapter, 12 * ProportionAdapter)];
        accImageV.image = [UIImage imageNamed:@"more"];
        teamInformCell.accessoryView = accImageV;
        
    }else{
        teamInformCell.accessoryType = UITableViewCellAccessoryNone;
        
    }

    
    return teamInformCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [LQProgressHud showLoading:@"加载中..."];
        JGHInformModel *model = [[JGHInformModel alloc]init];
        model = self.dataArray[indexPath.row];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSMutableArray *keyList = [NSMutableArray array];
        [keyList addObject:model.timeKey];
        [dict setObject:keyList forKey:@"keyList"];
        [dict setObject:DEFAULF_USERID forKey:@"userKey"];
        [[JsonHttp jsonHttp]httpRequestWithMD5:@"msg/batchDeleteMsg" JsonKey:nil withData:dict failedBlock:^(id errType) {
            [LQProgressHud hide];
        } completionBlock:^(id data) {
            NSLog(@"%@", data);
            [LQProgressHud hide];
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                [self loadData];
                [self.dataArray removeObjectAtIndex:indexPath.row];
                [self.systemNotTableView reloadData];
            }else{
                if ([data objectForKey:@"packResultMsg"]) {
                    [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                }
            }
        }];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JGHInformModel *model = _dataArray[indexPath.row];
    
    if ([model.linkURL containsString:@"dagolfla://"]) {
        
        __weak JGHSystemNotViewController *weakSelf = self;
        [[JGHPushClass pushClass] URLString:model.linkURL pushVC:^(UIViewController *vc) {
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
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
