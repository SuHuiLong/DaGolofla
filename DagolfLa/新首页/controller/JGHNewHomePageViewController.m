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
#import "JGHShowFavouritesCell.h"
#import "JGHShowActivityPhotoCell.h"
#import "JGHWonderfulTableViewCell.h"
#import "JGHShowRecomStadiumTableViewCell.h"
#import "JGHShowSuppliesMallTableViewCell.h"
#import "JGHIndexModel.h"
#import "JGHNavListView.h"
#import "JGLScoreNewViewController.h"
#import "JGHShowMyTeamViewController.h" // 我的球队
#import "JGTeamMemberORManagerViewController.h" // 球队详情 － 自己的球队
#import "JGNotTeamMemberDetailViewController.h"  // 球队详情 － 别人的球队
#import "JGPhotoAlbumViewController.h" // 相册
#import "JGLWebUserMallViewController.h"
#import "JGTeamMainhallViewController.h"
#import "JGDHistoryScoreViewController.h"
#import "JGTeamActibityNameViewController.h" // 活动
#import "JGLScoreLiveViewController.h"   // 直播
#import "UseMallViewController.h"
#import "JGNewCreateTeamTableViewController.h"
#import "DetailViewController.h"
#import "JGLPushDetailsViewController.h"

static NSString *const JGHPASHeaderTableViewCellIdentifier = @"JGHPASHeaderTableViewCell";
static NSString *const JGHShowSectionTableViewCellIdentifier = @"JGHShowSectionTableViewCell";
static NSString *const JGHShowFavouritesCellIdentifier = @"JGHShowFavouritesCell";
static NSString *const JGHShowActivityPhotoCellIdentifier = @"JGHShowActivityPhotoCell";
static NSString *const JGHWonderfulTableViewCellIdentifier = @"JGHWonderfulTableViewCell";
static NSString *const JGHShowRecomStadiumTableViewCellIdentifier = @"JGHShowRecomStadiumTableViewCell";
static NSString *const JGHShowSuppliesMallTableViewCellIdentifier = @"JGHShowSuppliesMallTableViewCell";

@interface JGHNewHomePageViewController ()<UITableViewDelegate, UITableViewDataSource, JGHShowSectionTableViewCellDelegate, CLLocationManagerDelegate, JGHShowActivityPhotoCellDelegate, JGHWonderfulTableViewCellDelegate, JGHShowRecomStadiumTableViewCellDelegate, JGHShowSuppliesMallTableViewCellDelegate, JGHNavListViewDelegate, JGHPASHeaderTableViewCellDelegate>
{
    NSArray *_titleArray;
    
    NSInteger _showLineID;//0-活动，1-相册，2-成绩
}
@property (nonatomic, strong)HomeHeadView *topScrollView;//BANNAER图

@property (nonatomic, strong)UITableView *homeTableView;//TB

