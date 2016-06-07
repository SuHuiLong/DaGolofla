//
//  HomeHeadView.m
//  JXZX
//
//  Created by qianfeng on 15/3/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HomeHeadView.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "Helper.h"
#import "ChangePicViewController.h"
@implementation HomeHeadView
{
    UIScrollView *_scrollView;
    
    UIPageControl *_pageCtrl;
    
    UIPageControl *_pageControl;

    
    NSArray* _modelArray;
    NSArray *_urlArray;
    NSArray* _titleArray;
    //定时器
    NSTimer *_timer;
    
    //点击的响应
    void (^_myClick)(UIViewController *);
    
    int _scrollHeight;
    
    UIImageView *_imageView;
}



- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    
        _scrollHeight = 190*ScreenWidth/375;
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _scrollHeight)];
        
        _scrollView.showsHorizontalScrollIndicator = NO ;
        _scrollView.bounces = NO ;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = YES;
        [self addSubview:_scrollView];
        
        
        _modelArray = [[NSArray alloc]init];
        _urlArray = [[NSArray alloc]init];
        _titleArray = [[NSArray alloc]init];
        
        //显示当前是第几页
        _pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _scrollHeight-30*ScreenWidth/375, ScreenWidth, 30*ScreenWidth/375)];
        [self addSubview:_pageCtrl];

        
        //设置分页
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _scrollHeight-30, ScreenWidth, 30)];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        [self addSubview:_pageControl];
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width,self.bounds.size.height)];
        [_imageView setImage:[UIImage imageNamed:@"bannerS.jpg"]];
        [_scrollView addSubview:_imageView];
    }
    return self;
}


- (void)config:(NSArray *)dataArray data:(NSArray *)url title:(NSArray *)name ts:(NSArray *)ts;
{
    _modelArray = dataArray;
    _urlArray = url;
    _titleArray = name;
    if (dataArray.count <= 1) {
        _scrollView.scrollEnabled = NO;
    }else{
        _scrollView.scrollEnabled = YES;
    }
    //显示图片
        
        for (int i = 0; i<dataArray.count+2; i++) {
            
            //创建图片视图
            _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth * i, 0, ScreenWidth, _scrollHeight)];
            _imageView.backgroundColor = [UIColor orangeColor];
            if (i == 0) {
//                NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://imgcache.dagolfla.com/adver/%@.jpg",dataArray[i-1]]];

                [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://imgcache.dagolfla.com/adver/%@.jpg?ts=%@",dataArray[dataArray.count - 1], ts[ts.count - 1]]] placeholderImage:[UIImage imageNamed:@"bannerS.jpg"]];
                
            }else if (i == dataArray.count+1) {
                [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://imgcache.dagolfla.com/adver/%@.jpg?ts=%@",dataArray[0], ts[0]]] placeholderImage:[UIImage imageNamed:@"bannerS.jpg"]];
            } else {
                [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://imgcache.dagolfla.com/adver/%@.jpg?ts=%@",dataArray[i-1], ts[i - 1]]] placeholderImage:[UIImage imageNamed:@"bannerS.jpg"]];
            }
            [_scrollView addSubview:_imageView];
            
            //添加手势
            //开启用户交互
            _imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
            [_imageView addGestureRecognizer:g];
            
            if (i == 0) {
                _imageView.tag = 300+dataArray.count - 1;
            }else if (i == dataArray.count + 1){
                _imageView.tag = 300;
            }else{
                _imageView.tag = 300+i-1;
            }
    }
    
    //设置滚动视图的范围
    _scrollView.contentSize = CGSizeMake(ScreenWidth*(dataArray.count+2), 0);
    
    _scrollView.contentOffset = CGPointMake(ScreenWidth, 0);

    _scrollView.delegate = self;
    
    _pageCtrl.numberOfPages = dataArray.count;
    //当前的page
    _pageCtrl.currentPage = 0;
    
    _pageCtrl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageCtrl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.33f green:0.70f blue:0.31f alpha:1.00f];
    
    //启动定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
  
}

- (void)timeAction
{
    
    if (_modelArray.count > 1) {
        NSInteger currentSize = _scrollView.contentOffset.x /ScreenWidth;
        
        
        if (currentSize == _modelArray.count+1) {
            [_scrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:NO];
        }else if (currentSize == 0) {
            [_scrollView setContentOffset:CGPointMake(ScreenWidth * (_modelArray.count), 0) animated:NO];
        }else {
            [_scrollView setContentOffset:CGPointMake(ScreenWidth * (currentSize + 1), 0) animated:YES];
        }
        
        //每隔一段时间滚动到下一页
        if (currentSize == _modelArray.count) {
            _pageCtrl.currentPage = 0;
        }else if (currentSize == 4 || currentSize == 5 ||currentSize == 0){
            
        }else{
            _pageCtrl.currentPage++;
        }
    }
    else
    {
        
    }
    
}

//点击图片的方法//传值
- (void)clickImage:(UIGestureRecognizer *)g
{
    UIImageView *imageView = (UIImageView *)g.view;
    NSInteger index = imageView.tag - 300;
    ChangePicViewController* changeVc = [[ChangePicViewController alloc]init];
    changeVc.strUrl = _urlArray[index];
    changeVc.strTitle = _titleArray[index];
    if (_myClick) {
        _myClick(changeVc);
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //手动滑动时候暂停自动替换
    [_timer invalidate];
    _timer = nil;
    
    NSInteger currentSize = _scrollView.contentOffset.x /ScreenWidth;

    if (currentSize == _modelArray.count+1) {
        [_scrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:NO];
    }else if (currentSize == 0) {
        [_scrollView setContentOffset:CGPointMake(ScreenWidth * (_modelArray.count), 0) animated:NO];
    }
  
    //得到当前页数
    if (currentSize == 0) {
        _pageCtrl.currentPage = _modelArray.count - 1;
    }else if (currentSize == _modelArray.count + 1){
        _pageCtrl.currentPage =0;
    }else {
        _pageCtrl.currentPage = currentSize - 1;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
}

- (void)setClick:(void (^)(UIViewController *))click
{
    _myClick = [click copy];//传到这里了
    
}

- (void)dealloc
{
    _myClick = nil;
    _timer = nil;
}


@end




