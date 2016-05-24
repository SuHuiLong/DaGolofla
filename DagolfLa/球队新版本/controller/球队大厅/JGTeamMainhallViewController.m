//
//  JGTeamMainhallViewController.m
//  DagolfLa
//
//  Created by 東 on 16/5/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamMainhallViewController.h"
#import "MJRefreshComponent.h"
#import "MJRefreshConst.h"
#import "UIView+MJExtension.h"
#import "UIScrollView+MJExtension.h"
#import "UIScrollView+MJRefresh.h"
#import "JGTeamChannelTableViewCell.h"
#import "JGTeamChannelTableView.h"
#import <CoreLocation/CoreLocation.h>
#import "JGTeamDetail.h"
#import "JGTeamDetailViewController.h"

@interface JGTeamMainhallViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating,CLLocationManagerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *searchArray;
@property (nonatomic, strong) NSMutableDictionary *paraDic;
@property (assign, nonatomic) int page;
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) NSMutableArray *modelArray;

@end


@implementation JGTeamMainhallViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.searchController.searchBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        self.searchController.searchBar.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"球队大厅";
    _tableView = [[JGTeamChannelTableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
    self.view = _tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 83 * ScreenWidth/320;
    _tableView.scrollEnabled = NO;
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.searchBar.barTintColor = [UIColor orangeColor];
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    self.searchController.searchBar.tintColor = [UIColor colorWithRed:0.36f green:0.66f blue:0.31f alpha:1.00f];
    self.searchController.searchBar.placeholder = @"输入球队昵称搜索";
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    [self getData];
    // Do any additional setup after loading the view.
}


- (void)getData{
    
    [[JsonHttp jsonHttp] httpRequest:@"team/getTeamList" JsonKey:nil withData:self.paraDic requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"error");
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        self.modelArray = [data objectForKey:@"teamList"];
        [self.tableView reloadData];
//        for (NSDictionary *Dic in dataArray) {
//            JGTeamDetail *model = [[JGTeamDetail alloc] init];
//            [model setValuesForKeysWithDictionary:Dic];
//            [self.modelArray addObject:model];
//        }
    }];
    
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currLocation = [locations lastObject];
    //NSLog(@"经度=%f 纬度=%f 高度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [self.paraDic setObject:[NSNumber numberWithFloat:currLocation.coordinate.latitude] forKey:@"likeName"];
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


//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchController.active) {
        return [self.searchArray count];
    }else{
        self.tableView.footer = nil;
        return [self.modelArray count];
    }
}

//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    JGTeamChannelTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (!self.searchController.active || [self.searchArray count] == 0) {
        
        cell.nameLabel.text = [self.modelArray[indexPath.row] objectForKey:@"name"];
        cell.adressLabel.text = [self.modelArray[indexPath.row] objectForKey:@"crtyName"];
        cell.describLabel.text = [self.modelArray[indexPath.row] objectForKey:@"info"];;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        // TEST
        cell.nameLabel.text = [self.modelArray[indexPath.row] objectForKey:@"name"];
        cell.adressLabel.text = [self.modelArray[indexPath.row] objectForKey:@"crtyName"];
        cell.describLabel.text = [self.modelArray[indexPath.row] objectForKey:@"info"];;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}


#pragma mark ------搜索框回调方法

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self.searchArray removeAllObjects];
    
    
    NSString *searchString = [self.searchController.searchBar text];
    //    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    _page = 1;
    [self.paraDic setObject:[NSNumber numberWithInt:_page] forKey:@"offset"];
    [self.paraDic setObject:searchString forKey:@"likeName"];
//    [self.paraDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"] forKey:@"userId"];
    if ([searchString length] > 0) {
        [[PostDataRequest sharedInstance] postDataRequest:@"user/searchTuser.do" parameter:self.paraDic success:^(id respondsData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            
            if ([[dict objectForKey:@"success"] boolValue]) {
//                NSArray *arra = [dict objectForKey:@"rows"];
//                
//                for (NSDictionary *dic in arra) {
//                    NewFriendModel *myModel = [[NewFriendModel alloc] init];
//                    [myModel setValuesForKeysWithDictionary:dic];
//                    [self.searchArray addObject:myModel];
//                }
//                
//                if ([self.searchArray count] < _page * 10) {
//                    self.tableView.footer = nil;
//                    
//                }else{
//                    self.tableView.footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(refrenshing1)];
//                }
                
                [self.tableView reloadData];
            }else {
                //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                //                [alert show];
            }
            
        } failed:^(NSError *error) {
            
            
        }];
        self.tableView.scrollEnabled = YES;
    }else{
        self.tableView.scrollEnabled = NO;
    }
    
    //    if (self.searchList!= nil) {
    //        [self.searchList removeAllObjects];
    //    }
    //过滤数据
    //    self.searchList= [NSMutableArray arrayWithArray:[_dataList filteredArrayUsingPredicate:preicate]];
    //刷新表格
    [self.searchArray removeAllObjects];
    [self.tableView reloadData];
}


- (NSMutableArray *)searchArray{
    if (!_searchArray) {
        _searchArray = [NSMutableArray arrayWithObjects:@"123", @"123", nil];
    }
    return _searchArray;
}

- (NSMutableDictionary *)paraDic{
    if (!_paraDic) {
        _paraDic = [[NSMutableDictionary alloc] init];
    }
    return _paraDic;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JGTeamDetailViewController *teamDetailVC = [[JGTeamDetailViewController alloc] init];
    teamDetailVC.teamDetailDic = self.modelArray[indexPath.row];
    [self.navigationController  pushViewController:teamDetailVC animated:YES];
    
//    if (self.searchController.active == NO) {
//        if (indexPath.row == 1) {
//            RecomeFriendViewController* reVc = [[RecomeFriendViewController alloc]init];
//            [self.navigationController pushViewController:reVc animated:YES];
//        }
//    }
//    else
//    {
//        PersonHomeController *selfVC = [[PersonHomeController alloc] init];
//        MyattenModel *myModel = self.searchArray[indexPath.row];
//        selfVC.strMoodId = myModel.userId;
//        [self.navigationController pushViewController:selfVC animated:YES];
//    }
}


- (void)refrenshing1{
    _page ++;
    [self.paraDic setObject:[NSNumber numberWithInt:_page] forKey:@"page"];
    [[PostDataRequest sharedInstance] postDataRequest:@"user/searchTuser.do" parameter:self.paraDic success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        
//        if ([[dict objectForKey:@"success"] boolValue]) {
//            NSArray *arra = [dict objectForKey:@"rows"];
//            
//            for (NSDictionary *dic in arra) {
//                NewFriendModel *myModel = [[NewFriendModel alloc] init];
//                [myModel setValuesForKeysWithDictionary:dic];
//                [self.searchArray addObject:myModel];
//            }
//            
//            [self.tableView reloadData];
//        }else {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//        [self.tableView.footer endRefreshing];
    } failed:^(NSError *error) {
        
    }];
    
}

- (NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray = [[NSMutableArray alloc] init];
    }
    return _modelArray;
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
