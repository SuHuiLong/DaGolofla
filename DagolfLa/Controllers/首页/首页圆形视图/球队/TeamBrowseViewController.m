//
//  BrowseImagesViewController.m
//  2015-02-04-WeChatImagePickerDemo
//
//  Created by TangJR on 15/2/5.
//  Copyright (c) 2015年 tangjr. All rights reserved.
//

#import "TeamBrowseViewController.h"
#import "PictureGestureView.h"
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface TeamBrowseViewController () <UIScrollViewDelegate>

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSMutableArray *selectImages;
@property (assign, nonatomic) CGPoint offset;

@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation TeamBrowseViewController

- (instancetype)initWithIndex:(NSInteger)index selectImages:(NSMutableArray *)selectImages {
    
    self = [super init];
    
    if (self) {
        
        self.index = index;
        self.selectImages = selectImages;
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeUserInterface];
}

- (void)initializeUserInterface {
    //发出通知隐藏标签栏
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonPressed:)];
    self.navigationItem.rightBarButtonItem = item;
    [item setTintColor:[UIColor whiteColor]];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * self.selectImages.count, _scrollView.bounds.size.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.contentOffset = CGPointMake(_index * _scrollView.bounds.size.width, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    self.offset = _scrollView.contentOffset;
    [self.view addSubview:_scrollView];
    
    [self resetScrollViewSubViews];
}

- (void)resetScrollViewSubViews {
    //     ////NSLog(@"%@",_selectImages);
    
    for (int i = 0; i < self.selectImages.count; i++) {
        
        PictureGestureView *imgview = [[PictureGestureView alloc] initWithFrame:CGRectMake(i * CGRectGetWidth(_scrollView.bounds), 0, CGRectGetWidth(_scrollView.bounds), CGRectGetHeight(_scrollView.bounds))];
        
        imgview.contentMode = UIViewContentModeScaleAspectFit;
        imgview.clipsToBounds = YES;
        //        imgview.contentMode = UIViewContentModeScaleAspectFill;
        imgview.clipsToBounds = YES;
        imgview.userInteractionEnabled = YES;
        
        //        [imgview.imageView setImage:_selectImages[i]];
        imgview.imageView.image=[UIImage imageWithData:_selectImages[i]];
        
        [self.scrollView addSubview:imgview];
    }
}

- (void)barButtonPressed:(UIBarButtonItem *)sender {
    
    if (_deleteBlock) {
        
        _deleteBlock(_index);
    }
    
    int flag = 0;
    if (self.index + 1 == self.selectImages.count) {
        flag = 1;
        self.index --;
    } else {
        for (NSInteger i = self.index + 1; i < self.scrollView.subviews.count; i ++) {
            UIView *subView = self.scrollView.subviews[i];
            [subView setFrame:CGRectMake(subView.frame.origin.x - CGRectGetWidth(subView.bounds), 0, CGRectGetWidth(subView.bounds), CGRectGetHeight(subView.bounds))];
        }
    }
    
    if (self.index == -1) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.selectImages removeAllObjects];
        return;
    }
    [self.selectImages removeObjectAtIndex:self.index];
    [self.scrollView.subviews[self.index + flag] removeFromSuperview];
    
    self.scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * self.selectImages.count, _scrollView.bounds.size.height);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (self.offset.x > scrollView.contentOffset.x) {
        self.index --;
    } else if (self.offset.x < scrollView.contentOffset.x){
        self.index ++;
    }
    self.offset = scrollView.contentOffset;
}

@end
