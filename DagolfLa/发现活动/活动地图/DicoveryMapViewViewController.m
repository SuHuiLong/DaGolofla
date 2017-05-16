//
//  DicoveryMapViewViewController.m
//  DagolfLa
//
//  Created by SHL on 2017/5/16.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "DicoveryMapViewViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI/BMKMapView.h>
#import "SearchWithMapOrderListViewController.h"
#import "SearchWithMapAnnotationView.h"

@interface DicoveryMapViewViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>{
    //MapView
    BMKMapView* _mapView;
    //定位
    BMKLocationService *_locService;
    //定位点与定位描述关联id
    NSInteger _iii;
    //自身坐标
    CLLocationCoordinate2D _userCoord;
    //搜索代理
    BMKGeoCodeSearch *_geoCodeSearch;
}
//数据源
@property(nonatomic,strong)NSMutableArray *dataArray;
//全国各省数量数据
@property(nonatomic,strong)NSMutableArray *provinceDataArray;
//全国各省份详细数据
@property(nonatomic, strong)NSMutableDictionary *cityDataDict;


@end

@implementation DicoveryMapViewViewController
-(NSMutableDictionary *)cityDataDict{
    if (!_cityDataDict) {
        _cityDataDict = [NSMutableDictionary dictionary];
    }
    return _cityDataDict;
}

-(NSMutableArray *)provinceDataArray{
    if (!_provinceDataArray) {
        _provinceDataArray = [NSMutableArray array];
    }
    return _provinceDataArray;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _geoCodeSearch.delegate = self;    //设置搜索代理
    self.navigationController.navigationBarHidden = true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _geoCodeSearch.delegate = nil;
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
    _locService = [[BMKLocationService alloc]init];
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _locService.delegate = self;
    [_locService startUserLocationService];
    mapView.showsUserLocation = YES;//显示自身位置
    mapView.zoomLevel = 11;
    [mapView dequeueReusableAnnotationViewWithIdentifier:@"SearchWithMapId"];
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
- (void)addPointAnnotation{
    //先移除然后添加
    [_mapView removeAnnotations:_mapView.annotations];
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
    newAnnotation.animatesDrop = false;
    //设置大头针图标
    NSString *image = @"pin";
    if (model.name) {
        image = @"provincePin";
    }
    newAnnotation.image = [UIImage imageNamed:image];
    [newAnnotation configModel:model];
    
    newAnnotation.userInteractionEnabled = true;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushAnination:)];
    [newAnnotation addGestureRecognizer:tap];
    return newAnnotation;
}

#pragma mark - initData
-(void)initData{
    [self initCityData];
    [self initProvinceData];
}
//获取省份的数据
-(void)initProvinceData{
    
    //md5 加密
    NSString *md5 = [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@dagolfla.com", DEFAULF_USERID]];
    NSDictionary *dict = @{
                           @"userKey":DEFAULF_USERID,
                           @"md5":md5
                           };
    [[JsonHttp jsonHttp] httpRequest:@"team/getTeamActivityProvinceStatistics" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
    } completionBlock:^(id data) {
        bool sucess = [[data objectForKey:@"packSuccess"] boolValue];
        if (sucess) {
            self.provinceDataArray = [NSMutableArray array];
            NSArray *listArray = [data objectForKey:@"list"];
            for (NSDictionary *listDict in listArray) {
                SearchWithMapModel *model = [[SearchWithMapModel alloc] init];
                model.dataType = 1;
                NSDictionary *latlon = [listDict objectForKey:@"latlon"];
                model.longtitude = [[latlon objectForKey:@"longitude"] floatValue];
                model.latitude = [[latlon objectForKey:@"latitude"] floatValue];
                model.name = [listDict objectForKey:@"name"];
                model.count = [[listDict objectForKey:@"count"] integerValue];
                [self.provinceDataArray addObject:model];
            }
        }
    }];
}
//获取选择城市的球场
-(void)initCityData{
    //md5 加密
    NSString *md5 = [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%@&provinceName=%@dagolfla.com", DEFAULF_USERID,_cityName]];
    NSDictionary *dict = @{
                           @"userKey":DEFAULF_USERID,
                           @"provinceName":_cityName,
                           @"md5":md5
                           };
    [[JsonHttp jsonHttp] httpRequest:@"team/getTeamActivityMapInfo" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        bool sucess = [[data objectForKey:@"packSuccess"] boolValue];
        if (sucess) {
            self.dataArray = [NSMutableArray array];
            NSArray *listArray = [data objectForKey:@"list"];
            for (NSDictionary *listDict in listArray) {
                SearchWithMapModel *model = [[SearchWithMapModel alloc] init];
                model.dataType = 1;

                NSDictionary *latlon = [listDict objectForKey:@"latlon"];
                model.longtitude = [[latlon objectForKey:@"longitude"] floatValue];
                model.latitude = [[latlon objectForKey:@"latitude"] floatValue];
                model.parkName = [listDict objectForKey:@"ballSimpleName"];

                model.count = [[listDict objectForKey:@"count"] integerValue];
                model.parkFullName = [listDict objectForKey:@"ballName"];
                model.ballKey = [listDict objectForKey:@"ballKey"];
                [self.dataArray addObject:model];
            }
            [self.cityDataDict setValue:self.dataArray forKey:_cityName];
            [self addPointAnnotation];
        }
    }];
}

