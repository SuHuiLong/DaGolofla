//
//  MyAttentionController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/31.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "MyAttentionController.h"
#import "LazyPageScrollView.h"
#import "MyAttentionViewCell.h"
#import "PersonHomeController.h"

#import "PostDataRequest.h"
#import "Helper.h"
#import "MJRefresh.h"
#import "MJDIYHeader.h"
#import "MJDIYBackFooter.h"

#import "MyattenModel.h"

//#import "TeamDetailViewController.h"
@interface MyAttentionController ()<LazyPageScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray* _titleArray;
    LazyPageScrollView* _pageView;
    
    UITableView* _tableView;
    
    UITableView* _tableOtherView;
    
    NSMutableArray* _dataArray;
    NSMutableArray* _dataRightArray;
    
    NSInteger _page;
    NSInteger _pageRight;
    
}
@property (strong, nonatomic) NSString* str;

@end

@implementation MyAttentionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的关注";
    
    _page = 1;
    _pageRight = 1;
    
    _dataArray = [[NSMutableArray alloc]init];
    _dataRightArray = [[NSMutableArray alloc]init];
    _str = [[NSString alloc]init];

    
    [self createPageView];
}
//添加 点击事件
-(void)addClick
{
    
}

-(void)createPageView
{
    _titleArray = @[@"我关注的",@"关注我的"];
    _pageView = [[LazyPageScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    [self.view addSubview:_pageView];
    _pageView.delegate=self;
    [_pageView initTab:YES Gap:50 TabHeight:50 VerticalDistance:10 BkColor:[UIColor whiteColor]];
    
    //左边列表
    _tableView=[[UITableView alloc] init];
    _tableView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [_pageView addTab:_titleArray[0] View:_tableView];
    _tableView.tag = 100;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"MyAttentionViewCell" bundle:nil] forCellReuseIdentifier:@"MyAttentionViewCell"];
    _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerBallRereshing)];
    _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerBallRereshing)];
    [_tableView.header beginRefreshing];
    
    //右边列表
    _tableOtherView=[[UITableView alloc] init];
    _tableOtherView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [_pageView addTab:_titleArray[1] View:_tableOtherView];
    _tableOtherView.tag = 101;
    _tableOtherView.delegate = self;
    _tableOtherView.dataSource = self;
    [_tableOtherView registerNib:[UINib nibWithNibName:@"MyAttentionViewCell" bundle:nil] forCellReuseIdentifier:@"MyAttentionViewCell"];
    
    
    //下划线
    [_pageView enableTabBottomLine:YES LineHeight:3 LineColor:[UIColor greenColor] LineBottomGap:0 ExtraWidth:80*ScreenWidth/375];
    //选中后的样式
    [_pageView setTitleStyle:[UIFont systemFontOfSize:15] Color:[UIColor blackColor] SelColor:[UIColor greenColor]];
    //分割线的样式
    [_pageView enableBreakLine:YES Width:1 TopMargin:5 BottomMargin:5 Color:[UIColor lightGrayColor]];
    //滑动视图到最左边和最右边的距离
    _pageView.leftTopView=0;
    _pageView.rightTopView=0;
    //    UIView* leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 0)];
    //    leftView.backgroundColor=[UIColor blackColor];
    
    //    UIView* rightView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 0)];
    //    rightView.backgroundColor=[UIColor purpleColor];
    //_pageView.rightTopView=rightView;
    
    // 生成LazyPageScrollView，需要设置完相关属性后调用该函数生成
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
    [[PostDataRequest sharedInstance] postDataRequest:@"UserFollow/querbyUserFollowList.do" parameter:@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"otherUserId":@0,@"page":[NSNumber numberWithInt:page],@"rows":@10} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        //        ////NSLog(@"%@",dict);
        
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (page == 1)[_dataArray removeAllObjects];
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                ////NSLog(@"%@",dataDict);
                MyattenModel *model = [[MyattenModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                
                if ([model.otherUserId isEqualToNumber:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]]) {
                }else {
                     [_dataArray addObject:model];
                }
            }
            _page++;
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
    [[PostDataRequest sharedInstance] postDataRequest:@"UserFollow/querbyUserFollowList.do" parameter:@{@"userId":@0,@"otherUserId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"page":[NSNumber numberWithInt:page],@"rows":@10} success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        //        ////NSLog(@"%@",dict);
        
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (page == 1)[_dataRightArray removeAllObjects];
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                MyattenModel *model = [[MyattenModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                
                if ([model.userId isEqualToNumber:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]]) {
                    
                }else{
                    [_dataRightArray addObject:model];

                }
            }
            _pageRight ++;
            [_tableOtherView reloadData];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        if (isReshing) {
            [_tableOtherView.header endRefreshing];
        }else {
            [_tableOtherView.footer endRefreshing];
        }
    } failed:^(NSError *error) {
        if (isReshing) {
            [_tableOtherView.header endRefreshing];
        }else {
            [_tableOtherView.footer endRefreshing];
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
    if (index == 0) {
        _tableView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerBallRereshing)];
//        _tableView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerBallRereshing)];
        [_tableView.header beginRefreshing];
    }
    else
    {
        _tableOtherView.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRightRereshing)];
//        _tableOtherView.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRightRereshing)];
        [_tableOtherView.header beginRefreshing];
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
#pragma MARK -- tableview
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80*ScreenWidth/375;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_tableView]) {
        ////NSLog(@"11  %ld",_dataArray.count);
        return _dataArray.count;
        
    }
    
    else if ([tableView isEqual:_tableOtherView])
        
    {
        ////NSLog(@"12  %ld",_dataRightArray.count);
        return _dataRightArray.count;
        
    }
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView isEqual:_tableView]) {
        
        MyAttentionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyAttentionViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell showData:_dataArray[indexPath.row]];
        return cell;
        
    }
    
    else if ([tableView isEqual:_tableOtherView])
    {
        MyAttentionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyAttentionViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell showData:_dataRightArray[indexPath.row]];
        return cell;
        
    }
    
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonHomeController* selfVc = [[PersonHomeController alloc]init];
    if (tableView == _tableView) {
        
        selfVc.strMoodId = [_dataArray[indexPath.row] otherUserId];
    } else {
        selfVc.strMoodId = [_dataRightArray[indexPath.row] userId];
        
    }
    selfVc.messType = @2;
    [self.navigationController pushViewController:selfVc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



@end
