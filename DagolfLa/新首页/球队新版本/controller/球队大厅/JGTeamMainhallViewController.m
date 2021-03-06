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
#import "JGDNewTeamDetailViewController.h"
//#import "JGTeamMemberORManagerViewController.h"
//#import "JGNewCreateTeamTableViewController.h"


#import "UITool.h"

#import "JGLViewCityChoose.h"

#import "JGDCreatTeamViewController.h"
#import "JGDNewTeamDetailViewController.h"


@interface JGTeamMainhallViewController ()<UITableViewDelegate,UITableViewDataSource,UIBarPositioningDelegate,UITextFieldDelegate>
{
    UITextField *_textField;
    NSString* _strSearch;//搜索的字符串
    
    
    // NSString* _strProvince;//省份的字符串
    //    UILabel* _labelCity;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *searchArray;
//@property (nonatomic, strong) NSMutableDictionary *paraDic;
@property (assign, nonatomic) NSInteger page;
//@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) NSMutableArray *modelArray; //数据源
@property (strong, nonatomic) UILabel *labelCity; //数据源
@property (strong, nonatomic) JGLViewCityChoose* viewCityChoose;
@end


@implementation JGTeamMainhallViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _viewCityChoose.hidden = YES;
    
}

//自定义searchbar
#pragma mark --自定义searchbar
-(void)createSeachBar{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    view.backgroundColor = [UITool colorWithHexString:@"d9d9d9" alpha:1];
    [self.view addSubview:view];
    
    
    /**
     点击按钮
     */
    UIButton *btnCity = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCity.frame = CGRectMake(10*ScreenWidth/375, 5, 70*ScreenWidth/375, 34);
    [btnCity setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCity addTarget:self action:@selector(cityShowCLick) forControlEvents:UIControlEventTouchUpInside];
    btnCity.backgroundColor = [UIColor whiteColor];
    btnCity.layer.masksToBounds = YES;
    btnCity.layer.cornerRadius = 5;
    [view addSubview:btnCity];
    
    _labelCity = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50*ScreenWidth/375, 34*ScreenWidth/375)];
    _labelCity.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    _labelCity.textAlignment = NSTextAlignmentCenter;
    [btnCity addSubview:_labelCity];
    
    //默认城市名称
    //    _strProvince = [[NSUserDefaults standardUserDefaults]objectForKey:CITYNAME];
    
    if (![Helper isBlankString:_strProvince]) {
        _labelCity.text = _strProvince;
        _textField.text = _strProvince;
    }else{
        _labelCity.text = [[NSUserDefaults standardUserDefaults] objectForKey:CITYNAME];
        _textField.text = @"";
    }
    
    
    UIImageView* imgvCity = [[UIImageView alloc]initWithFrame:CGRectMake(54*ScreenWidth/375, 5, 12*ScreenWidth/375, 24)];
    imgvCity.image = [UIImage imageNamed:@"xl"];
    [btnCity addSubview:imgvCity];
    
    UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(50*ScreenWidth/375, 0, 1*ScreenWidth/375, 34*ScreenWidth/375)];
    viewLine.backgroundColor = [UITool colorWithHexString:@"d9d9d9" alpha:1];
    [btnCity addSubview:viewLine];
    
    
    
    /**
     搜索框
     */
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(85*ScreenWidth/375, 5, ScreenWidth-155*ScreenWidth/375, 34)];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.layer.cornerRadius=5;
    imageView.tag=88;
    imageView.userInteractionEnabled=YES;
    imageView.clipsToBounds=YES;
    [view addSubview:imageView];
    
    UIImageView *imageView2=[[UIImageView alloc] init];
    imageView2.image=[UIImage imageNamed:@"search"];
    imageView2.frame=CGRectMake(10*ScreenWidth/375, 9, 16, 16);
    [imageView addSubview:imageView2];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(30*ScreenWidth/375, 0, ScreenWidth-115*ScreenWidth/375, 34)];
    _textField.textColor=[UIColor lightGrayColor];
    _textField.tag=888;
    _textField.placeholder=@"请输入搜索信息";
    _textField.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    [imageView addSubview:_textField];
    _textField.delegate = self;
    
    UIButton *SeachButton=[UIButton buttonWithType:UIButtonTypeCustom];
    SeachButton.frame=CGRectMake(ScreenWidth-60*ScreenWidth/375, 5, 60*ScreenWidth/375, 34);
    [SeachButton setTitle:@"搜索" forState:UIControlStateNormal];
    SeachButton.titleLabel.font = [UIFont systemFontOfSize:16*ScreenWidth/375];
    [SeachButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [SeachButton addTarget:self action:@selector(searchBarSearchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:SeachButton];
}
#pragma  mark --textfield
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _viewCityChoose.hidden = YES;
    return YES;
}


