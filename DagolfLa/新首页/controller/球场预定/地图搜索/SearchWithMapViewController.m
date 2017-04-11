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
#import "SearchWithMapOrderListViewController.h"
#import "SearchWithMapAnnotationView.h"
#import "JGDCourtDetailViewController.h"
@interface SearchWithMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>{
    //MapView
    BMKMapView* _mapView;
    //定位
    BMKLocationService *_locService;
    //定位点与定位描述关联id
    NSInteger _iii;
    //自身坐标
    CLLocationCoordinate2D _userCoord;
}
//数据源
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation SearchWithMapViewController

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.navigationController.navigationBarHidden = true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    self.navigationController.navigationBarHidden = false;
}

- (void)dealloc {
    if (_mapView) {
        _mapView.delegate = nil;
        _mapView = nil;
        [_mapView removeFromSuperview];
    }
}


#pragma mark - CreateView
-(void)createView{
    //设置地图缩放级别
    BMKMapView *mapView =  [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    mapView.delegate = self;
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];
    mapView.showsUserLocation = YES;//显示自身位置
    mapView.zoomLevel = 10;
    [self.view addSubview:mapView];
    _mapView = mapView;
    [self getLocation];
    //设置导航条
    [self createNavigationView];
}
//设置导航条
-(void)createNavigationView{
    self.title = @"";
    //设置导航背景 backAppbarBtn
    
    UIButton *backBtn = [Factory createButtonWithFrame:CGRectMake(kWvertical(6), 25, kWvertical(34), kWvertical(34)) image:[UIImage imageNamed:@"backAppbarBtn"] target:self selector:@selector(popback) Title:nil];
    
    backBtn.backgroundColor = RGBA(0, 0, 0, 0.4);
    backBtn.layer.cornerRadius = 5;
    [self.view addSubview:backBtn];
    
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
    //配置数据
    SearchWithMapModel *model = self.dataArray[_iii];

    NSString *AnnotationViewID = @"SearchWithMapId";
    SearchWithMapAnnotationView *newAnnotation = [[SearchWithMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];

    // 设置颜色
    newAnnotation.pinColor = BMKPinAnnotationColorPurple;
    // 从天上掉下效果
    newAnnotation.animatesDrop = YES;
    //设置大头针图标
    NSString *image = @"normalPin";
    if (model.isLeague==1) {
        image = @"pin";
    }
    newAnnotation.image = [UIImage imageNamed:image];
    [newAnnotation configModel:model];
    
    newAnnotation.userInteractionEnabled = true;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushAnination:)];
    [newAnnotation addGestureRecognizer:tap];
    return newAnnotation;
}

#pragma mark - initData

//获取选择城市的球场
-(void)initData{

    self.dataArray = [NSMutableArray array];
    //md5 加密
    NSString *md5 = [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@&provinceName=%@dagolfla.com", DEFAULF_USERID,_cityName]];
    NSDictionary *dict = @{
                           @"userKey":DEFAULF_USERID,
                           @"provinceName":_cityName,
                           @"md5":md5
                           };
    [[JsonHttp jsonHttp] httpRequest:@"bookball/getBookingOrderMapInfo" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
    } completionBlock:^(id data) {
        bool sucess = [[data objectForKey:@"packSuccess"] boolValue];
        if (sucess) {
            NSArray *listArray = [data objectForKey:@"list"];
            for (NSDictionary *listDict in listArray) {
                SearchWithMapModel *model = [[SearchWithMapModel alloc] init];
                NSDictionary *latlon = [listDict objectForKey:@"latlon"];
                model.longtitude = [[latlon objectForKey:@"longitude"] floatValue];
                model.latitude = [[latlon objectForKey:@"latitude"] floatValue];
                model.parkName = [listDict objectForKey:@"ballSimpleName"];
                model.orderPrice = [[listDict objectForKey:@"price"] stringValue];
                model.orderNum = [[listDict objectForKey:@"bookCount"] integerValue];
                model.parkFullName = [listDict objectForKey:@"ballName"];
                model.parkId = [listDict objectForKey:@"ballKey"];
                model.bookballKey = [listDict objectForKey:@"bookballKey"];
                model.isLeague = [[listDict objectForKey:@"isLeague"] integerValue];
                [self.dataArray addObject:model];
            }
            [self addPointAnnotation];
        }
    }];
}

