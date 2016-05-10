//
//  MineTeamController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/5.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "MineTeamController.h"
#import "LazyPageScrollView.h"
#import "MineTeamManCell.h"
#import "MineTeamActiveCell.h"

#import "TeamDeMessViewController.h"
#import "TeamActiveDeController.h"
#import "TeamCreateViewController.h"

#import "ActiveIsUseViewController.h"
#import "MyTeamViewController.h"

#import "TeamModel.h"
#import "TeamActiveModel.h"
#import "MJRefresh.h"
#import "MJDIYHeader.h"
#import "MJDIYBackFooter.h"
#import "PostDataRequest.h"
#import "Helper.h"
@interface MineTeamController ()<LazyPageScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray* _titleArray;
    LazyPageScrollView* _pageView;
    
    UIView* _viewFabu;
    
    UITableView* _tableViewLeft;
    UITableView* _tableViewRight;
    
    UIView* _viewMore;
    BOOL _showView;
    BOOL _isClick;
    
    NSInteger _indexNum;
    
//
    NSMutableArray* _dataLeftArray;
    NSMutableArray* _dataRightArray;
    
    NSInteger _page;
    NSInteger _pageRight;
    
    NSNumber* _numforr;
    
    //用来记录点击的cell
    NSInteger _indexNumber;
}
@end

@implementation MineTeamController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];

}

-(void)backButtonClcik{
//    if (self.popViewNumber == 2) {
//        UIViewController *target=nil;
//        for (UIViewController *vc in self.navigationController.viewControllers) {
//            if ([vc isKindOfClass:[MyTeamViewController class]]) {
//                target=vc;
//            }
//        }
//        if (target) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"Refreshing" object:nil];
//
//            [self.navigationController popToViewController:target animated:YES];
//        }
//    }else{
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 1;
    _pageRight = 1;
    
    self.title = @"我的球队";
    
    
    
    _dataLeftArray = [[NSMutableArray alloc]init];
    _dataRightArray = [[NSMutableArray alloc]init];
    
    [self createPageView];

    
    
}


-(void)createPageView
{
    _titleArray = @[@"球队管理",@"球队活动"];
    _pageView = [[LazyPageScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    [self.view addSubview:_pageView];
    _pageView.delegate=self;
    [_pageView initTab:YES Gap:50*ScreenWidth/375 TabHeight:50*ScreenWidth/375 VerticalDistance:10 BkColor:[UIColor whiteColor]];
    
    
    /**
     左边列表
     
     - returns:
     */
    _tableViewLeft=[[UITableView alloc] init];
    _tableViewLeft.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [_pageView addTab:_titleArray[0] View:_tableViewLeft];
    _tableViewLeft.tag = 200;
    _tableViewLeft.delegate = self;
    _tableViewLeft.dataSource = self;
    _tableViewLeft.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableViewLeft registerNib:[UINib nibWithNibName:@"MineTeamManCell" bundle:nil] forCellReuseIdentifier:@"MineTeamManCell"];
    
    _tableViewLeft.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerBallRereshing)];
    _tableViewLeft.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerBallRereshing)];
    [_tableViewLeft.header beginRefreshing];
    
    /**
     右边列表
     
     - returns: <#return value description#>
     */
    _tableViewRight=[[UITableView alloc] init];
    [_pageView addTab:_titleArray[1] View:_tableViewRight];
    _tableViewRight.tag = 201;
    _tableViewRight.delegate = self;
    _tableViewRight.dataSource = self;
    _tableViewRight.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableViewRight registerNib:[UINib nibWithNibName:@"MineTeamActiveCell" bundle:nil] forCellReuseIdentifier:@"MineTeamActiveCell"];
    
    
    
    //下划线
    [_pageView enableTabBottomLine:YES LineHeight:3 LineColor:[UIColor greenColor] LineBottomGap:0 ExtraWidth:80*ScreenWidth/375];
    //选中后的样式
    [_pageView setTitleStyle:[UIFont systemFontOfSize:15] Color:[UIColor blackColor] SelColor:[UIColor greenColor]];
    //分割线的样式
    [_pageView enableBreakLine:YES Width:1 TopMargin:5 BottomMargin:5 Color:[UIColor lightGrayColor]];
    
    //滑动视图到最左边和最右边的距离
    _pageView.leftTopView=0;
    _pageView.rightTopView=0;
    
    [_pageView generate];
    UIView *topView=[_pageView getTopContentView];
    UILabel *lb=[[UILabel alloc] init];
    lb.translatesAutoresizingMaskIntoConstraints=NO;
    lb.backgroundColor=[UIColor lightGrayColor];
    [topView addSubview:lb];
    [topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[lb]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lb)]];
    [topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lb(==1)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lb)]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //_pageView.selectedIndex=4;
    });
    
    
}


