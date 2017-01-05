//
//  JGHBaseScoreViewController.m
//  DagolfLa
//
//  Created by 黄安 on 16/12/19.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHBaseScoreViewController.h"

@interface JGHBaseScoreViewController ()<UIScrollViewDelegate>



@end    

@implementation JGHBaseScoreViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self createItem];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [self createItem];
}

- (void)createItem{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_wbg"] forBarMetrics:UIBarMetricsDefault];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >7.0) {
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor, nil]];
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
    
    //消除阴影线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@")-2"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClcik)];
    item.tintColor = [UIColor colorWithHexString:Bar_Segment];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"1",@"2",nil];
    _segment = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    _segment.frame = CGRectMake(0, 0, 152 *ProportionAdapter, 29*ProportionAdapter);
    _segment.selectedSegmentIndex = 0;
    [_segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    _segment.tintColor = [UIColor colorWithHexString:Bar_Segment];
    self.navigationItem.titleView = _segment;
    
    [self createScrollView];
}
-(void)backButtonClcik{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)segmentAction:(UISegmentedControl *)segment{
    if (segment.selectedSegmentIndex == 0) {
        _baseScrollView.contentOffset = CGPointMake( 0, 0);
        _segment.selectedSegmentIndex = 0;
    }else{
        _baseScrollView.contentOffset = CGPointMake( screenWidth, 0);
        _segment.selectedSegmentIndex = 1;
    }
}

- (void)createScrollView{
    _baseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight -64)];
    _baseScrollView.contentSize = CGSizeMake(2 *screenWidth, _baseScrollView.bounds.size.height);
    //隐藏垂直滚动条
    _baseScrollView.showsHorizontalScrollIndicator = NO;
    _baseScrollView.showsVerticalScrollIndicator = NO;
    _baseScrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    
    _baseScrollView.pagingEnabled = YES;
    _baseScrollView.delegate = self;
    
    _baseScrollView.scrollEnabled = NO;
    
    [self.view addSubview:self.baseScrollView];
}

//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
//    return scrollView.subviews[0];//通过视图的子视图数组得到_imageView
//}
//
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollView == %f", scrollView.contentOffset.x);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"scrollView222 == %f", scrollView.contentOffset.x);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollView333 == %f", scrollView.contentOffset.x);
    if (scrollView.contentOffset.x >= 375) {
        _segment.selectedSegmentIndex = 1;
    }else{
        _segment.selectedSegmentIndex = 0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotate
{
    return YES;
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
