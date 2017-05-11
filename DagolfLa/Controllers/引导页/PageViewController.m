//
//  PageViewController.m
//  开始动画
//
//  Created by qianfeng on 15/6/6.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "PageViewController.h"

@interface PageViewController ()<UIScrollViewDelegate>
{
    UIPageControl* _control;
}
@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createScroll];

}
-(void)createScroll
{
    UIScrollView* scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.pagingEnabled = YES;
    //scrollView.userInteractionEnabled = YES;
    [self.view addSubview:scrollView];
    scrollView.showsVerticalScrollIndicator = FALSE;
    scrollView.showsHorizontalScrollIndicator = FALSE;
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat heitht = [[UIScreen mainScreen] bounds].size.height;
    
    for(int i = 0; i < 4; i++){
        UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake((i)* width, 0, width, heitht)];
        [scrollView addSubview:imgv];
        NSString* string = [NSString stringWithFormat:@"guide_%d",i+1];
        imgv.image = [UIImage imageNamed:string];
        imgv.userInteractionEnabled = YES;
        if (i == 3) {
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [imgv addSubview:btn];
            btn.frame = CGRectMake(0, 0, width*9/11, heitht/12);
            btn.center = CGPointMake(width/2, heitht-heitht/12+20);
            btn.backgroundColor = [UIColor clearColor];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:20];
            [btn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    scrollView.contentSize = CGSizeMake(width*4, 0);
    scrollView.delegate = self;
}
-(void)clickAction
{
    _callBack();
    ////NSLog(@"11");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
