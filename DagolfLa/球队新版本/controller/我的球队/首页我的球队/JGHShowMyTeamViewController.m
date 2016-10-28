//
//  JGHShowMyTeamViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/27.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHShowMyTeamViewController.h"
#import "JGTeamActivityCell.h"
#import "JGLMyTeamTableViewCell.h"
#import "JGHShowMyTeamHeaderCell.h"
#import "JGHAddMoreTeamTableViewCell.h"
#import "JGLMyTeamModel.h"
#import "JGTeamAcitivtyModel.h"
#import "JGDGuestChannelViewController.h"
#import "JGTeamChannelViewController.h"

static NSString *const JGTeamActivityCellIdentifier = @"JGTeamActivityCell";
static NSString *const JGLMyTeamTableViewCellIdentifier = @"JGLMyTeamTableViewCell";
static NSString *const JGHShowMyTeamHeaderCellIdentifier = @"JGHShowMyTeamHeaderCell";
static NSString *const JGHAddMoreTeamTableViewCellIdentifier = @"JGHAddMoreTeamTableViewCell";

@interface JGHShowMyTeamViewController ()<UITableViewDelegate, UITableViewDataSource, JGHShowMyTeamHeaderCellDelegate, JGHAddMoreTeamTableViewCellDelegate>
{
    NSArray *_titleArray;
    NSInteger _page;
}
@property (nonatomic, strong)UITableView *showMyTeamTableView;

@property (nonatomic, strong)NSMutableArray *teamArray;

@property (nonatomic, strong)NSMutableArray *activityArray;

@end

