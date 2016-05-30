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
#import "JGLNewShopDetailViewController.h"

#define WebViewNav_TintColor ([UIColor orangeColor])

#define ShouYe @"http://res.dagolfla.com/web/html/index.html"

@interface ShouyeViewController ()<UIApplicationDelegate,CLLocationManagerDelegate,WKNavigationDelegate,WKUIDelegate>

@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) WKWebView *webView;


@end




@implementation ShouyeViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.navigationItem.leftBarButtonItem = nil;
    //发出通知显示标签栏
    [[NSNotificationCenter defaultCenter] postNotificationName:@"show" object:nil];
    
    //把当前页面的任务栏影藏
     [[UIApplication sharedApplication] setStatusBarHidden:YES];
    //把当前界面的导航栏隐藏
    self.navigationController.navigationBarHidden = YES;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        [RCIM sharedRCIM].receiveMessageDelegate=self;
    }
    [self getCurPosition];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return YES; //返回NO表示要显示，返回YES将hiden
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
    self.navigationItem.title = @"打高尔夫啦";
    self.view.backgroundColor = [UIColor whiteColor];

    [self createWebView];
    
    
    
    
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

#pragma mark --创建wkwebview
-(void)createWebView
{
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.allowsBackForwardNavigationGestures =YES;
    
    __weak typeof(self) weakSelf = self;
    [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        NSString *userAgent = result;
        NSString *newUserAgent = [userAgent stringByAppendingString:@" DagolfLa/2.0"];
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
        
        strongSelf.webView = [[WKWebView alloc] initWithFrame:strongSelf.view.bounds];
        
        // After this point the web view will use a custom appended user agent
        [strongSelf.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
            NSLog(@"%@", result);
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ShouYe]]];
        }];

    }];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ShouYe]]];
}


#pragma mark --webview的代理方法

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
}
- (void)evaluateJavaScript:(NSString *)javaScriptString
         completionHandler:(void (^)(id, NSError *))completionHandler
{
    //如果JavaScript 代码出错, 可以在completionHandler 进行处理.
    //在Objective-C 中注册 message handler:
    // WKScriptMessageHandler protocol?

}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"Message: %@", message.body);
    
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 类似 UIWebView 的 -webView: shouldStartLoadWithRequest: navigationType:
    
    NSLog(@"4.%@",navigationAction.request);
    
    
    NSString *url = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",url);
    decisionHandler(WKNavigationActionPolicyAllow);
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        if ([url rangeOfString:@"myTeam"].location != NSNotFound)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
            JGTeamChannelViewController* teamVc = [[JGTeamChannelViewController alloc]init];
            [self.navigationController pushViewController:teamVc animated:YES];
        }
        else if ([url rangeOfString:@"sportMgr"].location != NSNotFound)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
            ManageViewController* manVc = [[ManageViewController alloc]init];
            [self.navigationController pushViewController:manVc animated:YES];
        }
        else if ([url rangeOfString:@"vote"].location != NSNotFound)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
            VoteViewController* voteVc = [[VoteViewController alloc]init];
            [self.navigationController pushViewController:voteVc animated:YES];
        }
        else if ([url rangeOfString:@"type=shopMall"].location != NSNotFound && [url rangeOfString:@"url="].location == NSNotFound)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
            UseMallViewController* userVc = [[UseMallViewController alloc]init];
            [self.navigationController pushViewController:userVc animated:YES];
        }
        else if ([url rangeOfString:@"packageBook"].location != NSNotFound)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
            PackageViewController* pacVc = [[PackageViewController alloc]init];
            [self.navigationController pushViewController:pacVc animated:YES];
        }
        else if ([url rangeOfString:@"courseBook"].location != NSNotFound)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
            StadiumViewController* staVC = [[StadiumViewController alloc]init];
            [self.navigationController pushViewController:staVC animated:YES];
        }
        else if ([url rangeOfString:@"pcoach"].location != NSNotFound)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
            TeacherViewController* teaVc = [[TeacherViewController alloc]init];
            [self.navigationController pushViewController:teaVc animated:YES];
        }
        else if ([url rangeOfString:@"dagolfla://menu?type=shopMall&url="].location != NSNotFound)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:self];
            JGLNewShopDetailViewController* shoVc = [[JGLNewShopDetailViewController alloc]init];
            NSArray *array = [url componentsSeparatedByString:@"url="]; //从字符A中分隔成2个元素的数组
            NSLog(@"array:%@",array); //结果是adfsfsfs和dfsdf
            shoVc.urlRequest = array[1];        
            [self.navigationController pushViewController:shoVc animated:YES];
            
        }
        else
        {
            
        }

    }
    else
    {
        [Helper alertViewWithTitle:@"是否立即登录" withBlockCancle:^{
            
        } withBlockSure:^{
            EnterViewController *vc = [[EnterViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } withBlock:^(UIAlertController *alertView) {
            [self.navigationController presentViewController:alertView animated:YES completion:nil];
        }];
    }
    
}

#pragma mark --融云方法
- (void)onRCIMReceiveMessage:(RCMessage *)message
                        left:(int)left
{
    
}


@end
