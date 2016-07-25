//
//  BallParkViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/12.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "BallParkViewController.h"

#import "PostDataRequest.h"
#import "MJRefresh.h"
#import "MJDIYHeader.h"
#import "MJDIYBackFooter.h"
#import "Helper.h"
#import "BallParkModel.h"
#import <RongIMKit/RongIMKit.h>
#define kBallPark_URL @"ballInfo/queryPage.do"


@interface BallParkViewController ()<UITableViewDataSource,UITableViewDelegate,UIApplicationDelegate,CLLocationManagerDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _dataArray;
    BOOL _isClick;
    UITextField *_textField;
    
    NSInteger _page;
    
    BOOL _isCor;
}
@property (strong, nonatomic) CLLocationManager* locationManager;
@end

@implementation BallParkViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地区选择";
    
    _page = 1;
    _isCor = NO;
    
    [self getCurPosition];
    
    if (_isCor == NO) {
        //搜索栏
        [self createSeachBar];
        //表
        [self createTableView];
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
    NSLog(@"经度=%f 纬度=%f 高度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);
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
             
             //搜索栏
             [self createSeachBar];
             //表
             [self createTableView];
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




-(void)createSeachBar{
    _isCor = YES;
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44*ScreenWidth/375)];
    view.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:view];
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(13*ScreenWidth/375, 4*ScreenWidth/375, ScreenWidth-80*ScreenWidth/375, 36*ScreenWidth/375)];
    imageView.backgroundColor=[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:239.0/255];
    imageView.layer.cornerRadius = 15*ScreenWidth/375;
    imageView.tag=88;
    imageView.userInteractionEnabled=YES;
    imageView.clipsToBounds=YES;
    [view addSubview:imageView];
    
    UIImageView *imageView2=[[UIImageView alloc] init];
    imageView2.image=[UIImage imageNamed:@"search"];
    imageView2.frame=CGRectMake(10*ScreenWidth/375, 10*ScreenWidth/375, 16*ScreenWidth/375, 16*ScreenWidth/375);
    [imageView addSubview:imageView2];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(30*ScreenWidth/375, 0*ScreenWidth/375, ScreenWidth-115*ScreenWidth/375, 36*ScreenWidth/375)];
    _textField.textColor=[UIColor lightGrayColor];
    _textField.tag=888;
    [_textField addTarget:self action:@selector(keyboardDown3:) forControlEvents:UIControlEventEditingDidEndOnExit];
    _textField.placeholder=@"请输入类别或关键字";
    [imageView addSubview:_textField];
    _textField.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    
    UIButton *SeachButton=[UIButton buttonWithType:UIButtonTypeCustom];
    SeachButton.frame=CGRectMake(ScreenWidth-60*ScreenWidth/375, 0*ScreenWidth/375, 60*ScreenWidth/375, 44*ScreenWidth/375);
    [SeachButton setTitle:@"搜索" forState:UIControlStateNormal];
    SeachButton.titleLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    [SeachButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [SeachButton addTarget:self action:@selector(seachBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:SeachButton];
}
-(void)keyboardDown3:(UITextField *)tf{
    
}
-(void)seachBtnClick{
    [_textField resignFirstResponder];
    UIImageView *imageView=(UIImageView *)[self.view viewWithTag:88];
    NSLog(@"%@",_textField.text);
    if ([Helper isBlankString:_textField.text]==NO) {
        
//        [_dataArray removeAllObjects];
        _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
//        _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        [_tableView.header beginRefreshing];
    }else{
        [[ShowHUD showHUD]showToastWithText:@"请填写搜索信息" FromView:self.view];
    }

}


-(void)createTableView
{
    _dataArray = [[NSMutableArray alloc]init];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44*ScreenWidth/375, ScreenWidth, ScreenHeight-44*ScreenWidth/375-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [_tableView.header beginRefreshing];
}


#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [dict setObject:@15 forKey:@"rows"];
    [dict setObject:_textField.text forKey:@"ballName"];
    [dict setObject:self.lat forKey:@"xIndex"];
    [dict setObject:self.lng forKey:@"yIndex"];
    [[PostDataRequest sharedInstance] postDataRequest:kBallPark_URL parameter:dict success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (page == 1){
                [_dataArray removeAllObjects];
            }
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                BallParkModel *model = [[BallParkModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                [_dataArray addObject:model];
//                [_numArray addObject:model.ballId];
            }
            _page++;
            [_tableView reloadData];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
//        [_tableView reloadData];
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


#pragma mark --tableview的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
//返回每一行所对应的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [_dataArray[indexPath.row] ballName];//表示这个数组里买呢有多少区。区里面有多少行
    cell.textLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44*ScreenWidth/375;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isNeedAdd == YES) {
        if (![Helper isBlankString:[_dataArray[indexPath.row] ballAddress]]) {
            _callbackAddress([_dataArray[indexPath.row] ballName],[[_dataArray[indexPath.row] ballId] integerValue],[_dataArray[indexPath.row] ballAddress]);
        }
        else{
            _callbackAddress([_dataArray[indexPath.row] ballName],[[_dataArray[indexPath.row] ballId] integerValue],[_dataArray[indexPath.row] ballName]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if (_type1==0) {
            if (_isClick == NO)
            {
                //点击事件选中后传值
                _callback([_dataArray[indexPath.row] ballName],[[_dataArray[indexPath.row] ballId] integerValue]);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            if (_isClick == NO)
            {
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:[_dataArray[indexPath.row] ballId] forKey:@"ballKey"];
                [[JsonHttp jsonHttp]httpRequest:@"ball/getBallCode" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
                    
                } completionBlock:^(id data) {
                    
                    if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                        //点击事件选中后传值
                        NSMutableDictionary* dict1 = [[NSMutableDictionary alloc]init];
                        [dict1 setObject:[data objectForKey:@"ballAreas"] forKey:@"ballAreas"];
                        [dict1 setObject:[data objectForKey:@"tAll"] forKey:@"tAll"];
                        _callback1(dict1,[_dataArray[indexPath.row]loginpic]);
                        _callback([_dataArray[indexPath.row] ballName],[[_dataArray[indexPath.row] ballId] integerValue]);
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else{
                        [Helper alertViewWithTitle:@"球场整修中" withBlock:^(UIAlertController *alertView) {
                            [self presentViewController:alertView animated:YES completion:nil];
                        }];
                    }

                    NSLog(@"%@", data);
                    if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
                        
                    }else{
                        
                    }
                }];
            
                
            }
        }
    }
    
}


@end