#pragma mark - 下载数据
- (void)downLoadData:(int)page isReshing:(BOOL)isReshing{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    if (self.lat != nil) {
        [dict setObject:self.lat forKey:@"xIndex"];
    }
    if (self.lng != nil) {
        [dict setObject:self.lng forKey:@"yIndex"];
    }
    [dict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [dict setObject:@10 forKey:@"rows"];
    [dict setObject:@1 forKey:@"userType"];
    [dict setObject:@0 forKey:@"orderType"];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
    //ballNames  cityId   provinceName":@  cityName
    [[PostDataRequest sharedInstance] postDataRequest:@"team/queryPage.do" parameter:dict success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (_page == 1)
            {
                [_dataLeftArray removeAllObjects];
                _numforr = @-100;
            }
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                TeamModel *model = [[TeamModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                [_dataLeftArray addObject:model];
            }
            _page++;
            [_tableViewLeft reloadData];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        [_tableViewLeft reloadData];
        if (isReshing) {
            [_tableViewLeft.header endRefreshing];
        }else {
            [_tableViewLeft.footer endRefreshing];
        }
    } failed:^(NSError *error) {
        if (isReshing) {
            [_tableViewLeft.header endRefreshing];
        }else {
            [_tableViewLeft.footer endRefreshing];
        }
    }];

}
#pragma mark 开始进入刷新状态
- (void)headerBallRereshing
{
    _page = 1;
    [self downLoadData:_page isReshing:YES];
}

- (void)footerBallRereshing
{
    [self downLoadData:_page isReshing:NO];
}

#pragma mark - 下载数据
- (void)downLoadRightData:(int)page isReshing:(BOOL)isReshing{
    [[PostDataRequest sharedInstance] postDataRequest:@"TTeamActivity/queryByList.do" parameter:@{@"page":[NSNumber numberWithInt:page],@"rows":@10,@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"activityCreateUser":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        ////NSLog(@"%@",dict);
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (_pageRight == 1)
            {
                [_dataRightArray removeAllObjects];
            }
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
//                if ([[dataDict objectForKey:@"isendTime"] integerValue]== 1) {
                for (NSDictionary *dict0 in [dataDict objectForKey:@"activityList"]) {
                    TeamActiveModel *model = [[TeamActiveModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict0];
                    [_dataRightArray addObject:model];
                }
                
            }
            _pageRight++;
            [_tableViewRight reloadData];
        }else {
            if (_pageRight == 1)
            {
                [_dataRightArray removeAllObjects];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        if (isReshing) {
            [_tableViewRight.header endRefreshing];
        }else {
            [_tableViewRight.footer endRefreshing];
        }
    } failed:^(NSError *error) {
        if (isReshing) {
            [_tableViewRight.header endRefreshing];
        }else {
            [_tableViewRight.footer endRefreshing];
        }
    }];
}
#pragma mark 开始进入刷新状态
- (void)headerRightRereshing
{
    _pageRight = 1;
    [self downLoadRightData:_pageRight isReshing:YES];
}

- (void)footerRightRereshing
{
    [self downLoadRightData:_pageRight isReshing:NO];
}


-(void)LazyPageScrollViewPageChange:(LazyPageScrollView *)pageScrollView Index:(NSInteger)index PreIndex:(NSInteger)preIndex
{
//    ////NSLog(@"%ld %ld",preIndex,index);
    _indexNum = index;
    if (index == 0) {
        [_tableViewLeft.header endRefreshing];
        _tableViewLeft.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerBallRereshing)];
//        _tableViewLeft.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerBallRereshing)];
        [_tableViewLeft.header beginRefreshing];
    }
    else
    {
        [_tableViewRight.header endRefreshing];
        _tableViewRight.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRightRereshing)];
//        _tableViewRight.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(headerRightRereshing)];
        [_tableViewRight.header beginRefreshing];
    }
}


-(void)LazyPageScrollViewEdgeSwipe:(LazyPageScrollView *)pageScrollView Left:(BOOL)bLeft
{
    if(bLeft)
    {
        // ////NSLog(@"left");
    }
    else
    {
        //////NSLog(@"right");
    }
}

/**
 *  创建活动的按钮
 */
