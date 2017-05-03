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
#import "JGHShowMyTeamViewController.h" // 我的球队
#import "JGDNewTeamDetailViewController.h" // 球队详情
#import "JGLWebUserMallViewController.h"
#import "JGTeamMainhallViewController.h"
#import "JGHHistoryAndResultsViewController.h"
#import "JGHNewActivityDetailViewController.h" // 活动
#import "JGLScoreLiveViewController.h"   // 直播
#import "JGHIndexTableViewCell.h"
#import "JGHNewStartScoreViewController.h"

#import "UMMobClick/MobClick.h"
#import "JGDDPhotoAlbumViewController.h"
#import "JGDServiceViewController.h" // 定制服务
#import "JGDBookCourtViewController.h"  // 球场预定
#import "JGNewsViewController.h" // 咨询
#import "JGHConsultChannelCell.h"
#import "JGHChancelTableViewCell.h"
#import "JGNewsViewController.h"
#import "JGWkNewsViewController.h"
#import "UseMallViewController.h"
#import "JGDPersonalCard.h"
#import "JGHIndexSystemMessageCell.h"
#import "JGHShadowPhotoAlbumViewController.h"
#import "JGHSystemNotViewController.h"

static NSString *const JGHPASHeaderTableViewCellIdentifier = @"JGHPASHeaderTableViewCell";
static NSString *const JGHConsultChannelCellIdentifier = @"JGHConsultChannelCell";
static NSString *const JGHChancelTableViewCellIdentifier = @"JGHChancelTableViewCell";
static NSString *const JGHShowSectionTableViewCellIdentifier = @"JGHShowSectionTableViewCell";
static NSString *const JGHShowActivityPhotoCellIdentifier = @"JGHShowActivityPhotoCell";
static NSString *const JGHIndexTableViewCellIdentifier = @"JGHIndexTableViewCell";
static NSString *const JGHIndexSystemMessageCellIdentifier = @"JGHIndexSystemMessageCell";
static NSString *const JGHSpectatorSportsCellIdentifier = @"JGHSpectatorSportsCell";

@interface JGHNewHomePageViewController ()<UITableViewDelegate, UITableViewDataSource, JGHShowSectionTableViewCellDelegate, JGHShowActivityPhotoCellDelegate, JGHNavListViewDelegate, JGHPASHeaderTableViewCellDelegate, JGHIndexTableViewCellDelegate, JGHConsultChannelCellDelegate, JGHChancelTableViewCellDelegate>
{
    NSInteger _showLineID;//0-活动，1-相册，2-成绩
    NSInteger _showEventID;//0-赛事，1-球技，2-活动，3-视频
}

@property (nonatomic, copy)NSString *isBoot;
@property (nonatomic, strong)HomeHeadView *topScrollView;//BANNAER图
@property (nonatomic, strong)JGHIndexModel *indexModel;
@property (nonatomic, strong)JGHNavListView *navListView;
@property (nonatomic, strong)UITableView *homeTableView;//TB
@property (nonatomic, strong)UIView *toolView;//是否为启动请求数据接口 0： 非启动   1：启动
@end

@implementation JGHNewHomePageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationController.navigationBarHidden = YES;
    
    self.tabBarController.tabBar.hidden = NO;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //把当前界面的导航栏隐藏
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //监听分组页面返回，刷新数据    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(reloadViewData) name:@"loadMessageData" object:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self.navigationController.navigationBar
     setBackgroundImage:[UIImage imageNamed:@"segselectleft"]
     forBarMetrics:UIBarMetricsCompactPrompt];
    
    self.indexModel = [[JGHIndexModel alloc]init];
    _showLineID = 0;
    _showEventID = 0;

    [self createHomeTableView];
    
    [self parsingCacheData];
    
    [self loadIndexdata];
    
    [self createBanner];
    
    [self loadingPHP];
    
    if (DEFAULF_USERID) {
        [self loadMessageData];
        
        //刷新融云TongKT
        [self getRongTK];
    }
    
}

