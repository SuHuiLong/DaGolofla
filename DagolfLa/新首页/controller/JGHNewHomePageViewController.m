//
//  JGHNewHomePageViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHNewHomePageViewController.h"
#import "HomeHeadView.h"
#import "JGHPASHeaderTableViewCell.h"
#import "JGHShowSectionTableViewCell.h"
#import "JGHShowActivityPhotoCell.h"
#import "JGHIndexModel.h"
#import "JGHNavListView.h"
#import "JGLScoreNewViewController.h"
#import "JGHShowMyTeamViewController.h" // 我的球队
#import "JGDNewTeamDetailViewController.h" // 球队详情
//#import "JGTeamMemberORManagerViewController.h" // 球队详情 － 自己的球队
//#import "JGNotTeamMemberDetailViewController.h"  // 球队详情 － 别人的球队
#import "JGPhotoAlbumViewController.h" // 相册
#import "JGLWebUserMallViewController.h"
#import "JGTeamMainhallViewController.h"
#import "JGDHistoryScoreViewController.h"
#import "JGTeamActibityNameViewController.h" // 活动
#import "JGLScoreLiveViewController.h"   // 直播
#import "JGLScoreRankViewController.h"
#import "UseMallViewController.h"
#import "JGNewCreateTeamTableViewController.h"
#import "DetailViewController.h"
#import "JGLPushDetailsViewController.h"
#import "JGHIndexTableViewCell.h"

#import "UMMobClick/MobClick.h"
#import "UITabBar+badge.h"
#import <RongIMKit/RCIM.h>
#import "NewFriendViewController.h"
#import "JGTeamGroupViewController.h"
#import "JGLPresentAwardViewController.h"
#import "JGDActSelfHistoryScoreViewController.h"
#import "JGDWithDrawTeamMoneyViewController.h"
#import "JGTeamMemberController.h"
#import "JGLJoinManageViewController.h"


#import "JGDDPhotoAlbumViewController.h"


static NSString *const JGHPASHeaderTableViewCellIdentifier = @"JGHPASHeaderTableViewCell";
static NSString *const JGHShowSectionTableViewCellIdentifier = @"JGHShowSectionTableViewCell";
static NSString *const JGHShowActivityPhotoCellIdentifier = @"JGHShowActivityPhotoCell";
static NSString *const JGHIndexTableViewCellIdentifier = @"JGHIndexTableViewCell";

@interface JGHNewHomePageViewController ()<UITableViewDelegate, UITableViewDataSource, JGHShowSectionTableViewCellDelegate, JGHShowActivityPhotoCellDelegate, JGHNavListViewDelegate, JGHPASHeaderTableViewCellDelegate, JGHIndexTableViewCellDelegate>
{
    NSInteger _showLineID;//0-活动，1-相册，2-成绩
}
@property (nonatomic, strong)HomeHeadView *topScrollView;//BANNAER图

@property (nonatomic, strong)UITableView *homeTableView;//TB

//@property (strong, nonatomic) CLLocationManager* locationManager;

@property (nonatomic, strong)JGHIndexModel *indexModel;

@property (nonatomic, strong)JGHNavListView *navListView;

@end

@implementation JGHNewHomePageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.navigationItem.leftBarButtonItem = nil;
    //发出通知显示标签栏
    [[NSNotificationCenter defaultCenter] postNotificationName:@"show" object:nil];
    self.navigationController.navigationBarHidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //把当前页面的任务栏影藏
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    //把当前界面的导航栏隐藏
    self.navigationController.navigationBarHidden = NO;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"show" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.indexModel = [[JGHIndexModel alloc]init];
    _showLineID = 0;
    
    //监听分组页面返回，刷新数据
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(PushJGTeamActibityNameViewController:) name:@"PushJGTeamActibityNameViewController" object:nil];

    [self createHomeTableView];
    
    [self parsingCacheData];
    
    [self loadIndexdata];//上线不注释
    
//    [self getCurPosition];
    
    [self createBanner];
    
    [self loadingPHP];
    
    if (DEFAULF_USERID) {
        [self loadMessageData];
    }
    
    //获取通知中心单例对象
