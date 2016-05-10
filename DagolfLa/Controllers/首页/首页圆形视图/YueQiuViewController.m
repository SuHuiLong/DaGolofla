//
//  YueQiuViewController.m
//  DaGolfla
//
//  Created by bhxx on 15/7/23.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "YueQiuViewController.h"
#import "LazyPageScrollView.h"
@interface YueQiuViewController ()<LazyPageScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray* _titleArray;
    LazyPageScrollView* _pageView;
    
    UITableView* _tableView;
    
}
@end

@implementation YueQiuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
    _titleArray = @[@"q",@"球w",@"发起er"];
    _pageView = [[LazyPageScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_pageView];
    _pageView.delegate=self;
    [_pageView initTab:YES Gap:50 TabHeight:50 VerticalDistance:10 BkColor:[UIColor whiteColor]];
    
    for (int i = 0; i < 3; i++) {
        _tableView=[[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
        [_pageView addTab:_titleArray[i] View:_tableView];
        _tableView.tag = 100+i;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
        
    }
    //下划线
    [_pageView enableTabBottomLine:YES LineHeight:3 LineColor:[UIColor greenColor] LineBottomGap:0 ExtraWidth:10];
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //_pageView.selectedIndex=4;
    });
    
}
-(void)LazyPageScrollViewPageChange:(LazyPageScrollView *)pageScrollView Index:(NSInteger)index PreIndex:(NSInteger)preIndex
{
    //////NSLog(@"%ld %ld",preIndex,index);
}


-(void)LazyPageScrollViewEdgeSwipe:(LazyPageScrollView *)pageScrollView Left:(BOOL)bLeft
{
    if(bLeft)
    {
        //////NSLog(@"left");
    }
    else
    {
        //////NSLog(@"right");
    }
}

#pragma MARK -- tableview
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44*ScreenWidth/375;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}



@end