- (void)getRongTK{
    NSMutableDictionary* dictUser = [[NSMutableDictionary alloc]init];
    [dictUser setObject:DEFAULF_USERID forKey:@"userKey"];
    NSString *strMD = [JGReturnMD5Str getCaddieAuthUserKey:[DEFAULF_USERID integerValue]];
    [dictUser setObject:strMD forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"user/getUserInfo" JsonKey:nil withData:dictUser requestMethod:@"GET" failedBlock:^(id errType) {
    } completionBlock:^(id data) {
        if ([[data objectForKey:@"packSuccess"]boolValue]) {
            NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
            
            if ([data objectForKey:@"user"]) {
                NSDictionary *dict = [data objectForKey:@"user"];
                if ([dict objectForKey:@"rongTk"]) {
                    [userdef setObject:[dict objectForKey:@"rongTk"] forKey:@"rongTk"];
                    [userdef synchronize];
                }
            }            
        }
    }];
}

#pragma mark --刷新页面
- (void)reloadViewData{
    [self.homeTableView.mj_header beginRefreshing];
}
#pragma mark -- 下载未读消息数量
- (void)loadMessageData{
    [appDelegate loadMessageData];
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
        NSString *isExitTag = [userDef objectForKey:@"isExitTag"];
        [getDict setObject:DEFAULF_USERID forKey:@"userKey"];
        if ([_isBoot isEqualToString:@"1"]) {
            _isBoot = @"0";
        }else{
            _isBoot = @"1";
        }
        if(isExitTag){
            _isBoot = @"1";
            [userDef removeObjectForKey:@"isExitTag"];
        }
        [getDict setObject:_isBoot forKey:@"isBoot"];
    }else{
        [getDict setObject:@0 forKey:@"userKey"];
    }
    
    if ([userDef objectForKey:@"lat"]) {
        [getDict setObject:[userDef objectForKey:BDMAPLNG] forKey:@"longitude"];
        [getDict setObject:[userDef objectForKey:BDMAPLAT] forKey:@"latitude"];
    }
    
    [getDict setObject:@1 forKey:@"ballType"];
    [[JsonHttp jsonHttp]httpRequest:@"index/getIndexV1" JsonKey:nil withData:getDict requestMethod:@"GET" failedBlock:^(id errType) {
        [self.homeTableView.mj_header endRefreshing];
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        _showLineID = 0;
        _showEventID = 0;
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            bool isCanPerfectUserInfo =  [[data objectForKey:@"isCanPerfectUserInfo"] boolValue];
            if (isCanPerfectUserInfo) {
                [self alertCompleteSelfView];
            }
            
            if ([data objectForKey:@"newMsg"]) {
                self.indexModel.Msg = [data objectForKey:@"newMsg"];
            }else{
                self.indexModel.Msg = nil;
            }
            
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
        
        [self.homeTableView.mj_header endRefreshing];
    }];
}

#pragma mark -- 创建TableView
- (void)createHomeTableView{
    self.homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight -40 *ProportionAdapter) style:UITableViewStyleGrouped];
    
    UINib *pASHeaderTableViewCellNib = [UINib nibWithNibName:@"JGHPASHeaderTableViewCell" bundle: [NSBundle mainBundle]];
    [self.homeTableView registerNib:pASHeaderTableViewCellNib forCellReuseIdentifier:JGHPASHeaderTableViewCellIdentifier];
    
    UINib *consultChannelCellNib = [UINib nibWithNibName:@"JGHConsultChannelCell" bundle: [NSBundle mainBundle]];
    [self.homeTableView registerNib:consultChannelCellNib forCellReuseIdentifier:JGHConsultChannelCellIdentifier];
    
    UINib *showSectionTableViewCellNib = [UINib nibWithNibName:@"JGHShowSectionTableViewCell" bundle: [NSBundle mainBundle]];
    [self.homeTableView registerNib:showSectionTableViewCellNib forCellReuseIdentifier:JGHShowSectionTableViewCellIdentifier];
    
    [self.homeTableView registerClass:[JGHShowActivityPhotoCell class] forCellReuseIdentifier:JGHShowActivityPhotoCellIdentifier];

    [self.homeTableView registerClass:[JGHIndexTableViewCell class] forCellReuseIdentifier:JGHIndexTableViewCellIdentifier];
    
    [self.homeTableView registerClass:[JGHChancelTableViewCell class] forCellReuseIdentifier:JGHChancelTableViewCellIdentifier];
    
    [self.homeTableView registerClass:[JGHIndexSystemMessageCell class] forCellReuseIdentifier:JGHIndexSystemMessageCellIdentifier];
    
    self.homeTableView.dataSource = self;
    self.homeTableView.delegate = self;
    self.homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.homeTableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    self.homeTableView.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self.view addSubview:self.homeTableView];
}
- (void)headRereshing{
    [self loadIndexdata];
    [self loadBanner];
    [self loadMessageData];
}

