//
//  JGTeamChannelViewController.m
//  DagolfLa
//
//  Created by 東 on 16/5/10.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamChannelViewController.h"
#import "JGTeamChannelTableView.h"
#import "JGTeamChannelTableViewCell.h"
#import "JGTeamDetailViewController.h"
#import "JGTeamMainhallViewController.h"
#import "JGTeamDetailStylelTwoViewController.h"
#import "JGApplyMaterialViewController.h"
#import "JGTeamDetailViewController.h"
#import "JGTeamChannelActivityTableViewCell.h"
#import "JGTeamActivityViewController.h"
#import "JGLMyTeamViewController.h"
#import "JGTeamAcitivtyModel.h"
#import "JGTeamDetail.h"
#import "JGTeamActivityCell.h"
#import "JGHNewActivityDetailViewController.h"
#import "JGDNewTeamDetailViewController.h"
#import "JGTeamActivityCell.h"
#import <CoreLocation/CLLocation.h>

#import "HomeHeadView.h"  // topscrollView
#import "ChangePicModel.h"
#import "UseMallViewController.h"

#import "JGActivityMemNonMangerViewController.h" //test
//#import "JGDGuestChannelViewController.h"
//#import "JGHEventViewController.h"


@interface JGTeamChannelViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UIImageView *topView;
@property (nonatomic, strong)HomeHeadView *topScrollView;
@property (nonatomic, strong)NSMutableArray *scrillViewArray;

@property (nonatomic, strong)JGTeamChannelTableView *tableView;
@property (nonatomic, strong)NSMutableArray *buttonArray;

@property (nonatomic, strong)NSMutableArray *teamArray;
@property (nonatomic, strong)NSMutableArray *myTeamArray;
@property (nonatomic, strong)NSMutableArray *myActivityArray;
@property (nonatomic, strong)UILabel *titleLB;
@property (nonatomic, strong)UIView *topBackView;

@property (assign, nonatomic) NSInteger page;

@end

@implementation JGTeamChannelViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //    self.view.backgroundColor = [UIColor lightGrayColor];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    self.automaticallyAdjustsScrollViewInsets=NO;
    _page = 0;

    self.topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 360 * screenWidth / 320)];
    self.topBackView.userInteractionEnabled = YES;
    self.topBackView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [self.view addSubview:self.topBackView];
    
    UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    backBtn.frame = CGRectMake(0 , 20, 30 * screenWidth / 320, 30 * screenWidth / 320);
    [backBtn addTarget:self action:@selector(backBut) forControlEvents:(UIControlEventTouchUpInside)];
    [backBtn setImage:[UIImage imageNamed:@"backL"] forState:(UIControlStateNormal)];
    
    UIButton *creatTeam = [UIButton buttonWithType:(UIButtonTypeCustom)];
    creatTeam.frame = CGRectMake(screenWidth - 80 * screenWidth / 320 , 20 * screenWidth / 320, 80 * screenWidth / 320, 30 * screenWidth / 320);
    [creatTeam addTarget:self action:@selector(creatTeam) forControlEvents:(UIControlEventTouchUpInside)];
    [creatTeam setTitle:@"创建球队" forState:(UIControlStateNormal)];
    creatTeam.titleLabel.font = [UIFont systemFontOfSize:15  * screenWidth / 320];
    
    self.topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 160 * screenWidth / 320)];
    self.topView.image = [UIImage imageNamed:@"jianbian"];
    self.topView.userInteractionEnabled = YES;
