//
//  JGHTeamNotViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/11/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHTeamNotViewController.h"
#import "JGHTeamInformCell.h"
#import "JGHInformModel.h"

#import "NewFriendViewController.h"
#import "JGTeamActibityNameViewController.h"
#import "JGTeamGroupViewController.h"
#import "JGDActSelfHistoryScoreViewController.h"
#import "JGLPresentAwardViewController.h"
#import "UseMallViewController.h"
#import "JGLPushDetailsViewController.h"
#import "DetailViewController.h"
#import "JGNewCreateTeamTableViewController.h"
#import "JGDNewTeamDetailViewController.h"
#import "JGPhotoAlbumViewController.h"

#import "JGDWithDrawTeamMoneyViewController.h"
#import "JGTeamMainhallViewController.h"
#import "JGTeamMemberController.h"
#import "JGLJoinManageViewController.h"


static NSString *const JGHTeamInformCellIdentifier = @"JGHTeamInformCell";

@interface JGHTeamNotViewController ()<UITableViewDelegate, UITableViewDataSource>
{
//    NSInteger _selectCatory;//0-全选；1-取消全选
    NSInteger _page;
    
    UILabel *_promptLable;
}

@property (nonatomic, retain)UITableView *systemNotTableView;

@property (nonatomic, retain)NSMutableArray *dataArray;

@end

