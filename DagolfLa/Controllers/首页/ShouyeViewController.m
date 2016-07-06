//
//  ShouyeViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/7/21.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//


#import "ShouyeViewController.h"
#import "JGTeamChannelViewController.h"
#import "ManageViewController.h"
#import "VoteViewController.h"
#import "UseMallViewController.h"
#import "PackageViewController.h"
#import "StadiumViewController.h"
#import "TeacherViewController.h"

#import "EnterViewController.h"
//跳转详情界面
#import "JGLWinnersShareViewController.h"

#import "HomeHeadView.h"
#import "JGTeamActibityNameViewController.h"

#import "JGDActivityListViewController.h"
#import "JGDPrizeViewController.h"

@interface ShouyeViewController ()<UIApplicationDelegate,CLLocationManagerDelegate>
{
//    UITableView *_tableView;
    UIScrollView* _scrollView;
    UIView *_viewBase;
}
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (nonatomic, strong)HomeHeadView *topScrollView;//BANNAER图



@end




@implementation ShouyeViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.navigationItem.leftBarButtonItem = nil;
    //发出通知显示标签栏
    [[NSNotificationCenter defaultCenter] postNotificationName:@"show" object:nil];
    
    self.navigationController.navigationBarHidden = YES;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        [RCIM sharedRCIM].receiveMessageDelegate=self;
    }
    
    [self getCurPosition];
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
    //设置任务栏不占位置
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"打高尔夫啦";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //监听分组页面返回，刷新数据
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(PushJGTeamActibityNameViewController:) name:@"PushJGTeamActibityNameViewController" object:nil];

    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(0, screenWidth/2 + 425*screenWidth/375);
    //BANNER图
    [self createBanner];
    //用品商城
    [self createMall];
    //套餐预定，教练，球队
    [self createTeamOrder];
    //投票和球场预定
    [self createFieldAndVote];
}
#pragma mark -- 网页 跳转活动详情
- (void)PushJGTeamActibityNameViewController:(NSNotification *)not{
    JGTeamActibityNameViewController *teamCtrl= [[JGTeamActibityNameViewController alloc]init];
    teamCtrl.teamKey = [not.userInfo[@"timekey"] integerValue];
    teamCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:teamCtrl animated:YES];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)createBanner
{
    self.topScrollView = [[HomeHeadView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth/2)];
    self.topScrollView.userInteractionEnabled = YES;
    [_scrollView addSubview:self.topScrollView];
    
    
    
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
                self.topScrollView.delegate = self;
                [self.topScrollView setClick:^(UIViewController *vc) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            }
            
        }
        
    }];
    
    
}
-(void)createMall
{
    //商城
    UIButton* btnMall = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMall.frame = CGRectMake(5*screenWidth/375, screenWidth/2 + 5*screenWidth/375, screenWidth-10*screenWidth/375, 100*screenWidth/375);
    [btnMall setBackgroundImage:[UIImage imageNamed:@"userMall"] forState:UIControlStateNormal];
    [_scrollView addSubview:btnMall];
    [btnMall addTarget:self action:@selector(manageClick:) forControlEvents:UIControlEventTouchUpInside];
    btnMall.tag = 1001;

}
-(void)createTeamOrder
{
    //套餐
    UIButton* btnOrder = [UIButton buttonWithType:UIButtonTypeCustom];
    btnOrder.frame = CGRectMake(5*screenWidth/375, screenWidth/2 + 110*screenWidth/375, 100*screenWidth/375, 100*screenWidth/375);
    [btnOrder setBackgroundImage:[UIImage imageNamed:@"tcOrder"] forState:UIControlStateNormal];
    [_scrollView addSubview:btnOrder];
    [btnOrder addTarget:self action:@selector(manageClick:) forControlEvents:UIControlEventTouchUpInside];
    btnOrder.tag = 1002;

    
    //教练
    UIButton* btnTeacher = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTeacher.frame = CGRectMake(5*screenWidth/375, screenWidth/2 + 215*screenWidth/375, 100*screenWidth/375, 100*screenWidth/375);
    [btnTeacher setBackgroundImage:[UIImage imageNamed:@"zyjl"] forState:UIControlStateNormal];
    [_scrollView addSubview:btnTeacher];
    [btnTeacher addTarget:self action:@selector(manageClick:) forControlEvents:UIControlEventTouchUpInside];
    btnTeacher.tag = 1003;

    //球队
    UIButton* btnTeam = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTeam.frame = CGRectMake(110*screenWidth/375, screenWidth/2 + 110*screenWidth/375, screenWidth-115*screenWidth/375, 205*screenWidth/375);
    [btnTeam setBackgroundImage:[UIImage imageNamed:@"myqd"] forState:UIControlStateNormal];
    [_scrollView addSubview:btnTeam];
    [btnTeam addTarget:self action:@selector(manageClick:) forControlEvents:UIControlEventTouchUpInside];
    btnTeam.tag = 1004;

}
-(void)createFieldAndVote
{
    //投票
    UIButton* btnVote = [UIButton buttonWithType:UIButtonTypeCustom];
    btnVote.frame = CGRectMake(5*screenWidth/375, screenWidth/2 + 320*screenWidth/375, screenWidth/2-10*screenWidth/375, 100*screenWidth/375);
    [btnVote setBackgroundImage:[UIImage imageNamed:@"wytp"] forState:UIControlStateNormal];
    [_scrollView addSubview:btnVote];
    [btnVote addTarget:self action:@selector(manageClick:) forControlEvents:UIControlEventTouchUpInside];
    btnVote.tag = 1005;

    
    //球场
    UIButton* btnField = [UIButton buttonWithType:UIButtonTypeCustom];
    btnField.frame = CGRectMake(screenWidth/2, screenWidth/2 + 320*screenWidth/375, screenWidth/2-10*screenWidth/375, 100*screenWidth/375);
    [btnField setBackgroundImage:[UIImage imageNamed:@"qcyd"] forState:UIControlStateNormal];
    [_scrollView addSubview:btnField];
    [btnField addTarget:self action:@selector(manageClick:) forControlEvents:UIControlEventTouchUpInside];
    btnField.tag = 1006;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        EnterViewController *vc = [[EnterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)manageClick:(UIButton *)btn
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        
        switch (btn.tag) {
            case 1001:
            {
                NSLog(@"shangchen");
//                UseMallViewController
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                JGLWinnersShareViewController* userVc = [[JGLWinnersShareViewController alloc]init];
                [self.navigationController pushViewController:userVc animated:YES];
            }
                break;
            case 1002:
            {
                NSLog(@"taocan");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                PackageViewController* pacVc = [[PackageViewController alloc]init];
                [self.navigationController pushViewController:pacVc animated:YES];
            }
                break;
            case 1003:
            {
                NSLog(@"jiaolian");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                TeacherViewController* teaVc = [[TeacherViewController alloc]init];
                [self.navigationController pushViewController:teaVc animated:YES];
            }
                break;
            case 1004:
            {
                NSLog(@"qiuudi");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                JGTeamChannelViewController* teamVc = [[JGTeamChannelViewController alloc]init];
                [self.navigationController pushViewController:teamVc animated:YES];
            }
                break;
            case 1005:
            {
                NSLog(@"toup");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                VoteViewController* voteVc = [[VoteViewController alloc]init];
                [self.navigationController pushViewController:voteVc animated:YES];
            }
                break;
            case 1006:
            {
                NSLog(@"qiuchan");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
                StadiumViewController* staVC = [[StadiumViewController alloc]init];
                [self.navigationController pushViewController:staVC animated:YES];
                
            }
                break;
                
            default:
                break;
        }

    
    }
else
    {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"打高尔夫啦" message:@"确定是否立即登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }

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


@end