//    [self.view addSubview:self.topView];
    [self.topView addSubview:backBtn];
    [self.topView addSubview:creatTeam];
    
    self.topScrollView = [[HomeHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 160 * screenWidth / 320)];
    self.topScrollView.userInteractionEnabled = YES;
    
    [self creatCro];
    [self.topBackView addSubview:self.topScrollView];
    
    //渐变图
    UIImageView *gradientImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 60 * screenWidth / 320)];
    [gradientImage setImage:[UIImage imageNamed:@"jianbian"]];
    gradientImage.userInteractionEnabled = YES;
    [self.topScrollView addSubview:gradientImage];
    
    [gradientImage addSubview:backBtn];
    [gradientImage addSubview:creatTeam];
    
    self.buttonArray = [NSMutableArray arrayWithObjects:@"我的球队", @"我的活动", @"球队大厅", nil];
    
    for (int i = 0; i < 3; i ++) {
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(0, 175 * screenWidth / 320 + i * 50 * screenWidth / 320, screenWidth, 40 * screenWidth / 320);
        button.tag = 200 + i;
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font =[UIFont systemFontOfSize:15 * screenWidth / 320];

        [button addTarget:self action:@selector(team:) forControlEvents:(UIControlEventTouchUpInside)];
        [button setTitle:self.buttonArray[i] forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [button setImage:[UIImage imageNamed:@")"] forState:(UIControlStateNormal)];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 300 * screenWidth / 320, 0, 0);
        //        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 200 * screenWidth / 320);
        [self.topBackView addSubview:button];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10 * screenWidth / 320, 10 * screenWidth / 320, 20 * screenWidth / 320, 20 * screenWidth / 320)];
        NSArray *arra = [NSArray arrayWithObjects:@"qd", @"hd-1", @"dt", nil];
        imageV.image = [UIImage imageNamed:arra[i]];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        [button addSubview:imageV];
    }
    
    self.tableView = [[JGTeamChannelTableView alloc] initWithFrame:CGRectMake(0, 0 * screenWidth / 320, screenWidth, screenHeight) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.tableView.separatorStyle = UITableViewCellAccessoryDisclosureIndicator;
    self.tableView.rowHeight = 80 * screenWidth / 320;
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableHeaderView = self.topBackView;
    self.tableView.mj_header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    [self.tableView.mj_header beginRefreshing];
    [self.view addSubview:self.tableView];
    
    [self setData];
    
    UIImageView *blueImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10 * screenWidth / 320, 332 * screenWidth / 320, 5 * screenWidth / 320, 16 * screenWidth / 320)];
    blueImageV.backgroundColor = [UIColor colorWithRed:0.5 green:0.76 blue:1.0 alpha:1.0];
    [self.topBackView addSubview:blueImageV];
    
    self.titleLB = [[UILabel alloc] initWithFrame:CGRectMake(25, 320 * screenWidth / 320, screenWidth / 2, 40 * screenWidth / 320)];
    [self.topBackView addSubview:self.titleLB];
    
    //  嘉宾通道
    UIButton *guestBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    guestBtn.frame = CGRectMake(280 * ProportionAdapter, 330 * screenWidth / 320, 80 * ProportionAdapter, 20 * screenWidth / 320);
    [guestBtn setTitle:@"嘉宾通道" forState:(UIControlStateNormal)];
    guestBtn.titleLabel.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
    [guestBtn setTitleColor:[UIColor colorWithHexString:@"#32b14d"] forState:(UIControlStateNormal)];
    guestBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 70 * ProportionAdapter, 0, 0);
    guestBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10 * ProportionAdapter);
    [guestBtn setImage:[UIImage imageNamed:@"sildRight"] forState:(UIControlStateNormal)];
    [guestBtn addTarget:self action:@selector(guestAct) forControlEvents:(UIControlEventTouchUpInside)];
    [self.topBackView addSubview:guestBtn];
    // Do any additional setup after loading the view.
}

- (void)guestAct{
//    JGDGuestChannelViewController *guestVC = [[JGDGuestChannelViewController alloc] init];
//    [self.navigationController pushViewController:guestVC animated:YES];
}

#pragma mark ---刷新
// 刷新
- (void)headRereshing
{
    [self downLoadData:_page isReshing:YES];
}

- (void)footRereshing
{
    [self downLoadData:_page isReshing:NO];
}

