//
//  NewsMessageViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/8/4.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "NewsMessageViewController.h"
#import "LazyPageScrollView.h"
#import "CommunMessageViewCell.h"
#import "Helper.h"
#import "PostDataRequest.h"
#import "MJRefresh.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"
#import "NewsDetailModel.h"
@interface NewsMessageViewController ()<LazyPageScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray* _titleArray;
    LazyPageScrollView* _pageView;
    
    UITableView* _tableView1;
    UITableView* _tableView2;
    UIView* _viewDel;
    
    BOOL _isShowing;
    
    NSMutableArray *_data1Array;
    NSMutableArray *_data2Array;
    NSInteger _page1;
    NSInteger _page2;
    
    BOOL _onceInquireData;

}
@end

@implementation NewsMessageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    //发出通知隐藏标签栏
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //显示
    [[NSNotificationCenter defaultCenter] postNotificationName:@"show" object:self];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"社区消息";
    _page1 = 1;
    _page2 = 1;
    _data1Array = [NSMutableArray array];
    _data2Array = [NSMutableArray array];
    
    _isShowing = NO;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(messageClick)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
    
    
    //    UIButton* rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    //    [rightButton setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    //    [rightButton addTarget:self action:@selector(messageClick)forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    //    self.navigationItem.rightBarButtonItem= rightItem;
    
    
    
    [self createPageView];
    [self createDelView];
    
    [self loadData:_page1 type:2];
    
    // 添加刷新控件
    
}


// 添加刷新控件
- (void)addReshTableView:(NSInteger)tableViewNumber
{
    if (tableViewNumber == 1) {
        _tableView1.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing1)];
        _tableView1.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing1)];
        

    } else {
        _tableView2.header=[MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing2)];
        _tableView2.footer=[MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing2)];

    }

}

- (void)headerRereshing1
{
    _page1++;
    [self loadData:_page1 type:2];
}

- (void)footerRereshing1
{
    _page1++;
    [self loadData:_page1 type:2];
}

- (void)headerRereshing2
{
    _page2++;
    [self loadData:_page2 type:1];
    
}

- (void)footerRereshing2
{
    _page2++;
    [self loadData:_page2 type:1];
}