#pragma mark --城市选择view的点击事件
-(void)cityShowCLick
{
    if (_viewCityChoose) {
        if (_viewCityChoose.hidden == YES) {
            _viewCityChoose.hidden = NO;
            __weak JGTeamMainhallViewController* weakSelf = self;
            _viewCityChoose.blockStrPro = ^(NSString* strPro){
                _strProvince = strPro;
                //        weakSelf.text = strPro;
                weakSelf.labelCity.text = strPro;
                weakSelf.tableView.mj_header=[MJRefreshHeader headerWithRefreshingTarget:weakSelf refreshingAction:@selector(headRereshing)];
                [weakSelf.tableView.mj_header beginRefreshing];
                
            };
        }
        else{
            _viewCityChoose.hidden = YES;
        }
    } else {
        [self createBtnView];
    }
}

-(void)createBtnView
{
    _viewCityChoose = [[JGLViewCityChoose alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 44, ScreenWidth-20*ProportionAdapter, 144*ProportionAdapter)];
    
    if (![Helper isBlankString:_strProvince]) {
        _viewCityChoose.strProVince = _strProvince;
        [_viewCityChoose initwithStr:_strProvince];
    }else{
        _viewCityChoose.strProVince = [[NSUserDefaults standardUserDefaults] objectForKey:CITYNAME];
        [_viewCityChoose initwithStr:_strProvince];
    }
    __weak JGTeamMainhallViewController* weakSelf = self;
    _viewCityChoose.blockStrPro = ^(NSString* strPro){
        _strProvince = strPro;
        //        weakSelf.text = strPro;
        weakSelf.labelCity.text = strPro;
        weakSelf.tableView.mj_header=[MJRefreshHeader headerWithRefreshingTarget:weakSelf refreshingAction:@selector(headRereshing)];
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [self.view addSubview:_viewCityChoose];
}

#pragma mark --搜索按钮点击事件
-(void)searchBarSearchButtonClick{
    [self.searchArray removeAllObjects];
    [self.view endEditing:YES];
    _viewCityChoose.hidden = YES;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_textField.text forKey:@"likeName"];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    _strProvince = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults]objectForKey:CITYNAME]];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"创建球队" style:(UIBarButtonItemStylePlain) target:self action:@selector(creatTeam)];
    bar.tintColor = [UIColor whiteColor];
    [bar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15 * ProportionAdapter], NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = bar;
    _page = 0;
    self.title = @"搜索球队";
    _tableView = [[JGTeamChannelTableView alloc] initWithFrame:CGRectMake(0, 44, screenWidth, screenHeight-90 * ProportionAdapter) style:(UITableViewStylePlain)];
    //    _tableView = [[JGTeamChannelTableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 40)];
    _tableView.separatorStyle = UITableViewCellAccessoryDisclosureIndicator;
    
    _tableView.mj_header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    _tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    [_tableView.mj_header beginRefreshing];
    //    self.view = _tableView;
    [self.view addSubview:_tableView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    //    [self getCurPosition];
    [self createSeachBar];
    
    _tableView.rowHeight = 80 * ScreenWidth/320;
    
}

