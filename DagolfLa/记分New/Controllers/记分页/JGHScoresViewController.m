//
//  JGHScoresViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHScoresViewController.h"
#import "JGHScoresMainViewController.h"
#import "JGHScoresHoleView.h"
#import "JGHScoreListModel.h"

@interface JGHScoresViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
{
    UIPageViewController *_pageViewController;
    NSMutableArray *_dataArray;
    NSInteger _currentPage;
    UIPageControl *_pageControl;
    
    NSInteger _selectHole;
    
    JGHScoresHoleView *_scoresView;
    
    UIView *_tranView;
}

@property (nonatomic, strong)NSMutableArray *userScoreArray;

@property (nonatomic, strong)UIButton *titleBtn;

@end

@implementation JGHScoresViewController

- (instancetype)init{
    if (self == [super init]) {
        self.userScoreArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:BG_color];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(80*ProportionAdapter, 0, 80*ProportionAdapter, 44)];
    self.titleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80*ProportionAdapter, 44)];
    [titleView addSubview:self.titleBtn];
    [self.titleBtn setTitle:@"1 HOLE" forState:UIControlStateNormal];
    [self.titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleView;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveScoresClick)];
    item.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
    
    _dataArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<18; i++) {
        [_dataArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    _currentPage = 0;
    _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:1 navigationOrientation:0 options:nil];
    
    JGHScoresMainViewController *sub = [[JGHScoresMainViewController alloc]init];
//    sub.d
    [_pageViewController setViewControllers:@[sub] direction:0 animated:NO completion:nil];
    
    [self.view addSubview:_pageViewController.view];
    
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.numberOfPages = _dataArray.count;
    _pageControl.currentPage = 0;
    _pageControl.center = self.view.center;
    [self.view addSubview:_pageControl];
    _pageControl.pageIndicatorTintColor = [UIColor blueColor];
    
    [self getScoreList];
}
#pragma mark -- getScoreList 获取活动计分列表
- (void)getScoreList{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    [dict setObject:_scorekey forKey:@"scoreKey"];
    [dict setObject:[JGReturnMD5Str getScoreListUserKey:[DEFAULF_USERID integerValue] andScoreKey:[_scorekey integerValue]] forKey:@"md5"];
    [[JsonHttp jsonHttp]httpRequest:@"score/getScoreList" JsonKey:nil withData:dict requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {
            if ([data objectForKey:@"list"]) {
                NSArray *dataArray = [NSArray array];
                dataArray = [data objectForKey:@"list"];
                for (NSDictionary *dcitData in dataArray) {
                    JGHScoreListModel *model = [[JGHScoreListModel alloc]init];
                    [model setValuesForKeysWithDictionary:dcitData];
                    [self.userScoreArray addObject:model];
                }
            }
        }else{
            if ([data objectForKey:@"packResultMsg"]) {
                [[ShowHUD showHUD]showToastWithText:[data objectForKey:@"packResultMsg"] FromView:self.view];
            }
        }
    }];
}
#pragma mark -- titleBtn 点击事件
- (void)titleBtnClick:(UIButton *)btn{
    NSLog(@"XXX dong");
    if (_selectHole == 0) {
        _selectHole = 1;
        _scoresView = [[JGHScoresHoleView alloc]init];
        _scoresView.frame = CGRectMake(0, 0, screenWidth, screenHeight - 200);
        [self.view addSubview:_scoresView];
        [_scoresView getScoreList:_scorekey];
        
        _tranView = [[UIView alloc]initWithFrame:CGRectMake(0, _scoresView.frame.size.height, screenWidth, 200 *ProportionAdapter)];
        _tranView.backgroundColor = [UIColor blackColor];
        _tranView.alpha = 0.3;
        
        
        UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc]init];
        [tag addTarget:self action:@selector(titleBtnClick:)];
        [_tranView addGestureRecognizer:tag];
        [self.view addSubview:_tranView];
        [self.view addSubview:_scoresView];
        
    }else{
        _selectHole = 0;
        [_scoresView removeFromSuperview];
        [_tranView removeFromSuperview];
    }
}
//返回前一页的视图控制器
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    JGHScoresMainViewController *s = (JGHScoresMainViewController *)viewController;
    _currentPage = s.index;
    if (_currentPage <= 0) {
        _currentPage = _dataArray.count - 1;
        JGHScoresMainViewController *sub = [[JGHScoresMainViewController alloc]init];
        sub.index = _currentPage;
//        sub.text = _dataArray[_currentPage];
        return sub;
    }
    else
    {
        _currentPage--;
        JGHScoresMainViewController *sub = [[JGHScoresMainViewController alloc]init];
        sub.index = _currentPage;
//        sub.text = _dataArray[_currentPage];
        return sub;
    }
}

//返回后一页的视图控制器
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    JGHScoresMainViewController *s = (JGHScoresMainViewController *)viewController;
    _currentPage = s.index;
    if (_currentPage >= _dataArray.count - 1) {
        _currentPage = 0;
        JGHScoresMainViewController *sub = [[JGHScoresMainViewController alloc]init];
        sub.index = _currentPage;
//        sub.text = _dataArray[_currentPage];
        return sub;
    }
    else
    {
        _currentPage++;
        JGHScoresMainViewController *sub = [[JGHScoresMainViewController alloc]init];
        sub.index = _currentPage;
//        sub.text = _dataArray[_currentPage];
        NSLog(@"%@",sub);
        return sub;
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    JGHScoresMainViewController *sub = (JGHScoresMainViewController *)pageViewController.viewControllers[0];
    NSInteger index = sub.index;
    _pageControl.currentPage = index;
    [self.titleBtn setTitle:[NSString stringWithFormat:@"%td HOLE", sub.index+1] forState:UIControlStateNormal];
    [[ShowHUD showHUD]showToastWithText:[NSString stringWithFormat:@"第-%td-洞", sub.index+1] FromView:self.view];
}

#pragma mark -- 保存
- (void)saveScoresClick{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DEFAULF_USERID forKey:@"userKey"];
    
    
    [[JsonHttp jsonHttp]httpRequest:@"score/saveScore" JsonKey:nil withData:dict requestMethod:@"POST" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        NSLog(@"%@", data);
    }];
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
