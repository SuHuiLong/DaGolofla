//
//  SearchWithCityViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/5/5.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "SearchWithCityViewController.h"
#import "SearchWithCityTableViewCell.h"
#import "SearchWIthCityModel.h"

@interface SearchWithCityViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>

/**
 主视图tableview
 */
@property(nonatomic, strong)UITableView *mainTableView;
/**
 数据源
 */
@property(nonatomic, strong)NSMutableArray *dataArray;
/**
 定位省市按钮
 */
@property(nonatomic, strong)UIButton *localCityBtn;
/**
 定位代理
 */
@property (strong, nonatomic) CLLocationManager* locationManager;

@end

@implementation SearchWithCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(255,255,255);
    // Do any additional setup after loading the view.
}

#pragma mark - CreateView
-(void)createView{
    [self createNavigationView];
    [self createTableView];
}
//设置导航栏
-(void)createNavigationView{
    self.title = @"选择省市";
    if (_requestType==1) {
        self.title = @"活动省市";
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    //设置导航背景
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //backL
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    leftItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftItem;

}
//创建tableview
-(void)createTableView{
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) style:UITableViewStyleGrouped];
    mainTableView.backgroundColor = ClearColor;
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [mainTableView dequeueReusableCellWithIdentifier:@"SearchWithCityTableViewCellId"];
    [self.view addSubview:mainTableView];
    self.mainTableView = mainTableView;
}

#pragma mark - InitData
-(void)initData{
    switch (_requestType) {
        case 0:
            [self initOrderParkData];
            break;
        case 1:
            [self initActivityData];
            break;
        default:
            break;
    }
}
//获取订场城市数据
-(void)initOrderParkData{
    //使用yyDIskCache进行本地保存
    NSString *cacherPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    YYCache *diskCache = [[YYCache alloc] initWithPath:cacherPath];
    if ([diskCache containsObjectForKey:@"ballArea"]) {
        NSArray *list = (NSArray *)[diskCache objectForKey:@"ballArea"];
        self.dataArray = [NSMutableArray array];
        for (NSDictionary *listDict in list) {
            SearchWIthCityModel *model = [SearchWIthCityModel modelWithDictionary:listDict];
            [self.dataArray addObject:model];
        }
        [self.mainTableView reloadData];
    }
    [self loadData];
}
//通过服务器获取更新订场城市数据
-(void)loadData{
    
    [[JsonHttp jsonHttp] httpRequest:@"http://res.dagolfla.com/download/json/ballArea.json" failedBlock:^(id errType) {
        NSLog(@"%@", errType);
    } completionBlock:^(id data) {
        NSString *cacherPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        YYCache *diskCache = [[YYCache alloc] initWithPath:cacherPath];
        NSArray *list = [NSArray arrayWithArray:[data objectForKey:@"areaList"]];
        [diskCache setObject:list forKey:@"ballArea"];
        self.dataArray = [NSMutableArray array];
        for (NSDictionary *listDict in list) {
            SearchWIthCityModel *model = [SearchWIthCityModel modelWithDictionary:listDict];
            [self.dataArray addObject:model];
        }
        [self.mainTableView reloadData];
    }];
}
//获取订场城市数据
-(void)initActivityData{
    //使用yyDIskCache进行本地保存
    NSString *cacherPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    YYCache *diskCache = [[YYCache alloc] initWithPath:cacherPath];
    if ([diskCache containsObjectForKey:@"activityCityData"]) {
        NSArray *list = (NSArray *)[diskCache objectForKey:@"activityCityData"];
        self.dataArray = [NSMutableArray array];
        for (NSDictionary *listDict in list) {
            SearchWIthCityModel *model = [SearchWIthCityModel modelWithDictionary:listDict];
            [self.dataArray addObject:model];
        }
        [self.mainTableView reloadData];
    }
    [self loadActivityData];
}
//通过服务器获取更新活动城市数据
-(void)loadActivityData{
    
    [[JsonHttp jsonHttp] httpRequest:@"http://res.dagolfla.com/download/json/TeamActivityArea.json" failedBlock:^(id errType) {
        NSLog(@"%@", errType);
    } completionBlock:^(id data) {
        NSString *cacherPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        YYCache *diskCache = [[YYCache alloc] initWithPath:cacherPath];
        NSArray *list = [NSArray arrayWithArray:[data objectForKey:@"areaList"]];
        [diskCache setObject:list forKey:@"activityCityData"];
        self.dataArray = [NSMutableArray array];
        for (NSDictionary *listDict in list) {
            SearchWIthCityModel *model = [SearchWIthCityModel modelWithDictionary:listDict];
            [self.dataArray addObject:model];
        }
        [self.mainTableView reloadData];
    }];

}

