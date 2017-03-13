//
//  MyFootViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/31.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "MyFootViewController.h"

#import "AddFootViewController.h"
#import "ShowMapViewViewController.h"
#import "FootDetailViewController.h"

#import "MyFoodHeadTableViewCell.h"
#import "MyFootBodyTableViewCell.h"
#import "MyfootModel.h"

#import "Helper.h"

#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"


#import "PostDataRequest.h"

#import "PersonHomeController.h"

#import "MeViewController.h"


#import <BaiduMapAPI/BMapKit.h>
#import "UIView+ChangeFrame.h"


@interface MyFootViewController ()<UITableViewDataSource,UITableViewDelegate,BMKMapViewDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _dataArray;
    
    
    BMKMapView *_mapView;
    BMKPointAnnotation* pointAnnotation;
    
    NSInteger _page;
}

@end

@implementation MyFootViewController

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    // 地图的内存的释放
    [super viewWillAppear:animated];
    
    
    [_mapView viewWillAppear];
    
    
    self.tabBarController.tabBar.hidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的足迹";
    _dataArray = [[NSMutableArray alloc]init];
    
    _page = 1;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonPressed:)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-425*ScreenWidth/375 - 64)];
    if (ScreenHeight == 480) {
        _mapView.frame = CGRectMake(0, 0, ScreenWidth, 140*ScreenWidth/375);
    }
    //    //添加标注
    //    [self addPointAnnotation:3];
    //    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    [self createTableView];
    
    UIButton* btnMap = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMap.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-375*ScreenWidth/375-64);
    if (ScreenHeight == 480) {
        btnMap.frame = CGRectMake(0, 0, ScreenWidth, 140*ScreenWidth/375);
    }
    [self.view addSubview:btnMap];
    [btnMap addTarget:self action:@selector(mapClick) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)mapClick
{
    if (_dataArray.count == 0) {
        [Helper alertViewNoHaveCancleWithTitle:@"您还未添加足迹!" withBlock:^(UIAlertController *alertView) {
            [self presentViewController:alertView animated:YES completion:nil];
        }];
    }else{
        ShowMapViewViewController *vc = [[ShowMapViewViewController alloc] init];
        vc.mapCLLocationCoordinate2DArr = _dataArray;
        [self.navigationController pushViewController:vc animated:YES];
    }
}



//添加标注并设置地图
- (void)addPointAnnotation:(NSInteger)annotationNumber
{
    //    ////NSLog(@"%lu", (unsigned long)_dataArray.count);
    
    // 移除所有的标注
    [_mapView removeAnnotations:_mapView.annotations];
    // 双击和单击，移动，旋转
    _mapView.zoomEnabled = NO;
    _mapView.zoomEnabledWithTap = NO;
    _mapView.scrollEnabled = NO;
    _mapView.overlookEnabled = NO;
    _mapView.rotateEnabled = NO;
    
    if (_dataArray.count == 0) {
        
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        
        if (self.lat) {
            coor.latitude = [self.lat doubleValue];
            
        }else{
            coor.latitude = 31.2;
        }
        
        if (self.lng) {
            coor.longitude = [self.lng doubleValue];
        }else{
            coor.longitude = 121.4;
        }

        annotation.coordinate = coor;
        annotation.title = [[NSUserDefaults standardUserDefaults] objectForKey:@"定位"];
        [_mapView addAnnotation:annotation];
        
        
        
        
        // 设定屏幕的可见范围， 根据所有的标注来设定的
        
        
        CGFloat minlatitude = 0.0;
        CGFloat maxlatitude = 0.0;
        CGFloat minlongitude = 0.0;
        CGFloat maxlongitude = 0.0;
        
        if (minlatitude < coor.latitude ) {
            minlatitude = coor.latitude;
        }
        if (maxlatitude < coor.latitude ) {
            maxlatitude = coor.latitude;
        }
        if (minlongitude < coor.longitude ) {
            minlongitude = coor.longitude;
        }
        if (maxlongitude < coor.longitude ) {
            maxlongitude = coor.longitude;
        }

        CLLocationCoordinate2D coord;
        coord.latitude = (minlatitude + maxlatitude )/2 ;
        coord.longitude = (minlongitude + maxlongitude)/2;
        BMKCoordinateSpan co;
        co.latitudeDelta = maxlatitude - coord.latitude + 1.000;
        co.longitudeDelta = maxlongitude - coord.longitude + 1.0000;
        BMKCoordinateRegion region;
        region.center = coord;
        region.span = co;
        [_mapView setRegion:region animated:YES];

        
        
    } else {
        
        CGFloat minlatitude = 0.0;
        CGFloat maxlatitude = 0.0;
        CGFloat minlongitude = 0.0;
        CGFloat maxlongitude = 0.0;
        
        for (int i = 0; i < _dataArray.count; i++) {
            
            BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
            CLLocationCoordinate2D coor;
            coor.latitude = [[_dataArray[i] xIndex] doubleValue];
            coor.longitude = [[_dataArray[i] yIndex] doubleValue];
            annotation.coordinate = coor;
            annotation.title = [_dataArray[i] golfName];
            [_mapView addAnnotation:annotation];
            
            
            if (minlatitude < coor.latitude ) {
                minlatitude = coor.latitude;
            }
            if (maxlatitude < coor.latitude ) {
                maxlatitude = coor.latitude;
            }
            if (minlongitude < coor.longitude ) {
                minlongitude = coor.longitude;
            }
            if (maxlongitude < coor.longitude ) {
                maxlongitude = coor.longitude;
            }
        }
        // 设定屏幕的可见范围， 根据所有的标注来设定的
        CLLocationCoordinate2D coord;
        coord.latitude = (minlatitude + maxlatitude )/2 ;
        coord.longitude = (minlongitude + maxlongitude)/2;
        BMKCoordinateSpan co;
        co.latitudeDelta = maxlatitude - coord.latitude + 1.000;
        co.longitudeDelta = maxlongitude - coord.longitude + 1.0000;
        BMKCoordinateRegion region;
        region.center = coord;
        region.span = co;
        [_mapView setRegion:region animated:YES];
    }
}

