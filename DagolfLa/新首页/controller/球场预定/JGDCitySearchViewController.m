//
//  JGDCitySearchViewController.m
//  DagolfLa
//
//  Created by 東 on 16/12/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDCitySearchViewController.h"
#import <CoreLocation/CLLocationManager.h>
#import <BaiduMapAPI/BMapKit.h>//引入所有的头文件

#import <BaiduMapAPI/BMKMapView.h>//只引入所需的单个头文件

#import "ChineseString.h"

@interface JGDCitySearchViewController () <CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *searchTable;

@property (nonatomic, strong) UILabel *cityLB;
@property (nonatomic, strong) UIButton *cityBtn;

@property (nonatomic, strong) NSMutableDictionary *cityDic;
@property (nonatomic, strong) NSMutableArray *hotCityArray;

@property (nonatomic, strong) NSArray *keyArray;
@property (nonatomic, strong) NSMutableArray *cityArray;

@property (strong, nonatomic) CLLocationManager* locationManager;

@property (nonatomic, strong) UITableView *resultTableView;
@property (nonatomic, strong) NSMutableArray *resultArray;

@end

@implementation JGDCitySearchViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:@"http://res.dagolfla.com/download/json/ballCity.json"];
    
    NSError *error;
    NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error1 = nil;
    NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error1];

    self.hotCityArray = [dataDic objectForKey:@"hotList"];
    self.cityDic = [dataDic objectForKey:@"list"];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dic in [dataDic objectForKey:@"list"]) {
        if ([dic objectForKey:@"cName"]) {
            [arr addObject:[dic objectForKey:@"cName"]];
        }
    }
    
    self.keyArray = [ChineseString IndexArray:arr];
    self.cityArray = [ChineseString LetterSortArray:arr];
    
    
    
//    self.keyArray = [self.cityDic allKeys];
//    NSSortDescriptor *sortDes1 = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES]; // 升序
//    self.keyArray = [self.keyArray sortedArrayUsingDescriptors:@[sortDes1]];

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self searchVCSet];
    
    
    // Do any additional setup after loading the view.
}


- (void)searchVCSet{
    
    self.searchTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 * ProportionAdapter, screenWidth, screenHeight - 64 * ProportionAdapter) style:(UITableViewStyleGrouped)];
    self.searchTable.delegate = self;
    self.searchTable.dataSource = self;
    self.searchTable.rowHeight = 50 * ProportionAdapter;
    self.searchTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchTable.backgroundColor = [UIColor whiteColor];
    self.searchTable.tag = 50;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 64 * ProportionAdapter)];
    headView.backgroundColor = [UIColor colorWithHexString:@"#32b14b"];
    
    UITextField *searchTF = [[UITextField alloc] initWithFrame:CGRectMake(10* ProportionAdapter, 25* ProportionAdapter, 300* ProportionAdapter, 30* ProportionAdapter)];
    searchTF.borderStyle = UITextBorderStyleRoundedRect;
    searchTF.placeholder = @"请输入关键字";
    searchTF.font = [UIFont systemFontOfSize:16 * ProportionAdapter];
    [headView addSubview:searchTF];
    searchTF.delegate = self;
    searchTF.returnKeyType = UIReturnKeySearch;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(310* ProportionAdapter, 25* ProportionAdapter, 60* ProportionAdapter, 30* ProportionAdapter)];
    [button setTitle:@"取消" forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(searchAct) forControlEvents:(UIControlEventTouchUpInside)];
    [headView addSubview:button];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(5 * ProportionAdapter, 5, 31 * ProportionAdapter, 17 * ProportionAdapter)];
    imageV.image = [UIImage imageNamed:@"Search-1"];
    searchTF.leftView = imageV;
    searchTF.leftViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:headView];
    
    
    // tableViewHeader
    UIView *tableheaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 260 * ProportionAdapter)];
    tableheaderView.backgroundColor = [UIColor whiteColor];
    UILabel *locatTB = [self lablerect:CGRectMake(10 * ProportionAdapter, 0, 100, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(17 * ProportionAdapter) text:@"定位城市" textAlignment:(NSTextAlignmentLeft)];
    [tableheaderView addSubview:locatTB];
    
    UIImageView *cityIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter,  50 * ProportionAdapter, 12 * ProportionAdapter, 18 * ProportionAdapter)];
    cityIcon.image = [UIImage imageNamed:@"address"];
    [tableheaderView addSubview:cityIcon];

    
