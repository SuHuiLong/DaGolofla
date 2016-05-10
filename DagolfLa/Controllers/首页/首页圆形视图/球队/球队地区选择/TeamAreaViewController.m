//
//  TeamAreaViewController.m
//  DagolfLa
//
//  Created by bhxx on 15/12/18.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "TeamAreaViewController.h"
#import <MapKit/MapKit.h>

#import "CityCollectionViewCell.h"

#import "CityModel.h"
#import <BaiduMapAPI/BMapKit.h>
//#import <BaiduMapAPI/BMKReverseGeoCodeOption.h>
#import "PostDataRequest.h"
#import "MJRefresh.h"
#import "Helper.h"

#import "UIView+ChangeFrame.h"

#define kProvince_Url @"region/queryByFather.do"

@interface TeamAreaViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate>
{
    UIView* _viewHeader;
    
    UICollectionView* _collectionView;
    NSMutableArray* _dataProArray;
    NSMutableArray* _numProArray;
    
    NSMutableArray* _tableArray;
    NSMutableArray* _numTableArray;
    
    UITableView* _tableView;
    
    UILabel* _labelCity;
    UIImageView *_labelCityImage;
    //城市点击按钮，改变位置；
    UIButton* _cityChange;
    
    UIView* _viewCity;
    //热门城市
    UIButton* _btnHotCity;
    //城市
    UIButton* _btnNorCity;
    
    UIView* _viewProvince;
    UILabel* _labelProvince;
    
    UIView* _viewBase;
    
    BOOL _isShowCity;
    
    CLLocationManager* _locationManager;
    UIButton* _labelLocation;
    
    //
    NSString* _strProvince;
    
    UILabel* _cityTable;
    
    //标记上一次点击的是哪一个按钮
    NSInteger _shangyici;
    NSInteger _lastBtn;
}
@end

@implementation TeamAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地区";
    
    
    {
        
        //        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.frame.size.height)];
        //        _scrollView.delegate = self;
        //        [self addSubview:_scrollView];
        ////        _scrollView.backgroundColor = [UIColor redColor];
        //        _scrollView.contentSize = CGSizeMake(0, 0);
        //
        
        _isShowCity = YES;
        self.view.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
        
        _dataProArray = [[NSMutableArray alloc]init];
        _numProArray = [[NSMutableArray alloc]init];
        
        _tableArray = [[NSMutableArray alloc]init];
        _numTableArray = [[NSMutableArray alloc]init];
        
        [[PostDataRequest sharedInstance] postDataRequest:kProvince_Url parameter:@{@"rows":@15,@"fatherId":@1} success:^(id respondsData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            if ([[dict objectForKey:@"success"] boolValue]) {
                for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                    CityModel *model = [[CityModel alloc] init];
                    [model setValuesForKeysWithDictionary:dataDict];
                    if (![model.region_NAME  isEqualToString:@"北京市"] && ![model.region_NAME  isEqualToString: @"上海市"] && ![model.region_NAME  isEqualToString: @"天津市"] && ![model.region_NAME  isEqualToString: @"重庆市"]) {
                        [_dataProArray addObject:model.region_NAME];
                        [_numProArray addObject:model.region_ID];
                    }
                    
                    
                }
                //城市列表
                [self createTableView];
                _viewHeader = [[UIView alloc]init];
                
                //定位
                [self createLocation];
                
                //热门城市
                [self createHotCity];
                
                //省份
                [self createProvince];
                
                
                _viewHeader.userInteractionEnabled = YES;
                _tableView.tableHeaderView = _viewHeader;
                _viewHeader.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
                
                
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        } failed:^(NSError *error) {
            
        }];
    }
 
}

