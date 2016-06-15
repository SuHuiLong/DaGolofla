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
#import "JGNotTeamMemberDetailViewController.h"
#import "JGTeamMemberORManagerViewController.h"
#import "JGNewCreateTeamTableViewController.h"

#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"

@interface JGTeamMainhallViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating,CLLocationManagerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *searchArray;
@property (nonatomic, strong) NSMutableDictionary *paraDic;
@property (assign, nonatomic) NSInteger page;
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) NSMutableArray *modelArray; //数据源

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

    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"创建球队" style:(UIBarButtonItemStylePlain) target:self action:@selector(creatTeam)];
    bar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = bar;
    _page = 0;
    self.title = @"球队大厅";
    _tableView = [[JGTeamChannelTableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
    _tableView.separatorStyle = UITableViewCellAccessoryDisclosureIndicator;

    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    [_tableView.header beginRefreshing];
    self.view = _tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 80 * ScreenWidth/320;
//    _tableView.scrollEnabled = NO;
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.searchBar.barTintColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    self.searchController.searchBar.tintColor = [UIColor colorWithRed:0.36f green:0.66f blue:0.31f alpha:1.00f];
    self.searchController.searchBar.placeholder = @"输入球队昵称搜索";
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
//    [self getData];
    // Do any additional setup after loading the view.
}


- (void)getData{
    
    [[JsonHttp jsonHttp] httpRequest:@"team/getTeamList" JsonKey:nil withData:self.paraDic requestMethod:@"GET" failedBlock:^(id errType) {
        NSLog(@"error");
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        self.modelArray = [data objectForKey:@"teamList"];
        [self.tableView reloadData];

    }];
    
}

- (void)creatTeam{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    
    
    if ([user objectForKey:@"cacheCreatTeamDic"]) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"是否继续上次编辑" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [user setObject:0 forKey:@"cacheCreatTeamDic"];
            JGNewCreateTeamTableViewController *creatteamVc = [[JGNewCreateTeamTableViewController alloc] init];
            [self.navigationController pushViewController:creatteamVc animated:YES];
        }];
        UIAlertAction* action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            JGNewCreateTeamTableViewController *creatteamVc = [[JGNewCreateTeamTableViewController alloc] init];
            creatteamVc.detailDic = [user objectForKey:@"cacheCreatTeamDic"];
            creatteamVc.titleField.text = [[user objectForKey:@"cacheCreatTeamDic"] objectForKey:@"name"];
            
            
            //        @property (nonatomic, retain) UIImageView *imgProfile;
            //        @property (nonatomic, strong)UIButton *headPortraitBtn;//头像
            //        @property (nonatomic, strong)UITextField *titleField;//球队名称输入框
            [self.navigationController pushViewController:creatteamVc animated:YES];
        }];
        
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        JGNewCreateTeamTableViewController *creatteamVc = [[JGNewCreateTeamTableViewController alloc] init];
        [self.navigationController pushViewController:creatteamVc animated:YES];
    }
    
    
}

// 刷新
- (void)headRereshing
{
    [self downLoadData:_page isReshing:YES];
}

- (void)footRereshing
{
    [self downLoadData:_page isReshing:NO];
}

#pragma mark - 下载数据
- (void)downLoadData:(NSInteger)page isReshing:(BOOL)isReshing{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userKey"];
    [dict setObject:[NSNumber numberWithInteger:page] forKey:@"offset"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
    } completionBlock:^(id data) {
        if ([data objectForKey:@"teamList"]) {
            if (page == 0)
            {
                //清除数组数据
                [self.searchArray removeAllObjects];
            }

            [self.modelArray addObjectsFromArray:[data objectForKey:@"teamList"]];
            
            _page++;
            [_tableView reloadData];
        }else {
//            [Helper alertViewWithTitle:@"没有更多球队" withBlock:^(UIAlertController *alertView) {
//                [self presentViewController:alertView animated:YES completion:nil];
//            }];
        }
        [_tableView reloadData];
        if (isReshing) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
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
//        self.tableView.footer = nil;
        return [self.modelArray count];
    }
}

//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    JGTeamChannelTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row == 16) {
        NSLog(@"");
    }

