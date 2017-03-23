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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];

    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    
    [self.view addSubview:_mapView];
    if (self.fromWitchVC == 1) {
        [self createNavigationView];
        _mapView.height = screenHeight;
    }else{
        self.title = @"地图详情";
        
    }

}
// 地图的内存的释放
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    //添加标注 一定要和代理写在一起
    [self addPointAnnotation:3];
    if (self.fromWitchVC == 1) {
        self.navigationController.navigationBarHidden = true;
    }
}

//设置导航条
-(void)createNavigationView{
    self.title = @"";
    //设置导航背景 backAppbarBtn
    
    //    [self.navigationController.navigationBar setTintColor:WhiteColor];
    //    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    UIButton *backBtn = [Factory createButtonWithFrame:CGRectMake(kWvertical(6), 25, kWvertical(34), kWvertical(34)) image:[UIImage imageNamed:@"backAppbarBtn"] target:self selector:@selector(popback) Title:nil];
    
    backBtn.backgroundColor = RGBA(0, 0, 0, 0.4);
    backBtn.layer.cornerRadius = 5;
    [self.view addSubview:backBtn];
}
//返回
-(void)popback{
    [self.navigationController popViewControllerAnimated:YES];
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
    if (self.fromWitchVC != 1) {
            vi.selected = NO;
    }
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
        // 设置不可拖拽
        newAnnotationView.draggable = NO;
        newAnnotationView.selected = YES;

        if (self.fromWitchVC == 1) {
            //设置大头针图标
            NSString *image = @"normalPin";
            if (_isLeague) {
                image = @"pin";
            }
            newAnnotationView.image = [UIImage imageNamed:image];
 
        }
        //设置气泡
        UIView *paopaoView = [Factory createViewWithBackgroundColor:ClearColor frame:CGRectMake(0, 0, 100, kHvertical(50)) ];

        UIImageView *paopaoBackView = [Factory createImageViewWithFrame:CGRectMake(0, 0, 100, kHvertical(35)) Image:nil];
        paopaoBackView.backgroundColor = [UIColor whiteColor];
        paopaoBackView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        paopaoBackView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        paopaoBackView.layer.shadowOpacity = 0.4;//阴影透明度，默认0
        paopaoBackView.layer.shadowRadius = 4;//阴影半径，默认3
        paopaoBackView.layer.cornerRadius = 4;
        [paopaoView addSubview:paopaoBackView];
        
        //自定义气泡的内容，添加子控件在popView上
        UILabel *parkLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(10), 0, 100, kHvertical(35)) textColor:RGB(49,49,49) fontSize:kHorizontal(13) Title:annotation.title];
        parkLabel.numberOfLines = 1;
        parkLabel.backgroundColor = WhiteColor;
        parkLabel.layer.cornerRadius = 3;
        
        [parkLabel sizeToFitSelf];
        [paopaoView addSubview:parkLabel];
        //导航按钮
        UIImageView *navigationView = [Factory createImageViewWithFrame:CGRectMake(parkLabel.x_width + kWvertical(6), 0, kWvertical(60), parkLabel.height) Image:[UIImage imageNamed:@"showMapNavagation"]];
        [paopaoView addSubview:navigationView];
        
        paopaoView.width = navigationView.x_width;
        paopaoBackView.width = paopaoView.width;
        //向下尖号
        UIImageView *bottomArrow = [Factory createImageViewWithFrame:CGRectMake((navigationView.x_width - kWvertical(34))/2, parkLabel.y_height-kHvertical(8), kWvertical(34), kHvertical(16)) Image:[UIImage imageNamed:@"showMapBottom"]];
        [paopaoView addSubview:bottomArrow];
        
        BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:paopaoView];
        pView.frame = CGRectMake(0, 0, paopaoView.width, kHvertical(50));
        newAnnotationView.paopaoView = nil;
        newAnnotationView.paopaoView = pView;
        return newAnnotationView;
        
        return newAnnotationView;
    }
    return nil;
}

//气泡弹窗点击
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    view.tag = 1000;
}

- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    ////NSLog(@"%@", view.annotation.title);
}
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
    BMKPointAnnotation *tt = (BMKPointAnnotation *)view.annotation;
    if (self.fromWitchVC == 1) {
    [self AlertShow:tt.coordinate];
    }
}

// 百度  高德 苹果
-(void)AlertShow:(CLLocationCoordinate2D )coordinate{
    CLLocationCoordinate2D Coordinate = [JZLocationConverter bd09ToGcj02:coordinate];
    

    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"选择地图App" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //判断是否安装了百度地图，如果安装了百度地图，则使用百度地图导航
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"alertController -- 百度地图");
            NSString *urlsting =[[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",Coordinate.latitude,Coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
            
        }]];
    }

    //判断是否安装了高德地图，如果安装了高德地图，则使用高德地图导航
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 高德地图");
            NSString *urlsting =[[NSString stringWithFormat:@"iosamap://navi?sourceApplication= &backScheme= &lat=%f&lon=%f&dev=0&style=2",Coordinate.latitude,Coordinate.longitude]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication  sharedApplication]openURL:[NSURL URLWithString:urlsting]];
        }]];
    }
    
    //自带地图
    [alertController addAction:[UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"alertController -- 自带地图");
        
        //使用自带地图导航
        MKMapItem *currentLocation =[MKMapItem mapItemForCurrentLocation];
        
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:Coordinate addressDictionary:nil]];
        
        [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
    }]];
    
    //添加取消选项
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
        
    }]];
    
    //显示alertController
    [self presentViewController:alertController animated:YES completion:nil];
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    if (self.fromWitchVC == 1) {
        self.navigationController.navigationBarHidden = false;
    }
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
