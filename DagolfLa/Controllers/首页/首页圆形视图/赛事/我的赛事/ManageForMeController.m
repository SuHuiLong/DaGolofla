//
//  ManageMineViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/9/1.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ManageForMeController.h"
#import "LazyPageScrollView.h"
#import "ManageMineCell.h"
#import "ManageExamDetController.h"
#import "ManageDetailController.h"


#import "PostDataRequest.h"
#import "MJRefresh.h"
#import "MJDIYHeader.h"
#import "MJDIYBackFooter.h"
#import "Helper.h"

#import "ManageViewController.h"

@interface ManageForMeController ()<LazyPageScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
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

@implementation ManageForMeController


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
            if ([vc isKindOfClass:[ManageViewController class]]) {
                target=vc;
            }
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
    self.title = @"我的赛事";
    
    
    _page = 1;
    _pageRight = 1;
    
    _dataArray = [[NSMutableArray alloc]init];
    _dataMineArray = [[NSMutableArray alloc]init];
    
    
    //    UIButton* rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    //
    //    [rightButton setImage:[UIImage imageNamed:@"icon_008"] forState:UIControlStateNormal];
    //
    //    [rightButton addTarget:self action:@selector(messageClick)forControlEvents:UIControlEventTouchUpInside];
    //
    //    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    //
    //    self.navigationItem.rightBarButtonItem= rightItem;
    
    [self createPageView];
}

-(void)messageClick
{
    
}