#pragma  mark -- 创建Banner
-(void)createBanner
{
    //头视图
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth/2 +214 *ProportionAdapter)];
    headerView.backgroundColor = [UIColor whiteColor];
    //banner
    self.topScrollView = [[HomeHeadView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth/2)];
    self.topScrollView.userInteractionEnabled = YES;
    [headerView addSubview:self.topScrollView];
    
    self.navListView = [[JGHNavListView alloc]initWithFrame:CGRectMake(0, screenWidth/2 +10*ProportionAdapter, screenWidth, 204 *ProportionAdapter)];
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
    //
    [[JsonHttp jsonHttp] httpRequest:@"adv/getAdvertList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
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
                __weak JGHNewHomePageViewController *weakSelf = self;
                [self.topScrollView setClick:^(NSString *urlString) {

                    [MobClick event:@"home_banner_click"];

                    [weakSelf isLoginUp];
                   
                    if ([urlString containsString:@"dagolfla://"]) {
                        [[JGHPushClass pushClass]URLString:urlString pushVC:^(UIViewController *vc) {
                            vc.hidesBottomBarWhenPushed = YES;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        }];
                    }else{
                        UseMallViewController* userVc = [[UseMallViewController alloc]init];
                        userVc.linkUrl = urlString;
                        userVc.hidesBottomBarWhenPushed = YES;
                        [weakSelf.navigationController pushViewController:userVc animated:YES];
                    }
                }];
            }
        }
    }];
}

