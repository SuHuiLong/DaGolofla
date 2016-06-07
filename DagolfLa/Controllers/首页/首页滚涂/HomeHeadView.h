//
//  HomeHeadView.h
//  JXZX
//
//  Created by qianfeng on 15/3/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TopModel;
@protocol HomeHeadViewDelegate <NSObject>

- (void)didSelectAtImage:(TopModel *)model;

@end

@interface HomeHeadView : UIView <UIScrollViewDelegate>

//显示数据
- (void)config:(NSArray *)dataArray data:(NSArray *)url title:(NSArray *)name ts:(NSArray *)ts;


- (void)setClick:( void (^)(UIViewController* ))click;

@property (nonatomic, assign) NSInteger currentPage;


@property (nonatomic,weak)id<HomeHeadViewDelegate>delegate;

@end




///////////////////