#pragma mark - 下载数据
- (void)downLoadData:(NSInteger)page isReshing:(BOOL)isReshing{
    
    if ([self.myTeamArray count] != 0) {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:[NSNumber numberWithInteger:page] forKey:@"offset"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getMyTeamActivityAll" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_tableView.mj_header endRefreshing];
        }else {
            [_tableView.mj_footer endRefreshing];
        }
    } completionBlock:^(id data) {
        if ([data objectForKey:@"teamList"]) {
            if (page == 0)
            {
                //清除数组数据
                [self.myActivityArray removeAllObjects];
            }
            
            for (NSDictionary *dicModel in data[@"activityList"]) {
                JGTeamAcitivtyModel *model = [[JGTeamAcitivtyModel alloc] init];
                [model setValuesForKeysWithDictionary:dicModel];
                [self.myActivityArray addObject:model];
            }
            [self.tableView reloadData];
            
//            [self.myActivityArray addObjectsFromArray:[data objectForKey:@"teamList"]];
            
            _page++;
            [_tableView reloadData];
        }else {
            //            [Helper alertViewWithTitle:@"没有更多球队" withBlock:^(UIAlertController *alertView) {
            //                [self presentViewController:alertView animated:YES completion:nil];
            //            }];
        }
        [_tableView reloadData];
        if (isReshing) {
            [_tableView.mj_header endRefreshing];
        }else {
            [_tableView.mj_footer endRefreshing];
        }
    }];
    }else{
        if (isReshing) {
            [_tableView.mj_header endRefreshing];
        }else {
            [_tableView.mj_footer endRefreshing];
        }
    }
}


- (void)creatCro{
  
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@1 forKey:@"nPos"];
    [dict setValue:@0 forKey:@"nType"];
    [dict setValue:@0 forKey:@"page"];
    [dict setValue:@20 forKey:@"rows"];

    [[JsonHttp jsonHttp] httpRequest:@"adv/getAdvertList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            
            NSMutableArray* arrayIcon = [[NSMutableArray alloc]init];
            NSMutableArray* arrayUrl = [[NSMutableArray alloc]init];
            NSMutableArray* arrayTitle = [[NSMutableArray alloc]init];
            NSMutableArray* arrayTs = [[NSMutableArray alloc]init];
            for (NSDictionary *dataDict in [data objectForKey:@"advList"]) {
                
                [arrayIcon addObject: [dataDict objectForKey:@"timeKey"]];
                [arrayUrl addObject: [dataDict objectForKey:@"linkaddr"]];
                [arrayTitle addObject: [dataDict objectForKey:@"title"]];
                NSLog(@"%@", [dataDict objectForKey:@"ts"]);
                NSLog(@"%f", [Helper stringConversionToDate:[dataDict objectForKey:@"ts"]]);
                [arrayTs addObject:@([Helper stringConversionToDate:[dataDict objectForKey:@"ts"]])];
            }
            
            if ([arrayIcon count] != 0) {
                
                [self.topScrollView config:arrayIcon data:arrayUrl title:arrayTitle ts:arrayTs];
                self.topScrollView.delegate = self;
                
                __weak JGTeamChannelViewController *weakSelf = self;
                [self.topScrollView setClick:^(NSString *urlString) {
//                    weakSelf.hidesBottomBarWhenPushed = YES;
//                    [weakSelf.navigationController pushViewController:vc animated:YES];
                    
                    if ([urlString containsString:@"dagolfla://"]) {
                        [[JGHPushClass pushClass]URLString:urlString pushVC:^(UIViewController *vc) {
                            vc.hidesBottomBarWhenPushed = YES;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        }];
                    }else{
                        UseMallViewController* userVc = [[UseMallViewController alloc]init];
                        userVc.linkUrl = urlString;
                        [weakSelf.navigationController pushViewController:userVc animated:YES];
                    }
                }];
            }

        }
        
    }];

}