#pragma mark - BMKMapViewDelegate
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    
}

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        // 设置颜色
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        
        // 设置可拖拽
        newAnnotationView.draggable = YES;
        return newAnnotationView;
    }
    return nil;
}



-(void)viewWillDisappear:(BOOL)animated {

        [super viewWillDisappear:animated];
    
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    
    // 移除所有的标注
    //    [_mapView removeAnnotations:_mapView.annotations];
}
- (void)dealloc {
    
    if (_mapView) {
        _mapView = nil;
    }
}

-(void)barButtonPressed:(UIBarButtonItem *)btn
{
    AddFootViewController* addVc = [[AddFootViewController alloc]init];
    [self.navigationController pushViewController:addVc animated:YES];
}

-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ScreenHeight-425*ScreenWidth/375-64, ScreenWidth, 425*ScreenWidth/375) style:UITableViewStylePlain];
    if (ScreenHeight == 480) {
        _tableView.frame = CGRectMake(0, 140*ScreenWidth/375, ScreenWidth, ScreenHeight-140*ScreenWidth/375);
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //    _tableView.bounces = NO;
    
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //    [_tableView registerNib:[UINib nibWithNibName:@"MyFootFirstViewCell" bundle:nil] forCellReuseIdentifier:@"MyFootFirstViewCell"];
    [_tableView registerClass:[MyFoodHeadTableViewCell class] forCellReuseIdentifier:@"MyFoodHeadTableViewCell"];
    [_tableView registerClass:[MyFootBodyTableViewCell class] forCellReuseIdentifier:@"MyFootBodyTableViewCell"];
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    
    //    addHeaderWithTarget: 是第三方类库中UIScrolView的category。
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [_tableView.header beginRefreshing];
}

#pragma mark --MJ刷新方法

- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSNumber *userId = [user objectForKey:@"userId"];
    NSNumber *lat = [user objectForKey:@"lat"];
    NSNumber *lng = [user objectForKey:@"lng"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        
    if (lat != nil) {
        [dict setObject:lat forKey:@"lat"];
    }
    if (lng != nil) {
         [dict setObject:lat forKey:@"lng"];
    }
    
    
    [dict setObject:@10 forKey:@"rows"];
    [dict setObject:userId forKey:@"userId"];
    [dict setObject:@-1 forKey:@"searchState"];
    [dict setObject:@1 forKey:@"moodType"];
    [dict setObject:[NSNumber numberWithInt:page] forKey:@"page"];

    
    [[PostDataRequest sharedInstance] postDataRequest:@"userMood/queryPage.do" parameter:dict success:^(id respondsData) {

        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        
        ////NSLog(@"dict == %@",dict);
        
        if ([[dict objectForKey:@"success"]boolValue]) {
            if (page == 1)[_dataArray removeAllObjects];
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                MyfootModel *model = [[MyfootModel alloc] init];
                
                
                [model setValuesForKeysWithDictionary:dataDict];
                [_dataArray addObject:model];
                
            }
            
            _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
            
            //添加标注 一定要和代理写在一起, 防止 视图将要出现这个方法已经执行
            
            [self addPointAnnotation:_dataArray.count];
            
            _page++;
            [_tableView reloadData];
            
        }else {
            
            _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
            
            //添加标注 一定要和代理写在一起, 防止 视图将要出现这个方法已经执行
            
            [self addPointAnnotation:_dataArray.count];
        }
        [_tableView reloadData];
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    } failed:^(NSError *error) {
        
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    }];
}


#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _page = 1;
    [self downLoadData:_page isReshing:YES];
}

- (void)footerRereshing
{
    [self downLoadData:_page isReshing:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85*ScreenWidth/320;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        MyFoodHeadTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MyFoodHeadTableViewCell" forIndexPath:indexPath];
        [cell showData:_dataArray[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else
    {
        MyFootBodyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MyFootBodyTableViewCell" forIndexPath:indexPath];
        [cell showData:_dataArray[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FootDetailViewController *vc = [[FootDetailViewController alloc] init];
    vc.myFoot = _dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
