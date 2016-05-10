//
//  TeamGaoActiveController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/9.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "TeamGaoActiveController.h"

#import "TeamActiveTableViewCell.h"
//活动详情
#import "TeamActiveDeController.h"
#import "TeamActivePostController.h"

#import "PostDataRequest.h"
#import "Helper.h"
#import "MJRefresh.h"
#import "MJDIYHeader.h"
#import "MJDIYBackFooter.h"

#import "TeamActiveModel.h"


@interface TeamGaoActiveController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _dataArray;
    NSMutableArray* _dataLastArr;
    
    NSInteger _page;
    
    
}
@end

@implementation TeamGaoActiveController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"高球活动";
    _page = 1;
    _dataArray = [[NSMutableArray alloc]init];
    _dataLastArr = [[NSMutableArray alloc]init];
    
    if ([_teamStand integerValue] == 1 || [_teamStand integerValue] == 2 || [_teamStand integerValue] == 4) {
        [self createFabu];
    }
    
    [self uiConfig];
    
    
}

-(void)createFabu
{
    UIView* viewFabu = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44*ScreenWidth/375)];
    viewFabu.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:viewFabu];
    
    UIButton* viewBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    viewBtn.backgroundColor = [UIColor clearColor];
    viewBtn.frame = CGRectMake(0, 0, viewFabu.frame.size.width, viewFabu.frame.size.height);
    [viewFabu addSubview:viewBtn];
    [viewBtn addTarget:self action:@selector(teamActiveClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton* btnJia = [UIButton buttonWithType:UIButtonTypeSystem];
    btnJia.frame = CGRectMake(13*ScreenWidth/375, 10*ScreenWidth/375, 20*ScreenWidth/375, 20*ScreenWidth/375);
    [btnJia setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnJia.titleLabel.font = [UIFont systemFontOfSize:22*ScreenWidth/375];
    btnJia.backgroundColor = [UIColor clearColor];
    [viewBtn addSubview:btnJia];
    [btnJia setTitle:@"+" forState:UIControlStateNormal];
    [btnJia addTarget:self action:@selector(teamActiveClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton* btnText = [UIButton buttonWithType:UIButtonTypeSystem];
    btnText.frame = CGRectMake(35*ScreenWidth/375, 7*ScreenWidth/375, 60*ScreenWidth/375, 30*ScreenWidth/375);
    [btnText setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnText.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    btnText.backgroundColor = [UIColor clearColor];
    [viewBtn addSubview:btnText];
    [btnText setTitle:@"发布活动" forState:UIControlStateNormal];
    [btnText addTarget:self action:@selector(teamActiveClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* imgvJian = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 20*ScreenWidth/375, 14*ScreenWidth/375, 12*ScreenWidth/375, 16*ScreenWidth/375)];
    imgvJian.image = [UIImage imageNamed:@"left_jt"];
    [viewBtn addSubview:imgvJian];

}
-(void)teamActiveClick
{
    TeamActivePostController* actVc = [[TeamActivePostController alloc]init];
    actVc.teamId = _teamId;
    [self.navigationController pushViewController:actVc animated:YES];
}

-(void)uiConfig
{
    if ([_teamStand integerValue] == 1 || [_teamStand integerValue] == 2 || [_teamStand integerValue] == 4) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44*ScreenWidth/375, ScreenWidth, ScreenHeight-15*ScreenWidth/375-44*ScreenWidth/375) style:UITableViewStylePlain];
    }
    else{
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-15*ScreenWidth/375) style:UITableViewStylePlain];
    }
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [_tableView registerClass:[TeamActiveTableViewCell class] forCellReuseIdentifier:@"TeamActiveTableViewCell"];
    
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRereshing)];
    _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRereshing)];
    [_tableView.header beginRefreshing];
}

#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    
//    //NSLog(@"%@",_teamId);
    [[PostDataRequest sharedInstance] postDataRequest:@"TTeamActivity/queryByList.do" parameter:@{@"page":[NSNumber numberWithInt:page],@"rows":@10,@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"team_Id":_teamId} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        ////NSLog(@"%@",dict);
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (page == 1)
            {
                [_dataArray removeAllObjects];
                [_dataLastArr removeAllObjects];
            }
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                if ([[dataDict objectForKey:@"isendTime"] integerValue] != 3) {
                    for (NSDictionary *dict0 in [dataDict objectForKey:@"activityList"]) {
                        TeamActiveModel *model = [[TeamActiveModel alloc] init];
                        [model setValuesForKeysWithDictionary:dict0];
                        [_dataArray addObject:model];
                    }
                }else{
                    for (NSDictionary *dict0 in [dataDict objectForKey:@"activityList"]) {
                        TeamActiveModel *model = [[TeamActiveModel alloc] init];
                        [model setValuesForKeysWithDictionary:dict0];
                        [_dataLastArr addObject:model];
                    }
                }
            }
            _page ++;
            [_tableView reloadData];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
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
- (void)headRereshing
{
    _page = 1;
    [self downLoadData:_page isReshing:YES];
}

- (void)footRereshing
{
    [self downLoadData:_page isReshing:NO];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100*ScreenWidth/375;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _dataArray.count;
    }
    else
    {
        return _dataLastArr.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    else
    {
        if (_dataLastArr.count != 0) {
            return 30*ScreenWidth/375;
        }
        else{
            return 0;
        }
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30*ScreenWidth/375)];
        view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
        
//        93 5
        UIImageView* imgvLeft = [[UIImageView alloc]initWithFrame:CGRectMake(0, 12*ScreenWidth/375, 93*ScreenWidth/375, 6*ScreenWidth/375)];
        imgvLeft.image = [UIImage imageNamed:@"left_line"];
        [view addSubview:imgvLeft];
        
        UIImageView* imgvRight = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-93*ScreenWidth/375, 12*ScreenWidth/375, 93*ScreenWidth/375, 6*ScreenWidth/375)];
        imgvRight.image = [UIImage imageNamed:@"right_line"];
        [view addSubview:imgvRight];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30*ScreenWidth/375)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"以下为已经结束的球队活动";
        [view addSubview:label];
        label.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        
        
        return view;
    }
    return nil;
}

//指定有多少个分区(Section)，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ////NSLog(@"%@",_dataArray);
    if (indexPath.section == 0) {
        TeamActiveTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TeamActiveTableViewCell" forIndexPath:indexPath];
        [cell showData:_dataArray[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        TeamActiveTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TeamActiveTableViewCell" forIndexPath:indexPath];
        [cell showData:_dataLastArr[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeamActiveDeController* teamVc = [[TeamActiveDeController alloc]init];
    if (indexPath.section == 0) {
        teamVc.teamActivityId = [_dataArray[indexPath.row] teamActivityId];
        teamVc.teamStand = _teamStand;
    }
    else
    {
        teamVc.teamActivityId = [_dataLastArr[indexPath.row] teamActivityId];
        teamVc.teamStand = _teamStand;
    }
    [self.navigationController pushViewController:teamVc animated:YES];
}
@end