- (void)setData{
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {

    NSMutableDictionary *getMyTeam = [NSMutableDictionary dictionary];
    [getMyTeam setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userKey"];
    [getMyTeam setValue:@0 forKey:@"offset"];
    [[JsonHttp jsonHttp] httpRequest:@"team/getMyTeamList" JsonKey:nil withData:getMyTeam requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"%@", errType);
    } completionBlock:^(id data) {

        self.myTeamArray =  [data[@"teamList"] mutableCopy];
        
        if ([self.myTeamArray count] != 0) {
            self.titleLB.text = @" 近期活动";
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:DEFAULF_USERID forKey:@"userKey"];
            [dic setValue:@0 forKey:@"offset"];

            [[JsonHttp jsonHttp] httpRequest:@"team/getMyTeamActivityAll" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
                [Helper alertViewNoHaveCancleWithTitle:@"获取活动列表失败" withBlock:^(UIAlertController *alertView) {
                    [self.navigationController presentViewController:alertView animated:YES completion:nil];
                }];
            } completionBlock:^(id data) {
                
                for (NSDictionary *dicModel in data[@"activityList"]) {
                    JGTeamAcitivtyModel *model = [[JGTeamAcitivtyModel alloc] init];
                    [model setValuesForKeysWithDictionary:dicModel];
                    [self.myActivityArray addObject:model];
                }
                [self.tableView reloadData];
            }];
        }else{
            self.titleLB.text = @" 推荐球队";
            NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if ([user objectForKey:@"lng"]) {
                [dic setObject:[user objectForKey:@"lng"] forKey:@"longitude"];
            }
            else
            {
                [dic setObject:@121.605072 forKey:@"longitude"];
            }
            
            if ([user objectForKey:@"lat"]) {
                [dic setObject:[user objectForKey:@"lat"] forKey:@"latitude"];
            }
            else
            {
                [dic setObject:@31.156063 forKey:@"latitude"];
            }
            NSString *str = [user objectForKey:@"currentCity"];
            if (![user objectForKey:@"currentCity"]) {
                str = @"上海";
            }
            [dic setValue:str forKey:@"crtyName"];
            [dic setValue:@0 forKey:@"offset"];
            [[JsonHttp jsonHttp] httpRequest:@"team/getTeamList" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
                [Helper alertViewNoHaveCancleWithTitle:@"获取推荐球队列表失败" withBlock:^(UIAlertController *alertView) {
                    [self.navigationController presentViewController:alertView animated:YES completion:nil];
                }];
            } completionBlock:^(id data) {
                self.teamArray = data[@"teamList"];


                [self.tableView reloadData];
                
            }];
            
        }
    }];
    }else{
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
        } withBlockSure:^{
            JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
            vc.reloadCtrlData = ^(){
                
            };
            [self.navigationController pushViewController:vc animated:YES];
        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }
}


- (void)creatTeam{
//    
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    
//    if ([user objectForKey:@"cacheCreatTeamDic"]) {
//        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"是否继续上次编辑" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *action1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [user setObject:0 forKey:@"cacheCreatTeamDic"];
//            JGNewCreateTeamTableViewController *creatteamVc = [[JGNewCreateTeamTableViewController alloc] init];
//            [self.navigationController pushViewController:creatteamVc animated:YES];
//        }];
//        UIAlertAction* action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            JGNewCreateTeamTableViewController *creatteamVc = [[JGNewCreateTeamTableViewController alloc] init];
//            creatteamVc.detailDic = [[user objectForKey:@"cacheCreatTeamDic"] mutableCopy];
//            creatteamVc.titleField.text = [[user objectForKey:@"cacheCreatTeamDic"] objectForKey:@"name"];
//            
//
//            [self.navigationController pushViewController:creatteamVc animated:YES];
//        }];
//        
//        [alert addAction:action1];
//        [alert addAction:action2];
//        [self presentViewController:alert animated:YES completion:nil];
//
//    }else{
//        JGNewCreateTeamTableViewController *creatteamVc = [[JGNewCreateTeamTableViewController alloc] init];
//        [self.navigationController pushViewController:creatteamVc animated:YES];
//    }
    
}