#pragma mark --定位
-(void)createLocation
{
    UIView* viewLocation = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 60*ScreenWidth/375)];
    [_viewHeader addSubview:viewLocation];
    
    UILabel* labelLoaction = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 0, 50*ScreenWidth/375, 30*ScreenWidth/375)];
    labelLoaction.text = @"地区:";
    labelLoaction.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [viewLocation addSubview:labelLoaction];
    
    UIButton* btnAll = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAll.frame = CGRectMake(60*ScreenWidth/375, 0, 60*ScreenWidth/375, 30*ScreenWidth/375);
    [btnAll setTitle:@"所有地区" forState:UIControlStateNormal];
    [btnAll setTitleColor:[UIColor colorWithRed:0.93f green:0.33f blue:0.19f alpha:1.00f] forState:UIControlStateNormal];
    [viewLocation addSubview:btnAll];
    btnAll.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [btnAll addTarget:self action:@selector(allCityClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imgvJu = [[UIImageView alloc]initWithFrame:CGRectMake(60*ScreenWidth/375, 37*ScreenWidth/375, 10*ScreenWidth/375, 16*ScreenWidth/375)];
    imgvJu.image = [UIImage imageNamed:@"juli"];
    [viewLocation addSubview:imgvJu];
    
    
    //定位后的城市
    NSString* strCity = [[NSUserDefaults standardUserDefaults]objectForKey:@"定位"];
    _labelLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    _labelLocation.frame = CGRectMake(80*ScreenWidth/375, 30*ScreenWidth/375, 100*ScreenWidth/375, 30*ScreenWidth/375);
    [_labelLocation setTitleColor:[UIColor colorWithRed:0.62f green:0.62f blue:0.62f alpha:1.00f] forState:UIControlStateNormal];
    [_labelLocation setTitle:strCity forState:UIControlStateNormal];
    _labelLocation.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    [viewLocation addSubview:_labelLocation];
    [_labelLocation addTarget:self action:@selector(LocationClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton* btnAfresh = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAfresh.frame = CGRectMake(ScreenWidth-80*ScreenWidth/375, 10*ScreenWidth/375, 80*ScreenWidth/375, 40*ScreenWidth/375);
    [btnAfresh setTitle:@"重新定位" forState:UIControlStateNormal];
    btnAfresh.imageEdgeInsets = UIEdgeInsetsMake(7*ScreenWidth/375, -40*ScreenWidth/375, 7*ScreenWidth/375, 5*ScreenWidth/375);
    btnAfresh.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    btnAfresh.titleEdgeInsets = UIEdgeInsetsMake(0, -30*ScreenWidth/375, 0, 0);
    [btnAfresh setTitleColor:[UIColor colorWithRed:0.62f green:0.62f blue:0.62f alpha:1.00f] forState:UIControlStateNormal];
    [btnAfresh setImage:[UIImage imageNamed:@"chongxin"] forState:UIControlStateNormal];
    [viewLocation addSubview:btnAfresh];
    [btnAfresh addTarget:self action:@selector(cityRedingClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 59*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 1*ScreenWidth/375)];
    viewLine.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
    [viewLocation addSubview:viewLine];
    
}
-(void)LocationClick
{
    
    //    ////NSLog(@"%f, %f",[[[NSUserDefaults standardUserDefaults] objectForKey:@"lat"] doubleValue],[[[NSUserDefaults standardUserDefaults] objectForKey:@"lng"] doubleValue]);
    CLLocation *c = [[CLLocation alloc] initWithLatitude:[[[NSUserDefaults standardUserDefaults] objectForKey:@"lat"] doubleValue] longitude:[[[NSUserDefaults standardUserDefaults] objectForKey:@"lng"] doubleValue]];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:c completionHandler:^(NSArray *placemarks, NSError *error) {        //遍历位置信息
        for (CLPlacemark * place in placemarks) {
     
            
            [UIView animateWithDuration:0.2 animations:^{
                [self.navigationController popViewControllerAnimated:YES];
                
            } completion:^(BOOL finished) {
                if (finished) {
                    if (_shangyici!=0) {
                        UIButton *button = (UIButton *)[_viewProvince viewWithTag:_shangyici];
                        button.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
                    }
                    if (_lastBtn!=0) {
                        UIButton *button = (UIButton *)[_viewCity viewWithTag:_lastBtn];
                        button.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
                    }
                }
                
            }];
            if ([_teamType integerValue] != 10) {
                _blockCity(place.administrativeArea,place.locality);
            }
            else
            {
                _callBackCity(place.administrativeArea, place.locality,@12);
            }
            
        }
    }];
    //CLGeocoder的反编码
    
    
    
    
}

-(void)allCityClick
{
    //所有地区，不用传值
    ////NSLog(@"2");
    [UIView animateWithDuration:0.2 animations:^{
        [self.navigationController popViewControllerAnimated:YES];
        
    } completion:^(BOOL finished) {
        if (finished) {
            if (_shangyici!=0) {
                UIButton *button = (UIButton *)[_viewProvince viewWithTag:_shangyici];
                button.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
            }
            if (_lastBtn!=0) {
                UIButton *button = (UIButton *)[_viewCity viewWithTag:_lastBtn];
                button.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
            }
        }
        
    }];
    if ([_teamType integerValue] != 10) {
        _blockCity(@"",@"");
    }
    else
    {
        _callBackCity(@"",@"",@0);
    }
    
}

-(void)cityRedingClick:(UIButton *)btn
{
    
    //  [Helper rotate360DegreeWithImageView:btn.imageView];
    if (_locationManager==nil) {
        _locationManager=[[CLLocationManager alloc] init];
    }
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager.delegate=self;
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        _locationManager.distanceFilter=10.0f;
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager startUpdatingLocation];
        NSString* strCity = [[NSUserDefaults standardUserDefaults]objectForKey:@"定位"];
        //        _labelLocation.text = [NSString stringWithFormat:@"%@",strCity];
        [_labelLocation setTitle:strCity forState:UIControlStateNormal];
        
        
    }
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    if ([locations count]>0) {
        CLLocation* loc = [locations objectAtIndex:0];
        CLLocationCoordinate2D pos = [loc coordinate];
        //        [self.layer removeAllAnimations];
        //        CLLocationCoordinate2D coord=[WGS84TOGCJ02 transformFromWGSToGCJ:[loc coordinate]];
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        [[PostDataRequest sharedInstance] getDataRequest:[NSString stringWithFormat:@"http://mo.amap.com/service/geo/getadcode.json?longitude=%f&latitude=%f",pos.longitude,pos.latitude] success:^(id respondsData) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingAllowFragments error:nil];
            [user setObject:[dict objectForKey:@"city"] forKey:@"定位"];
            [user setObject:[dict objectForKey:@"adcode"] forKey:@"code1"];
            [user setObject:[dict objectForKey:@"lat"] forKey:@"lat"];
            [user setObject:[dict objectForKey:@"lon"] forKey:@"lng"];
            [user synchronize];
            //            ////NSLog(@"city == %@",[dict objectForKey:@"city"]);
            
            [_locationManager stopUpdatingLocation];
            //            [self.layer removeAllAnimations];
            
        } failed:^(NSError *error) {
            //            ////NSLog(@"111");
            //            ////NSLog(@"%@",error);
        }];
        
    }
    
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
}