//创建球队
- (void)creatTeam{
    _viewCityChoose.hidden = YES;
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    JGDCreatTeamViewController *createVC = [[JGDCreatTeamViewController alloc] init];
    
    if ([user objectForKey:@"cacheCreatTeamDic"]) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"是否继续上次编辑" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [user setObject:0 forKey:@"cacheCreatTeamDic"];
            
            [self.navigationController pushViewController:createVC animated:YES];
        }];
        
        UIAlertAction* action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            createVC.detailDic = [[user objectForKey:@"cacheCreatTeamDic"] mutableCopy];
            
            [self.navigationController pushViewController:createVC animated:YES];
        }];
        
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        [self.navigationController pushViewController:createVC animated:YES];
    }
    
    
    
    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    //
    //    if ([user objectForKey:@"cacheCreatTeamDic"]) {
    //        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"是否继续上次编辑" preferredStyle:UIAlertControllerStyleAlert];
    //
    //        UIAlertAction *action1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //            [user setObject:0 forKey:@"cacheCreatTeamDic"];
    //            JGNewCreateTeamTableViewController *creatteamVc = [[JGNewCreateTeamTableViewController alloc] init];
    //            [self.navigationController pushViewController:creatteamVc animated:YES];
    //        }];
    //        UIAlertAction* action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //            JGNewCreateTeamTableViewController *creatteamVc = [[JGNewCreateTeamTableViewController alloc] init];
    //            creatteamVc.detailDic = [user objectForKey:@"cacheCreatTeamDic"];
    //            creatteamVc.titleField.text = [[user objectForKey:@"cacheCreatTeamDic"] objectForKey:@"name"];
    //
    //            [self.navigationController pushViewController:creatteamVc animated:YES];
    //        }];
    //
    //        [alert addAction:action1];
    //        [alert addAction:action2];
    //        [self presentViewController:alert animated:YES completion:nil];
    //
    //    }else{
    //        JGNewCreateTeamTableViewController *creatteamVc = [[JGNewCreateTeamTableViewController alloc] init];
    //        [self.navigationController pushViewController:creatteamVc animated:YES];
    //    }
    
    
}

// 刷新
- (void)headRereshing
{
    _page = 0;
    [self downLoadData:_page isReshing:YES];
    
}

- (void)footRereshing
{
    [self downLoadData:_page isReshing:NO];
}

#pragma mark - 下载数据
- (void)downLoadData:(NSInteger)page isReshing:(BOOL)isReshing{
    _viewCityChoose.hidden = YES;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userKey"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    if ([user objectForKey:BDMAPLAT]) {
        [dict setObject:[user objectForKey:BDMAPLAT] forKey:@"latitude"];
        [dict setObject:[user objectForKey:BDMAPLNG] forKey:@"longitude"];
    }
    
    if (![Helper isBlankString:_strProvince]) {
        [dict setObject:_strProvince forKey:@"province"];
    }
    
    [dict setObject:[NSNumber numberWithInteger:_page] forKey:@"offset"];
    [[JsonHttp jsonHttp]httpRequest:@"team/getTeamList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        if (isReshing) {
            [_tableView.mj_header endRefreshing];
        }else {
            [_tableView.mj_footer endRefreshing];
        }
    } completionBlock:^(id data) {
        if (_page == 0)
        {
            //清除数组数据
            [self.searchArray removeAllObjects];
            [self.modelArray removeAllObjects];
        }
        if ([data objectForKey:@"teamList"]) {
            [self.modelArray addObjectsFromArray:[data objectForKey:@"teamList"]];
            
            _page++;
            [_tableView reloadData];
        }else {
        }
        [_tableView reloadData];
        if (isReshing) {
            [_tableView.mj_header endRefreshing];
        }else {
            [_tableView.mj_footer endRefreshing];
        }
    }];
}


//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (![Helper isBlankString:_textField.text]) {
        if (self.searchArray) {
            return [self.searchArray count];
        }else{
            return 0;
        }
    }else{
        if (self.modelArray) {
            return [self.modelArray count];
        }else{
            return 0;
        }
    }
}