@property (strong, nonatomic) CLLocationManager* locationManager;

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
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    _titleArray = @[@"", @"精彩推荐", @"热门球队", @"球场推荐", @"用品商城"];
    self.indexModel = [[JGHIndexModel alloc]init];
    _showLineID = 0;
    
    //监听分组页面返回，刷新数据
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(PushJGTeamActibityNameViewController:) name:@"PushJGTeamActibityNameViewController" object:nil];

    
    [self createHomeTableView];
    
    [self parsingCacheData];
    
    [self loadIndexdata];//上线不注释
    
    [self getCurPosition];
    
    [self createBanner];
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
        NSString * str = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:&error];
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
        [getDict setObject:[userDef objectForKey:@"lng"] forKey:@"longitude"];
        [getDict setObject:[userDef objectForKey:@"lat"] forKey:@"latitude"];
    }
    
    [[JsonHttp jsonHttp]httpRequest:@"index/getIndex" JsonKey:nil withData:getDict requestMethod:@"GET" failedBlock:^(id errType) {
        [self.homeTableView.header endRefreshing];
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        _showLineID = 0;
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            [self.indexModel setValuesForKeysWithDictionary:data];
            
            [self.homeTableView reloadData];
            [self.homeTableView.header endRefreshing];
            
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
            //        [archiver encodeInt:20 forKey:@"age"];
            //        [archiver encodeObject:@[@"ios",@"oc"] forKey:@"language"];
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
    }];
}
#pragma mark -- 创建TableView
- (void)createHomeTableView{
    self.homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight -44)];
    
    UINib *pASHeaderTableViewCellNib = [UINib nibWithNibName:@"JGHPASHeaderTableViewCell" bundle: [NSBundle mainBundle]];
    [self.homeTableView registerNib:pASHeaderTableViewCellNib forCellReuseIdentifier:JGHPASHeaderTableViewCellIdentifier];
    
    UINib *showSectionTableViewCellNib = [UINib nibWithNibName:@"JGHShowSectionTableViewCell" bundle: [NSBundle mainBundle]];
    [self.homeTableView registerNib:showSectionTableViewCellNib forCellReuseIdentifier:JGHShowSectionTableViewCellIdentifier];
    
    UINib *showFavouritesCellNib = [UINib nibWithNibName:@"JGHShowFavouritesCell" bundle: [NSBundle mainBundle]];
    [self.homeTableView registerNib:showFavouritesCellNib forCellReuseIdentifier:JGHShowFavouritesCellIdentifier];
    
    [self.homeTableView registerClass:[JGHWonderfulTableViewCell class] forCellReuseIdentifier:JGHWonderfulTableViewCellIdentifier];
    
    [self.homeTableView registerClass:[JGHShowActivityPhotoCell class] forCellReuseIdentifier:JGHShowActivityPhotoCellIdentifier];
    
    [self.homeTableView registerClass:[JGHShowRecomStadiumTableViewCell class] forCellReuseIdentifier:JGHShowRecomStadiumTableViewCellIdentifier];
    
    [self.homeTableView registerClass:[JGHShowSuppliesMallTableViewCell class] forCellReuseIdentifier:JGHShowSuppliesMallTableViewCellIdentifier];
    
    self.homeTableView.dataSource = self;
    self.homeTableView.delegate = self;
    self.homeTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.homeTableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    self.homeTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self.view addSubview:self.homeTableView];
}
- (void)headRereshing{
    [self loadIndexdata];
}
#pragma  mark -- 创建Banner
-(void)createBanner
{
    //头视图
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth/2 +95 *ProportionAdapter)];
    headerView.backgroundColor = [UIColor whiteColor];
    //banner
    self.topScrollView = [[HomeHeadView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth/2)];
    self.topScrollView.userInteractionEnabled = YES;
    [headerView addSubview:self.topScrollView];
    
    self.navListView = [[JGHNavListView alloc]initWithFrame:CGRectMake(0, screenWidth/2, screenWidth, 95 *ProportionAdapter)];
    self.navListView.delegate = self;
    [headerView addSubview:self.navListView];
    
    self.homeTableView.tableHeaderView = headerView;
    
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
                [self.topScrollView setClick:^(UIViewController *vc) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            }
        }
    }];
}
#pragma mark - UITableViewDataSource 协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return _dataArray.count +1;
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2){
        //热门球队
        if (_indexModel.plateList.count > 0) {
            NSDictionary *dict = _indexModel.plateList[1];
            NSArray *bodyList = [dict objectForKey:@"bodyList"];
            return bodyList.count;
        }else{
            return 0;
        }
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 4) {
        return 0;
    }
    return 10 *ProportionAdapter;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10)];
    footView.backgroundColor = [UIColor colorWithHexString:BG_color];
    return footView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        JGHShowActivityPhotoCell *showActivityPhotoCell = [tableView dequeueReusableCellWithIdentifier:JGHShowActivityPhotoCellIdentifier];
        showActivityPhotoCell.delegate = self;
        [showActivityPhotoCell configJGHShowActivityPhotoCell:_indexModel.activityList];
        return showActivityPhotoCell;
    }else if (indexPath.section == 1){
        JGHWonderfulTableViewCell *wonderfulTableViewCell = [tableView dequeueReusableCellWithIdentifier:JGHWonderfulTableViewCellIdentifier];
        wonderfulTableViewCell.delegate = self;
        if (self.indexModel.plateList.count > 0) {
            NSDictionary *wonderfulDict = self.indexModel.plateList[0];
            NSArray *wonderfulArray = [wonderfulDict objectForKey:@"bodyList"];
            [wonderfulTableViewCell configJGHWonderfulTableViewCell:wonderfulArray];
        }
    
        return wonderfulTableViewCell;
    }else if (indexPath.section == 2){
        //热门球队
        JGHShowFavouritesCell *showFavouritesCell = [tableView dequeueReusableCellWithIdentifier:JGHShowFavouritesCellIdentifier];
        if (self.indexModel.plateList.count > 1) {
            NSDictionary *favourDict = self.indexModel.plateList[1];
            NSArray *favourArray = [favourDict objectForKey:@"bodyList"];
            [showFavouritesCell configJGHShowFavouritesCell:favourArray[indexPath.row]];
        }
        
        return showFavouritesCell;
    }else if (indexPath.section == 3){
        //球场推荐
        JGHShowRecomStadiumTableViewCell *showRecomStadiumTableViewCell = [tableView dequeueReusableCellWithIdentifier:JGHShowRecomStadiumTableViewCellIdentifier];
        showRecomStadiumTableViewCell.delegate = self;
        
        if (self.indexModel.plateList.count > 2) {
            NSDictionary *recomStadiumDict = self.indexModel.plateList[2];
            NSArray *recomStadiumArray = [recomStadiumDict objectForKey:@"bodyList"];
            [showRecomStadiumTableViewCell configJGHShowRecomStadiumTableViewCell:recomStadiumArray];
        }
        
        return showRecomStadiumTableViewCell;
    }else{
        //用品商城
        JGHShowSuppliesMallTableViewCell *showSuppliesMallTableViewCell = [tableView dequeueReusableCellWithIdentifier:JGHShowSuppliesMallTableViewCellIdentifier];
        showSuppliesMallTableViewCell.delegate = self;
        if (self.indexModel.plateList.count > 3) {
            NSDictionary *suppliesMallDict = self.indexModel.plateList[3];
            NSArray *suppliesMallArray = [suppliesMallDict objectForKey:@"bodyList"];
            [showSuppliesMallTableViewCell configJGHShowSuppliesMallTableViewCell:suppliesMallArray];
        }
        
        return showSuppliesMallTableViewCell;
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
        
        [showSectionCell congfigJGHShowSectionTableViewCell:_titleArray[section] andHiden:_more];
        return (UIView *)showSectionCell;
    }
}
//Cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 活动－相册－成绩
        return 190 *ProportionAdapter;
    }else if (indexPath.section == 1){
        //精彩推荐
        if (_indexModel.plateList.count > 0) {
            NSDictionary *dict = _indexModel.plateList[0];
            NSArray *bodyList = [dict objectForKey:@"bodyList"];
            return ((bodyList.count-1)/2+1) *143 *ProportionAdapter + 8*ProportionAdapter;
        }else{
            return 0;
        }
    }else if (indexPath.section == 3){
        //球场推荐
        if (_indexModel.plateList.count > 0) {
            NSDictionary *dict = _indexModel.plateList[2];
            NSArray *bodyList = [dict objectForKey:@"bodyList"];
            return ((bodyList.count-1)/2+1) *171 *ProportionAdapter + 8*ProportionAdapter;
        }else{
            return 0;
        }
    }else if (indexPath.section == 4){
        //用品商城
        if (_indexModel.plateList.count > 0) {
            NSDictionary *dict = [_indexModel.plateList lastObject];
            NSArray *bodyList = [dict objectForKey:@"bodyList"];
            return ((bodyList.count-1)/2+1) *250 *ProportionAdapter + 8*ProportionAdapter;
        }else{
            return 0;
        }
    }else{
        //2---热门球队
        return 90 *ProportionAdapter;
    }
}
//设置头部高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45 *ProportionAdapter;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 热门球队 --- 详情
    if (indexPath.section == 2) {
        NSDictionary *dict = [_indexModel.plateList[1] objectForKey:@"bodyList"][indexPath.row];
        [self hotTeam: dict];
    }
}

