//
//  ZanNumViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/5.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//
#import "MJRefreshFooter.h"
#import "MJRefreshComponent.h"
#import "MJRefreshConst.h"
#import "UIView+MJExtension.h"
#import "ZanNumViewController.h"
#import "ZanNumTableViewCell.h"
#import "UserAssistModel.h"

#import "PersonHomeController.h"

@interface ZanNumViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int _page;
    BOOL _isFirstInto;
}

@property (nonatomic, strong)NSMutableArray* dataArray;
@property (nonatomic, strong)NSMutableDictionary *paraDic;
@property (nonatomic, strong)UITableView* tableView;

@end

@implementation ZanNumViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    if (_isFirstInto != YES) {
        return;
    }
    _isFirstInto = NO;
    _page = 1;
    [self.paraDic setObject:[NSNumber numberWithInt:_page] forKey:@"page"];
    [self.paraDic setObject:@10 forKey:@"rows"];
    [self.paraDic setObject:_ymModel.userMoodId forKey:@"mId"];
    
    NSString *str;
    if (self.likeOrShar == 667) {
        str = @"userAssist/queryPage.do";
    }else{
        str = @"userForward/queryPage.do";
    }
    
    [[PostDataRequest sharedInstance] postDataRequest:str parameter:self.paraDic success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        [self.dataArray removeAllObjects];
        if ([[dict objectForKey:@"success"] boolValue]) {
            NSArray *arra = [dict objectForKey:@"rows"];
            
            for (NSDictionary *dic in arra) {
                UserAssistModel *asModel = [[UserAssistModel alloc] init];
                [asModel setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:asModel];
            }
            
            [self.tableView reloadData];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        [self.tableView.mj_footer endRefreshing];
    } failed:^(NSError *error) {
        
    }];

    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isFirstInto = YES;
    if (_likeOrShar == 667) {
        self.title = [NSString stringWithFormat:@"%@赞",_ymModel.assistCount];
    }else{
        self.title = [NSString stringWithFormat:@"%@分享",_ymModel.forwardNum];
    }
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    

    //    [self prepareData];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 15 * ScreenWidth/375)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZanNumTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZanNumTableViewCell"];

    
    
    if ([(_likeOrShar == 667 ? _ymModel.assistCount : _ymModel.forwardNum) intValue] > 10) {
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refrenshing1)];
    }
    
}

-(void)prepareData
{
    self.dataArray = [[NSMutableArray alloc]init];
    if (_likeOrShar == 667) {
        for (NSDictionary *dic in _ymModel.tUserAssists) {
            UserAssistModel *userAssis = [[UserAssistModel alloc] init];
            [userAssis setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:userAssis];
        }
    }else{
        for (NSDictionary *dic in _ymModel.userForwards) {
            UserAssistModel *userAssis = [[UserAssistModel alloc] init];
            [userAssis setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:userAssis];
        }
 
    }
 
}


// 上拉刷新:page  页码
- (void)refrenshing1{
    _page ++;
    [self.paraDic setObject:[NSNumber numberWithInt:_page] forKey:@"page"];
    [self.paraDic setObject:@10 forKey:@"rows"];
    [self.paraDic setObject:_ymModel.userMoodId forKey:@"mId"];
    
    NSString *str;
    if (self.likeOrShar == 667) {
        str = @"userAssist/queryPage.do";
    }else{
        str = @"userForward/queryPage.do";
    }
    
    [[PostDataRequest sharedInstance] postDataRequest:str parameter:self.paraDic success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        
        if ([[dict objectForKey:@"success"] boolValue]) {
            NSArray *arra = [dict objectForKey:@"rows"];
            
            for (NSDictionary *dic in arra) {
                UserAssistModel *asModel = [[UserAssistModel alloc] init];
                [asModel setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:asModel];
            }
            
            [self.tableView reloadData];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        [self.tableView.mj_footer endRefreshing];
    } failed:^(NSError *error) {
        
    }];
    
    
}


#pragma MARK -- tableview
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60*ScreenWidth/375;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
//    if (_page > 1) {
//        return [self.dataArray count];
//    }else{
//        if (_likeOrShar == 667) {
//            return _ymModel.tUserAssists.count;
//        }else{
//            return _ymModel.userForwards.count;
//        }
//    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZanNumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZanNumTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.dataArray.count > 0) {
        [cell setUserAssisModel:self.dataArray[indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    PersonHomeController* selfVc = [[PersonHomeController alloc]init];
    UserAssistModel *newA = self.dataArray[indexPath.row];
    selfVc.strMoodId = newA.uId;;
//    selfVc.strMoodId =  [_ymModel.tUserAssists[indexPath.row] objectForKey:@"uId"];
//    selfVc.messType = @2;
    [self.navigationController pushViewController:selfVc animated:YES];

}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableDictionary *)paraDic{
    if (!_paraDic) {
        _paraDic = [[NSMutableDictionary alloc] init];
    }
    return _paraDic;
}
@end