#pragma mark --热门城市
-(void)createHotCity
{
    
    _labelCity = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 60*ScreenWidth/375, ScreenWidth, 30*ScreenWidth/375)];
    _labelCity.text = @"热门城市:";
    _labelCity.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [_viewHeader addSubview:_labelCity];
    _labelCity.userInteractionEnabled = YES;
    
    
    _labelCityImage = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 40 *ScreenWidth/375, _labelCity.frameY + 8 * ScreenWidth / 375, 13 *ScreenWidth/375, 12 *ScreenWidth/375)];
    _labelCityImage.hidden = YES;
    [_viewHeader addSubview:_labelCityImage];
    
    _cityChange = [UIButton buttonWithType:UIButtonTypeCustom];
    _cityChange.frame = CGRectMake(0, 0, ScreenWidth, 30*ScreenWidth/375);
    _cityChange.backgroundColor = [UIColor clearColor];
    [_labelCity addSubview:_cityChange];
    [_cityChange addTarget:self action:@selector(changeClick) forControlEvents:UIControlEventTouchUpInside];
    
    _viewCity = [[UIView alloc]initWithFrame:CGRectMake(0, 90*ScreenWidth/375, ScreenWidth, 100*ScreenWidth/375)];
    [_viewHeader addSubview:_viewCity];
    
    for (int i = 0; i < 8; i++) {
        NSArray* array = @[@"北京市",@"上海市",@"广州市",@"深圳市",@"杭州市",@"海口市",@"重庆市",@"天津市"];
        _btnHotCity = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnHotCity.frame = CGRectMake(15*ScreenWidth/375 + 90*(i%4)*ScreenWidth/375, 40*ScreenWidth/375*(i/4), 75*ScreenWidth/375, 30*ScreenWidth/375);
        _btnHotCity.backgroundColor = [UIColor colorWithRed:0.88f green:0.88f blue:0.88f alpha:1.00f];
        _btnHotCity.layer.masksToBounds = YES;
        _btnHotCity.layer.cornerRadius = 3*ScreenWidth/375;
        [_btnHotCity setTitle:array[i] forState:UIControlStateNormal];
        [_btnHotCity setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btnHotCity.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        [_viewCity addSubview:_btnHotCity];
        [_btnHotCity addTarget:self action:@selector(cityChooseClick:) forControlEvents:UIControlEventTouchUpInside];
        _btnHotCity.tag = 300 + i;
    }
}
-(void)cityChooseClick:(UIButton *)btn
{
    //城市选择
    if (_lastBtn!=0) {
        UIButton *button = (UIButton *)[_viewCity viewWithTag:_lastBtn];
        button.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    }
    btn.backgroundColor = [UIColor orangeColor];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.navigationController popViewControllerAnimated:YES];
        
    } completion:^(BOOL finished) {
        if (finished) {
            if (_shangyici!=0) {
                UIButton *button = (UIButton *)[_viewProvince viewWithTag:_shangyici];
                button.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
            }
            if (_lastBtn!=0) {
                UIButton *button = (UIButton *)[_viewCity viewWithTag:_lastBtn];
                button.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
            }
        }
        
    }];
    switch (btn.tag - 300) {
        case 0:
        {
            if ([_teamType integerValue] != 10) {
                _blockCity(@"北京市",@"北京市");
            }
            else
            {
                _callBackCity(@"北京市",@"北京市",@2);
            }
            
            
        }
            break;
        case 1:
        {
            if ([_teamType integerValue] != 10) {
                _blockCity(@"上海市",@"上海市");
            }
            else
            {
                _callBackCity(@"上海市",@"上海市",@10);
            }
        }
            break;
        case 2:
        {
            if ([_teamType integerValue] != 10) {
                _blockCity(@"广东省",@"广州市");
            }
            else
            {
                _callBackCity(@"广东省",@"广州市",@232);
            }
            
        }
            break;
        case 3:
        {
            if ([_teamType integerValue] != 10) {
                _blockCity(@"广东省",@"深圳市");
            }
            else
            {
                _callBackCity(@"广东省",@"深圳市",@234);
            }
            
            
        }
            break;
        case 4:
        {
            if ([_teamType integerValue] != 10) {
                _blockCity(@"浙江省",@"杭州市");
            }
            else
            {
                _callBackCity(@"浙江省",@"杭州市",@122);
            }

        }
            break;
        case 5:
        {
            if ([_teamType integerValue] != 10) {
                _blockCity(@"海南省",@"海口市");
            }
            else
            {
                _callBackCity(@"海南省",@"海口市",@267);
            }
        }
            break;
        case 6:
        {
            if ([_teamType integerValue] != 10) {
                _blockCity(@"重庆市",@"重庆市");
            }
            else
            {
                _callBackCity(@"重庆市",@"重庆市",@23);
            }
        }
            break;
        case 7:
        {
            if ([_teamType integerValue] != 10) {
                _blockCity(@"天津市",@"天津市");
            }
            else
            {
                _callBackCity(@"天津市",@"天津市",@3);
            }

        }
            break;
            
        default:
            break;
    }
    _lastBtn = btn.tag;
    
}

