//
//  YueMyBallViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/13.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "YueMyBallViewController.h"
#import "LazyPageScrollView.h"
#import "YueMyBallTableViewCell.h"
#import "YueDetailViewController.h"

#import "PostDataRequest.h"

#import "Helper.h"


#import "MJRefresh.h"
#import "MJDIYHeader.h"
#import "MJDIYBackFooter.h"

#define kYue_url @"aboutBall/queryPage.do"
@interface YueMyBallViewController ()<LazyPageScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray* _titleArray;
    LazyPageScrollView* _pageView;
    
    UITableView* _tableLeftView;
    UITableView* _tableRightView;
    
    NSMutableArray* _dataArray;
    NSMutableArray* _dataMineArray;
    
    NSInteger _indexNum;
    NSInteger _page;
    NSInteger _pageRight;
    
}
@end

@implementation YueMyBallViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    [self.view addSubview:view];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backL"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
}


-(void)backButtonClcik{
    
    if (self.popViewNumber == 2) {
        UIViewController *target=nil;
        for (UIViewController *vc in self.navigationController.viewControllers) {
//            if ([vc isKindOfClass:[YueHallViewController class]]) {
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
    self.title = @"我的约球";
    
    _page = 1;
    _pageRight = 1;
    _dataArray = [[NSMutableArray alloc]init];
    _dataMineArray = [[NSMutableArray alloc]init];
    UIButton* rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    
    [rightButton setImage:[UIImage imageNamed:@"icon_008"] forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(messageClick)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem= rightItem;
    
    [self createPageView];
}

-(void)messageClick
{
    
}


-(void)createPageView
{
    _titleArray = @[@"我发起的约球",@"我参与的约球"];
    _pageView = [[LazyPageScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    [self.view addSubview:_pageView];
    _pageView.delegate=self;
    [_pageView initTab:YES Gap:50*ScreenWidth/375 TabHeight:50*ScreenWidth/375 VerticalDistance:10 BkColor:[UIColor whiteColor]];
    
    
    /**
     左边列表
     
     - returns: 
     */
    _tableLeftView=[[UITableView alloc] init];
    _tableLeftView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [_pageView addTab:_titleArray[0] View:_tableLeftView];
    _tableLeftView.tag = 400;
    _tableLeftView.delegate = self;
    _tableLeftView.dataSource = self;
    _tableLeftView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableLeftView registerNib:[UINib nibWithNibName:@"YueMyBallTableViewCell" bundle:nil] forCellReuseIdentifier:@"YueMyBallTableViewCell"];
    
    _tableLeftView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerBallRereshing)];
    _tableLeftView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerBallRereshing)];
    [_tableLeftView.header beginRefreshing];
    /**
     右边列表
     
     - returns: <#return value description#>
     */
    _tableRightView=[[UITableView alloc] init];
    [_pageView addTab:_titleArray[1] View:_tableRightView];
    _tableRightView.tag = 401;
    _tableRightView.delegate = self;
    _tableRightView.dataSource = self;
    _tableRightView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableRightView registerNib:[UINib nibWithNibName:@"YueMyBallTableViewCell" bundle:nil] forCellReuseIdentifier:@"YueMyBallTableViewCell"];
    
    
    
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
//    ////NSLog(@"%@")
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [dict setObject:@10 forKey:@"rows"];
    [dict setObject:self.lng forKey:@"yIndex"];
    [dict setObject:self.lat forKey:@"xIndex"];
    [dict setObject:@0 forKey:@"orderType"];
    [dict setObject:@1 forKey:@"userType"];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
    [[PostDataRequest sharedInstance] postDataRequest:kYue_url parameter:dict success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        //        ////NSLog(@"%@",dict);
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (page==1)[_dataArray removeAllObjects];
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                ////NSLog(@"%@",dataDict);
                YueHallModel *model = [[YueHallModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                [_dataArray addObject:model];
            }
            _page++;
            [_tableLeftView reloadData];
        }else {
            if (page==1)[_dataArray removeAllObjects];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        [_tableLeftView reloadData];
        if (isReshing) {
            [_tableLeftView.header endRefreshing];
        }else {
            [_tableLeftView.footer endRefreshing];
        }
    } failed:^(NSError *error) {
        if (isReshing) {
            [_tableLeftView.header endRefreshing];
        }else {
            [_tableLeftView.footer endRefreshing];
        }
    }];
}
#pragma mark 开始进入刷新状态
- (void)headerBallRereshing
{
    _page=1;
    [self downLoadData:_page isReshing:YES];
}