#pragma mark - Action
-(void)popBack{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//定位城市选择
-(void)localCityBtnClick{
    self.blockAddress(self.localCityBtn.titleLabel.text);
    [self.navigationController popViewControllerAnimated:YES];
}
//重新定位
-(void)resetBtnClick{
    [self getCurPosition];
}

#pragma mark - UITableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchWIthCityModel *model = self.dataArray[indexPath.row];
    NSArray *cityArray = model.provinceList;
    NSInteger cityNum = cityArray.count;
    NSInteger numberLine = cityNum/3;
    NSInteger remainder = cityNum%3;
    if (remainder>0) {
        numberLine ++ ;
    }
    if (numberLine==0) {
        numberLine = 1;
    }
    return kHvertical(40)*numberLine + kHvertical(10);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kHvertical(125);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchWithCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchWithCityTableViewCellId"];
    if(cell == nil){
        cell = [[SearchWithCityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchWithCityTableViewCellId"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    __weak typeof(self) weakself = self;
    cell.blockAddress = ^(NSString *city){
        weakself.blockAddress(city);
        [self.navigationController popViewControllerAnimated:YES];
    };
    SearchWIthCityModel *model = self.dataArray[indexPath.row];
    [cell configModel:model];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [Factory createViewWithBackgroundColor:ClearColor frame:CGRectMake(0, 0, screenWidth, kHvertical(125))];
    
    //定位省市
    UILabel *locatCity = [Factory createLabelWithFrame:CGRectMake(kWvertical(12), kHvertical(17), kWvertical(100), kHvertical(20)) textColor:RGB(49,49,49) fontSize:kHorizontal(17) Title:@"定位省市"];
    [headerView addSubview:locatCity];
    
    //定位图标
    UIImageView *cityIcon = [Factory createImageViewWithFrame:CGRectMake(kWvertical(12), kHvertical(56), kWvertical(10), kHvertical(14)) Image:[UIImage imageNamed:@"address"]];
    [headerView addSubview:cityIcon];
    
    //当前省市
    self.localCityBtn = [Factory createButtonWithFrame:CGRectMake(kWvertical(26), kHvertical(56), kWvertical(100), kHvertical(14)) titleFont:kHorizontal(15) textColor:RGB(49,49,49) backgroundColor:ClearColor target:self selector:@selector(localCityBtnClick) Title:[UserDefaults objectForKey:CITYNAME]];
    [self.localCityBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.localCityBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [headerView addSubview:self.localCityBtn];
    
    //重新定位
    UIButton *resetBtn = [Factory createButtonWithFrame:CGRectMake(screenWidth - kWvertical(105), kHvertical(50), kWvertical(85), kHvertical(27)) titleFont:kHorizontal(15) textColor:RGB(0,134,73) backgroundColor:ClearColor target:self selector:@selector(resetBtnClick) Title:@" 重新定位"];
    [resetBtn setImage:[UIImage imageNamed:@"refresh"] forState:(UIControlStateNormal)];
    [resetBtn setImageEdgeInsets:UIEdgeInsetsMake(kHvertical(3), 0, kHvertical(3), 0)];
    [headerView addSubview:resetBtn];
    //浅色分割线
    UIView *lineView = [Factory createViewWithBackgroundColor:RGB(238,238,238) frame:CGRectMake(0, kHvertical(81), screenWidth, kHvertical(10))];
    [headerView addSubview:lineView];
    
    //提示文字
    UILabel *alertLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(12), lineView.y_height + kHvertical(15), screenWidth/2, kHvertical(24)) textColor:RGB(49,49,49) fontSize:kHorizontal(17) Title:@"选择查看的省市"];
    [headerView addSubview:alertLabel];
    
    return headerView;
}


#pragma mark --定位方法
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
    UIActivityIndicatorView *cityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(screenWidth - kWvertical(105), kHvertical(50),kHvertical(27), kHvertical(27))];
    [self.mainTableView addSubview:cityView];
    cityView.backgroundColor = [UIColor whiteColor];
    cityView.color = [UIColor grayColor];
    [cityView startAnimating];

    CLLocation *currLocation = [locations lastObject];
    //NSLog(@"经度=%f 纬度=%f 高度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0){
             CLPlacemark *placemark = [array objectAtIndex:0];
             //将获得的所有信息显示到label上
             //获取城市
             NSString *cityName = placemark.locality;
             
             if (!cityName) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 cityName = placemark.administrativeArea;
             }
             [UserDefaults setObject:cityName forKey:CITYNAME];
             //省份
             NSString *city =  placemark.administrativeArea;

             if ([city containsString:@"市"] || [city containsString:@"省"]) {
                 city = [city substringToIndex:[city length] - 1];
             }
             [UserDefaults setObject:city forKey:PROVINCENAME];
             [self.localCityBtn setTitle:city forState:(UIControlStateNormal)];
         }
         [cityView stopAnimating];
         [cityView removeFromSuperview];
     }];
    [UserDefaults setObject:[NSNumber numberWithFloat:currLocation.coordinate.latitude] forKey:BDMAPLAT];//纬度
    [UserDefaults setObject:[NSNumber numberWithFloat:currLocation.coordinate.longitude] forKey:BDMAPLNG];//经度

    [_locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