//    self.cityLB = [self lablerect:CGRectMake(30 * ProportionAdapter,  45 * ProportionAdapter, 100, 30 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(15 * ProportionAdapter) text:[[NSUserDefaults standardUserDefaults] objectForKey:CITYNAME] textAlignment:(NSTextAlignmentLeft)];
//    [tableheaderView addSubview:self.cityLB];
    
    self.cityBtn = [[UIButton alloc] initWithFrame:CGRectMake(30 * ProportionAdapter,  45 * ProportionAdapter, 200, 30 * ProportionAdapter)];
    [self.cityBtn setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:CITYNAME] forState:(UIControlStateNormal)];
    self.cityBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.cityBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.cityBtn setTitleColor:[UIColor colorWithHexString:@"#313131"] forState:(UIControlStateNormal)];
    [tableheaderView addSubview:self.cityBtn];
    [self.cityBtn addTarget:self action:@selector(cityClickAct:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    UIButton *resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(250 * ProportionAdapter, 45 * ProportionAdapter, 110 * ProportionAdapter, 30 * ProportionAdapter)];
    [resetBtn setTitle:@"重新定位" forState:(UIControlStateNormal)];
    resetBtn.titleLabel.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    [resetBtn setImage:[UIImage imageNamed:@"refresh"] forState:(UIControlStateNormal)];
    [resetBtn setTitleColor:[UIColor colorWithHexString:@"#32b14d"] forState:(UIControlStateNormal)];
    resetBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10 * ProportionAdapter, 0, 0);
    [resetBtn addTarget:self action:@selector(getCurPosition) forControlEvents:(UIControlEventTouchUpInside)];
    [tableheaderView addSubview:resetBtn];

    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 80 * ProportionAdapter, screenWidth, 10 * ProportionAdapter)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [tableheaderView addSubview:lineView];
    self.searchTable.tableHeaderView = tableheaderView;
    
    
    UILabel *hotLB = [self lablerect:CGRectMake(10 * ProportionAdapter, 90 * ProportionAdapter, 100, 50 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(17 * ProportionAdapter) text:@"热门城市" textAlignment:(NSTextAlignmentLeft)];
    [tableheaderView addSubview:hotLB];
    
    
    for (int i = 0; i < [self.hotCityArray count]; i ++) {
        
        UIButton *hotBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 * ProportionAdapter + 125 * (i%3) * ProportionAdapter, i/3 * 40 * ProportionAdapter + 140 * ProportionAdapter, 80 * ProportionAdapter, 25 * ProportionAdapter)];
        hotBtn.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        hotBtn.layer.cornerRadius = 6;
        hotBtn.clipsToBounds = YES;
        hotBtn.tag = 500 + i;
        NSMutableAttributedString *attribStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ (%@)", [self.hotCityArray[i] objectForKey:@"cName"], [self.hotCityArray[i] objectForKey:@"ballCount"]]];
        [attribStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14 * ProportionAdapter] range:NSMakeRange(0, [[self.hotCityArray[i] objectForKey:@"cName"] length])];
        [attribStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#313131"] range:NSMakeRange(0, [[self.hotCityArray[i] objectForKey:@"cName"] length])];
        [attribStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11 * ProportionAdapter] range:NSMakeRange([[self.hotCityArray[i] objectForKey:@"cName"] length] + 1, [[NSString stringWithFormat:@"%@", [self.hotCityArray[i] objectForKey:@"ballCount"]] length] + 2)];
        [attribStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a0a0a0"] range:NSMakeRange([[self.hotCityArray[i] objectForKey:@"cName"] length] + 1, [[NSString stringWithFormat:@"%@", [self.hotCityArray[i] objectForKey:@"ballCount"]] length] + 2)];
        [hotBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 3 * ProportionAdapter, 0)];
        [hotBtn setAttributedTitle:attribStr forState:(UIControlStateNormal)];
        
        [hotBtn addTarget:self action:@selector(cityAct:) forControlEvents:(UIControlEventTouchUpInside)];
        [tableheaderView addSubview:hotBtn];
    }
    
    
    [self.view addSubview:self.searchTable];
}

- (void)cityAct:(UIButton *)btn{

    self.blockAddress([self.hotCityArray[btn.tag - 500] objectForKey:@"cName"]);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchAct{
    [self.navigationController popViewControllerAnimated:YES];
}


- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView.tag == 50) {
        return 25 * ProportionAdapter;
    }else{
        return 0.00001;
    }
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView.tag == 60) {
        return nil;
    }
    
    UILabel *headLB = [self lablerect:CGRectMake(0, 0, screenWidth, 25 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:(14 * ProportionAdapter) text:[NSString stringWithFormat:@"  %@", self.keyArray[section]] textAlignment:(NSTextAlignmentLeft)];
    headLB.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    
    NSString *uppercaseStr = [NSString stringWithFormat:@"  %@", self.keyArray[section]];
    NSMutableAttributedString *mutAtr = [[NSMutableAttributedString alloc] initWithString:uppercaseStr.uppercaseString];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.firstLineHeadIndent = 10 * ProportionAdapter;
    [mutAtr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, mutAtr.length)];
    headLB.attributedText = mutAtr;
    