-(void)changeClick
{
    if (_isShowCity == NO) {
        [UIView animateWithDuration:0.2 animations:^{
            
            _viewCity.alpha = 1;
            _viewProvince.frame = CGRectMake(0, 160*ScreenWidth/375, ScreenWidth, 40*ScreenWidth/375*(_dataProArray.count/4)+70*ScreenWidth/375);
            _labelCity.text = @"热门城市:";
            _viewBase.frame = CGRectMake(0, 40*ScreenWidth/375*(_dataProArray.count/4)+70*ScreenWidth/375+160*ScreenWidth/375, 0, 30*ScreenWidth/375*(_tableArray.count)+30*ScreenWidth/375);
            //            _viewBase.alpha = 0;
            _cityTable.alpha = 0;
            _labelCityImage.hidden = YES;
            _viewHeader.frame = CGRectMake(0, 0, ScreenWidth, 40*ScreenWidth/375*((_dataProArray.count-1)/4+1)+60*ScreenWidth/375+150*ScreenWidth/375);
            _tableView.tableHeaderView=_viewHeader;
            
            [_tableArray removeAllObjects];
            [_tableView reloadData];
        }];
        _isShowCity = YES;
        //        _scrollView.contentSize = CGSizeMake(0, 40*ScreenWidth/375*(_dataProArray.count/4)+70*ScreenWidth/375+160*ScreenWidth/375);
    }
    
}