@implementation JGHShowMyTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"球队部落";
    self.teamArray = [NSMutableArray array];
    self.activityArray = [NSMutableArray array];
    _page = 0;
    _titleArray = @[@"我的球队", @"", @"我的球队活动"];
    
    [self createHomeTableView];
    
    [self loadMyTeamList];
    
    [self loadMyActivityList];
}
#pragma mark -- 下载我的活动
- (void)loadMyActivityList{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];//3619
    [dict setObject:@(_page) forKey:@"offset"];
    [dict setObject:[NSString stringWithFormat:@"%@", _timeKey] forKey:@"teamKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getMyTeamActivityAll" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        [self.showMyTeamTableView.header endRefreshing];
        [self.showMyTeamTableView.footer endRefreshing];
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            if (_page == 0)
            {
                //清除数组数据
                [self.activityArray removeAllObjects];
            }
            if ([data objectForKey:@"activityList"]) {
                NSArray *array = [data objectForKey:@"activityList"];
                for (NSDictionary *dict in array) {
                    JGTeamAcitivtyModel *model = [[JGTeamAcitivtyModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.activityArray addObject:model];
                }
                _page++;
                
            }
        }
        
        [self.showMyTeamTableView reloadData];
        [self.showMyTeamTableView.header endRefreshing];
        [self.showMyTeamTableView.footer endRefreshing];
    }];
}
#pragma mark -- 下载我的球队
- (void)loadMyTeamList{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
    [dict setObject:@0 forKey:@"offset"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getMyTeamList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        [self.showMyTeamTableView.header endRefreshing];
        [self.showMyTeamTableView.footer endRefreshing];
    } completionBlock:^(id data) {
        [self.teamArray removeAllObjects];
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            for (NSDictionary *dataDic in [data objectForKey:@"teamList"]) {
                JGLMyTeamModel *model = [[JGLMyTeamModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDic];
                [self.teamArray addObject:model];
            }
        }
//        else {
//            if ([data objectForKey:@"packResultMsg"]) {
//                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
//            }
//        }
        
        [self.showMyTeamTableView reloadData];
        [self.showMyTeamTableView.header endRefreshing];
        [self.showMyTeamTableView.footer endRefreshing];
    }];
}
#pragma mark -- 创建TableView
- (void)createHomeTableView{
    self.showMyTeamTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight -44)];
    
    UINib *teamActivityCellNib = [UINib nibWithNibName:@"JGTeamActivityCell" bundle: [NSBundle mainBundle]];
    [self.showMyTeamTableView registerNib:teamActivityCellNib forCellReuseIdentifier:JGTeamActivityCellIdentifier];
    
    UINib *showMyTeamHeaderCellNib = [UINib nibWithNibName:@"JGHShowMyTeamHeaderCell" bundle: [NSBundle mainBundle]];
    [self.showMyTeamTableView registerNib:showMyTeamHeaderCellNib forCellReuseIdentifier:JGHShowMyTeamHeaderCellIdentifier];
    
    UINib *addMoreTeamTableViewCellNib = [UINib nibWithNibName:@"JGHAddMoreTeamTableViewCell" bundle: [NSBundle mainBundle]];
    [self.showMyTeamTableView registerNib:addMoreTeamTableViewCellNib forCellReuseIdentifier:JGHAddMoreTeamTableViewCellIdentifier];
    
    [self.showMyTeamTableView registerClass:[JGLMyTeamTableViewCell class] forCellReuseIdentifier:JGLMyTeamTableViewCellIdentifier];
    
    self.showMyTeamTableView.dataSource = self;
    self.showMyTeamTableView.delegate = self;
    self.showMyTeamTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.showMyTeamTableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    self.showMyTeamTableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    
    self.showMyTeamTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self.view addSubview:self.showMyTeamTableView];
}
- (void)headRereshing{
    _page = 0;
    [self loadMyActivityList];
    [self loadMyTeamList];
}
- (void)footRereshing{
    [self loadMyActivityList];
}
#pragma mark - UITableViewDataSource 协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //    return _dataArray.count +1;
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _teamArray.count;//我的球队
    }else if (section == 2){
        return _activityArray.count;//我的活动
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 10 *ProportionAdapter;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10)];
    footView.backgroundColor = [UIColor colorWithHexString:BG_color];
    return footView;
}
//组头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        JGHAddMoreTeamTableViewCell *addMoreTeamTableViewCell = [tableView dequeueReusableCellWithIdentifier:JGHAddMoreTeamTableViewCellIdentifier];
        addMoreTeamTableViewCell.delegate = self;
        return addMoreTeamTableViewCell;
    }else{
        JGHShowMyTeamHeaderCell *showMyTeamHeaderCell = [tableView dequeueReusableCellWithIdentifier:JGHShowMyTeamHeaderCellIdentifier];
        showMyTeamHeaderCell.delegate = self;
        [showMyTeamHeaderCell configJGHShowMyTeamHeaderCell:_titleArray[section] andSection:section];
        return showMyTeamHeaderCell;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGLMyTeamTableViewCell *myTeamTableViewCell = [tableView dequeueReusableCellWithIdentifier:JGLMyTeamTableViewCellIdentifier];
        if (_teamArray.count > 0) {
            [myTeamTableViewCell newShowData:_teamArray[indexPath.row]];
        }
        
        return myTeamTableViewCell;
    }else{
        JGTeamActivityCell *teamActivityCell = [tableView dequeueReusableCellWithIdentifier:JGTeamActivityCellIdentifier];
        [teamActivityCell setJGTeamActivityCellWithModel:_activityArray[indexPath.row] fromCtrl:1];
        return teamActivityCell;
    }
}
//Cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100 *ProportionAdapter;
    }else if (indexPath.section == 2){
        return 80 *ProportionAdapter;
    }
    return 0;
}
//设置头部高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 40 *ProportionAdapter;
    }
    return 45 *ProportionAdapter;
}
#pragma mark -- 嘉宾通道
- (void)didSelectGuestsBtn:(UIButton *)guestbtn{
    NSLog(@"嘉宾通道");
    guestbtn.enabled = NO;
    JGDGuestChannelViewController *guestChanneCtrl = [[JGDGuestChannelViewController alloc]init];
    [self.navigationController pushViewController:guestChanneCtrl animated:YES];
    guestbtn.enabled = YES;
}

#pragma mark -- 添加更多球队
- (void)didSelectAddMoreBtn:(UIButton *)btn{
    NSLog(@"添加更多球队");
    btn.enabled = NO;
    JGTeamChannelViewController *teamMainCtrl = [[JGTeamChannelViewController alloc]init];
    [self.navigationController pushViewController:teamMainCtrl animated:YES];
    btn.enabled = YES;
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