- (void)footerBallRereshing
{
    [self downLoadData:_page isReshing:NO];
}

#pragma mark - 下载数据
- (void)downLoadRightData:(int)page isReshing:(BOOL)isReshing{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [dict setObject:@10 forKey:@"rows"];
    [dict setObject:self.lng forKey:@"yIndex"];
    [dict setObject:self.lat forKey:@"xIndex"];
    [dict setObject:@0 forKey:@"orderType"];
    [dict setObject:@2 forKey:@"userType"];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
    [[PostDataRequest sharedInstance] postDataRequest:kYue_url parameter:dict success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        //        ////NSLog(@"%@",dict);
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (_pageRight == 1)[_dataMineArray removeAllObjects];
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                ////NSLog(@"%@",dataDict);
                YueHallModel *model = [[YueHallModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                [_dataMineArray addObject:model];
            }
            _pageRight++;
            [_tableRightView reloadData];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        [_tableRightView reloadData];
        if (isReshing) {
            [_tableRightView.header endRefreshing];
        }else {
            [_tableRightView.footer endRefreshing];
        }
    } failed:^(NSError *error) {
        if (isReshing) {
            [_tableRightView.header endRefreshing];
        }else {
            [_tableRightView.footer endRefreshing];
        }
    }];
}
#pragma mark 开始进入刷新状态
- (void)headerRightRereshing
{
    _pageRight=1;
    [self downLoadRightData:_pageRight isReshing:YES];
}

- (void)footerRightRereshing
{
    [self downLoadRightData:_pageRight isReshing:NO];
}


-(void)LazyPageScrollViewPageChange:(LazyPageScrollView *)pageScrollView Index:(NSInteger)index PreIndex:(NSInteger)preIndex
{
    ////NSLog(@"%ld",preIndex);
    
    _indexNum = index;
    if (index == 0) {
        [_tableLeftView.header endRefreshing];
        _tableLeftView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerBallRereshing)];
        [_tableLeftView.header beginRefreshing];
    }
    else
    {
        [_tableRightView.header endRefreshing];
        _tableRightView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRightRereshing)];
        [_tableRightView.header beginRefreshing];
    }
    
    
}


-(void)LazyPageScrollViewEdgeSwipe:(LazyPageScrollView *)pageScrollView Left:(BOOL)bLeft
{
//    if (<#condition#>) {
//        <#statements#>
//    }
    
}
#pragma MARK -- tableview
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120*ScreenWidth/375;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_tableLeftView]) {
        return _dataArray.count;
        
    }
    
    else if ([tableView isEqual:_tableRightView])
    {
        return _dataMineArray.count;
        
    }
    
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView isEqual:_tableLeftView]) {
        
        YueMyBallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YueMyBallTableViewCell" forIndexPath:indexPath];
        //            cell.textLabel.text = _dataArray[indexPath.row];
        [cell showData:_dataArray[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    
    else if ([tableView isEqual:_tableRightView])
    {
        YueMyBallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YueMyBallTableViewCell" forIndexPath:indexPath];
        [cell showData:_dataMineArray[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ////NSLog(@"%ld",tableView.tag);
    ////NSLog(@"%ld",_indexNum);
    if (_indexNum == 0) {
        YueDetailViewController* yueDVc = [[YueDetailViewController alloc]init];
        yueDVc.aboutBallId = [_dataArray[indexPath.row] aboutBallId];
        
        [self.navigationController pushViewController:yueDVc animated:YES];
    }
    else if (_indexNum == 1)
    {
        YueDetailViewController* yueDVc = [[YueDetailViewController alloc]init];
        yueDVc.aboutBallId = [_dataMineArray[indexPath.row] aboutBallId];
        
        [self.navigationController pushViewController:yueDVc animated:YES];
    }
    else
    {
        
    }
}



@end
