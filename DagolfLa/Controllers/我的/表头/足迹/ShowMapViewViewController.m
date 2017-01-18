//
//  ShowMapViewViewController.m
//  DagolfLa
//
//  Created by 张天宇 on 15/10/14.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ShowMapViewViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "MyfootModel.h"


#import "Helper.h"
@interface ShowMapViewViewController ()<BMKMapViewDelegate>
{
    BMKMapView *_mapView;
    BMKPointAnnotation* pointAnnotation;
}

@end

@implementation ShowMapViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.fromWitchVC == 1) {
        self.title = @"球场地址";

    }else{
        self.title = @"地图详情";

    }
    
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
//    leftItem.tintColor=[UIColor whiteColor];
//    self.navigationItem.leftBarButtonItem = leftItem;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];

    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
//    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-425*ScreenWidth/375 - 15)];
    //    //添加标注
    //    [self addPointAnnotation:3];
    //    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
}
// 地图的内存的释放
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    //添加标注 一定要和代理写在一起
    [self addPointAnnotation:3];
}
//添加标注并设置地图
- (void)addPointAnnotation:(NSInteger)annotationNumber
{

    if (_mapCLLocationCoordinate2DArr.count == 0) {
        
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        
        if ([user objectForKey:BDMAPLAT]) {
            coor.latitude = [[user objectForKey:BDMAPLAT] doubleValue];

        }else{
            coor.latitude = 31.2;

        }
        
        if ([user objectForKey:BDMAPLNG]) {
            coor.longitude = [[user objectForKey:BDMAPLNG] doubleValue];
            
        }else{
            coor.longitude = 121.4;
            
        }

//        //NSLog(@">>>>>>>>>>>>>>>>>%@,%@",self.lat,self.lng);
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

//        
//        
//        [Helper alertViewNoHaveCancleWithTitle:@"您还未添加足迹..." withBlock:^(UIAlertController *alertView) {
//            [self.navigationController presentViewController:alertView animated:YES completion:nil];
//        }];
    }else{
    
        [_mapView removeAnnotations:_mapView.annotations];
        // 双击和单击，移动，旋转
        _mapView.zoomEnabled = YES;
        _mapView.zoomEnabledWithTap = YES;
        _mapView.scrollEnabled = YES;
        _mapView.overlookEnabled = YES;
        _mapView.rotateEnabled = YES;
        
        
        CGFloat minlatitude = 0.0;
        CGFloat maxlatitude = 0.0;
        CGFloat minlongitude = 0.0;
        CGFloat maxlongitude = 0.0;
        
        for (int i = 0; i < _mapCLLocationCoordinate2DArr.count; i++) {
            BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
            CLLocationCoordinate2D coor;
            //_mapCLLocationCoordinate2DArr有一条数据，是一个空字符串
            
            coor.latitude = [[_mapCLLocationCoordinate2DArr[i] xIndex] doubleValue];
            coor.longitude = [[_mapCLLocationCoordinate2DArr[i] yIndex] doubleValue];
            annotation.coordinate = coor;
            annotation.title = [_mapCLLocationCoordinate2DArr[i] golfName];
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
    BMKAnnotationView *vi = (BMKAnnotationView *)[_mapView viewWithTag:1000];
    vi.selected = NO;
    [mapView deselectAnnotation:vi.annotation animated:YES];
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
        newAnnotationView.selected = YES;

        return newAnnotationView;
    }
    return nil;
}

//气泡弹窗点击
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
   
    ////NSLog(@"%@", view.annotation.title);
    view.tag = 1000;

}

- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    ////NSLog(@"%@", view.annotation.title);
    
    

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}
- (void)dealloc {
    
    if (_mapView) {
        _mapView = nil;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