//    NSNotificationCenter *messageCenter = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(loadMessageData) name:@"loadMessageData" object:nil];
    
}
#pragma mark -- 下载未读消息数量
- (void)loadMessageData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:[Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]] forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"msg/geSumtUnread" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            int teamUnread = [[data objectForKey:@"teamUnread"] intValue];
            int systemUnread = [[data objectForKey:@"systemUnread"] intValue];
            
            __weak typeof(self) __weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableArray *displayConversationTypeArray = [NSMutableArray array];
                [displayConversationTypeArray addObject:@1];
                int count = [[RCIMClient sharedRCIMClient]
                             getUnreadCount:displayConversationTypeArray];
                if ((systemUnread +teamUnread +count) > 0) {
                    [__weakSelf.tabBarController.tabBar showBadgeOnItemIndex:2 badgeValue:(systemUnread +teamUnread +count)];
                    
                } else {
                    [__weakSelf.tabBarController.tabBar hideBadgeOnItemIndex:2];
                }
                
            });
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
}
- (void)updateBadgeValueForTabBarItem
{
    
    
}
#pragma mark -- 登录PHP
- (void)loadingPHP{
    [Helper callPHPLoginUserId:[NSString stringWithFormat:@"%@", DEFAULF_USERID]];
}
#pragma mark -- 寻找本地缓存数据
- (void)parsingCacheData{
    //解归档----获取缓存数据-----
    //获得文件路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"indexdata.archiver"];
    //1. 从磁盘读取文件，生成NSData实例
    NSData *unarchiverData = [NSData dataWithContentsOfFile:filePath];
    if (unarchiverData) {
        //2. 根据Data实例创建和初始化解归档对象
        NSKeyedUnarchiver *unachiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:unarchiverData];
        //3. 解归档，根据key值访问
        JGHIndexModel *model = [unachiver decodeObjectForKey:@"indexModel"];
        self.indexModel = model;

        [self.homeTableView reloadData];
    }else{
        NSString * path = [[NSBundle mainBundle] pathForResource:@"index.json" ofType:nil];
        
        NSError * error = nil;
        NSString * str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"error:%@", error);
        }
        
        NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError * error1 = nil;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error1];
        if (error1) {
            NSLog(@"error1:%@", error1);
        }
        
        [self.indexModel setValuesForKeysWithDictionary:dic];
        [self.homeTableView reloadData];
    }
}