- (void)loadData:(NSInteger)page type:(NSInteger)type
{
    //我发送的
    [[PostDataRequest sharedInstance] postDataRequest:@"mess/querybyChats.do" parameter:@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"page":[NSNumber numberWithInteger:page],@"rows":@10,@"messType":@2,@"selectType":@2} success:^(id respondsData) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"%@",dict);
        [_tableView1.header endRefreshing];
        [_tableView1.footer endRefreshing];

                if ([[dict objectForKey:@"success"] boolValue]) {
            if (page == 1)
            {
                [_data1Array removeAllObjects];
            }
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                NewsDetailModel *model = [[NewsDetailModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                    [_data1Array addObject:model];
            }
                [_tableView1 reloadData];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
  
    } failed:^(NSError *error) {
        
    }];
    
    //我接收的
    [[PostDataRequest sharedInstance] postDataRequest:@"mess/querybyChats.do" parameter:@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"page":[NSNumber numberWithInteger:page],@"rows":@10,@"messType":@6, @"selectType":@2} success:^(id respondsData) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"%@",dict);

        [_tableView2.footer endRefreshing];
        [_tableView2.footer endRefreshing];
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (page == 1)
            {
                [_data2Array removeAllObjects];
            }
            for (NSDictionary *dataDict in [dict objectForKey:@"rows"]) {
                NewsDetailModel *model = [[NewsDetailModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDict];
                    [_data2Array addObject:model];
            }
                [_tableView2 reloadData];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failed:^(NSError *error) {
    }];

    
    
    
    
}
-(void)messageClick
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:@-1 forKey:@"mId"];
    
    
    [dic setValue:@0 forKey:@"type"];
    [dic setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
    [dic setValue:@6 forKey:@"messType"];
    
    [[PostDataRequest sharedInstance] postDataRequest:@"mess/delete.do" parameter:dic success:^(id respondsData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
        if ([[dict objectForKey:@"success"] boolValue]) {
            if (_pageView.selectedIndex == 0) {
                [_data1Array removeAllObjects];
                [_tableView1 reloadData];
            } else {
                [_data2Array removeAllObjects];
                [_tableView2 reloadData];
            }
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    } failed:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"\n链接超时！\n" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertView show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        });
    }];
    
    
    
    
}
-(void)createDelView
{
    _viewDel = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth-110*ScreenWidth/375, 10*ScreenWidth/375, 100*ScreenWidth/375, 40*ScreenWidth/375)];
    _viewDel.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_viewDel];
    _viewDel.hidden = YES;
    UIButton* delBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100*ScreenWidth/375, 40*ScreenWidth/375)];
    [_viewDel addSubview:delBtn];
    [delBtn setTitle:@"删除全部" forState:UIControlStateNormal];
    [delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [delBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)deleteClick
{
    
}
-(void)createPageView
{
    _titleArray = @[@"我收到的",@"我发送的"];
    _pageView = [[LazyPageScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_pageView];
    _pageView.delegate=self;
    [_pageView initTab:YES Gap:50 TabHeight:50 VerticalDistance:10 BkColor:[UIColor whiteColor]];
    [_pageView enableScroll:NO];
    
    _tableView1 =[[UITableView alloc] init];
//    _tableView1.backgroundColor = [UIColor colorWithRed:0.1*(arc4random()%10) green:0.1*(arc4random()%10) blue:0.1*(arc4random()%10) alpha:1];
    [_pageView addTab:_titleArray[0] View:_tableView1];
    
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    
    //        // 打开tableView的编辑状态
    //        [_tableView setEditing:YES animated:YES];
    [self addReshTableView:1];
    [_tableView1 registerNib:[UINib nibWithNibName:@"CommunMessageViewCell" bundle:nil] forCellReuseIdentifier:@"CommunMessageViewCell"];
    
    _tableView2 =[[UITableView alloc] init];
//    _tableView2.backgroundColor = [UIColor colorWithRed:0.1*(arc4random()%10) green:0.1*(arc4random()%10) blue:0.1*(arc4random()%10) alpha:1];
    [_pageView addTab:_titleArray[1] View:_tableView2];
    
    _tableView2.delegate = self;
    _tableView2.dataSource = self;
    
    //        // 打开tableView的编辑状态
    //        [_tableView setEditing:YES animated:YES];
    [self addReshTableView:2];
    [_tableView2 registerNib:[UINib nibWithNibName:@"CommunMessageViewCell" bundle:nil] forCellReuseIdentifier:@"CommunMessageViewCell"];
    
    //下划线
    [_pageView enableTabBottomLine:YES LineHeight:3 LineColor:[UIColor greenColor] LineBottomGap:0 ExtraWidth:80];
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
-(void)LazyPageScrollViewPageChange:(LazyPageScrollView *)pageScrollView Index:(NSInteger)index PreIndex:(NSInteger)preIndex
{
    //////NSLog(@"%ld %ld",preIndex,index);
    if (index == 1 && _onceInquireData == NO) {
        [self loadData:_page2 type:1];
    }
    _onceInquireData = YES;
}


-(void)LazyPageScrollViewEdgeSwipe:(LazyPageScrollView *)pageScrollView Left:(BOOL)bLeft
{
    if(bLeft)
    {
        // ////NSLog(@"left");
        //         [self loadData:_page2 type:1];
    }
    else
    {
        //////NSLog(@"right");
        
    }
}
#pragma MARK -- tableview

// 每一行都是什么编辑状态(删除/ 添加)
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 每一行都是什么编辑状态(删除/ 添加)
    //    return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete; // 多选
    
    // 在tableView中, 对于一些判断条件最好使用数据源, 不要用下标
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 每一行是否可以被编辑
    // 判断根据数据
    return YES;
}

// delete按钮连接的方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ////NSLog(@"点击");
    //UITableViewCellEditingStyleDelete, 该方法执行的是delete按钮
    //UITableViewCellEditingStyleInsert, 该方法执行的是+号(点击+号执行下面的方法)
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 当点击删除按钮时
        
        // 对视图做操作之前, 要先对数据源做处理
        
        if (tableView == _tableView1) {
            //  1. 数据源删除数据
            [_data1Array removeObjectAtIndex:indexPath.row];
            
            //  2. (视图)删除一个cell
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop]; // indexPath 表示你点击的cell
        } else {
            //  1. 数据源删除数据
            [_data2Array removeObjectAtIndex:indexPath.row];
            
            //  2. (视图)删除一个cell
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop]; // indexPath 表示你点击的cell
        }
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        NewsDetailModel* model;
        if (tableView == _tableView1) {
            model = _data1Array[indexPath.row];
            [dic setValue:@2 forKey:@"messType"];
        } else {
            model = _data2Array[indexPath.row];
            [dic setValue:@1 forKey:@"messType"];
        }
        [dic setValue:@1 forKey:@"type"];
        [dic setValue:model.mId forKey:@"mId"];
        [dic setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
        
        
        [[PostDataRequest sharedInstance] postDataRequest:@"mess/delete.do" parameter:dic success:^(id respondsData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingMutableContainers error:nil];
            if ([[dict objectForKey:@"success"] boolValue]) {
                
            }else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        } failed:^(NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"\n链接超时！\n" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertView dismissWithClickedButtonIndex:0 animated:YES];
            });
        }];
        
        
        
    }
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 77;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView1) {
        return _data1Array.count;
    } else {
        
        return _data2Array.count;
    }
    
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ////NSLog(@"%ld", (long)tableView.tag);
    
    
    
    CommunMessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommunMessageViewCell" forIndexPath:indexPath];
    
    
    
    if (tableView == _tableView1) {
        
        [cell showData:_data1Array[indexPath.row]];
    } else {
        [cell showData:_data2Array[indexPath.row]];
    }
    
    
    return cell;
    
}






@end