- (void)hotTeam:(NSDictionary *)dict{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if (DEFAULF_USERID != nil) {
        [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    }
    [dic setObject:[dict objectForKey:@"timeKey"] forKey:@"teamKey"];
    
    [[JsonHttp jsonHttp] httpRequest:@"team/getTeamInfo" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
            if (![data objectForKey:@"teamMember"]) {
                JGNotTeamMemberDetailViewController *detailVC = [[JGNotTeamMemberDetailViewController alloc] init];
                detailVC.detailDic = [data objectForKey:@"team"];
                [self.navigationController pushViewController:detailVC animated:YES];
            }else{
                
                if ([[[data objectForKey:@"teamMember"] objectForKey:@"power"] containsString:@"1005"]){
                    JGTeamMemberORManagerViewController *detailVC = [[JGTeamMemberORManagerViewController alloc] init];
                    detailVC.detailDic = [data objectForKey:@"team"];
                    
                    detailVC.isManager = YES;
                    [self.navigationController pushViewController:detailVC animated:YES];
                }else{
                    JGTeamMemberORManagerViewController *detailVC = [[JGTeamMemberORManagerViewController alloc] init];
                    detailVC.detailDic = [data objectForKey:@"team"];
                    detailVC.isManager = NO;
                    [self.navigationController pushViewController:detailVC animated:YES];
                }
            }
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
}
#pragma mark -- 1001(活动) －－1002(相册) －－ 1003（成绩）
- (void)didSelectActivityOrPhotoOrResultsBtn:(UIButton *)btn{
    JGHShowActivityPhotoCell *cell = [self.homeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    UILabel *activityLable = [self.view viewWithTag:30001];
    UILabel *photoLable = [self.view viewWithTag:30002];
    UILabel *scoreLable = [self.view viewWithTag:30003];
    
    if (btn.tag == 1001) {
        _showLineID = 0;
        activityLable.hidden = NO;
        photoLable.hidden = YES;
        scoreLable.hidden = YES;
        [cell configJGHShowActivityPhotoCell:_indexModel.activityList];
        
    } else if (btn.tag == 1002) {
        _showLineID = 1;
        activityLable.hidden = YES;
        photoLable.hidden = NO;
        scoreLable.hidden = YES;
        [cell configJGHShowPhotoCell:_indexModel.albumList];
        cell.photoBlock = ^(NSInteger numB){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
            
            JGPhotoAlbumViewController *photoVC = [[JGPhotoAlbumViewController alloc] init];
            photoVC.albumKey = [_indexModel.albumList[numB] objectForKey:@"timeKey"];
            [self.navigationController pushViewController:photoVC animated:YES];
        };
    } else if (btn.tag == 1003) {
        _showLineID = 2;
        activityLable.hidden = YES;
        photoLable.hidden = YES;
        scoreLable.hidden = NO;
        [cell configJGHShowLiveCell:_indexModel.scoreList];
        cell.liveBlock = ^(NSInteger numB){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
            
            JGLScoreLiveViewController *liveVC = [[JGLScoreLiveViewController alloc] init];
            
            liveVC.activity = [_indexModel.scoreList[numB] objectForKey:@"timeKey"];
            
            JGTeamAcitivtyModel* liveModel = [[JGTeamAcitivtyModel alloc] init];
            [liveModel setValuesForKeysWithDictionary:_indexModel.scoreList[numB]];
            
            liveVC.model = liveModel;
            
            [self.navigationController pushViewController:liveVC animated:YES];
        };
    }
    
}
#pragma mark -- 我的球队
- (void)didSelectMyTeamBtn:(UIButton *)btn{
    JGHShowMyTeamViewController *myTeamVC = [[JGHShowMyTeamViewController alloc] init];
    myTeamVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myTeamVC animated:YES];
}
#pragma mark -- 开局记分
- (void)didSelectStartScoreBtn:(UIButton *)btn{
    JGLScoreNewViewController *scoreCtrl = [[JGLScoreNewViewController alloc]init];
    scoreCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scoreCtrl animated:YES];
}
#pragma mark -- 历史成绩
- (void)didSelectHistoryResultsBtn:(UIButton *)btn{
    JGDHistoryScoreViewController *historyCtrl = [[JGDHistoryScoreViewController alloc]init];
    historyCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:historyCtrl animated:YES];
}
#pragma mark -- 活动点击事件
- (void)activityListSelectClick:(UIButton *)btn{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
    NSDictionary *dic = _indexModel.activityList[btn.tag - 200];
    JGTeamActibityNameViewController *teamActVC = [[JGTeamActibityNameViewController alloc] init];
    teamActVC.teamKey = [[dic objectForKey:@"timeKey"] integerValue];
    [self.navigationController pushViewController:teamActVC animated:YES];
}
#pragma mark -- 精彩推荐 -- 相册
- (void)wonderfulSelectClick:(UIButton *)btn{
    NSLog(@"%td", btn.tag);
    NSDictionary *dict = _indexModel.plateList[0];
    NSArray *bodyList = [dict objectForKey:@"bodyList"];
    NSDictionary *ablumListDict = bodyList[btn.tag -300];
    JGPhotoAlbumViewController *photoAlbumCtrl = [[JGPhotoAlbumViewController alloc]init];
    photoAlbumCtrl.albumKey = [NSNumber numberWithInteger:[[ablumListDict objectForKey:@"timeKey"] integerValue]];
    photoAlbumCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:photoAlbumCtrl animated:YES];
}
#pragma mark -- 球场推荐
- (void)recomStadiumSelectClick:(UIButton *)btn{
    NSLog(@"%td", btn.tag);
    NSDictionary *dict = _indexModel.plateList[2];
    NSArray *bodyList = [dict objectForKey:@"bodyList"];
    NSDictionary *mallListDict = bodyList[btn.tag -400];
    [self pushctrlWithUrl:[mallListDict objectForKey:@"weblinks"]];
}
#pragma mark -- 用品商城
- (void)suppliesMallSelectClick:(UIButton *)btn{
    NSLog(@"%td", btn.tag);
    NSDictionary *dict = _indexModel.plateList[3];
    NSArray *bodyList = [dict objectForKey:@"bodyList"];
    NSDictionary *mallListDict = bodyList[btn.tag -500];
    [self pushctrlWithUrl:[mallListDict objectForKey:@"weblinks"]];
}
#pragma mark -- 更多
- (void)didSelectMoreBtn:(UIButton *)moreBtn{
    NSLog(@"%td", moreBtn.tag);
    NSDictionary *dict = _indexModel.plateList[moreBtn.tag -100 -1];
    NSString *url = [dict objectForKey:@"moreLink"];
    if ([url containsString:@"teamHall"]) {
        JGTeamMainhallViewController *teamMainCtrl = [[JGTeamMainhallViewController alloc]init];
        teamMainCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:teamMainCtrl animated:YES];
    }else {
        NSString *urlRequest;
        if ([url containsString:@"index.html"]) {
            //http://www.dagolfla.com/app/index.html
            urlRequest = @"http://www.dagolfla.com/app/index.html";
        }else{
            urlRequest = @"http://www.dagolfla.com/app/bookserch.html";
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
#pragma MARK --定位方法
-(void)getCurPosition{
    if (_locationManager==nil) {
        _locationManager=[[CLLocationManager alloc] init];
    }
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager.delegate=self;
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        _locationManager.distanceFilter=10.0f;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            [_locationManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
        }
        [_locationManager startUpdatingLocation];
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currLocation = [locations lastObject];
    //NSLog(@"经度=%f 纬度=%f 高度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //将获得的所有信息显示到label上
             NSLog(@"%@",placemark.name);
             //获取城市
             NSString *city = placemark.locality;
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             [user setObject:city forKey:@"currentCity"];
             [user synchronize];
             
             //定位成功后下载数据
             [self loadIndexdata];
         } else {
             //定位失败后也下载数据
             [self loadIndexdata];
         }
     }];
    
    
    [user setObject:[NSNumber numberWithFloat:currLocation.coordinate.latitude] forKey:@"lat"];//纬度
    [user setObject:[NSNumber numberWithFloat:currLocation.coordinate.longitude] forKey:@"lng"];//经度
    [_locationManager stopUpdatingLocation];
    [user synchronize];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
        //NSLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
        //NSLog(@"无法获取位置信息");
    }
    
    //定位失败后也下载数据
    [self loadIndexdata];
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
}
#pragma mark -- 判断是否需要登录
- (void)isLoginUp{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        
    }
    else
    {
        [Helper alertViewWithTitle:@"是否立即登录?" withBlockCancle:^{
            
        } withBlockSure:^{
            EnterViewController *vc = [[EnterViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
        return;
    }
}
#pragma mark -- 网页 跳转活动详情
- (void)PushJGTeamActibityNameViewController:(NSNotification *)not{
    [self isLoginUp];
    
    if ([not.userInfo[@"details"] isEqualToString:@"activityKey"]) {
        //活动
        JGTeamActibityNameViewController *teamCtrl= [[JGTeamActibityNameViewController alloc]init];
        teamCtrl.teamKey = [not.userInfo[@"timekey"] integerValue];
        teamCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:teamCtrl animated:YES];
        return;
    }
    else if ([not.userInfo[@"details"] isEqualToString:@"teamKey"])
    {
        //球队
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userKey"];
        [dic setObject:@([not.userInfo[@"timekey"] integerValue]) forKey:@"teamKey"];
        
        [[JsonHttp jsonHttp] httpRequest:@"team/getTeamInfo" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {
            
        } completionBlock:^(id data) {
            
            
            if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                
                if (![data objectForKey:@"teamMember"]) {
                    JGNotTeamMemberDetailViewController *detailVC = [[JGNotTeamMemberDetailViewController alloc] init];
                    detailVC.detailDic = [data objectForKey:@"team"];
                    
                    [self.navigationController pushViewController:detailVC animated:YES];
                }else{
                    
                    if ([[[data objectForKey:@"teamMember"] objectForKey:@"power"] containsString:@"1005"]){
                        JGTeamMemberORManagerViewController *detailVC = [[JGTeamMemberORManagerViewController alloc] init];
                        detailVC.detailDic = [data objectForKey:@"team"];
                        detailVC.isManager = YES;
                        [self.navigationController pushViewController:detailVC animated:YES];
                    }else{
                        JGTeamMemberORManagerViewController *detailVC = [[JGTeamMemberORManagerViewController alloc] init];
                        detailVC.detailDic = [data objectForKey:@"team"];
                        detailVC.isManager = NO;
                        [self.navigationController pushViewController:detailVC animated:YES];
                    }
                    
                    
                }
                
            }else{
                if ([data objectForKey:@"packResultMsg"]) {
                    [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
                }
            }
            
        }];
        
        return;
    }
    else if ([not.userInfo[@"details"] isEqualToString:@"goodKey"])
    {
        //商城
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
        UseMallViewController* userVc = [[UseMallViewController alloc]init];
        userVc.linkUrl = [NSString stringWithFormat:@"http://www.dagolfla.com/app/ProductDetails.html?proid=%td",[not.userInfo[@"timekey"] integerValue]];
        [self.navigationController pushViewController:userVc animated:YES];
        return;
    }
    else if ([not.userInfo[@"details"] isEqualToString:@"url"])
    {
        //h5
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
        JGLPushDetailsViewController* puVc = [[JGLPushDetailsViewController alloc]init];
        puVc.strUrl = [NSString stringWithFormat:@"%@",not.userInfo[@"timekey"]];
        [self.navigationController pushViewController:puVc animated:YES];
    }
    else if ([not.userInfo[@"details"] isEqualToString:@"moodKey"])
    {
        //社区
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
        
        DetailViewController * comDevc = [[DetailViewController alloc]init];
        
        comDevc.detailId = [NSNumber numberWithInteger:[not.userInfo[@"timekey"] integerValue]];
        
        [self.navigationController pushViewController:comDevc animated:YES];
        
    }
    //创建球队
    else if ([not.userInfo[@"details"] isEqualToString:@"createTeam"]) {
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
                creatteamVc.detailDic = [[user objectForKey:@"cacheCreatTeamDic"] mutableCopy];
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
    else{
        
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
