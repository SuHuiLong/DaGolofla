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

static NSString *const JGHPASHeaderTableViewCellIdentifier = @"JGHPASHeaderTableViewCell";
static NSString *const JGHShowSectionTableViewCellIdentifier = @"JGHShowSectionTableViewCell";
static NSString *const JGHShowFavouritesCellIdentifier = @"JGHShowFavouritesCell";
static NSString *const JGHShowActivityPhotoCellIdentifier = @"JGHShowActivityPhotoCell";
static NSString *const JGHWonderfulTableViewCellIdentifier = @"JGHWonderfulTableViewCell";
static NSString *const JGHShowRecomStadiumTableViewCellIdentifier = @"JGHShowRecomStadiumTableViewCell";
static NSString *const JGHShowSuppliesMallTableViewCellIdentifier = @"JGHShowSuppliesMallTableViewCell";

@interface JGHNewHomePageViewController ()<UITableViewDelegate, UITableViewDataSource, JGHShowSectionTableViewCellDelegate, CLLocationManagerDelegate, JGHShowActivityPhotoCellDelegate, JGHWonderfulTableViewCellDelegate, JGHShowRecomStadiumTableViewCellDelegate, JGHShowSuppliesMallTableViewCellDelegate, JGHNavListViewDelegate>
{
    NSArray *_titleArray;
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
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
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
    
    [self getCurPosition];
    
    [self loadIndexdata];//上线注释
    
    [self createHomeTableView];
    
    [self createBanner];
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
        
        [self.indexModel setValuesForKeysWithDictionary:data];
        
        [self.homeTableView reloadData];
        [self.homeTableView.header endRefreshing];
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
        
//        NSInteger saveOrDelete = 0;
//        saveOrDelete = [_showArray[section] integerValue];
//        [eventRulesHeaderCell configJGHEventRulesHeaderCell:section +1 andSelect:saveOrDelete];
        
        return pASHeaderCell;
    }else{
        JGHShowSectionTableViewCell *showSectionCell = [tableView dequeueReusableCellWithIdentifier:JGHShowSectionTableViewCellIdentifier];
        showSectionCell.delegate = self;
        showSectionCell.moreBtn.tag = 100 +section;
        [showSectionCell congfigJGHShowSectionTableViewCell:_titleArray[section] andHiden:1];
        return showSectionCell;
    }
}

//Cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 活动－相册－成绩
        return 150 *ProportionAdapter;
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
    // 热门球队
    if (indexPath.section == 2) {
        
    }
}
#pragma mark -- 我的球队
- (void)didSelectMyTeamBtn:(UIButton *)btn{
    NSLog(@"我的球队");
}
#pragma mark -- 开局记分
- (void)didSelectStartScoreBtn:(UIButton *)btn{
    NSLog(@"开局记分");
}
#pragma mark -- 历史成绩
- (void)didSelectHistoryResultsBtn:(UIButton *)btn{
    NSLog(@"历史成绩");
}
#pragma mark -- 活动点击事件
- (void)activityListSelectClick:(UIButton *)btn{
    NSLog(@"%td", btn.tag);
}
#pragma mark -- 精彩推荐
- (void)wonderfulSelectClick:(UIButton *)btn{
    NSLog(@"%td", btn.tag);
}
#pragma mark -- 球场推荐
- (void)recomStadiumSelectClick:(UIButton *)btn{
    NSLog(@"%td", btn.tag);
}
#pragma mark -- 用品商城
- (void)suppliesMallSelectClick:(UIButton *)btn{
    NSLog(@"%td", btn.tag);
}
#pragma mark -- 更多
- (void)didSelectMoreBtn:(UIButton *)moreBtn{
    NSLog(@"%td", moreBtn.tag);
    
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
         }
         else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }
         else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
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