#pragma mark --省份
-(void)createProvince
{
    _viewProvince = [[UIView alloc]initWithFrame:CGRectMake(0, 160*ScreenWidth/375, ScreenWidth, 40*ScreenWidth/375*((_dataProArray.count-1)/4+1)+50*ScreenWidth/375)];
    [_viewHeader addSubview:_viewProvince];
    _viewHeader.frame = CGRectMake(0, 0, ScreenWidth, 40*ScreenWidth/375*((_dataProArray.count-1)/4+1)+60*ScreenWidth/375+150*ScreenWidth/375);
    
    _labelProvince = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 0, 50*ScreenWidth/375, 30*ScreenWidth/375)];
    _labelProvince.text = @"省份:";
    _labelProvince.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [_viewProvince addSubview:_labelProvince];
    
    
    for (int i = 0; i < _dataProArray.count; i++) {
        _btnNorCity = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _btnNorCity.frame = CGRectMake(15*ScreenWidth/375 + 90*(i%4)*ScreenWidth/375, 40*ScreenWidth/375*((_dataProArray.count-1)/4+1), 75*ScreenWidth/375, 30*ScreenWidth/375);
        _btnNorCity.frame = CGRectMake(15*ScreenWidth/375 + 90*(i%4)*ScreenWidth/375, 40*ScreenWidth/375*(i/4)+30*ScreenWidth/375, 75*ScreenWidth/375, 30*ScreenWidth/375);
        [_btnNorCity setTitle:_dataProArray[i] forState:UIControlStateNormal];
        _btnNorCity.layer.masksToBounds = YES;
        _btnNorCity.layer.cornerRadius = 3*ScreenWidth/375;
        [_btnNorCity setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btnNorCity.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        [_viewProvince addSubview:_btnNorCity];
        _btnNorCity.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
        _btnNorCity.tag = 500+i;
        [_btnNorCity addTarget:self action:@selector(btnNormalClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    _cityTable = [[UILabel alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 30*ScreenWidth/375+ 40*ScreenWidth/375*((_dataProArray.count-1)/4+1), ScreenWidth, 30*ScreenWidth/375)];
    _cityTable.text = @"城市:";
    _cityTable.alpha = 0;
    _cityTable.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    [_viewProvince addSubview:_cityTable];
    
}

-(void)btnNormalClick:(UIButton *)btn
{
    if (_shangyici!=0) {
        UIButton *button = (UIButton *)[_viewProvince viewWithTag:_shangyici];
        button.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    }
    btn.backgroundColor = [UIColor orangeColor];
    
    if (_isShowCity == YES) {
        
        [UIView animateWithDuration:0.2 animations:^{
            _viewCity.alpha = 0;
            _viewProvince.frame = CGRectMake(0, 90*ScreenWidth/375, ScreenWidth, 40*ScreenWidth/375*(_dataProArray.count/4)+70*ScreenWidth/375);
            _viewBase.frame = CGRectMake(0, 40*ScreenWidth/375*(_dataProArray.count/4)+70*ScreenWidth/375+90*ScreenWidth/375, 0, 30*ScreenWidth/375*(_tableArray.count)+30*ScreenWidth/375);
            //            ////NSLog(@"height == %f",40*ScreenWidth/375*(_dataProArray.count/4)+70*ScreenWidth/375+90*ScreenWidth/375);
            _labelCity.text = @"点击这里,显示热门城市:";
            _viewBase.alpha = 1;
            _viewBase.userInteractionEnabled = YES;
            _cityTable.alpha = 1;
            
            _labelCityImage.frame = CGRectMake(ScreenWidth - 40 *ScreenWidth/375, _labelCity.frameY + 9 * ScreenWidth / 375, 12 *ScreenWidth/375, 12 *ScreenWidth/375);
            _labelCityImage.image = [UIImage imageNamed:@")"];
            _labelCityImage.hidden = NO;
            _viewHeader.frame = CGRectMake(0, 0, ScreenWidth, 40*ScreenWidth/375*((_dataProArray.count-1)/4+1)+60*ScreenWidth/375+90*ScreenWidth/375);
            _tableView.tableHeaderView = _viewHeader;
            [_tableView reloadData];
        }];
        
        //        [_scrollView setContentOffset:CGPointMake(0, 60*ScreenWidth/375)];
        _isShowCity = NO;
        //        _scrollView.contentSize = CGSizeMake(0, 40*ScreenWidth/375*(_dataProArray.count/4)+70*ScreenWidth/375+90*ScreenWidth/375 + 30*ScreenWidth/375*(_tableArray.count)+30*ScreenWidth/375);
        
    }
    else
    {
        
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        _tableView.contentOffset = CGPointMake(0, 60*ScreenWidth/375);
    }];
    
    [[PostDataRequest sharedInstance] postDataRequest:kProvince_Url parameter:@{@"rows":@15,@"fatherId":_numProArray[btn.tag-500]} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        //        ////NSLog(@"222 %@",dict);
        if ([[dict objectForKey:@"success"] boolValue]) {
            [_tableArray removeAllObjects];
            [_numTableArray removeAllObjects];
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                CityModel *model = [[CityModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                [_tableArray addObject:model.region_NAME];
                [_numTableArray addObject:model.region_ID];
                
            }
            _strProvince = _dataProArray[btn.tag-500];
            
            //             _scrollView.contentSize = CGSizeMake(0, 40*ScreenWidth/375*(_dataProArray.count/4)+70*ScreenWidth/375+90*ScreenWidth/375 + 44*ScreenWidth/375*(_tableArray.count)+30*ScreenWidth/375);
            //            ////NSLog(@"111 %ld",_tableArray.count);
            //            _tableView.frame = CGRectMake(0, 0, ScreenWidth, 44*ScreenWidth/375*(_tableArray.count));
            [_tableView reloadData];
            
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failed:^(NSError *error) {
        
    }];
    _shangyici=btn.tag;
    
}

#pragma mark --列表
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44*ScreenWidth/375;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    ////NSLog(@"count == %ld ",_numTableArray.count);
    return _tableArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellIdentification";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    
    cell.textLabel.text = _tableArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ////NSLog(@"1");
    ////NSLog(@"chenshi  =====     %@,%@",_strProvince, _tableArray[indexPath.row]);
    [UIView animateWithDuration:0.2 animations:^{
        [self.navigationController popViewControllerAnimated:YES];
        
    } completion:^(BOOL finished) {
        if (finished) {
            if (_shangyici!=0) {
                UIButton *button = (UIButton *)[_viewProvince viewWithTag:_shangyici];
                button.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
            }
            if (_lastBtn!=0) {
                UIButton *button = (UIButton *)[_viewCity viewWithTag:_lastBtn];
                button.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
            }
            
        }
        
    }];
    if ([_teamType integerValue] != 10) {
        _blockCity(_strProvince,_tableArray[indexPath.row]);
    }
    else
    {
        _callBackCity(_strProvince,_tableArray[indexPath.row],_numTableArray[indexPath.row]);
    }
    
    
    //    self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
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