#pragma mark -- 下载数据
- (void)loadIndexdata{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *getDict = [NSMutableDictionary dictionary];
    
    if ([[userDef objectForKey:userID] integerValue] > 0) {
        [getDict setObject:DEFAULF_USERID forKey:@"userKey"];
    }else{
        [getDict setObject:@0 forKey:@"userKey"];
    }
    
    if ([userDef objectForKey:@"lat"]) {
        [getDict setObject:[userDef objectForKey:BDMAPLNG] forKey:@"longitude"];
        [getDict setObject:[userDef objectForKey:BDMAPLAT] forKey:@"latitude"];
    }
    
    [[JsonHttp jsonHttp]httpRequest:@"index/getIndex" JsonKey:nil withData:getDict requestMethod:@"GET" failedBlock:^(id errType) {
        [self.homeTableView.header endRefreshing];
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        _showLineID = 0;
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            [self.indexModel setValuesForKeysWithDictionary:data];
            
            [self.homeTableView reloadData];
            
            // -----------缓存数据-------------
            //获得文件路径
            NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *filePath = [documentPath stringByAppendingPathComponent:@"indexdata.archiver"];
            
            //1. 使用NSData存放归档数据
            NSMutableData *archiverData = [NSMutableData data];
            //2. 创建归档对象
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:archiverData];
            //3. 添加归档内容 （设置键值对）
            [archiver encodeObject:_indexModel forKey:@"indexModel"];
            //4. 完成归档
            [archiver finishEncoding];
            //5. 将归档的信息存储到磁盘上
            if ([archiverData writeToFile:filePath atomically:YES]) {
                NSLog(@"archiver success");
            }
            
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
        
        [self.homeTableView.header endRefreshing];
    }];
}
#pragma mark -- 创建TableView
- (void)createHomeTableView{
    self.homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight -40 *ProportionAdapter) style:UITableViewStyleGrouped];
    
    UINib *pASHeaderTableViewCellNib = [UINib nibWithNibName:@"JGHPASHeaderTableViewCell" bundle: [NSBundle mainBundle]];
    [self.homeTableView registerNib:pASHeaderTableViewCellNib forCellReuseIdentifier:JGHPASHeaderTableViewCellIdentifier];
    
    UINib *showSectionTableViewCellNib = [UINib nibWithNibName:@"JGHShowSectionTableViewCell" bundle: [NSBundle mainBundle]];
    [self.homeTableView registerNib:showSectionTableViewCellNib forCellReuseIdentifier:JGHShowSectionTableViewCellIdentifier];
    
    [self.homeTableView registerClass:[JGHShowActivityPhotoCell class] forCellReuseIdentifier:JGHShowActivityPhotoCellIdentifier];

    [self.homeTableView registerClass:[JGHIndexTableViewCell class] forCellReuseIdentifier:JGHIndexTableViewCellIdentifier];
    
    self.homeTableView.dataSource = self;
    self.homeTableView.delegate = self;
    self.homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.homeTableView.header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    self.homeTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self.view addSubview:self.homeTableView];
}
- (void)headRereshing{
    [self loadIndexdata];
    [self loadBanner];
}
#pragma  mark -- 创建Banner
-(void)createBanner
{
    //头视图
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth/2 +115 *ProportionAdapter)];
    headerView.backgroundColor = [UIColor whiteColor];
    //banner
    self.topScrollView = [[HomeHeadView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth/2)];
    self.topScrollView.userInteractionEnabled = YES;
    [headerView addSubview:self.topScrollView];
    
    self.navListView = [[JGHNavListView alloc]initWithFrame:CGRectMake(0, screenWidth/2 +10*ProportionAdapter, screenWidth, 105 *ProportionAdapter)];
    self.navListView.delegate = self;
    [headerView addSubview:self.navListView];
    
    self.homeTableView.tableHeaderView = headerView;
    
    [self loadBanner];
}
#pragma mark -- 下载barner数据
- (void)loadBanner{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@0 forKey:@"nPos"];
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
                //                self.topScrollView.delegate = self;
                __weak JGHNewHomePageViewController *weakSelf = self;
                [self.topScrollView setClick:^(UIViewController *vc) {
                    [weakSelf isLoginUp];
                    
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:nil];
                }];
            }
        }
    }];
}
#pragma mark - UITableViewDataSource 协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{  
//    return _dataArray.count +1;
    return _indexModel.plateList.count +1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == _indexModel.plateList.count +1) {
        return 0;
    }
    return 10 *ProportionAdapter;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == _indexModel.plateList.count +1) {
        return nil;
    }else{
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10 *ProportionAdapter)];
        footView.backgroundColor = [UIColor colorWithHexString:BG_color];
        return footView;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        JGHShowActivityPhotoCell *showActivityPhotoCell = [tableView dequeueReusableCellWithIdentifier:JGHShowActivityPhotoCellIdentifier];
        showActivityPhotoCell.delegate = self;
        [showActivityPhotoCell configJGHShowActivityPhotoCell:_indexModel.activityList];
        return showActivityPhotoCell;
    }else{
        JGHIndexTableViewCell *indexTableViewCell = [tableView dequeueReusableCellWithIdentifier:JGHIndexTableViewCellIdentifier];
        indexTableViewCell.delegate = self;
        
        if (_indexModel.plateList.count > 0) {
            NSDictionary *dict = _indexModel.plateList[indexPath.section -1];
            NSArray *bodyList = [dict objectForKey:@"bodyList"];
            NSInteger bodyLayoutType = [[dict objectForKey:@"bodyLayoutType"] integerValue];
            NSInteger imgHeight = [[dict objectForKey:@"imgHeight"] integerValue];
            NSInteger imgWidth = [[dict objectForKey:@"imgWidth"] integerValue];
            
            if (bodyLayoutType == 0) {
                //精彩推荐
                [indexTableViewCell configJGHWonderfulTableViewCell:bodyList andImageW:imgWidth andImageH:imgHeight];
            }else if (bodyLayoutType == 1){
                //用品商城
                [indexTableViewCell configJGHShowSuppliesMallTableViewCell:bodyList andImageW:imgWidth andImageH:imgHeight];
            }else if (bodyLayoutType == 2){
                //热门球队
                [indexTableViewCell configJGDHotTeamCell:bodyList andImageW:imgWidth andImageH:imgHeight];
            }else if (bodyLayoutType == 3){
                //订场推荐
                [indexTableViewCell configJGHShowRecomStadiumTableViewCell:bodyList andImageW:imgWidth andImageH:imgHeight];
            }else{
                //其他  －－－ 更新版本
                
            }
        }
        
        return indexTableViewCell;
    }
}
//组头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        JGHPASHeaderTableViewCell *pASHeaderCell = [tableView dequeueReusableCellWithIdentifier:JGHPASHeaderTableViewCellIdentifier];
        pASHeaderCell.delegate = self;
        [pASHeaderCell configJGHPASHeaderTableViewCell:_showLineID];
        return (UIView *)pASHeaderCell;
    }else{
        JGHShowSectionTableViewCell *showSectionCell = [tableView dequeueReusableCellWithIdentifier:JGHShowSectionTableViewCellIdentifier];
        showSectionCell.delegate = self;
        showSectionCell.moreBtn.tag = 100 +section;
        
        NSDictionary *dict = _indexModel.plateList[section -1];
        NSInteger _more = 0;
        if ([dict objectForKey:@"moreLink"]) {
            _more = 1;
        }
        
        [showSectionCell congfigJGHShowSectionTableViewCell:[dict objectForKey:@"title"] andHiden:_more];
        return (UIView *)showSectionCell;
    }
}
//Cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 活动－相册－成绩
        return 190 *ProportionAdapter;
    }else{
        if (_indexModel.plateList.count > 0) {
            NSDictionary *dict = _indexModel.plateList[indexPath.section -1];
            NSArray *bodyList = [dict objectForKey:@"bodyList"];
            NSInteger bodyLayoutType = [[dict objectForKey:@"bodyLayoutType"] integerValue];
            NSInteger imgHeight = [[dict objectForKey:@"imgHeight"] integerValue];
            if (bodyLayoutType == 0) {
                //精彩推荐
                return ((bodyList.count-1)/2+1) *(imgHeight +35 +8) *ProportionAdapter + 8*ProportionAdapter;
            }else if (bodyLayoutType == 1){
                //用品商城
                return ((bodyList.count-1)/2+1) *(imgHeight +104) *ProportionAdapter;
            }else if (bodyLayoutType == 2){
                //热门球队
                return ((25 +imgHeight) *ProportionAdapter) *bodyList.count;
            }else if (bodyLayoutType == 3){
                //订场推荐
                return ((bodyList.count-1)/2+1) *(imgHeight +56 +8) *ProportionAdapter + 8*ProportionAdapter;
            }else{
                //其他  －－－ 更新版本
                return 30 *ProportionAdapter;
            }
        }else{
            return 0;
        }
    }
}
//设置头部高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45 *ProportionAdapter;
}

