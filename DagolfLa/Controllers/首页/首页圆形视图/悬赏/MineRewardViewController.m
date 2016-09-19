//
//  MineRewardViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/10.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "MineRewardViewController.h"
#import "LazyPageScrollView.h"

#import "PostRewardCell.h"
#import "PostDetailViewController.h"
#import "RewordModel.h"

#import "PostDataRequest.h"
#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"
#import "Helper.h"

#import "PostRewordViewController.h"

//#import "HighBallViewController.h"
#define kShang_url @"aboutBallReward/queryPage.do"
@interface MineRewardViewController ()<LazyPageScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray* _titleArray;
    LazyPageScrollView* _pageView;
    
    UITableView* _tableView;
    UITableView* _tableViewRight;
    
    //左边列表
    NSMutableArray* _dataArray;
    NSMutableArray* _dataLastArray;
    //右边列表数组
    NSMutableArray* _dataRightArray;
    NSMutableArray* _dataRightLastArray;
    UIView* _viewMore;
//    BOOL _showView;
    BOOL _isClick;
    
    NSInteger _indexNum;
    
    NSInteger _page;
    NSInteger _pageRight;
    
}
@end

@implementation MineRewardViewController



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
}

-(void)backButtonClcik{
    if (self.popViewNumber == 2) {
        UIViewController *target=nil;
        for (UIViewController *vc in self.navigationController.viewControllers) {
//            if ([vc isKindOfClass:[HighBallViewController class]]) {
//                target=vc;
//            }
        }
        if (target) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Refreshing" object:nil];

            [self.navigationController popToViewController:target animated:YES];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    [self.view addSubview:view];
    
    _page = 1;
    _pageRight = 1;
    
    _dataArray = [[NSMutableArray alloc]init];
    _dataLastArray = [[NSMutableArray alloc]init];
    
    _dataRightArray = [[NSMutableArray alloc]init];
    _dataRightLastArray = [[NSMutableArray alloc]init];
    
    
    self.title = @"我的悬赏";

    
    [self createPageView];
    //导航栏点击按钮视图
    [self createBtnView];
    
}

-(void)createBtnView
{
    _viewMore = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth-100*ScreenWidth/375, 10, 120*ScreenWidth/375, 100*ScreenWidth/375)];
    _viewMore.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_viewMore];
    _viewMore.hidden = YES;
    //    NSArray* titleArr = @[@"首页",@"消息",@"我的悬赏"];
    for (int i = 0; i < 2; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(10, i*50*ScreenWidth/375, 100*ScreenWidth/375, 50*ScreenWidth/375);
        //        btn.titleLabel.text = [NSString stringWithFormat:@"%d",i];
        [btn setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
//        btn.backgroundColor = [UIColor redColor];
        [_viewMore addSubview:btn];
        [btn addTarget:self action:@selector(myPostClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 150 + i;
    }
}
-(void)myPostClick:(UIButton*)btn
{
    
}


-(void)createPageView
{
    _titleArray = @[@"我发布的悬赏",@"我参与的悬赏"];
    _pageView = [[LazyPageScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    [self.view addSubview:_pageView];
    _pageView.delegate=self;
    [_pageView initTab:YES Gap:50*ScreenWidth/375 TabHeight:50*ScreenWidth/375 VerticalDistance:10 BkColor:[UIColor whiteColor]];
    
    _tableView=[[UITableView alloc] init];
    _tableView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [_pageView addTab:_titleArray[0] View:_tableView];
    _tableView.tag = 100;
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    [_tableView registerNib:[UINib nibWithNibName:[NSString stringWithFormat:@"PostRewardCell"] bundle:nil] forCellReuseIdentifier:@"PostRewardCell"];
    [_tableView registerClass:[PostRewardCell class] forCellReuseIdentifier:@"PostRewardCell"];
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerLeftRereshing)];
    _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLeftRereshing)];
    [_tableView.header beginRefreshing];
    
    
    _tableViewRight=[[UITableView alloc] init];
    _tableViewRight.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [_pageView addTab:_titleArray[1] View:_tableViewRight];
    _tableViewRight.tag = 101;
    _tableViewRight.delegate = self;
    _tableViewRight.dataSource = self;
    [_tableViewRight registerClass:[PostRewardCell class] forCellReuseIdentifier:@"PostRewardCell"];
    
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
    [dict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [dict setObject:@10 forKey:@"rows"];
    if (self.lng != nil) {
        [dict setObject:self.lng forKey:@"yIndex"];
    }
    if (self.lat != nil) {
        [dict setObject:self.lat forKey:@"xIndex"];
    }
    [dict setObject:@1 forKey:@"userType"];
    [dict setObject:@-1 forKey:@"orderType"];
    [dict setObject:@-1 forKey:@"moneyDown"];
    [dict setObject:@-1 forKey:@"moneyUp"];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
    [[PostDataRequest sharedInstance] postDataRequest:kShang_url parameter:dict success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        //        ////NSLog(@"%@",dict);
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (page == 1){
                [_dataArray removeAllObjects];
                [_dataLastArray removeAllObjects];
            }
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                RewordModel *model = [[RewordModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                if ([model.states integerValue]== 0) {
                    [_dataArray addObject:model];
                }
                else
                {
                    [_dataLastArray addObject:model];
                }
            }
            _page++;
            [_tableView reloadData];
        }else {
            if (page == 1){
                [_dataArray removeAllObjects];
                [_dataLastArray removeAllObjects];
            }
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
- (void)headerLeftRereshing
{
    _page = 1;
    [self downLoadData:_page isReshing:YES];
}

- (void)footerLeftRereshing
{
    [self downLoadData:_page isReshing:NO];
}

#pragma mark - 下载数据
- (void)downLoadRightData:(int)page isReshing:(BOOL)isReshing{
    [[PostDataRequest sharedInstance] postDataRequest:kShang_url parameter:@{@"page":[NSNumber numberWithInt:page],@"rows":@10,@"yIndex":self.lng,@"xIndex":self.lat,@"userType":@2,@"orderType":@-1,@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"moneyDown":@-1,@"moneyUp":@-1} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (page == 1){
                [_dataRightArray removeAllObjects];
                [_dataRightLastArray removeAllObjects];
            }
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                ////NSLog(@"%@",dataDict);
                RewordModel *model = [[RewordModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                if ([model.states integerValue]== 0) {
                    [_dataRightArray addObject:model];
                }
                else
                {
                    [_dataRightLastArray addObject:model];
                }
            }
            _pageRight ++;
            [_tableViewRight reloadData];
        }else {
            if (page == 1){
                [_dataRightArray removeAllObjects];
                [_dataRightLastArray removeAllObjects];
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
- (void)headerRereshingRight
{
    _pageRight = 1;
    [self downLoadRightData:_pageRight isReshing:YES];
}

- (void)footerRereshingRight
{
    [self downLoadRightData:_pageRight isReshing:NO];
}

-(void)LazyPageScrollViewPageChange:(LazyPageScrollView *)pageScrollView Index:(NSInteger)index PreIndex:(NSInteger)preIndex
{
    //////NSLog(@"%ld %ld",preIndex,index);
    
    if (index == 0) {
        [_tableView.header endRefreshing];
        _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerLeftRereshing)];
//        _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLeftRereshing)];
        [_tableView.header beginRefreshing];
    }
    else
    {
        [_tableViewRight.header endRefreshing];
        _tableViewRight.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshingRight)];
//        _tableViewRight.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshingRight)];
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
#pragma mark --TableView

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73*ScreenWidth/320;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_tableView]) {
        if (section == 0) {
            return _dataArray.count;
        }
        else
        {
            return _dataLastArray.count;
        }
        
    }
    
    else if ([tableView isEqual:_tableViewRight])
        
    {
        if (section == 0) {
            return _dataRightArray.count;
        }
        else
        {
            return _dataRightLastArray.count;
        }
        
    }
    
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView isEqual:_tableView]) {
        
        PostRewardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostRewardCell" forIndexPath:indexPath];
        //            cell.textLabel.text = _dataArray[indexPath.row];
        if (indexPath.section == 0) {
            [cell showData:_dataArray[indexPath.row]];
        }
        else
        {
            [cell showData:_dataLastArray[indexPath.row]];
        }
//        if (_dataLastArray.count == 0) {
//            _tableView.
//        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    
    else if ([tableView isEqual:_tableViewRight])
    {
        PostRewardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostRewardCell" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            [cell showData:_dataRightArray[indexPath.row]];
        }
        else
        {
            [cell showData:_dataRightLastArray[indexPath.row]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostDetailViewController* detailVc = [[PostDetailViewController alloc]init];
    if (tableView.tag == 100) {
        if (indexPath.section == 0) {
             detailVc.aboutBallId = [_dataArray[indexPath.row] aboutBallReId];
        }
        else
        {
             detailVc.aboutBallId = [_dataLastArray[indexPath.row] aboutBallReId];
        }

       
    }
    else
    {
        if (indexPath.section == 0) {
            detailVc.aboutBallId = [_dataRightArray[indexPath.row] aboutBallReId];
        }
        else
        {
            detailVc.aboutBallId = [_dataRightLastArray[indexPath.row] aboutBallReId];
        }
        
    }
    [self.navigationController pushViewController:detailVc animated:YES];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_tableView) {
        if (section == 0) {
            return 0;
        }
        else
        {
            if (_dataLastArray.count == 0) {
                return 0;
            }
            else
            {
                return 30*ScreenWidth/375;
            }
        }
    }
    else
    {
        if (section == 0) {
            return 0;
        }
        else
        {
            if (_dataRightLastArray.count == 0) {
                return 0;
            }
            else
            {
                return 30*ScreenWidth/375;
            }
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
        label.text = @"以下为已经结束的悬赏活动";
        [view addSubview:label];
        label.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        
        
        return view;
    }
    return nil;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}






@end