#pragma mark - Action
-(void)popback{
    [self clearMapView];
    [self.navigationController popViewControllerAnimated:YES];
}
//点击
-(void)pushAnination:(UITapGestureRecognizer *)tap{
    MKAnnotationView *view = (MKAnnotationView *)tap.view;
    view.selected = false;
    if ([view isKindOfClass:[SearchWithMapAnnotationView class]]) {
        SearchWithMapAnnotationView *sView = (SearchWithMapAnnotationView *)view;
        if (sView.dataModel.name) {
            _blockProvince(sView.dataModel.name);
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        NSString *parkId = sView.dataModel.parkId;
        NSInteger orderNum = sView.dataModel.orderNum;
        NSString *pardName = sView.dataModel.parkName;
        if (orderNum==1) {
            
            
        }else{

        
        }
    }
}


#pragma mark - 地图代理
//地图可视区域变化
-(void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    
    //    NSLog(@"%f",mapView.zoomLevel);
    
}
//地图状态改变完成后
-(void)mapStatusDidChanged:(BMKMapView *)mapView{
    CLLocationCoordinate2D centerCoordinate = mapView.centerCoordinate;
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = centerCoordinate;
    [_geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
}

//根据地区获取经纬度
-(void)getLocation{
    NSString *oreillyAddress = _cityName;
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:oreillyAddress completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil) {
            NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            _mapView.centerCoordinate = firstPlacemark.location.coordinate;
        }
        else if ([placemarks count] == 0 && error == nil) {
            _mapView.centerCoordinate = CLLocationCoordinate2DMake(31.245577, 121.50633) ;
        } else if (error != nil) {
            _mapView.centerCoordinate = CLLocationCoordinate2DMake(31.245577, 121.50633) ;
        }
    }];
}
//根据经纬度获取省份名
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    CGFloat zoomLevel = _mapView.zoomLevel;
    //小于8.5显示省份
    if (zoomLevel<8) {
        if ([self.dataArray isEqual:self.provinceDataArray]) {
            return;
        }
        if (self.provinceDataArray.count>0) {
            self.dataArray = self.provinceDataArray;
            _cityName = [NSString string];
            [self addPointAnnotation];
        }else{
            [self initProvinceData];
        }
        return;
    }
    NSString *province = result.addressDetail.province;
    if (province.length>1) {
        NSLog(@"%@",[NSString stringWithFormat:@"省份名：%@", province]);
        //位置移动超出省份和放大系数改变之后请求省份数据
        if (![province isEqualToString:_cityName]||[self.dataArray isEqual:self.provinceDataArray]) {
            _cityName = province;
            if ([self.cityDataDict containsObjectForKey:_cityName]) {
                self.dataArray = [NSMutableArray arrayWithArray:[self.cityDataDict objectForKey:_cityName]];
                [self addPointAnnotation];
            }else{
                [self initCityData];
            }
        }
    }
}



//处理当前位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    _userCoord = userLocation.location.coordinate;
    [_locService stopUserLocationService];
}
//定位失败
- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"error:%@",error);
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(31.245577, 121.50633) ;
}


/**
 气泡点击（未实现）
 
 @param mapView mapVoew
 @param view 气泡
 */
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

//pop自后清空界面
-(void)clearMapView{
    _mapView = nil;
    _mapView.delegate = nil;
    _mapView.showsUserLocation = NO;
    [_mapView   removeAnnotations:_mapView.annotations];
    [_mapView   removeOverlays:_mapView.overlays];
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
