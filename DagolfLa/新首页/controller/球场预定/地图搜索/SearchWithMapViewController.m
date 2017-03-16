//
//  SearchWithMapViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/3/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "SearchWithMapViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI/BMKMapView.h>
#import "SearchWithMapAnnotationView.h"
@interface SearchWithMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>{
    //MapView
    BMKMapView* _mapView;
    //定位
    BMKLocationService *_locService;
    //定位点与定位描述关联id
    NSInteger _iii;
}
//数据源
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation SearchWithMapViewController

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}


#pragma mark - CreateView
-(void)createView{
    
    //设置地图缩放级别
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-64)];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;//显示自身位置
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(31.245577, 121.50633) ;
    _mapView.zoomLevel = 14;
    [self.view addSubview:_mapView];
    
//    [self addPointAnnotation];
    [self startLocation];
}

//添加标注
- (void)addPointAnnotation
{
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        BMKPointAnnotation* pointAnnotation;
        SearchWithMapModel *model = self.dataArray[i];
        pointAnnotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = model.latitude;
        coor.longitude = model.longtitude;
        pointAnnotation.coordinate = coor;
        pointAnnotation.title = @"";
        pointAnnotation.subtitle = @"";
        _iii = i;
        [_mapView addAnnotation:pointAnnotation];
    }
}
// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"SearchWithMapId";
    SearchWithMapAnnotationView *newAnnotation = [[SearchWithMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];

    // 设置颜色
    newAnnotation.pinColor = BMKPinAnnotationColorPurple;
    // 从天上掉下效果
    newAnnotation.animatesDrop = YES;
    //设置大头针图标
    newAnnotation.image = [UIImage imageNamed:@"pin"];
    //配置数据
    SearchWithMapModel *model = self.dataArray[_iii];
    [newAnnotation configModel:model];
    
    return newAnnotation;
}

#pragma mark - initData

//获取选择城市的球场
-(void)initData{

    self.dataArray = [NSMutableArray array];
    
    NSArray *array = @[
  @[@"121.463669",@"31.237538",@"旗中",@"2000",@"1",@"11"],
  @[@"121.470568",@"31.246182",@"虹桥",@"3000",@"1",@"12"],
  @[@"121.494427",@"31.244454",@"佘山",@"4000",@"1",@"13"],
  @[@"121.473155",@"31.26347@",@"林克斯",@"5000",@"5",@"14"]
  ];
    
    for (int i = 0; i < array.count; i++) {
        NSArray *arr = array[i];
        SearchWithMapModel *model = [[SearchWithMapModel alloc] init];
        model.longtitude = [arr[0] floatValue];
        model.latitude = [arr[1] floatValue];
        model.parkName = arr[2];
        model.orderPrice = arr[3];
        model.orderNum = [arr[4] integerValue];
        model.parkId = arr[5];
        [self.dataArray addObject:model];
    }
    [self addPointAnnotation];
}


#pragma mark - 定位代理
//开始定位
-(void)startLocation{
    
    //初始化BMKLocationService
    [BMKLocationService setLocationDistanceFilter:kCLLocationAccuracyNearestTenMeters];
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}
//处理位置坐标更新

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
//    _mapView.centerCoordinate = userLocation.location.coordinate;
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_locService stopUserLocationService];
}
//定位失败
- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"error:%@",error);
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(31.245577, 121.50633) ;
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    view.selected = false;
    if ([view isKindOfClass:[SearchWithMapAnnotationView class]]) {
        SearchWithMapAnnotationView *sView = (SearchWithMapAnnotationView *)view;
        NSString *parkId = sView.pinId;
        NSLog(@"%@",parkId);
        
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