#pragma mark - UITableViewDataSource 协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{  
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
    
    if (!_indexModel.Msg && (section == 0)) {
        return 0.0001;
    }else{
        return 10 *ProportionAdapter;
}
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
        JGHIndexSystemMessageCell *showSectionCell = [tableView dequeueReusableCellWithIdentifier:JGHIndexSystemMessageCellIdentifier];
        showSectionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_indexModel.Msg) {
            showSectionCell.hidden = NO;
            [showSectionCell configJGHIndexSystemMessageCell:_indexModel.Msg];
        }else{
            showSectionCell.hidden = YES;
        }
        
        return showSectionCell;
    }else{
        JGHIndexTableViewCell *indexTableViewCell = [tableView dequeueReusableCellWithIdentifier:JGHIndexTableViewCellIdentifier];
        indexTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
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
            }else if (bodyLayoutType == 4){
                //精彩赛事
                [indexTableViewCell configJGHSpectatorSportsView:bodyList andImageW:imgWidth andImageH:imgHeight];
            }else if (bodyLayoutType == 5){
                //高旅套餐
                [indexTableViewCell configJGHGolfPackageView:bodyList andImageW:imgWidth andImageH:imgHeight];
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
        return nil;
    }

    JGHShowSectionTableViewCell *showSectionCell = [tableView dequeueReusableCellWithIdentifier:JGHShowSectionTableViewCellIdentifier];
    showSectionCell.delegate = self;
    //showSectionCell.moreBtn.tag = 100 +section;
    showSectionCell.moreClick.tag = 100 +section;
    
    NSDictionary *dict = _indexModel.plateList[section -1];
    NSInteger _more = 0;
    if ([dict objectForKey:@"moreLink"]) {
        _more = 1;
    }
    
    [showSectionCell congfigJGHShowSectionTableViewCell:[dict objectForKey:@"title"] andHiden:_more];
    return (UIView *)showSectionCell;
}
//Cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 系统消息
        if (_indexModel.Msg) {
            return 80 *ProportionAdapter;
        }else{
            return 0.0001;
        }
    }else{
        if (_indexModel.plateList.count > 0) {
            NSDictionary *dict = _indexModel.plateList[indexPath.section -1];
            NSArray *bodyList = [dict objectForKey:@"bodyList"];
            NSInteger bodyLayoutType = [[dict objectForKey:@"bodyLayoutType"] integerValue];
            NSInteger imgHeight = [[dict objectForKey:@"imgHeight"] integerValue];
            if (bodyLayoutType == 0) {
                //球队掠影
                return ((bodyList.count-1)/2+1) *(imgHeight +35 +8) *ProportionAdapter;
            }else if (bodyLayoutType == 1){
                //用品商城
                return ((bodyList.count-1)/2+1) *(imgHeight +104) *ProportionAdapter;
            }else if (bodyLayoutType == 2){
                //热门球队
                return ((25 +imgHeight) *ProportionAdapter) *bodyList.count;
            }else if (bodyLayoutType == 3){
                //订场推荐
                return ((bodyList.count-1)/2+1) *(imgHeight +56 +8) *ProportionAdapter;
            }else if (bodyLayoutType == 4){
                //精彩赛事
                return imgHeight*ProportionAdapter +99*ProportionAdapter;
            }else if (bodyLayoutType == 5){
                //高旅套餐
                return imgHeight*ProportionAdapter +89*ProportionAdapter;
            }else{
                //其他  －－－ 更新版本
                return 0;
            }
        }else{
            return 0;
        }
    }
}
//设置头部高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 45 *ProportionAdapter;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self isLoginUp];
        //系统消息
        if ([_indexModel.Msg objectForKey:@"linkURL"]) {
            [self pushctrlWithUrl:[_indexModel.Msg objectForKey:@"linkURL"]];
        }else{
            //消息无跳转链接－－跳转至消息
            JGHSystemNotViewController *sysCtrl = [[JGHSystemNotViewController alloc]init];
            sysCtrl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sysCtrl animated:YES];
        }
    }
}
- (void)hotTeam:(NSDictionary *)dict{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if (DEFAULF_USERID != nil) {
        [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    }
    [dic setObject:[dict objectForKey:@"timeKey"] forKey:@"teamKey"];
    
    JGDNewTeamDetailViewController *newTeamVC = [[JGDNewTeamDetailViewController alloc] init];
    newTeamVC.timeKey = [NSNumber numberWithInteger:[[dict objectForKey:@"timeKey"] integerValue]];
    newTeamVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newTeamVC animated:YES];
}
#pragma mark -- 资讯点击事件
- (void)didSelectJGHConsultChannelCellBtnClick:(UIButton *)btn{
    JGHChancelTableViewCell *cell = [self.homeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    UIButton *oneBtn = [self.view viewWithTag:801];
    UIButton *twoBtn = [self.view viewWithTag:802];
    UIButton *threeBtn = [self.view viewWithTag:803];
    UIButton *fourBtn = [self.view viewWithTag:804];
    [oneBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [twoBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [threeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [fourBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    if (btn.tag == 801) {
        _showEventID = 0;
        [oneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell configJGHChancelTableViewCellMatchList:_indexModel.matchNewList];
    }else if (btn.tag == 802){
        _showEventID = 1;
        [twoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell configJGHChancelTableViewCellMatchList:_indexModel.ballSkillNewList];
    }else if (btn.tag == 803){
        _showEventID = 2;
        [threeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell configJGHChancelTableViewCellMatchList:_indexModel.activityNewList];
    }else if (btn.tag == 804){
        _showEventID = 3;
        [fourBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell configJGHChancelTableViewCellMatchList:_indexModel.videoNewList];
    }
}
#pragma mark -- 资讯详情跳转
- (void)didSelectChancelClick:(UIButton *)btn{
    NSLog(@"_showEventID == %ld", (long)_showEventID);
    NSLog(@"btn.tag == %td", btn.tag);

    [self isLoginUp];

    /*
    JGWkNewsViewController *wknewsCtrl = [[JGWkNewsViewController alloc]init];
    if (_showEventID == 0) {
        wknewsCtrl.detailDic = _indexModel.matchNewList[btn.tag - 900];
        wknewsCtrl.urlString = [_indexModel.matchNewList[btn.tag - 900] objectForKey:@"url"];
    }else if (_showEventID == 1){
        wknewsCtrl.detailDic = _indexModel.ballSkillNewList[btn.tag - 900];
        wknewsCtrl.urlString = [_indexModel.ballSkillNewList[btn.tag - 900] objectForKey:@"url"];
    }else if (_showEventID == 2){
        wknewsCtrl.detailDic = _indexModel.activityNewList[btn.tag - 900];
        wknewsCtrl.urlString = [_indexModel.activityNewList[btn.tag - 900] objectForKey:@"url"];
    }else{
        wknewsCtrl.detailDic = _indexModel.videoNewList[btn.tag - 900];
        wknewsCtrl.urlString = [_indexModel.videoNewList[btn.tag - 900] objectForKey:@"url"];
    }
    
    wknewsCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:wknewsCtrl animated:YES];
     */
}
#pragma mark -- 查看更多
- (void)didSelectChancelMoreClick:(UIButton *)btn{

    [self isLoginUp];

    JGNewsViewController *moreCtrl = [[JGNewsViewController alloc]init];
    moreCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:moreCtrl animated:YES];
}
#pragma mark -- 1001(活动) －－1002(相册) －－ 1003（成绩）
- (void)didSelectActivityOrPhotoOrResultsBtn:(UIButton *)btn{
    
    JGHShowActivityPhotoCell *cell = [self.homeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    UILabel *activityLable = [self.view viewWithTag:30001];
    UILabel *photoLable = [self.view viewWithTag:30002];
    UILabel *scoreLable = [self.view viewWithTag:30003];
    
    UIButton *oneBtn = [self.view viewWithTag:1001];
    UIButton *twoBtn = [self.view viewWithTag:1002];
    UIButton *threeBtn = [self.view viewWithTag:1003];
    [oneBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [twoBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [threeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    if (btn.tag == 1001) {
        
        [MobClick event:@"activity"];

        _showLineID = 0;
        activityLable.hidden = NO;
        photoLable.hidden = YES;
        scoreLable.hidden = YES;
        [oneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [twoBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [threeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [cell configJGHShowActivityPhotoCell:_indexModel.activityList];
        
    } else if (btn.tag == 1002) {
        
        [MobClick event:@"photoAlbum"];

        _showLineID = 1;
        activityLable.hidden = YES;
        photoLable.hidden = NO;
        scoreLable.hidden = YES;
        [oneBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [twoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [threeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
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
        [oneBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [twoBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [threeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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

#pragma mark -- 服务定制
- (void)didSelectShitaBtn:(UIButton *)btn{
    
    [self isLoginUp];
    
    if (btn.tag == 700) {
        // 历史成绩
        [MobClick event:@"home_history_score_click"];
        JGHHistoryAndResultsViewController *historyCtrl = [[JGHHistoryAndResultsViewController alloc]init];
        historyCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:historyCtrl animated:YES];
    }else if (btn.tag == 701) {
        
        NSString *urlRequest = @"http://www.dagolfla.com/app/index.html"; // 用品商城
        [MobClick event:@"home_shop_click"];

        JGLWebUserMallViewController *mallCtrl = [[JGLWebUserMallViewController alloc]init];
        mallCtrl.urlRequest = urlRequest;
        mallCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mallCtrl animated:YES];
        
    }else if (btn.tag == 702) {
        
        [MobClick event:@"home_traver_package_click"];
        NSString *urlRequest = @"http://www.dagolfla.com/app/golftourism.html"; // 商旅套餐
    
        JGLWebUserMallViewController *mallCtrl = [[JGLWebUserMallViewController alloc]init];
        mallCtrl.urlRequest = urlRequest;
        mallCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mallCtrl animated:YES];

    } else{
        
        // 服务定制
        [MobClick event:@"home_service_custom_click"];
        JGDServiceViewController *serviceVC = [[JGDServiceViewController alloc] init];
        serviceVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:serviceVC animated:YES];
    }
}


#pragma mark -- 我的球队
- (void)didSelectMyTeamBtn:(UIButton *)btn{
    [self isLoginUp];
    // 友盟埋点
    [MobClick event:@"home_team_click"];
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
    
    btn.userInteractionEnabled = NO;
    
    [MobClick event:@"home_start_score_click"];
    JGHNewStartScoreViewController *scoreCtrl = [[JGHNewStartScoreViewController alloc]init];
    scoreCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scoreCtrl animated:YES];
    
    btn.userInteractionEnabled = YES;
}

#pragma mark -- 球场预定
- (void)didSelectHistoryResultsBtn:(UIButton *)btn{
//    [self isLoginUp];
    [MobClick event:@"home_ball_park_booking_click"];

    JGDBookCourtViewController *bookVC = [[JGDBookCourtViewController alloc] init];
    bookVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bookVC animated:YES];
    
//    NSString *urlRequest = @"http://www.dagolfla.com/app/bookserch.html";
//    JGLWebUserMallViewController *mallCtrl = [[JGLWebUserMallViewController alloc]init];
//    mallCtrl.urlRequest = urlRequest;
//    mallCtrl.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:mallCtrl animated:YES];
}

#pragma mark -- 活动点击事件
- (void)activityListSelectClick:(UIButton *)btn{
    [self isLoginUp];
    
    NSDictionary *dic = _indexModel.activityList[btn.tag - 200];
    JGHNewActivityDetailViewController *teamActVC = [[JGHNewActivityDetailViewController alloc] init];
    teamActVC.teamKey = [[dic objectForKey:@"timeKey"] integerValue];
    teamActVC.hidesBottomBarWhenPushed = YES;//6598520
    [self.navigationController pushViewController:teamActVC animated:YES];
    //JGHNewActivityDetailViewController
    
    /*
    NSDictionary *dic = _indexModel.activityList[btn.tag - 200];
    JGHNewActivityDetailViewController *teamActVC = [[JGHNewActivityDetailViewController alloc] init];
    teamActVC.teamKey = [[dic objectForKey:@"timeKey"] integerValue];
    teamActVC.hidesBottomBarWhenPushed = YES;//6598520
    [self.navigationController pushViewController:teamActVC animated:YES];
     */

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

        /*
        JGDDPhotoAlbumViewController *photoAlbumCtrl = [[JGDDPhotoAlbumViewController alloc] init];
//        JGPhotoAlbumViewController *photoAlbumCtrl = [[JGPhotoAlbumViewController alloc]init];
        photoAlbumCtrl.albumKey = [NSNumber numberWithInteger:[[ablumListDict objectForKey:@"timeKey"] integerValue]];
        photoAlbumCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:photoAlbumCtrl animated:YES];
        */
        [MobClick event:@"home_plate_click" attributes:@{@"球队掠影":[ablumListDict objectForKey:@"title"]}];

        JGHShadowPhotoAlbumViewController *phoVc = [[JGHShadowPhotoAlbumViewController alloc] init];
        //    JGPhotoAlbumViewController* phoVc = [[JGPhotoAlbumViewController alloc]init];
        //JGLPhotoAlbumModel *model = [[JGLPhotoAlbumModel alloc]init];
        //model = _dataArray[indexPath.item];
        
        //phoVc.strTitle = model.name;
        phoVc.albumKey = [NSNumber numberWithInteger:[[ablumListDict objectForKey:@"timeKey"] integerValue]];
        //phoVc.power = [NSString stringWithFormat:@"%@", model.power];
        //phoVc.state = [_dictMember objectForKey:@"state"];
        //phoVc.teamTimeKey = model.teamKey;
        //phoVc.dictMember = _dictMember;
        //phoVc.userKey = model.userKey;
        phoVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:phoVc animated:YES];
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
        [MobClick event:@"home_plate_click" attributes:@{@"订场推荐":[bodyList[btn.tag -400] objectForKey:@"weblinks"]}];
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
        [MobClick event:@"home_plate_click" attributes:@{@"用品商城":[bodyList[btn.tag -500] objectForKey:@"weblinks"]}];
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
    if (moreBtn.tag != 101) {
        [self isLoginUp];
    }
    NSArray *titleArray = [NSArray arrayWithObjects:@"精彩赛事-更多", @"球队掠影-更多", @"高旅套餐-更多", @"订场推荐-更多", @"用品商城-更多", nil];

    NSDictionary *dict = _indexModel.plateList[moreBtn.tag -100 -1];
    NSString *urlString = [dict objectForKey:@"moreLink"];
    [MobClick event:@"home_plate_more_click" attributes:@{titleArray[moreBtn.tag -101]:urlString}];

    [self pushctrlWithUrl:urlString];
}
#pragma mark -- 高旅套餐
- (void)didSelectGolgPackageUrlString:(NSInteger)selectID{
    [self isLoginUp];
    
    for (NSDictionary *dict in _indexModel.plateList) {
        NSInteger bodyLayoutType = [[dict objectForKey:@"bodyLayoutType"] integerValue];
        if (bodyLayoutType == 5) {
            
            NSArray *bodyListArray = [dict objectForKey:@"bodyList"];
            NSDictionary *bodyDict = bodyListArray[selectID];
            if ([bodyDict objectForKey:@"weblinks"]) {
                [[JGHPushClass pushClass] URLString:[NSString stringWithFormat:@"%@", [bodyDict objectForKey:@"weblinks"]] pushVC:^(UIViewController *vc) {
                    [MobClick event:@"home_plate_click" attributes:@{@"高旅套餐":[NSString stringWithFormat:@"%@", [bodyDict objectForKey:@"weblinks"]]}];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            }
        }
    }
}
#pragma mark -- 精彩赛事
- (void)selectSpectatorSportsUrlString:(NSInteger)selectID{
//    [self isLoginUp];
    for (NSDictionary *dict in _indexModel.plateList) {
        NSInteger bodyLayoutType = [[dict objectForKey:@"bodyLayoutType"] integerValue];
        if (bodyLayoutType == 4) {
            
            NSArray *bodyListArray = [dict objectForKey:@"bodyList"];
            NSDictionary *bodyDict = bodyListArray[selectID];
            if ([bodyDict objectForKey:@"weblinks"]) {
                [[JGHPushClass pushClass] URLString:[NSString stringWithFormat:@"%@", [bodyDict objectForKey:@"weblinks"]] pushVC:^(UIViewController *vc) {
                    [MobClick event:@"home_plate_click" attributes:@{@"精彩赛事":[NSString stringWithFormat:@"%@", [bodyDict objectForKey:@"weblinks"]]}];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            }
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 通过URL 判断跳转
- (void)pushctrlWithUrl:(NSString *)url{
    if ([url containsString:@"dagolfla://"]) {
        
        [[JGHPushClass pushClass] URLString:url pushVC:^(UIViewController *vc) {
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];
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
            JGHLoginViewController *vc = [[JGHLoginViewController alloc] init];
            vc.reloadCtrlData = ^(){
                [self.homeTableView.mj_header beginRefreshing];
                [self loadMessageData];
            };
            
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
        
        return;
    }
}

#pragma mark - Table View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scrollView11 == %f", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y > screenWidth/2 -20) {
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
        [self.view addSubview:self.toolView];
        _toolView.alpha = 1.0;
    }else{
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.view addSubview:self.toolView];
        _toolView.alpha = 0.0;
    }
}
//替换任务栏
- (UIView *)toolView{
    if (_toolView == nil) {
        _toolView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 20)];
        CGRect frame = _toolView.frame;
        frame.origin = CGPointMake(0, 0);
        _toolView.frame = frame;
        _toolView.alpha = 0.0;
        _toolView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEA"];
    }
    return _toolView;
}


//显示完善资料弹窗
-(void)alertCompleteSelfView{

    JGDPersonalCard *card = [[JGDPersonalCard alloc] initWithFrame:[UIScreen mainScreen].bounds];
    card.userInteractionEnabled = YES;
    [self.view addSubview:card];
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