//    if (!self.searchController.active || [self.searchArray count] == 0) {
    if (self.searchController.active) {
    
        if ([self.searchArray count] != 0) {
            [cell.iconImageV sd_setImageWithURL:[Helper setImageIconUrl:[[self.searchArray[indexPath.row] objectForKey:@"timeKey"] integerValue]] placeholderImage:[UIImage imageNamed:TeamLogoImage]];
//            cell.nameLabel.text = [self.searchArray[indexPath.row] objectForKey:@"name"];
            cell.nameLabel.text = [NSString stringWithFormat:@"%@ (%@人)",[self.modelArray[indexPath.row] objectForKey:@"name"],[self.searchArray[indexPath.row] objectForKey:@"userSum"]];
            cell.adressLabel.text = [self.searchArray[indexPath.row] objectForKey:@"crtyName"];
            cell.describLabel.text = [self.searchArray[indexPath.row] objectForKey:@"info"];;
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.tableView.separatorStyle = UITableViewCellAccessoryNone;
        return cell;
    }else{
        // TEST
        [cell.iconImageV sd_setImageWithURL:[Helper setImageIconUrl:[[self.modelArray[indexPath.row] objectForKey:@"timeKey"] integerValue]] placeholderImage:[UIImage imageNamed:TeamLogoImage]];
        
        cell.nameLabel.text = [NSString stringWithFormat:@"%@ (%@)",[self.modelArray[indexPath.row] objectForKey:@"name"],[self.modelArray[indexPath.row] objectForKey:@"userSum"]];
        cell.adressLabel.text = [self.modelArray[indexPath.row] objectForKey:@"crtyName"];
        cell.describLabel.text = [self.modelArray[indexPath.row] objectForKey:@"info"];;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.tableView.separatorStyle = UITableViewCellAccessoryNone;

        return cell;
    }
}


#pragma mark ------搜索框回调方法

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self.searchArray removeAllObjects];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[self.searchController.searchBar text] forKey:@"likeName"];
    [dict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"] forKey:@"userKey"];
//    [dict setObject:[NSNumber numberWithInteger:_page] forKey:@"offset"];
    [dict setObject:@0 forKey:@"offset"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
     
        
    } completionBlock:^(id data) {
        if ([data objectForKey:@"teamList"]) {
                //清除数组数据
                [self.searchArray removeAllObjects];
            
//            [self.modelArray addObjectsFromArray:[data objectForKey:@"teamList"]];
            for (NSDictionary *dic in [data objectForKey:@"teamList"]) {
                [self.searchArray addObject:dic];
            }
            
            _page++;
            [_tableView reloadData];
        }else {
//            [Helper alertViewWithTitle:@"失败" withBlock:^(UIAlertController *alertView) {
//                [self presentViewController:alertView animated:YES completion:nil];
//            }];
        }
        [_tableView reloadData];
    
        
    }];

}


- (NSMutableArray *)searchArray{
    if (!_searchArray) {
        _searchArray = [[NSMutableArray alloc] init];;
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
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userKey"];
    [dic setObject:@([[self.modelArray[indexPath.row] objectForKey:@"timeKey"] integerValue]) forKey:@"teamKey"];

    [[JsonHttp jsonHttp] httpRequest:@"team/getTeamInfo" JsonKey:nil withData:dic requestMethod:@"GET" failedBlock:^(id errType) {

    } completionBlock:^(id data) {

        if (![data objectForKey:@"teamMember"]) {
            JGNotTeamMemberDetailViewController *detailVC = [[JGNotTeamMemberDetailViewController alloc] init];
            if (self.searchController.active) {
                detailVC.detailDic = self.searchArray[indexPath.row];
            }else{
                detailVC.detailDic = self.modelArray[indexPath.row];
            }
            [self.navigationController pushViewController:detailVC animated:YES];
        }else{            
            
            if ([[[data objectForKey:@"teamMember"] objectForKey:@"power"] containsString:@"1005"]){
                JGTeamMemberORManagerViewController *detailVC = [[JGTeamMemberORManagerViewController alloc] init];
                if (self.searchController.active) {
                    detailVC.detailDic = self.searchArray[indexPath.row];
                }else{
                    detailVC.detailDic = self.modelArray[indexPath.row];
                }
                detailVC.isManager = YES;
                [self.navigationController pushViewController:detailVC animated:YES];
            }else{
                JGTeamMemberORManagerViewController *detailVC = [[JGTeamMemberORManagerViewController alloc] init];
                if (self.searchController.active) {
                    detailVC.detailDic = self.searchArray[indexPath.row];
                }else{
                    detailVC.detailDic = self.modelArray[indexPath.row];
                }
                detailVC.isManager = NO;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
            
//            if ([[data objectForKey:@"teamMember"] objectForKey:@"identity"] == 0){
//                
//                JGTeamMemberORManagerViewController *detailVC = [[JGTeamMemberORManagerViewController alloc] init];
//                detailVC.detailDic = [data objectForKey:@"team"];
//                 [self.navigationController pushViewController:detailVC animated:YES];
//            }else{
//                JGTeamMemberORManagerViewController *detailVC = [[JGTeamMemberORManagerViewController alloc] init];
//                detailVC.detailDic = [data objectForKey:@"team"];
//                [self.navigationController pushViewController:detailVC animated:YES];
//            }
        }
    }];
    
//    JGTeamDetailViewController *teamDetailVC = [[JGTeamDetailViewController alloc] init];
//    teamDetailVC.teamDetailDic = self.modelArray[indexPath.row];
//    [self.navigationController  pushViewController:teamDetailVC animated:YES];
    
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