-(void)createWanderOrder
{
    
    
    UIButton* viewBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    viewBtn.backgroundColor = [UIColor clearColor];
    viewBtn.frame = CGRectMake(0, 0, _viewFabu.frame.size.width, _viewFabu.frame.size.height);
    [_viewFabu addSubview:viewBtn];
    [viewBtn addTarget:self action:@selector(createTeamClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* btnJia = [UIButton buttonWithType:UIButtonTypeSystem];
    btnJia.frame = CGRectMake(13*ScreenWidth/375, 3*ScreenWidth/375, 20*ScreenWidth/375, 20*ScreenWidth/375);
    [btnJia setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnJia.titleLabel.font = [UIFont systemFontOfSize:22*ScreenWidth/375];
    btnJia.backgroundColor = [UIColor clearColor];
    [viewBtn addSubview:btnJia];
    [btnJia setTitle:@"+" forState:UIControlStateNormal];
    
    [btnJia addTarget:self action:@selector(createTeamClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton* btnText = [UIButton buttonWithType:UIButtonTypeSystem];
    btnText.frame = CGRectMake(35*ScreenWidth/375, 5*ScreenWidth/375, 60*ScreenWidth/375, 20*ScreenWidth/375);
    [btnText setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnText.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    btnText.backgroundColor = [UIColor clearColor];
    [viewBtn addSubview:btnText];
    
    if (_tableViewLeft) {
        [btnText setTitle:@"创建球队" forState:UIControlStateNormal];
    }
    else
    {
        [btnText setTitle:@"创建活动" forState:UIControlStateNormal];
    }
    [btnText addTarget:self action:@selector(createTeamClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* imgvJian = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 20*ScreenWidth/375, 10*ScreenWidth/375, 10*ScreenWidth/375, 10*ScreenWidth/375)];
    imgvJian.image = [UIImage imageNamed:@"left_jt"];
    [viewBtn addSubview:imgvJian];
    
}
//创建球队点击事件
-(void)createTeamClick
{
    if (_indexNum == 0) {
        //创建球队
        TeamCreateViewController* teamVc = [[TeamCreateViewController alloc]init];
        [self.navigationController pushViewController:teamVc animated:YES];
    }
    else
    {
        //发布活动
        ActiveIsUseViewController* isVc = [[ActiveIsUseViewController alloc]init];
        [self.navigationController pushViewController:isVc animated:YES];
    
    }
}

//创建活动点击事件
-(void)CreateActiveClick
{
    ////NSLog(@"2");
}



#pragma mark --TableView

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100) {
        return 80*ScreenWidth/375;
    }
    else
    {
        return 70*ScreenWidth/320;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_tableViewLeft]) {
        return _dataLeftArray.count;
        
    }
    
    else if ([tableView isEqual:_tableViewRight])
        
    {
        return _dataRightArray.count;
        
    }
    
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    if (tableView.tag == 100) {
        
        ////NSLog(@"%ld",_dataLeftArray.count);
        MineTeamManCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MineTeamManCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        cell.introLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        cell.stateLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        [cell showData:_dataLeftArray[indexPath.row]];
        return cell;
    }
    MineTeamActiveCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MineTeamActiveCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    cell.nameLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
    cell.timeLabel.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
    cell.areaLabel.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
    cell.stateLabel.font = [UIFont systemFontOfSize:13*ScreenWidth/375];
    [cell showData:_dataRightArray[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_indexNum == 0) {
        TeamDeMessViewController *teamVc = [[TeamDeMessViewController alloc]init];
//        teamVc.teamId = [_dataLeftArray[indexPath.row] teamId];
//        teamVc.forrelvant = [_dataLeftArray[indexPath.row] forrelevant];
//        teamVc.isBack = YES;
        teamVc.forBlock = ^(NSNumber* forrevent, NSInteger indexNum){
            _numforr = forrevent;
        };
        teamVc.isBack = YES;
        teamVc.teamId = [_dataLeftArray[indexPath.row] teamId];
//        teamVc.modelMian = _dataLeftArray[indexPath.row];
        if ([_numforr integerValue] == -100) {
            teamVc.forrelvant = [_dataLeftArray[indexPath.row] forrelevant];
        }else{
            if (indexPath.row == _indexNumber) {
                teamVc.forrelvant = _numforr;
            }
            else
            {
                teamVc.forrelvant = [_dataLeftArray[indexPath.row] forrelevant];
            }
        }
        teamVc.indexNum = indexPath.row;
        [self.navigationController pushViewController:teamVc animated:YES];
    }
    else
    {
        TeamActiveDeController* teamVc = [[TeamActiveDeController alloc]init];
        teamVc.teamActivityId = [_dataRightArray[indexPath.row] teamActivityId];
        teamVc.teamStand = [_dataRightArray[indexPath.row] forrelevant];
        [self.navigationController pushViewController:teamVc animated:YES];
    }
    
}







@end
