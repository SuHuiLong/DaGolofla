//
//  ShouyeViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/7/21.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "Helper.h"
#import "UIImageView+WebCache.h"

#import "ShouyeViewController.h"
#import "AppDelegate.h"
#import "HomeHeadView.h"

#import "UseMallViewController.h"
#import "StadiumViewController.h"
#import "PackageViewController.h"
#import "PracticeViewController.h"
#import "TeacherViewController.h"
#import "MemberShipViewController.h"

#import "MeWonderViewCell.h"

#import "YueHallViewController.h"
#import "HighBallViewController.h"
#import "MyTeamViewController.h"
#import "ManageViewController.h"
#import "VoteViewController.h"
#import "SpeciallOfferViewController.h"
#import "JGTeamChannelViewController.h"

#import <BaiduMapAPI/BMapKit.h>
#import <MapKit/MapKit.h>
#import "UIView+ChangeFrame.h"
#import "PostDataRequest.h"

#import "EnterViewController.h"
#import "Helper.h"

#import "ChangePicModel.h"
#import <CoreLocation/CoreLocation.h>
#import "UITabBar+badge.h"
#define NUM 10


@interface ShouyeViewController ()<HomeHeadViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate, BMKMapViewDelegate, BMKLocationServiceDelegate,MKMapViewDelegate,CLLocationManagerDelegate>
{
    
    NSMutableArray* _scrollArray;
    
    UIScrollView* _scrollView;
    
    UIScrollView* _yuansuScrollview;
    
    UICollectionView* _collectionView;
    
    NSArray* _iconLabelArr;
    
    //    BMKMapView* _mapView;
    BMKLocationService* _locService;
    
    HomeHeadView * _headerView;
}
@property (strong, nonatomic) CLLocationManager* locationManager;

@end




@implementation ShouyeViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.navigationItem.leftBarButtonItem = nil;
    //发出通知显示标签栏
    [[NSNotificationCenter defaultCenter] postNotificationName:@"show" object:nil];
    
    self.navigationController.navigationBarHidden=NO;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        [RCIM sharedRCIM].receiveMessageDelegate=self;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"打高尔夫啦";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 获取app名和用户安装的app的版本号
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
    NSString* appName =[infoDict objectForKey:@"CFBundleDisplayName"];
//    NSString* text =[NSString stringWithFormat:@"%@ %@",appName,versionNum];
//    //NSLog(@"%@",text);
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:versionNum forKeyedSubscript:@"versionNo"];
    [dict setObject:@"ios" forKeyedSubscript:@"client"];
    [[PostDataRequest sharedInstance] postDataRequest:@"version/queryNewVersion.do" parameter:dict success:^(id respondsData) {
        NSDictionary* dataDic = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dataDic objectForKey:@"success"] integerValue] == 1) {
            if ([[[dataDic objectForKey:@"rows"] objectForKey:@"versionNo"] integerValue] > [versionNum integerValue]) {
                [Helper alertViewWithTitle:@"您有新的版本,是否立即更新" withBlockCancle:^{
                    
                } withBlockSure:^{
                    NSURL *url = [NSURL URLWithString:[dataDic objectForKey:@"httpUrl"]];
                    [[UIApplication sharedApplication]openURL:url];
                } withBlock:^(UIAlertController *alertView) {
                    [self.navigationController presentViewController:alertView animated:YES completion:nil];
                }];
            }
        }
        
    } failed:^(NSError *error) {
        
    }];
    
    
    _iconLabelArr = [[NSArray alloc]init];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_scrollView];
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollArray = [[NSMutableArray alloc]init];
    
    _headerView = [[HomeHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 190*ScreenWidth/375)];
    _headerView.backgroundColor = [UIColor blueColor];
    [_scrollView addSubview:_headerView];

    
    //右边按钮
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"xiaoxi"] style:UIBarButtonItemStylePlain target:self action:@selector(moreClick)];
//    rightBtn.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    //首页滚动视图
    [self createScrollView];
    //中部的方块
    [self createMallView];
    
    //圆形图标
    [self xiangmuView];
    
    //定位
    //    [self locationWeiZhi];
    
    [self getCurPosition];
}



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
//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
//
//    if ([locations count]>0) {
//        CLLocation* loc = [locations objectAtIndex:0];
//        CLLocationCoordinate2D pos = [loc coordinate];
//        //        CLLocationCoordinate2D coord=[WGS84TOGCJ02 transformFromWGSToGCJ:[loc coordinate]];
//        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
//        ////NSLog(@"%f   %f",pos.latitude,pos.longitude);
//        [[PostDataRequest sharedInstance] getDataRequest:[NSString stringWithFormat:@"http://mo.amap.com/service/geo/getadcode.json?longitude=%f&latitude=%f",pos.longitude,pos.latitude] success:^(id respondsData) {
//
//            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingAllowFragments error:nil];
//            ////NSLog(@"%@",dict);;
//            [user setObject:[dict objectForKey:@"city"] forKey:@"定位"];
//            [user setObject:[dict objectForKey:@"adcode"] forKey:@"code1"];
//            [user setObject:[dict objectForKey:@"lat"] forKey:@"lat"];
//            [user setObject:[dict objectForKey:@"lon"] forKey:@"lng"];
//            [user synchronize];
//
//            ////NSLog(@"%@",[dict objectForKey:@"adcode"]);
//            [_locationManager stopUpdatingLocation];
//            NSString* strCity = [[NSUserDefaults standardUserDefaults]objectForKey:@"定位"];
//            ////NSLog(@"city  == %@",strCity);
//
//
//
//        } failed:^(NSError *error) {
//            ////NSLog(@"定位错误");
//            //            ////NSLog(@"%@",error);
//        }];
//    }
//}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currLocation = [locations lastObject];
    //NSLog(@"经度=%f 纬度=%f 高度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user setObject:[NSNumber numberWithFloat:currLocation.coordinate.latitude] forKey:@"lat"];
    [user setObject:[NSNumber numberWithFloat:currLocation.coordinate.longitude] forKey:@"lng"];
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