- (void)backBut{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)team:(UIButton *)button{
    
    if (button.tag == 200) {

        JGLMyTeamViewController* myVc = [[JGLMyTeamViewController alloc]init];
        [self.navigationController pushViewController:myVc animated:YES];
    }else if (button.tag == 201) {
        JGTeamActivityViewController* teamVc = [[JGTeamActivityViewController alloc]init];
        teamVc.isMEActivity = 3;
        teamVc.fromMine = 1;
        [self.navigationController pushViewController:teamVc animated:YES];
    
    }else if (button.tag == 202) {
        
        JGTeamMainhallViewController *MainhallTeamVC = [[JGTeamMainhallViewController alloc] init];
        if (![Helper isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentCity"]]) {
            MainhallTeamVC.strProvince = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentCity"];
        }
        [self.navigationController pushViewController:MainhallTeamVC animated:YES];
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    
    if (([self.myTeamArray count] == 0)) {
               return [self.teamArray count];
    }else{
        if ([self.myActivityArray count] == 0) {
            return 0;
        }else{
            return [self.myActivityArray count];
        }
    }
    

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    
    if (([self.myTeamArray count] == 0)) {
        JGTeamChannelTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.teamModel = self.teamArray[indexPath.row];
             cell.nameLabel.text = [self.teamArray[indexPath.row] objectForKey:@"name"];
        cell.adressLabel.text = [self.teamArray[indexPath.row] objectForKey:@"crtyName"];
        cell.describLabel.text = [self.teamArray[indexPath.row] objectForKey:@"info"];
        [cell.iconImageV sd_setImageWithURL:[Helper setImageIconUrl:[[self.teamArray[indexPath.row] objectForKey:@"timeKey"] integerValue]] placeholderImage:[UIImage imageNamed:TeamLogoImage]];
        ;
        return cell;
    }else{
            if ([self.myActivityArray count] == 0) {
            return nil;
        }else{
        JGTeamActivityCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"JGTeamActivityCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setJGTeamActivityCellWithModel:self.myActivityArray[indexPath.row] fromCtrl:2];
        return cell;
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.myActivityArray count] == 0) {

        JGDNewTeamDetailViewController *detailV = [[JGDNewTeamDetailViewController alloc] init];
        detailV.timeKey = [self.teamArray[indexPath.row] objectForKey:@"timeKey"];
        
        [self.navigationController pushViewController:detailV animated:YES];
    }else{
        //频道首页cell
        // ---- 存在球队赛事matchKey-跳到赛事详情－否则跳转到活动详情
        JGTeamAcitivtyModel *model = self.myActivityArray[indexPath.row];
        if ([model.matchKey integerValue] > 0) {
        }else{
            JGHNewActivityDetailViewController *teamActivityVC = [[JGHNewActivityDetailViewController alloc] init];
            teamActivityVC.teamKey = [model.timeKey integerValue];
            [self.navigationController pushViewController:teamActivityVC animated:YES];
        }        
    }
}

- (NSMutableArray *)scrillViewArray{
    if (!_scrillViewArray) {
        _scrillViewArray = [[NSMutableArray alloc] init];
    }
    return _scrillViewArray;
}

- (NSMutableArray *)myActivityArray{
    if (!_myActivityArray) {
        _myActivityArray = [[NSMutableArray alloc] init];
    }
    return _myActivityArray;
}

- (NSMutableArray *)teamArray{
    if (!_teamArray) {
        _teamArray = [[NSMutableArray alloc] init];
    }
    return _teamArray;
}

- (NSMutableArray *)myTeamArray{
    if (!_myTeamArray) {
        _myTeamArray = [[NSMutableArray alloc] init];
    }
    return _myTeamArray;
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