-(void)createPageView
{
    _titleArray = @[@"我发起的赛事",@"我参与的赛事"];
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
    _tableLeftView.tag = 200;
    _tableLeftView.delegate = self;
    _tableLeftView.dataSource = self;
    _tableLeftView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableLeftView registerNib:[UINib nibWithNibName:@"ManageMineCell" bundle:nil] forCellReuseIdentifier:@"ManageMineCell"];
    
    _tableLeftView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerBallRereshing)];
    _tableLeftView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerBallRereshing)];
    [_tableLeftView.header beginRefreshing];
    
    /**
     右边列表
     
     - returns: <#return value description#>
     */
    _tableRightView=[[UITableView alloc] init];
    [_pageView addTab:_titleArray[1] View:_tableRightView];
    _tableRightView.tag = 201;
    _tableRightView.delegate = self;
    _tableRightView.dataSource = self;
    _tableRightView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableRightView registerNib:[UINib nibWithNibName:@"ManageMineCell" bundle:nil] forCellReuseIdentifier:@"ManageMineCell"];
    
    
    
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
    if (self.lng != nil) {
        [dict setObject:self.lng forKey:@"yIndex"];
    }
    if (self.lat != nil) {
        [dict setObject:self.lat forKey:@"xIndex"];
    }
    //    if (![Helper isBlankString:_textField.text]) {
    //        [dict setObject:_textField.text forKey:@"ballNames"];
    //    }
    
    [dict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [dict setObject:@10 forKey:@"rows"];
    [dict setObject:@0 forKey:@"userType"];
    [dict setObject:@1 forKey:@"listType"];
    [dict setObject:[NSNumber numberWithInteger:0] forKey:@"orderType"];
    [dict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"] forKey:@"userId"];
    //,@"eventisEndStart":@"",@"eventIsPrivate":@""
    [[PostDataRequest sharedInstance] postDataRequest:@"tballevent/querybyList.do" parameter:dict success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (page == 1){
                [_dataArray removeAllObjects];
            }

            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                for (NSDictionary *dict0 in [dataDict objectForKey:@"list"]) {
                    GameModel *model = [[GameModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict0];
                    [_dataArray addObject:model];
                }
            }
            _page++;
            [_tableLeftView reloadData];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
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
    _page = 1;
    [self downLoadData:_page isReshing:YES];
}

- (void)footerBallRereshing
{
    [self downLoadData:_page isReshing:NO];
}

#pragma mark - 下载数据
- (void)downLoadRightData:(int)page isReshing:(BOOL)isReshing{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    if (self.lng != nil) {
        [dict setObject:self.lng forKey:@"yIndex"];
    }
    if (self.lat != nil) {
        [dict setObject:self.lat forKey:@"xIndex"];
    }
    //    if (![Helper isBlankString:_textField.text]) {
    //        [dict setObject:_textField.text forKey:@"ballNames"];
    //    }
    
    [dict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [dict setObject:@10 forKey:@"rows"];
    [dict setObject:@0 forKey:@"userType"];
    [dict setObject:@2 forKey:@"listType"];
    [dict setObject:[NSNumber numberWithInteger:0] forKey:@"orderType"];
    [dict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"] forKey:@"userId"];
    //,@"eventisEndStart":@"",@"eventIsPrivate":@""
    [[PostDataRequest sharedInstance] postDataRequest:@"tballevent/querybyList.do" parameter:dict success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (page == 1){
                [_dataMineArray removeAllObjects];
            }
            
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                for (NSDictionary *dict0 in [dataDict objectForKey:@"list"]) {
                    GameModel *model = [[GameModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict0];
                    [_dataMineArray addObject:model];
                }
            }
            _pageRight++;
            [_tableRightView reloadData];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        if (isReshing) {
            [_tableRightView.header endRefreshing];
        }else {
            [_tableRightView.header endRefreshing];
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
    _pageRight = 1;
    [self downLoadRightData:_pageRight isReshing:YES];
}

- (void)footerRightRereshing
{
    [self downLoadRightData:_pageRight isReshing:NO];
}


-(void)LazyPageScrollViewPageChange:(LazyPageScrollView *)pageScrollView Index:(NSInteger)index PreIndex:(NSInteger)preIndex
{
    
    _indexNum = index;
    if (index == 0) {
        [_tableLeftView.header endRefreshing];
        _tableLeftView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerBallRereshing)];
//        _tableLeftView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerBallRereshing)];
        [_tableLeftView.header beginRefreshing];
    }
    else
    {
        [_tableRightView.header endRefreshing];
        _tableRightView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRightRereshing)];
//        _tableRightView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRightRereshing)];
        [_tableRightView.header beginRefreshing];
    }
    
    
}


-(void)LazyPageScrollViewEdgeSwipe:(LazyPageScrollView *)pageScrollView Left:(BOOL)bLeft
{
    
    
}
#pragma MARK -- tableview
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130*ScreenWidth/375;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_tableLeftView]) {
        return _dataArray.count;
        
    }
    
    else if ([tableView isEqual:_tableRightView])
        
    {
        ////NSLog(@"12  %ld",_dataMineArray.count);
        return _dataMineArray.count;
        
    }
    
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView isEqual:_tableLeftView]) {
        
        ManageMineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ManageMineCell" forIndexPath:indexPath];
        //            cell.textLabel.text = _dataArray[indexPath.row];
        [cell showData:_dataArray[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    
    else if ([tableView isEqual:_tableRightView])
    {
        ManageMineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ManageMineCell" forIndexPath:indexPath];
        [cell showData:_dataMineArray[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else
    {
        return nil;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_indexNum == 0) {
        ManageDetailController* yueDVc = [[ManageDetailController alloc]init];
//        yueDVc.aboutBallId = [_dataArray[indexPath.row] aboutBallId];
        yueDVc.eventId = [_dataArray[indexPath.row] eventId];
        [self.navigationController pushViewController:yueDVc animated:YES];
    }
    else
    {
        ManageDetailController* yueDVc = [[ManageDetailController alloc]init];
//        yueDVc.aboutBallId = [_dataMineArray[indexPath.row] aboutBallId];
        yueDVc.eventId = [_dataMineArray[indexPath.row] eventId];
        [self.navigationController pushViewController:yueDVc animated:YES];
    }
    
}



@end