- (void)hotTeam:(NSDictionary *)dict{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if (DEFAULF_USERID != nil) {
        [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    }
    [dic setObject:[dict objectForKey:@"timeKey"] forKey:@"teamKey"];
    
    JGDNewTeamDetailViewController *newTeamVC = [[JGDNewTeamDetailViewController alloc] init];
    newTeamVC.timeKey = [dict objectForKey:@"timeKey"];
    newTeamVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newTeamVC animated:YES];
}
#pragma mark -- 1001(活动) －－1002(相册) －－ 1003（成绩）
- (void)didSelectActivityOrPhotoOrResultsBtn:(UIButton *)btn{
    
    JGHShowActivityPhotoCell *cell = [self.homeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    UILabel *activityLable = [self.view viewWithTag:30001];
    UILabel *photoLable = [self.view viewWithTag:30002];
    UILabel *scoreLable = [self.view viewWithTag:30003];
    
    if (btn.tag == 1001) {
        
        [MobClick event:@"activity"];

        _showLineID = 0;
        activityLable.hidden = NO;
        photoLable.hidden = YES;
        scoreLable.hidden = YES;
        [cell configJGHShowActivityPhotoCell:_indexModel.activityList];
        
    } else if (btn.tag == 1002) {
        
        [MobClick event:@"photoAlbum"];

        _showLineID = 1;
        activityLable.hidden = YES;
        photoLable.hidden = NO;
        scoreLable.hidden = YES;
        [cell configJGHShowPhotoCell:_indexModel.albumList];
        cell.photoBlock = ^(NSInteger numB){
            [self isLoginUp];
            
            JGDDPhotoAlbumViewController *photoVC = [[JGDDPhotoAlbumViewController alloc] init];
            //            photoVC.blockRefresh = ^(){
            //只是实现，不作操作
            //            };
            photoVC.hidesBottomBarWhenPushed = YES;
            photoVC.albumKey = [_indexModel.albumList[numB] objectForKey:@"timeKey"];
            [self.navigationController pushViewController:photoVC animated:YES];
        };
    } else if (btn.tag == 1003) {
        
        [MobClick event:@"live"];

        _showLineID = 2;
        activityLable.hidden = YES;
        photoLable.hidden = YES;
        scoreLable.hidden = NO;
        [cell configJGHShowLiveCell:_indexModel.scoreList];
        cell.liveBlock = ^(NSInteger numB){
            [self isLoginUp];
            
            JGLScoreLiveViewController *liveVC = [[JGLScoreLiveViewController alloc] init];
            
            liveVC.activity = [_indexModel.scoreList[numB] objectForKey:@"timeKey"];
            liveVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:liveVC animated:YES];
        };
    }
    
}
#pragma mark -- 我的球队
- (void)didSelectMyTeamBtn:(UIButton *)btn{
    [self isLoginUp];
    // 友盟埋点
    [MobClick event:@"teamTribe"];
    if (_indexModel.isHaveTeam == 0) {
        JGTeamMainhallViewController *teamMainCtrl = [[JGTeamMainhallViewController alloc]init];
        NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
        if ([userdef objectForKey:@"currentCity"]) {
            
        }else{
            
        }
        //[user setObject:city forKey:@"currentCity"];
        teamMainCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:teamMainCtrl animated:YES];
    }else{
        JGHShowMyTeamViewController *myTeamVC = [[JGHShowMyTeamViewController alloc] init];
        myTeamVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myTeamVC animated:YES];
    }
}
#pragma mark -- 开局记分
- (void)didSelectStartScoreBtn:(UIButton *)btn{
    [self isLoginUp];
    [MobClick event:@"beginKeepScore"];
    JGLScoreNewViewController *scoreCtrl = [[JGLScoreNewViewController alloc]init];
    scoreCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scoreCtrl animated:YES];
}
#pragma mark -- 历史成绩
- (void)didSelectHistoryResultsBtn:(UIButton *)btn{
    [self isLoginUp];
    [MobClick event:@"historyScore"];
    JGDHistoryScoreViewController *historyCtrl = [[JGDHistoryScoreViewController alloc]init];
    historyCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:historyCtrl animated:YES];
}
#pragma mark -- 活动点击事件
- (void)activityListSelectClick:(UIButton *)btn{
    [self isLoginUp];
    
    NSDictionary *dic = _indexModel.activityList[btn.tag - 200];
    JGTeamActibityNameViewController *teamActVC = [[JGTeamActibityNameViewController alloc] init];
    teamActVC.teamKey = [[dic objectForKey:@"timeKey"] integerValue];
    teamActVC.hidesBottomBarWhenPushed = YES;//6598520
    [self.navigationController pushViewController:teamActVC animated:YES];
}
#pragma mark -- 精彩推荐 -- 相册
- (void)wonderfulSelectClick:(UIButton *)btn{
    NSLog(@"%td", btn.tag);
    [self isLoginUp];
    
    [MobClick event:@"wonderfulPhotoAlbum"];
    NSDictionary *mallListDict = [NSDictionary dictionary];
    for (int i=0; i<_indexModel.plateList.count; i++) {
        if ([[_indexModel.plateList[i] objectForKey:@"bodyLayoutType"] integerValue] == 0) {
            mallListDict = _indexModel.plateList[i];
        }
    }
    
    if (mallListDict) {
        NSArray *bodyList = [mallListDict objectForKey:@"bodyList"];
        NSDictionary *ablumListDict = bodyList[btn.tag -300];

        JGDDPhotoAlbumViewController *photoAlbumCtrl = [[JGDDPhotoAlbumViewController alloc] init];
//        JGPhotoAlbumViewController *photoAlbumCtrl = [[JGPhotoAlbumViewController alloc]init];
        photoAlbumCtrl.albumKey = [NSNumber numberWithInteger:[[ablumListDict objectForKey:@"timeKey"] integerValue]];
        photoAlbumCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:photoAlbumCtrl animated:YES];
    }
}
#pragma mark -- 订场推荐
- (void)recomStadiumSelectClick:(UIButton *)btn{
    NSLog(@"%td", btn.tag);
    [self isLoginUp];
    [MobClick event:@"ballParkRecommend"];

    NSDictionary *recomListDict = [NSDictionary dictionary];
    for (int i=0; i<_indexModel.plateList.count; i++) {
        if ([[_indexModel.plateList[i] objectForKey:@"bodyLayoutType"] integerValue] == 3) {
            recomListDict = _indexModel.plateList[i];
        }
    }
    
    if (recomListDict) {
        NSArray *bodyList = [NSArray array];
        bodyList = [recomListDict objectForKey:@"bodyList"];
        NSString *mallUrl = [bodyList[btn.tag -400] objectForKey:@"weblinks"];
        [self pushctrlWithUrl:mallUrl];
    }else{
        return;
    }
}
#pragma mark -- 用品商城
- (void)suppliesMallSelectClick:(UIButton *)btn{
    NSLog(@"%td", btn.tag);
    [self isLoginUp];
    [MobClick event:@"market"];

    NSDictionary *mallListDict = [NSDictionary dictionary];
    for (int i=0; i<_indexModel.plateList.count; i++) {
        if ([[_indexModel.plateList[i] objectForKey:@"bodyLayoutType"] integerValue] == 1) {
            mallListDict = _indexModel.plateList[i];
        }
    }
    
    if (mallListDict) {
        NSArray *bodyList = [NSArray array];
        bodyList = [mallListDict objectForKey:@"bodyList"];
        NSString *mallUrl = [bodyList[btn.tag -500] objectForKey:@"weblinks"];
        [self pushctrlWithUrl:mallUrl];
    }else{
        return;
    }
}
#pragma mark -- 热门球队
- (void)hotTeamSelectClick:(UIButton *)btn{
    NSLog(@"%td", btn.tag);
    [self isLoginUp];
    
    [MobClick event:@"hotTeam"];
    
    // 热门球队 --- 详情  bodyLayoutType -2
    NSDictionary *hotTeamDict = [NSDictionary dictionary];
    for (int i=0; i<_indexModel.plateList.count; i++) {
        if ([[_indexModel.plateList[i] objectForKey:@"bodyLayoutType"] integerValue] == 2) {
            hotTeamDict = _indexModel.plateList[i];
        }
    }
    
    if (hotTeamDict) {
        NSArray *bodyList = [NSArray array];
        bodyList = [hotTeamDict objectForKey:@"bodyList"];
        [self hotTeam:bodyList[btn.tag -600]];
    }else{
        return;
    }
}
#pragma mark -- 更多
- (void)didSelectMoreBtn:(UIButton *)moreBtn{
    NSLog(@"%td", moreBtn.tag);
    [self isLoginUp];
    
    NSDictionary *dict = _indexModel.plateList[moreBtn.tag -100 -1];
    NSString *url = [dict objectForKey:@"moreLink"];
    if ([url containsString:@"teamHall"]) {
        
        [MobClick event:@"hotTeamLobby"];

        JGTeamMainhallViewController *teamMainCtrl = [[JGTeamMainhallViewController alloc]init];
        teamMainCtrl.hidesBottomBarWhenPushed = YES;
        if (![Helper isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentCity"]]) {
            teamMainCtrl.strProvince = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentCity"];
        }
        [self.navigationController pushViewController:teamMainCtrl animated:YES];
    }else {
        NSString *urlRequest;
        if ([url containsString:@"index.html"]) {
            //http://www.dagolfla.com/app/index.html  商城
            urlRequest = @"http://www.dagolfla.com/app/index.html";
            [MobClick event:@"marketMore"];
        }else{
            urlRequest = @"http://www.dagolfla.com/app/bookserch.html";
            [MobClick event:@"ballParkMore"];
        }
        
        JGLWebUserMallViewController *mallCtrl = [[JGLWebUserMallViewController alloc]init];
        mallCtrl.urlRequest = urlRequest;
        mallCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mallCtrl animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 通过URL 判断跳转
- (void)pushctrlWithUrl:(NSString *)url{
    
    if ([url containsString:@"goodDetail"]) {//商城／球场预定
        JGLWebUserMallViewController *mallCtrl = [[JGLWebUserMallViewController alloc]init];
        //http://www.dagolfla.com/app/ProductDetails.html?proid=%@
        NSString *urlRequest = [NSString stringWithFormat:@"%@", [Helper returnKeyVlaueWithUrlString:url andKey:@"goodKey"]];
        mallCtrl.urlRequest = [NSString stringWithFormat:@"http://www.dagolfla.com/app/ProductDetails.html?proid=%@", urlRequest];
        mallCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mallCtrl animated:YES];
        return;
    }
    
    if ([url containsString:@"teamMediaList"]) {//相册
        JGPhotoAlbumViewController *albumCtrl = [[JGPhotoAlbumViewController alloc]init];
        NSNumber *albumKey = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:url andKey:@"albumKey"] integerValue]];
        if ([albumKey integerValue] > 0) {
            albumCtrl.albumKey = albumKey;
        }else{
            albumCtrl.albumKey = 0;
        }
        albumCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:albumCtrl animated:YES];
        return;
    }
    
    if ([url containsString:@"openURL"]) {//相册
        JGLWebUserMallViewController *mallCtrl = [[JGLWebUserMallViewController alloc]init];
        //http://www.dagolfla.com/app/ProductDetails.html?proid=%@
        
        NSString *urlRequest = [NSString stringWithFormat:@"%@", [Helper returnKeyVlaueWithUrlString:url andKey:@"url"]];
        mallCtrl.urlRequest = [urlRequest stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        mallCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mallCtrl animated:YES];
        return;
    }
}
#pragma mark -- 判断是否需要登录
- (void)isLoginUp{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        
    }
    else
    {
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"show" object:nil];
        } withBlockSure:^{
            JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
            vc.reloadCtrlData = ^(){
                [self loadIndexdata];
            };
            [self.navigationController pushViewController:vc animated:YES];
        } withBlock:^(UIAlertController *alertView) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"show" object:nil];
            [self presentViewController:alertView animated:YES completion:nil];
        }];
        
        return;
    }
}
#pragma mark -- 网页 跳转活动详情
- (void)PushJGTeamActibityNameViewController:(NSNotification *)not{
    //回到首页
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.tabBarController.selectedIndex = 0;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        
    }
    else
    {
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"show" object:nil];
        } withBlockSure:^{
            JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
            vc.reloadCtrlData = ^(){
                [self loadIndexdata];
            };
            [self.navigationController pushViewController:vc animated:YES];
        } withBlock:^(UIAlertController *alertView) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"show" object:nil];
            [self presentViewController:alertView animated:YES completion:nil];
        }];
        
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@", not.userInfo[@"details"]];
    
    if ([urlString containsString:@"dagolfla://"]) {
        
        // 球队提现
        
        if ([urlString containsString:@"teamWithDraw"]) {
            if ([urlString containsString:@"?"]) {
                JGDWithDrawTeamMoneyViewController *vc = [[JGDWithDrawTeamMoneyViewController alloc] init];
                vc.teamKey = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:urlString andKey:@"teamKey"] integerValue]];
                [self.navigationController pushViewController:vc animated:YES];        }
        }
        
        // 球队大厅
            
            if ([urlString containsString:@"teamHall"]) {
                JGTeamMainhallViewController *teamMainCtrl = [[JGTeamMainhallViewController alloc]init];
                [self.navigationController pushViewController:teamMainCtrl animated:YES];
        }
        
        // 成员管理
        
        if ([urlString containsString:@"teamMemberMgr"]) {
            JGTeamMemberController* menVc = [[JGTeamMemberController alloc]init];
            menVc.title = @"队员管理";
            menVc.power = @"1004,1001,1002,1005";
            menVc.teamManagement = 1;
            menVc.teamKey = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:urlString andKey:@"teamKey"] integerValue]];
            [self.navigationController pushViewController:menVc animated:YES];
        }
        
        // 入队审核页面
        
        if ([urlString containsString:@"auditTeamMember"]) {
            JGLJoinManageViewController *jgJoinVC = [[JGLJoinManageViewController alloc] init];
            jgJoinVC.teamKey = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:urlString andKey:@"teamKey"] integerValue]];
            [self.navigationController pushViewController:jgJoinVC animated:YES];
        }
        
        //新球友
        if ([urlString containsString:@"newUserFriendList"]) {
            NewFriendViewController *friendCtrl = [[NewFriendViewController alloc]init];
            friendCtrl.fromWitchVC = 2;
            [self.navigationController pushViewController:friendCtrl animated:YES];
        }
        
        // 相册
        if ([urlString containsString:@"teamMediaList"]) {
            JGPhotoAlbumViewController *albumVC = [[JGPhotoAlbumViewController alloc]init];
            albumVC.albumKey = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:urlString andKey:@"albumKey"] integerValue]];
            albumVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:albumVC animated:YES];
        }

        //活动详情
        if ([urlString containsString:@"teamActivityDetail"]) {
            JGTeamActibityNameViewController *teamCtrl= [[JGTeamActibityNameViewController alloc]init];
            teamCtrl.teamKey = [[Helper returnKeyVlaueWithUrlString:urlString andKey:@"activityKey"] integerValue];
            teamCtrl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:teamCtrl animated:YES];
        }
        
        //分组--普通用户
        if ([urlString containsString:@"activityGroup"]) {
            JGTeamGroupViewController *teamGroupCtrl= [[JGTeamGroupViewController alloc]init];
            teamGroupCtrl.teamActivityKey = [[Helper returnKeyVlaueWithUrlString:urlString andKey:@"activityKey"] integerValue];
            teamGroupCtrl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:teamGroupCtrl animated:YES];
        }
        
        //分组--管理
        if ([urlString containsString:@"activityGroupAdmin"]) {
            JGTeamGroupViewController *teamGroupCtrl= [[JGTeamGroupViewController alloc]init];
            teamGroupCtrl.teamActivityKey = [[Helper returnKeyVlaueWithUrlString:urlString andKey:@"activityKey"] integerValue];
            teamGroupCtrl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:teamGroupCtrl animated:YES];
        }
        
        //活动成绩详情 --
        if ([urlString containsString:@"activityScore"]) {
            JGLScoreRankViewController *scoreLiveCtrl= [[JGLScoreRankViewController alloc]init];
            scoreLiveCtrl.activity = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:urlString andKey:@"activityKey"] integerValue]];
            scoreLiveCtrl.teamKey = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:urlString andKey:@"teamKey"] integerValue]];
            scoreLiveCtrl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:scoreLiveCtrl animated:YES];
        }
        
        //获奖详情 -- 
        if ([urlString containsString:@"awardedInfo"]) {
            JGLPresentAwardViewController *teamGroupCtrl= [[JGLPresentAwardViewController alloc]init];
            teamGroupCtrl.activityKey = [[Helper returnKeyVlaueWithUrlString:urlString andKey:@"activityKey"] integerValue];
            teamGroupCtrl.teamKey = [[Helper returnKeyVlaueWithUrlString:urlString andKey:@"teamKey"] integerValue];
            teamGroupCtrl.isManager = 0;//0-非管理员
            teamGroupCtrl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:teamGroupCtrl animated:YES];
        }
        
        //球队详情
        if ([urlString containsString:@"teamDetail"]) {
            JGDNewTeamDetailViewController *newTeamVC = [[JGDNewTeamDetailViewController alloc] init];
            newTeamVC.timeKey = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:urlString andKey:@"timekey"] integerValue]];
            newTeamVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:newTeamVC animated:YES];
        }
        
        //商品详情
        if ([urlString containsString:@"goodDetail"]) {
            UseMallViewController* userVc = [[UseMallViewController alloc]init];
            userVc.linkUrl = [NSString stringWithFormat:@"http://www.dagolfla.com/app/ProductDetails.html?proid=%td", [[Helper returnKeyVlaueWithUrlString:urlString andKey:@"timekey"] integerValue]];
            userVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:userVc animated:YES];
        }
        
        //H5
        if ([urlString containsString:@"openURL"]) {
            JGLPushDetailsViewController* puVc = [[JGLPushDetailsViewController alloc]init];
            puVc.strUrl = [Helper returnKeyVlaueWithUrlString:urlString andKey:@"timekey"];
            puVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:puVc animated:YES];
        }
        
        //社区
        if ([urlString containsString:@"moodKey"]) {
            DetailViewController * comDevc = [[DetailViewController alloc]init];
            comDevc.detailId = [NSNumber numberWithInteger:[[Helper returnKeyVlaueWithUrlString:urlString andKey:@"timekey"] integerValue]];
            comDevc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:comDevc animated:YES];
        }
        
        //创建球队
        if ([urlString containsString:@"createTeam"]) {
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