//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JGTeamChannelTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //    if (!self.searchController.active || [self.searchArray count] == 0) {
    // https://imgcache.dagolfla.com/team/%@.jpg@200w_200h_2o
    if (![Helper isBlankString:_textField.text]) {
        NSString *bgUrl = [NSString stringWithFormat:@"https://imgcache.dagolfla.com/team/%@.jpg@200w_200h_2o", [self.searchArray[indexPath.row] objectForKey:@"timeKey"]];
        [[SDImageCache sharedImageCache] removeImageForKey:bgUrl fromDisk:YES withCompletion:nil];
        
        if ([self.searchArray count] != 0) {
            [cell.iconImageV sd_setImageWithURL:[Helper setImageIconUrl:[[self.searchArray[indexPath.row] objectForKey:@"timeKey"] integerValue]] placeholderImage:[UIImage imageNamed:TeamLogoImage]];
            //            cell.nameLabel.text = [self.searchArray[indexPath.row] objectForKey:@"name"];
            cell.nameLabel.text = [NSString stringWithFormat:@"%@ (%@人)",[self.searchArray[indexPath.row] objectForKey:@"name"],[self.searchArray[indexPath.row] objectForKey:@"userSum"]];
            cell.adressLabel.text = [self.searchArray[indexPath.row] objectForKey:@"crtyName"];
            cell.describLabel.text = [self.searchArray[indexPath.row] objectForKey:@"info"];;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        self.tableView.separatorStyle = UITableViewCellAccessoryNone;
        return cell;
    }else{
        // TEST
        NSString *bgUrl = [NSString stringWithFormat:@"https://imgcache.dagolfla.com/team/%@.jpg@200w_200h_2o", [self.modelArray[indexPath.row] objectForKey:@"timeKey"]];
        NSLog(@"%@",[Helper setImageIconUrl:[[self.modelArray[indexPath.row] objectForKey:@"timeKey"] integerValue]]);
        [[SDImageCache sharedImageCache] removeImageForKey:bgUrl fromDisk:YES withCompletion:nil];
        [cell.iconImageV sd_setImageWithURL:[Helper setImageIconUrl:[[self.modelArray[indexPath.row] objectForKey:@"timeKey"] integerValue]] placeholderImage:[UIImage imageNamed:TeamLogoImage]];
        NSLog(@"%@", [Helper setImageIconUrl:[[self.modelArray[indexPath.row] objectForKey:@"timeKey"] integerValue]]);
        
        cell.nameLabel.text = [NSString stringWithFormat:@"%@ (%@)",[self.modelArray[indexPath.row] objectForKey:@"name"],[self.modelArray[indexPath.row] objectForKey:@"userSum"]];
        cell.adressLabel.text = [self.modelArray[indexPath.row] objectForKey:@"crtyName"];
        cell.describLabel.text = [self.modelArray[indexPath.row] objectForKey:@"info"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        self.tableView.separatorStyle = UITableViewCellAccessoryNone;
        
        return cell;
    }
}


#pragma mark ------搜索框回调方法


- (NSMutableArray *)searchArray{
    if (!_searchArray) {
        _searchArray = [[NSMutableArray alloc] init];;
    }
    return _searchArray;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _viewCityChoose.hidden = YES;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (DEFAULF_USERID != nil) {
        [dic setObject:DEFAULF_USERID forKey:@"userKey"];
    }
    if (![Helper isBlankString:_textField.text]) {
        [dic setObject:@([[self.searchArray[indexPath.row] objectForKey:@"timeKey"] integerValue]) forKey:@"teamKey"];
    }else{
        [dic setObject:@([[self.modelArray[indexPath.row] objectForKey:@"timeKey"] integerValue]) forKey:@"teamKey"];
    }
    
    JGDNewTeamDetailViewController *teamDetailVC = [[JGDNewTeamDetailViewController alloc] init];
    teamDetailVC.timeKey = [dic objectForKey:@"teamKey"];
    [self.navigationController pushViewController:teamDetailVC animated:YES];
        
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