//创建首页页面滚动视图
-(void)createScrollView
{
    //    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [[PostDataRequest sharedInstance] postDataRequest:@"scroll/queryAll.do" parameter:@{@"scrollClass":@0} success:^(id respondsData) {
        
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dict objectForKey:@"success"] integerValue] == 1) {
            
            NSMutableArray* arrayIcon = [[NSMutableArray alloc]init];
            NSMutableArray* arrayUrl = [[NSMutableArray alloc]init];
            NSMutableArray* arrayTitle = [[NSMutableArray alloc]init];
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                ////NSLog(@"%@",dataDict);
                ChangePicModel *model = [[ChangePicModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                [_scrollArray addObject:model];
                [arrayIcon addObject:model.pic];
                [arrayUrl addObject:model.nexturl];
                [arrayTitle addObject:model.title];
            }
//            //NSLog(@"%@",arrayIcon[0]);
            
            [_headerView config:arrayIcon data:arrayUrl title:arrayTitle];
            _headerView.delegate = self;
            [_headerView setClick:^(UIViewController *vc) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }
    } failed:^(NSError *error) {
        
    }];
    
}
#pragma mark --方形视图
-(void)createMallView
{
    NSArray* arrayFang = @[@[@"gqsb",@"qcyd",@"tcyd"],@[@"lxc",@"jl",@"hjxs"]];
    NSArray* arrayTit = @[@[@"高球用品",@"球场预订",@"套餐预订"],@[@"练习场",@"教练",@"会籍销售"]];
    //多少行
    for (int i = 0 ; i < 2; i++)
    {
        //多少列
        for (int j = 0 ; j < 3; j++)
        {
            
            UIImageView* iView = [[UIImageView alloc]init];
            //            iView.backgroundColor = [UIColor redColor];
            iView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",arrayFang[i][j]]];
            iView.frame = CGRectMake(j*122*ScreenWidth/375+6*ScreenWidth/375,195*ScreenWidth/375+ i*72*ScreenWidth/375, 120*ScreenWidth/375, 70*ScreenWidth/375) ;
            
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] init] ;
            
            tap.numberOfTapsRequired = 1 ;
            
            [tap addTarget:self action:@selector(tapView:)] ;
            //添加手势到视图上
            [iView addGestureRecognizer:tap] ;
            
            iView.tag = 100+i%5*3+j;
            
            [_scrollView addSubview:iView] ;
            
            iView.userInteractionEnabled = YES ;
            
            
            UILabel* labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(4*ScreenWidth/375, iView.frame.size.height/2-12*ScreenWidth/375, iView.frame.size.width/2, 24*ScreenWidth/375)];
            labelTitle.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
            labelTitle.textAlignment = NSTextAlignmentCenter;
            labelTitle.textColor = [UIColor whiteColor];
            labelTitle.text = [NSString stringWithFormat:@"%@",arrayTit[i][j]];
            [iView addSubview:labelTitle];
            
        }
    }
    
}
#pragma mark --圆形视图
//圆形视图
-(void)xiangmuView
{
    _yuansuScrollview = [[UIScrollView alloc]init];
    
    [_scrollView addSubview:_yuansuScrollview];
    _yuansuScrollview.backgroundColor = [UIColor whiteColor];
    // _yuansuScrollview.contentSize
    //如果圆形图标位置小玉屏幕高度，则无偏移量
    if (345*ScreenWidth/375+568-360*ScreenWidth/375 < ScreenHeight)
    {
        _yuansuScrollview.frame = CGRectMake(0, 350*ScreenWidth/375, ScreenWidth, ScreenHeight-360*ScreenWidth/375-64-49*ScreenWidth/375);
        _scrollView.contentSize = CGSizeMake(0, 0);
    }
    else
    {
        //用5的屏幕高度代替4的屏幕高度创建
        _yuansuScrollview.frame = CGRectMake(0, 350*ScreenWidth/375, ScreenWidth, 568-360*ScreenWidth/375-64-44*ScreenWidth/375);
        CGFloat size = 345*ScreenWidth/375+568-360*ScreenWidth/375-44*ScreenWidth/375;
        _scrollView.contentSize = CGSizeMake(0, size);
        
    }
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing=0.f;//左右间隔
    flowLayout.minimumLineSpacing=0.f;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, _yuansuScrollview.frame.size.width, _yuansuScrollview.frame.size.height) collectionViewLayout:flowLayout];
    //    _collectionView.frame = _yuansuScrollview.frame;
    [_yuansuScrollview addSubview:_collectionView];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.showsHorizontalScrollIndicator=NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.bounces = NO;
    _collectionView.scrollEnabled = NO;
    _collectionView.contentSize = CGSizeMake(0, 0);
    //注册cell
    [_collectionView registerNib: [UINib nibWithNibName:@"MeWonderViewCell" bundle:nil] forCellWithReuseIdentifier:@"MeWonderViewCell"];
    
    _iconLabelArr = @[@"我要约球",@"高球悬赏",@"加入球队",@"加入赛事",@"我要投票",@"天天特价"];
}
#pragma mark -- uicollection方法
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* arrayYuan = @[@"wyyq",@"gqxs",@"wdqd",@"ssgl",@"wytp",@"tttj"];
    MeWonderViewCell *cell = [[MeWonderViewCell alloc]init];
    
    // Set up the reuse identifier
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MeWonderViewCell"forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.iconLabel.text = [NSString stringWithFormat:@"%@",_iconLabelArr[indexPath.row]];
    cell.iconLabel.textAlignment = NSTextAlignmentCenter;
    cell.iconLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",arrayYuan[indexPath.row]]];
    
    
    return cell;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return ScreenWidth>=375?CGSizeMake(80*ScreenWidth/375, 105*ScreenWidth/375):CGSizeMake(80*ScreenWidth/375, 90*ScreenWidth/375);
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
//        NSArray *vcArr = @[@"YueHallViewController",
//                           @"HighBallViewController",
//                           @"MyTeamViewController",
//                           @"ManageViewController",
//                           @"VoteViewController",
//                           @"SpeciallOfferViewController"];
        NSArray *vcArr = @[@"YueHallViewController",
                           @"HighBallViewController",
                           @"JGTeamActivityViewController",
                           @"ManageViewController",
                           @"VoteViewController",
                           @"SpeciallOfferViewController"];
        //        NSArray *titleArr = @[@"我要约球",@"球场预订",@"我的球队",@"赛事管理",@"我要投票",@"天天特价"];
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for (int i = 0; i<vcArr.count; i++) {
            ViewController *vc = [[NSClassFromString(vcArr[i]) alloc]init];
            //            vc.title = titleArr[i];
            [arr addObject:vc];
        }
        //发出通知隐藏标签栏
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
        ////NSLog(@"55");
        [self.navigationController pushViewController:arr[indexPath.row] animated:YES];
        ////NSLog(@"66");
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"打高尔夫啦" message:@"确定是否立即登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        EnterViewController *vc = [[EnterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark --融云方法
- (void)onRCIMReceiveMessage:(RCMessage *)message
                        left:(int)left
{
    [self.tabBarController.tabBar showBadgeOnItemIndex:3];
}


//方块视图的手势点击事件
-(void) tapView:(UITapGestureRecognizer*) tapView
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
        NSArray *vcArr = @[@"UseMallViewController",
                           @"StadiumViewController",
                           @"PackageViewController",
                           @"PracticeViewController",
                           @"TeacherViewController",
                           @"MemberShipViewController"];
        NSArray *titleArr = @[@"高球用品",@"球场预订",@"套餐预订",@"练习场",@"教练",@"会籍"];
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for (int i = 0; i<vcArr.count; i++) {
            ViewController *vc = [[NSClassFromString(vcArr[i]) alloc]init];
            //UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
            vc.type = i;
            vc.title = titleArr[i];
            [arr addObject:vc];
            
            
        }
        [self.navigationController pushViewController:arr[tapView.view.tag-100] animated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"打高尔夫啦" message:@"确定是否立即登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}


@end