@implementation JGHTeamNotViewController

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
    self.navigationItem.title = @"球队通知";
    
    self.dataArray = [NSMutableArray array];
    
    _page = 0;
    
    [self createSystemNotTableView];
    
    [self loadData];
}
#pragma mark -- 下载数据
- (void)loadData{
    [LQProgressHud showLoading:@"加载中..."];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:@1 forKey:@"nSrc"];
    [dict setObject:@(_page) forKey:@"offset"];
    [dict setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@&nSrc=1dagolfla.com", DEFAULF_USERID]] forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"msg/getMsgList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        [self.systemNotTableView.header endRefreshing];
        [self.systemNotTableView.footer endRefreshing];
        [LQProgressHud hide];
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        [LQProgressHud hide];
        if (_page == 0) {
            [self.dataArray removeAllObjects];
        }
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            NSArray *list = [data objectForKey:@"list"];
            if (list.count == 0) {

            }else{
                for (int i=0; i<list.count; i++) {
                    JGHInformModel *model = [[JGHInformModel alloc]init];
                    [model setValuesForKeysWithDictionary:list[i]];
                    [self.dataArray addObject:model];
                }
                
                [self.systemNotTableView reloadData];
            }
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
            _promptLable.text = @"暂无球队通知";
            [window addSubview:_promptLable];
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
    [self.systemNotTableView registerClass:[JGHTeamInformCell class] forCellReuseIdentifier:JGHTeamInformCellIdentifier];
    
    UIView *CCCView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 10 * ProportionAdapter)];
    CCCView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    self.systemNotTableView.tableHeaderView = CCCView;
    
    
    self.systemNotTableView.header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    self.systemNotTableView.footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];

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
    
    CGSize titleSize;
    
    if (model.linkURL) {
        titleSize = [[NSString stringWithFormat:@"    %@", model.title] boundingRectWithSize:CGSizeMake(screenWidth - 50 * ProportionAdapter, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16*ProportionAdapter]} context:nil].size;
        
    }else{
        titleSize = [[NSString stringWithFormat:@"    %@", model.title] boundingRectWithSize:CGSizeMake(screenWidth - 30 * ProportionAdapter, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16*ProportionAdapter]} context:nil].size;
    }
    
    
    //    CGSize contentSize = [model.content boundingRectWithSize:CGSizeMake(screenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15*ProportionAdapter]} context:nil].size;
    
    return 60 *ProportionAdapter +titleSize.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGHTeamInformCell *teamInformCell = [tableView dequeueReusableCellWithIdentifier:JGHTeamInformCellIdentifier forIndexPath:indexPath];
    teamInformCell.selectionStyle = UITableViewCellSelectionStyleNone;

    JGHInformModel *model = _dataArray[indexPath.row];

    [teamInformCell configJGHTeamInformCell:model];
    
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
        
        
        
        
        // 球队提现
        
        if ([model.linkURL containsString:@"teamWithDraw"]) {
            if ([model.linkURL containsString:@"?"]) {
                JGDWithDrawTeamMoneyViewController *vc = [[JGDWithDrawTeamMoneyViewController alloc] init];
                vc.teamKey = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:model.linkURL andKey:@"teamKey"] integerValue]];
                [self.navigationController pushViewController:vc animated:YES];        }
        }
        
        // 球队大厅
        
        if ([model.linkURL containsString:@"teamHall"]) {
            JGTeamMainhallViewController *teamMainCtrl = [[JGTeamMainhallViewController alloc]init];
            [self.navigationController pushViewController:teamMainCtrl animated:YES];
        }
        
        // 成员管理
        
        if ([model.linkURL containsString:@"teamMemberMgr"]) {
            JGTeamMemberController* menVc = [[JGTeamMemberController alloc]init];
            menVc.title = @"队员管理";
            menVc.power = @"1004,1001,1002,1005";
            menVc.teamManagement = 1;
            menVc.teamKey = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:model.linkURL andKey:@"teamKey"] integerValue]];
            [self.navigationController pushViewController:menVc animated:YES];
        }
        
        // 入队审核页面
        
        if ([model.linkURL containsString:@"auditTeamMember"]) {
            JGLJoinManageViewController *jgJoinVC = [[JGLJoinManageViewController alloc] init];
            jgJoinVC.teamKey = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:model.linkURL andKey:@"teamKey"] integerValue]];
            [self.navigationController pushViewController:jgJoinVC animated:YES];
        }
        

        
        
        
        
        
        
        //新球友
        if ([model.linkURL containsString:@"newUserFriendList"]) {
            NewFriendViewController *friendCtrl = [[NewFriendViewController alloc]init];
            friendCtrl.fromWitchVC = 2;
            [self.navigationController pushViewController:friendCtrl animated:YES];
        }
        
        // 相册
        if ([model.linkURL containsString:@"teamMediaList"]) {
            JGPhotoAlbumViewController *albumVC = [[JGPhotoAlbumViewController alloc]init];
            albumVC.albumKey = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:model.linkURL andKey:@"albumKey"] integerValue]];
            albumVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:albumVC animated:YES];
        }

        //活动详情
        if ([model.linkURL containsString:@"teamActivityDetail"]) {
            JGTeamActibityNameViewController *teamCtrl= [[JGTeamActibityNameViewController alloc]init];
            teamCtrl.teamKey = [[Helper returnKeyVlaueWithUrlString:model.linkURL andKey:@"activityKey"] integerValue];
            teamCtrl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:teamCtrl animated:YES];
        }
        
        //分组--普通用户
        if ([model.linkURL containsString:@"activityGroup"]) {
            JGTeamGroupViewController *teamGroupCtrl= [[JGTeamGroupViewController alloc]init];
            teamGroupCtrl.teamActivityKey = [[Helper returnKeyVlaueWithUrlString:model.linkURL andKey:@"activityKey"] integerValue];
            teamGroupCtrl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:teamGroupCtrl animated:YES];
        }
        
        //分组--管理
        if ([model.linkURL containsString:@"activityGroupAdmin"]) {
            JGTeamGroupViewController *teamGroupCtrl= [[JGTeamGroupViewController alloc]init];
            teamGroupCtrl.teamActivityKey = [[Helper returnKeyVlaueWithUrlString:model.linkURL andKey:@"activityKey"] integerValue];
            teamGroupCtrl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:teamGroupCtrl animated:YES];
        }
        
        //活动成绩详情 --
        if ([model.linkURL containsString:@"activityScore"]) {
            JGDActSelfHistoryScoreViewController *teamGroupCtrl= [[JGDActSelfHistoryScoreViewController alloc]init];
            teamGroupCtrl.teamKey = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:model.linkURL andKey:@"teamKey"] integerValue]];
            teamGroupCtrl.timeKey = [Helper returnKeyVlaueWithUrlString:model.linkURL andKey:@"activityKey"];
            teamGroupCtrl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:teamGroupCtrl animated:YES];
        }
        
        //获奖详情 --
        if ([model.linkURL containsString:@"awardedInfo"]) {
            JGLPresentAwardViewController *teamGroupCtrl= [[JGLPresentAwardViewController alloc]init];
            teamGroupCtrl.activityKey = [[Helper returnKeyVlaueWithUrlString:model.linkURL andKey:@"activityKey"] integerValue];
            teamGroupCtrl.teamKey = [[Helper returnKeyVlaueWithUrlString:model.linkURL andKey:@"teamKey"] integerValue];
            teamGroupCtrl.isManager = 0;//0-非管理员
            teamGroupCtrl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:teamGroupCtrl animated:YES];
        }
        
        //球队详情
        if ([model.linkURL containsString:@"teamDetail"]) {
            JGDNewTeamDetailViewController *newTeamVC = [[JGDNewTeamDetailViewController alloc] init];
            newTeamVC.timeKey = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:model.linkURL andKey:@"timekey"] integerValue]];
            newTeamVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:newTeamVC animated:YES];
        }
        
        //商品详情
        if ([model.linkURL containsString:@"goodDetail"]) {
            UseMallViewController* userVc = [[UseMallViewController alloc]init];
            userVc.linkUrl = [NSString stringWithFormat:@"http://www.dagolfla.com/app/ProductDetails.html?proid=%td", [[Helper returnKeyVlaueWithUrlString:model.linkURL andKey:@"timekey"] integerValue]];
            userVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:userVc animated:YES];
        }
        
        //H5
        if ([model.linkURL containsString:@"openURL"]) {
            JGLPushDetailsViewController* puVc = [[JGLPushDetailsViewController alloc]init];
            puVc.strUrl = [Helper returnKeyVlaueWithUrlString:model.linkURL andKey:@"timekey"];
            puVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:puVc animated:YES];
        }
        
        //社区
        if ([model.linkURL containsString:@"moodKey"]) {
            DetailViewController * comDevc = [[DetailViewController alloc]init];
            comDevc.detailId = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:model.linkURL andKey:@"timekey"] integerValue]];
            comDevc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:comDevc animated:YES];
        }
        
        //创建球队
        if ([model.linkURL containsString:@"createTeam"]) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            
            if ([user objectForKey:@"cacheCreatTeamDic"]) {
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"是否继续上次编辑" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [user setObject:0 forKey:@"cacheCreatTeamDic"];
                    JGNewCreateTeamTableViewController *creatteamVc = [[JGNewCreateTeamTableViewController alloc] init];
                    creatteamVc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:creatteamVc animated:YES];
                }];
                UIAlertAction* action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    JGNewCreateTeamTableViewController *creatteamVc = [[JGNewCreateTeamTableViewController alloc] init];
                    creatteamVc.detailDic = [[user objectForKey:@"cacheCreatTeamDic"] mutableCopy];
                    creatteamVc.titleField.text = [[user objectForKey:@"cacheCreatTeamDic"] objectForKey:@"name"];
                    creatteamVc.hidesBottomBarWhenPushed = YES;
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
