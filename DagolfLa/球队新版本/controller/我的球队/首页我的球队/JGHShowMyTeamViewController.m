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

#import "JGDNewTeamDetailViewController.h"
#import "JGTeamActibityNameViewController.h" 
#import "JGTeamMainhallViewController.h"    // 大厅

#import "JGNewCreateTeamTableViewController.h"
#import "UMMobClick/MobClick.h"

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

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    if ([user objectForKey:@"cacheCreatTeamDic"]) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"是否继续上次编辑" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [user setObject:0 forKey:@"cacheCreatTeamDic"];
            JGNewCreateTeamTableViewController *creatteamVc = [[JGNewCreateTeamTableViewController alloc] init];
            [self.navigationController pushViewController:creatteamVc animated:YES];
        }];
        UIAlertAction* action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            JGNewCreateTeamTableViewController *creatteamVc = [[JGNewCreateTeamTableViewController alloc] init];
            creatteamVc.detailDic = [user objectForKey:@"cacheCreatTeamDic"];
            creatteamVc.titleField.text = [[user objectForKey:@"cacheCreatTeamDic"] objectForKey:@"name"];
            
            [self.navigationController pushViewController:creatteamVc animated:YES];
        }];
        
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        JGNewCreateTeamTableViewController *creatteamVc = [[JGNewCreateTeamTableViewController alloc] init];
        [self.navigationController pushViewController:creatteamVc animated:YES];
    }
    
    
}

#pragma mark -- 下载我的活动
- (void)loadMyActivityList{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];//3619
    [dict setObject:@(_page) forKey:@"offset"];
    [dict setObject:[NSString stringWithFormat:@"%@", _timeKey] forKey:@"teamKey"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getMyTeamActivityList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
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
    [dict setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]] forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getMyTeamListAll" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        [self.showMyTeamTableView.header endRefreshing];
        [self.showMyTeamTableView.footer endRefreshing];
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
            }else{
                [self.showMyTeamTableView removeFromSuperview];
                self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
                UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(134 * ProportionAdapter, 105 * ProportionAdapter, 107 * ProportionAdapter, 107 * ProportionAdapter)];
                imageV.image = [UIImage imageNamed:@"bg-shy"];
                [self.view addSubview:imageV];
                
                UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(100 * ProportionAdapter, 251 * ProportionAdapter, 200 * ProportionAdapter, 30 * ProportionAdapter)];
                label1.text = @"您还没有自己的球队哦";
                label1.font = [UIFont systemFontOfSize:18 * ProportionAdapter];
                label1.textColor = [UIColor colorWithHexString:@"a0a0a0"];
                [self.view addSubview:label1];
                
                UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20 * ProportionAdapter, 300 * ProportionAdapter, screenWidth - 40 * ProportionAdapter, 80 * ProportionAdapter)];
                label2.textColor = [UIColor colorWithHexString:@"a0a0a0"];
                label2.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
                NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:@"您可以点击右上角创建自己的球队，也可到球队大厅快速加入别人的球队！"];
                [attriString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18 * ProportionAdapter] range:NSMakeRange(19, 4)];
                [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#32b148"] range:NSMakeRange(19, 4)];
                label2.attributedText = attriString;
                label2.numberOfLines = 0;
                [self.view addSubview:label2];
                
                UITapGestureRecognizer *gapVC = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvt)];
                [label2 addGestureRecognizer:gapVC];
                label2.userInteractionEnabled = YES;
            }
            
            
            
        }
//        else {
//            if ([data objectForKey:@"packResultMsg"]) {
//                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
//            }
//        }
        
        
        [self.showMyTeamTableView.header endRefreshing];
        [self.showMyTeamTableView.footer endRefreshing];
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
    self.showMyTeamTableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    self.showMyTeamTableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    
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
        JGTeamActibityNameViewController *actVC = [[JGTeamActibityNameViewController alloc] init];
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
    
//    [[JsonHttp jsonHttp] httpRequest:@"team/getTeamInfo" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
//        [Helper alertViewNoHaveCancleWithTitle:@"获取球队信息失败" withBlock:^(UIAlertController *alertView) {
//            [self.navigationController presentViewController:alertView animated:YES completion:nil];
//        }];
//        
//    } completionBlock:^(id data) {
//        
//        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
//            JGTeamMemberORManagerViewController *detailVC = [[JGTeamMemberORManagerViewController alloc] init];
//            if ([[[data objectForKey:@"teamMember"] objectForKey:@"power"] containsString:@"1005"]){
//                detailVC.detailDic = [data objectForKey:@"team"];
//                //                detailVC.detailModel.manager = 1;
//                detailVC.isManager = YES;
//                
//                [self.navigationController pushViewController:detailVC animated:YES];
//            }else{
//                
//                detailVC.detailDic = [data objectForKey:@"team"];
//                //                detailVC.detailModel.manager = 0;
//                detailVC.isManager = NO;
//                
//                [self.navigationController pushViewController:detailVC animated:YES];
//            }
//            
//        }else{
//            if ([data objectForKey:@"packResultMsg"]) {
//                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
//            }
//        }
//        
//    }];
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
    [MobClick event:@"teamLobby"];
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