#pragma mark - Action
-(void)popback{
    [self.navigationController popViewControllerAnimated:YES];
}
//点击
-(void)pushAnination:(UITapGestureRecognizer *)tap{
    
    MKAnnotationView *view = (MKAnnotationView *)tap.view;
    view.selected = false;
    if ([view isKindOfClass:[SearchWithMapAnnotationView class]]) {
        SearchWithMapAnnotationView *sView = (SearchWithMapAnnotationView *)view;
        NSString *parkId = sView.dataModel.parkId;
        NSInteger orderNum = sView.dataModel.orderNum;
        NSString *pardName = sView.dataModel.parkName;
        if (orderNum==1) {
            JGDCourtDetailViewController *courtVC = [[JGDCourtDetailViewController alloc] init];
            courtVC.timeKey = [NSNumber numberWithInteger:[sView.dataModel.bookballKey integerValue]];
            [self.navigationController pushViewController:courtVC animated:YES];
            
        }else{
            SearchWithMapOrderListViewController *vc = [[SearchWithMapOrderListViewController alloc] init];
            vc.ballKey = parkId;
            vc.title = pardName;
            vc.userCoord = _userCoord;
            [self.navigationController pushViewController:vc animated:YES];
        }
        NSLog(@"%@",parkId);
        
    }
    
}


#pragma mark - 定位代理
//根据地区获取经纬度
-(void)getLocation{

    NSString *oreillyAddress = _cityName;
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:oreillyAddress completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil) {
            NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            NSLog(@"Longitude = %f", firstPlacemark.location.coordinate.longitude);
            NSLog(@"Latitude = %f", firstPlacemark.location.coordinate.latitude);
            _mapView.centerCoordinate = firstPlacemark.location.coordinate;
//            CLLocationCoordinate2DMake(31.245577, 121.50633) ;
        }
        else if ([placemarks count] == 0 && error == nil) {
            NSLog(@"Found no placemarks.");
            _mapView.centerCoordinate = CLLocationCoordinate2DMake(31.245577, 121.50633) ;
        } else if (error != nil) {
            NSLog(@"An error occurred = %@", error);
            _mapView.centerCoordinate = CLLocationCoordinate2DMake(31.245577, 121.50633) ;
        }
    }];  

}

-(void)mapStatusDidChanged:(BMKMapView *)mapView{
    CLLocationCoordinate2D centerCoordinate = mapView.centerCoordinate;
    
    NSLog(@"%f---%f",centerCoordinate.latitude,centerCoordinate.longitude);
}

//处理位置坐标更新

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
//    _mapView.centerCoordinate = userLocation.location.coordinate;
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    _userCoord = userLocation.location.coordinate;
    [_locService stopUserLocationService];
}
//定位失败
- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"error:%@",error);
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(31.245577, 121.50633) ;
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{

   //设置点击自身位置时不显示气泡
    [mapView deselectAnnotation:view.annotation
                           animated:NO];
//    view.selected = false;
//    if ([view isKindOfClass:[SearchWithMapAnnotationView class]]) {
//        SearchWithMapAnnotationView *sView = (SearchWithMapAnnotationView *)view;
//        NSString *parkId = sView.dataModel.parkId;
//        NSInteger orderNum = sView.dataModel.orderNum;
//        NSString *pardName = sView.dataModel.parkName;
//        if (orderNum==1) {
//            JGDCourtDetailViewController *courtVC = [[JGDCourtDetailViewController alloc] init];
//            courtVC.timeKey = [NSNumber numberWithInteger:[sView.dataModel.bookballKey integerValue]];
//            [self.navigationController pushViewController:courtVC animated:YES];
//
//        }else{
//            SearchWithMapOrderListViewController *vc = [[SearchWithMapOrderListViewController alloc] init];
//            vc.ballKey = parkId;
//            vc.title = pardName;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        NSLog(@"%@",parkId);
//        
//        
//    }
    
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
