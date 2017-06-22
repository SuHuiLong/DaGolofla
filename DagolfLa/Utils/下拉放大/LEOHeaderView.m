//
//  LEOHeaderView.m
//  iOS-NavigationBar-Category
//
//  Created by 雷亮 on 16/7/29.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "LEOHeaderView.h"
#import "UIView+leoAdd.h"

#define kSelfWidth  self.bounds.size.width
#define kSelfHeight self.bounds.size.height
#define kKeyWindow [[UIApplication sharedApplication] keyWindow]

#ifndef BLOCK_EXE
#define BLOCK_EXE(block, ...) \
if (block) { \
block(__VA_ARGS__); \
}
#endif

@interface LEOHeaderView ()

@property (nonatomic, copy) ReachtopBlock block;
@property (nonatomic, copy) PressHeaderBlock pressBlock;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation LEOHeaderView

#pragma mark -
#pragma mark - external calling methods
- (void)setBackgroundImage:(UIImage *)image {
    self.backgroundImageView.image = image;
    //self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    //self.backgroundImageView.clipsToBounds = YES;
}

- (void)setHeaderImage:(UIImage *)image text:(NSString *)text {
    //self.headerImageView.image = [UIImage imageNamed:@""];
    //self.label.text = text;
}

- (void)reloadWithScrollView:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y + kSelfHeight - kNavigationBarHeight;
    if (offsetY < 0) {
        // 下拉
        // 图片放大
        CGFloat centerX = kSelfWidth / 2;
        CGFloat centerY = (kSelfHeight - offsetY) / 2;
        CGFloat kScale = (kSelfHeight - offsetY) / kSelfHeight;
        self.backgroundImageView.center = CGPointMake(centerX, centerY);
        self.backgroundImageView.transform = CGAffineTransformMakeScale(kScale, kScale);
    } else if (offsetY > 0 && offsetY <= kSelfHeight - kNavigationBarHeight) {
        // 上拉
        // 改变背景图的位置
        self.top = -offsetY / 2;
    }
}

#pragma mark -
#pragma mark - getter methods
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.frame = CGRectMake(0, 0, kSelfWidth, kSelfHeight);
        _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        _backgroundImageView.clipsToBounds = YES;
        [self addSubview:_backgroundImageView];
    }
    return _backgroundImageView;
}

@end
