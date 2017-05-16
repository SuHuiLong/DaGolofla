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
#import "JGDNewTeamDetailViewController.h"
#import "JGHNewActivityDetailViewController.h"
#import "JGTeamMainhallViewController.h"    // 大厅

#import "JGDCreatTeamViewController.h" // new
#import "UMMobClick/MobClick.h"

static NSString *const JGTeamActivityCellIdentifier = @"JGTeamActivityCell";
static NSString *const JGLMyTeamTableViewCellIdentifier = @"JGLMyTeamTableViewCell";
static NSString *const JGHShowMyTeamHeaderCellIdentifier = @"JGHShowMyTeamHeaderCell";
static NSString *const JGHAddMoreTeamTableViewCellIdentifier = @"JGHAddMoreTeamTableViewCell";

@interface JGHShowMyTeamViewController ()<UITableViewDelegate, UITableViewDataSource, JGHAddMoreTeamTableViewCellDelegate>
{
    NSArray *_titleArray;
    NSInteger _page;
}
@property (nonatomic, strong)UITableView *showMyTeamTableView;

@property (nonatomic, strong)NSMutableArray *teamArray;

@property (nonatomic, strong)NSMutableArray *activityArray;

@end

@implementation JGHShowMyTeamViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick event:@"teamHallKey"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.navigationItem.title = @"球队部落";
    self.teamArray = [NSMutableArray array];
    self.activityArray = [NSMutableArray array];
    _page = 0;
    _titleArray = @[@"我的球队", @"", @"我的球队活动"];
    
    UIBarButtonItem *createTeam = [[UIBarButtonItem alloc] initWithTitle:@"创建球队" style:(UIBarButtonItemStyleDone) target:self action:@selector(createTeam)];
    createTeam.tintColor = [UIColor whiteColor];
    [createTeam setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15 * ProportionAdapter], NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = createTeam;
    
    [self createHomeTableView];
    
    [self loadMyTeamList];
    
    [self loadMyActivityList];
}

//创建球队
- (void)createTeam{
    [MobClick event:@"team_create_click"];

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

    JGDCreatTeamViewController *createVC = [[JGDCreatTeamViewController alloc] init];
    
    if ([user objectForKey:@"cacheCreatTeamDic"]) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"是否继续上次编辑" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [user setObject:0 forKey:@"cacheCreatTeamDic"];

            [self.navigationController pushViewController:createVC animated:YES];
        }];
        
        UIAlertAction* action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            createVC.detailDic = [[user objectForKey:@"cacheCreatTeamDic"] mutableCopy];
            
            [self.navigationController pushViewController:createVC animated:YES];
        }];
        
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        [self.navigationController pushViewController:createVC animated:YES];
    }
    
    
}

#pragma mark -- 下载我的活动
- (void)loadMyActivityList{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];//3619
    [dict setObject:@(_page) forKey:@"offset"];

    [[JsonHttp jsonHttp]httpRequest:@"team/getMyTeamActivityList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        [self.showMyTeamTableView.mj_header endRefreshing];
        [self.showMyTeamTableView.mj_footer endRefreshing];
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
        [self.showMyTeamTableView.mj_header endRefreshing];
        [self.showMyTeamTableView.mj_footer endRefreshing];
    }];
}
#pragma mark -- 下载我的球队
- (void)loadMyTeamList{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:userID] forKey:@"userKey"];
    [dict setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]] forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getMyTeamListAll" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        [self.showMyTeamTableView.mj_header endRefreshing];
        [self.showMyTeamTableView.mj_footer endRefreshing];
    } completionBlock:^(id data) {
        [self.teamArray removeAllObjects];
        if ([[data objectForKey:@"packSuccess"] boolValue]) {
            
            if ([data objectForKey:@"teamList"]) {
                for (NSDictionary *dataDic in [data objectForKey:@"teamList"]) {
                    JGLMyTeamModel *model = [[JGLMyTeamModel alloc] init];
                    [model setValuesForKeysWithDictionary:dataDic];
                    [self.teamArray addObject:model];
                }
                
                [self.showMyTeamTableView reloadData];
            }
        }
        
        [self.showMyTeamTableView.mj_header endRefreshing];
        [self.showMyTeamTableView.mj_footer endRefreshing];
    }];
}

- (void)tapAvt{

    JGTeamMainhallViewController *teamMainCtrl = [[JGTeamMainhallViewController alloc]init];
    if (![Helper isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentCity"]]) {
        teamMainCtrl.strProvince = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentCity"];
    }
    [self.navigationController pushViewController:teamMainCtrl animated:YES];

}

#pragma mark -- 创建TableView
- (void)createHomeTableView{
    self.showMyTeamTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight -64) style:UITableViewStylePlain];
    
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
    self.showMyTeamTableView.mj_header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    self.showMyTeamTableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    
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
    }else if (section == 1){
        return 10 *ProportionAdapter;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10 *ProportionAdapter)];
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
        myTeamTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return myTeamTableViewCell;
    }else{
        JGTeamActivityCell *teamActivityCell = [tableView dequeueReusableCellWithIdentifier:JGTeamActivityCellIdentifier];
        [teamActivityCell setJGTeamActivityCellWithModel:_activityArray[indexPath.row] fromCtrl:1];
        teamActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return teamActivityCell;
    }
}
//Cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        return 100 *ProportionAdapter;
//    }else if (indexPath.section == 2){
//        return 81 *ProportionAdapter;
//    }
    return kHvertical(81);
}
//设置头部高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 60 *ProportionAdapter;
    }else if (section == 0 || section == 2){
        return 50 *ProportionAdapter;
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self teamAct:indexPath];
    } else if (indexPath.section == 2) {
        JGHNewActivityDetailViewController *actVC = [[JGHNewActivityDetailViewController alloc] init];
        JGTeamAcitivtyModel *model = _activityArray[indexPath.row];
        if (model.teamActivityKey > 0) {
            actVC.teamKey = model.teamActivityKey;
        }else{
            actVC.teamKey = [model.timeKey integerValue];
        }
        [self.navigationController pushViewController:actVC animated:YES];
    }
}

- (void)teamAct:(NSIndexPath *)indexPath{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userKey"];
    JGLMyTeamModel *model = _teamArray[indexPath.row];
    [dic setObject:@([model.teamKey integerValue]) forKey:@"teamKey"];
    
    JGDNewTeamDetailViewController *newTeamVC = [[JGDNewTeamDetailViewController alloc] init];
    newTeamVC.timeKey = model.teamKey;
    [self.navigationController pushViewController:newTeamVC animated:YES];
}

#pragma mark -- 添加更多球队
- (void)didSelectAddMoreBtn:(UIButton *)btn{
    NSLog(@"添加更多球队");
    btn.enabled = NO;
    [MobClick event:@"team_join_more_team_click"];
    JGTeamMainhallViewController *teamMainCtrl = [[JGTeamMainhallViewController alloc]init];
    if (![Helper isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentCity"]]) {
        teamMainCtrl.strProvince = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentCity"];
    }
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