//    UIView *backView = [[UIView alloc] init];
//    backView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    return headLB;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    if (tableView.tag == 50) {
//        cell.textLabel.text = [self.cityDic objectForKey:self.keyArray[indexPath.section]][indexPath.row];
        cell.textLabel.text = self.cityArray[indexPath.section][indexPath.row];
    }else{
        cell.textLabel.text = self.resultArray[indexPath.row];
    }

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5 * ProportionAdapter, screenWidth, 0.5 * ProportionAdapter)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [cell.contentView addSubview:lineView];
    cell.textLabel.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 50) {
//        return [[self.cityDic objectForKey:self.keyArray[section]] count];
        return [self.cityArray[section] count];
    }else{
        return [self.resultArray count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView.tag == 50) {
        return [self.keyArray count];
    }else{
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 50) {
        self.blockAddress(self.cityArray[indexPath.section][indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        self.blockAddress(self.resultArray[indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)cityClickAct:(UIButton *)btn{
    self.blockAddress(btn.titleLabel.text);
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    //http://res.dagolfla.com/download/json/ballCity.json       未分词 json
    //http://res.dagolfla.com/download/json/ballCitySeg.json    已分词 json
    //    NSURL *url = [NSURL URLWithString:@"http://res.dagolfla.com/download/json/ballCitySeg.json"];
    NSURL *url = [NSURL URLWithString:@"http://res.dagolfla.com/download/json/ballCity.json"];

    NSError *error;
    NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error1 = nil;
    NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error1];

    for (NSDictionary *dic in [dataDic objectForKey:@"list"]) {
        if ([[dic objectForKey:@"cName"] containsString:textField.text]) {
            [self.resultArray addObject:[dic objectForKey:@"cName"]];
        }
        
    }
    
    
    [self.view addSubview:self.resultTableView];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@""] && [textField.text length] == 1) {
        // 全删
        [self.resultTableView removeFromSuperview];
        [self.searchTable reloadData];
    }
    return YES;
}


- (UITableView *)resultTableView{
    if (!_resultTableView) {
        _resultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 * ProportionAdapter, screenWidth, screenHeight - 64 * ProportionAdapter) style:(UITableViewStyleGrouped)];
        _resultTableView.delegate = self;
        _resultTableView.dataSource = self;
        _resultTableView.tag = 60;
        _resultTableView.rowHeight = 50 * ProportionAdapter;
        
    }
    return _resultTableView;
}




// 右侧索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //  改变索引颜色
    self.searchTable.sectionIndexColor = [UIColor colorWithRed:0.36f green:0.66f blue:0.31f alpha:1.00f];
    self.searchTable.sectionIndexBackgroundColor = [UIColor whiteColor];
    
    if (tableView.tag == 50) {
        return self.keyArray;
    }else{
        return nil;
    }
//    NSInteger number = [self.keyArray count];
//    return [self.keyArray subarrayWithRange:NSMakeRange(0, number)];
}

//点击索引跳转到相应位置
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    
    if (!self.keyArray[index]) {
        
        return 0;
        
    }else{
        
        [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        
        return index;
    }
}



#pragma mark --定位方法

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
    
    UIActivityIndicatorView *cityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(250 * ProportionAdapter, 45 * ProportionAdapter, 30 * ProportionAdapter, 30 * ProportionAdapter)];
    [self.searchTable addSubview:cityView];
    cityView.backgroundColor = [UIColor whiteColor];
    cityView.color = [UIColor grayColor];
    [cityView startAnimating];
    
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
             //获取城市
             NSString *city = placemark.locality;
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             if ([city containsString:@"市"] || [city containsString:@"省"]) {
                 city = [city substringToIndex:[city length] - 1];
             }

//             self.cityLB.text = city;
             [self.cityBtn setTitle:city forState:(UIControlStateNormal)];
             [user setObject:city forKey:CITYNAME];
             [user synchronize];

         } else {
             
         }
         [cityView stopAnimating];
         [cityView removeFromSuperview];
     }];
    
    
    [user setObject:[NSNumber numberWithFloat:currLocation.coordinate.latitude] forKey:BDMAPLAT];//纬度
    [user setObject:[NSNumber numberWithFloat:currLocation.coordinate.longitude] forKey:BDMAPLNG];//经度
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
    
    //定位失败后也下载数据
}


- (NSMutableArray *)hotCityArray{
    if (!_hotCityArray) {
        _hotCityArray = [[NSMutableArray alloc] init];
    }
    return _hotCityArray;
}

- (NSMutableDictionary *)cityDic{
    if (!_cityDic) {
        _cityDic = [[NSMutableDictionary alloc] init];
    }
    return _cityDic;
}

- (NSArray *)keyArray{
    if (!_keyArray) {
        _keyArray = [[NSArray alloc] init];
    }
    return _keyArray;
}

- (NSMutableArray *)resultArray{
    if (!_resultArray) {
        _resultArray = [[NSMutableArray alloc] init];
    }
    return _resultArray;
}

- (NSMutableArray *)cityArray{
    if (!_cityArray) {
        _cityArray = [[NSMutableArray alloc] init];
    }
    return _cityArray;
}

//  封装cell方法
- (UILabel *)lablerect:(CGRect)rect labelColor:(UIColor *)color labelFont:(NSInteger)font text:(NSString *)text textAlignment:(NSTextAlignment )alignment{
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = alignment;
    label.frame = rect;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font];
    label.text = text;
    return label;
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
