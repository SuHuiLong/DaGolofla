//
//  JGTeamActivityViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/10.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamActivityViewController.h"
#import "JGTeamAcitivtyModel.h"
#import "JGTeamActivityCell.h"
#import "JGTeamActibityNameViewController.h"
#import "JGHLaunchActivityViewController.h"
#import "JGTeamGroupViewController.h"
#import "JGTeamApplyViewController.h"

#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"

@interface JGTeamActivityViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *teamActivityTableView;
@property (nonatomic, strong)NSMutableArray *dataArray;//数据模型数组
@property (nonatomic, assign)NSInteger page;

@end

@implementation JGTeamActivityViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}

- (instancetype)init{
    if (self = [super init]) {
        self.dataArray = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"球队活动";
    self.page = 1;
    [self createTeamActivityTabelView];
    
//    self.isAdmin = @"0";
//    //判断权限
//    if ([self.isAdmin isEqualToString:@"0"]) {
    [self createAdminBtn];
//    }
    
    [self loadData];
    
    [self loadTestData];
}

- (void)loadTestData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"/team/11010.png" forKey:@"data"];
    [dict setObject:@"1" forKey:@"mType"];
    [dict setObject:@"1000" forKey:@"tag"];
    

}

- (void)loadData{
    //获取球队活动
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    //244  121212
    [dict setObject:[def objectForKey:@"userId"] forKey:@"userKey"];//3619
    //189781710290821120  http://192.168.2.6:8888
//    [dict setObject:@"192" forKey:@"teamKey"];
    [dict setObject:@"0" forKey:@"offset"];
    
    [[JsonHttp jsonHttp]httpRequest:@"team/getMyTeamActivityList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"errType == %@", errType);
    } completionBlock:^(id data) {
        NSLog(@"data == %@", data);
        [self.dataArray removeAllObjects];
        
        NSArray *array = [data objectForKey:@"activityList"];
        NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
        
        for (NSDictionary *dict in array) {
            JGTeamAcitivtyModel *model = [[JGTeamAcitivtyModel alloc]init];
            
            [model setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:model];
        }
        
        [self.teamActivityTableView reloadData];
    }];
}

#pragma mark -- 创建发布活动
- (void)createAdminBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = RightNavItemFrame;
    btn.titleLabel.font = [UIFont systemFontOfSize:FontSize_Normal];
    [btn setTitle:@"发布活动" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(launchActivityBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
#pragma mark -- 发布球队活动
- (void)launchActivityBtnClick:(UIButton *)btn{
    JGHLaunchActivityViewController * launchCtrl = [[JGHLaunchActivityViewController alloc]init];
    [self.navigationController pushViewController:launchCtrl animated:YES];
}
#pragma mark -- 创建TableView
- (void)createTeamActivityTabelView{
    self.teamActivityTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStyleGrouped];
    self.teamActivityTableView.delegate = self;
    self.teamActivityTableView.dataSource = self;
    self.teamActivityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.teamActivityTableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    self.teamActivityTableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
//    self.teamActivityTableView.header beginRefreshing];
    
    [self.view addSubview:self.teamActivityTableView];
}

#pragma mark 开始进入刷新状态
- (void)headRereshing
{
    self.page = 0;
    [self downLoadData:self.page isReshing:YES];
}

- (void)footRereshing
{
    [self downLoadData:self.page isReshing:NO];
}

#pragma mark - 下载数据
- (void)downLoadData:(NSInteger)page isReshing:(BOOL)isReshing{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [dict setObject:[def objectForKey:@"userId"] forKey:@"userKey"];//3619
    [dict setObject:@(self.page) forKey:@"offset"];
    
    [[JsonHttp jsonHttp]httpRequest:@"team/getMyTeamActivityList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [self.teamActivityTableView.header endRefreshing];
        }else {
            [self.teamActivityTableView.footer endRefreshing];
        }
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            if (page == 0)
            {
                //清除数组数据
                [self.dataArray removeAllObjects];
            }
            if ([data objectForKey:@"activityList"]) {
                NSArray *array = [data objectForKey:@"activityList"];
                for (NSDictionary *dict in array) {
                    JGTeamAcitivtyModel *model = [[JGTeamAcitivtyModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.dataArray addObject:model];
                }
                self.page++;
                
                [self.teamActivityTableView reloadData];
            }else{
                [Helper alertViewWithTitle:@"没有更多活动" withBlock:^(UIAlertController *alertView) {
                    [self presentViewController:alertView animated:YES completion:nil];
                }];
            }

        }else {
            
            [Helper alertViewWithTitle:@"获取失败" withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
        [self.teamActivityTableView reloadData];
        if (isReshing) {
            [self.teamActivityTableView.header endRefreshing];
        }else {
            [self.teamActivityTableView.footer endRefreshing];
        }
    }];
}


#pragma mark -- tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *teamActivityCellID = @"JGTeamActivityCell";
    JGTeamActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:teamActivityCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JGTeamActivityCell" owner:self options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JGTeamAcitivtyModel *model = [[JGTeamAcitivtyModel alloc]init];
    model = self.dataArray[indexPath.section];
    [cell setJGTeamActivityCellWithModel:model];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JGTeamActibityNameViewController *activityNameCtrl = [[JGTeamActibityNameViewController alloc]init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    JGTeamAcitivtyModel *model = self.dataArray[indexPath.section];
    [dict setObject:@(model.teamActivityKey) forKey:@"activityKey"];
    [[NSUserDefaults standardUserDefaults]setObject:@(model.teamActivityKey) forKey:@"activityKey"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", (long)model.teamKey] forKey:TeamKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId" ] forKey:@"userKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamActivity" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
     
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:[[data objectForKey:TeamMember] objectForKey:@"power"] forKey:TeamMember];
            [user synchronize];

            JGTeamAcitivtyModel *model = [[JGTeamAcitivtyModel alloc] init];
            [model setValuesForKeysWithDictionary:[data objectForKey:@"activity"]];
            activityNameCtrl.model = model;
            [self.navigationController pushViewController:activityNameCtrl animated:YES];
          }else {
             [Helper alertViewWithTitle:@"获取失败" withBlock:^(UIAlertController *alertView) {
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
     }];
    
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
