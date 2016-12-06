//
//  SDBrowserImageView.m
//  SDPhotoBrowser
//
//  Created by aier on 15-2-6.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDBrowserImageView.h"
#import "UIImageView+WebCache.h"
#import "SDPhotoBrowserConfig.h"

@implementation SDBrowserImageView
{
    SDWaitingView *_waitingView;
//    UIScrollView *_scroll;
//    UIImageView *_scrollImageView;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFit;
        
//        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
//        doubleTap.numberOfTapsRequired = 2;
//        [self addGestureRecognizer:doubleTap];
    }
    return self;
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    
    NSLog(@":========%f",_scroll.zoomScale);
    CGPoint touchPoint = [tap locationInView:_scroll];
    if (_scroll.zoomScale == _scroll.maximumZoomScale) {
        [_scroll setZoomScale:_scroll.minimumZoomScale animated:YES];
    } else {
        [_scroll zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _waitingView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    
    if (self.image.size.height > self.bounds.size.height) {
        if (!_scroll) {
            _scroll = [[UIScrollView alloc] init];
            _scroll.frame = self.bounds;
            _scroll.backgroundColor = [UIColor whiteColor];
            _scroll.tag = 1000;
            _scroll.delegate  =  self;
            _scrollImageView = [[UIImageView alloc] init];
            _scrollImageView.tag = 10000;
            _scrollImageView.image = self.image;
            [_scroll addSubview:_scrollImageView];

            _scroll.showsHorizontalScrollIndicator = NO;
            _scroll.showsVerticalScrollIndicator = NO;
            _scroll.decelerationRate = UIScrollViewDecelerationRateFast;
            _scroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            _scroll.backgroundColor = SDPhotoBrowserBackgrounColor;
            
            [self addSubview:_scroll];
            self.contentMode = UIViewContentModeScaleAspectFit;
            
            [self adjustFrame];
        }
    }
    
    _scroll.contentSize = CGSizeMake(0, self.image.size.height);
}

#pragma mark - UIScrollViewDelegate
//显示的图片
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _scrollImageView;
}
// 当scrollView缩放时，调用该方法。在缩放过程中，回多次调用
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    //居中显示
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
    _scrollImageView.center = CGPointMake(scrollView.contentSize.width/2 + offsetX,scrollView.contentSize.height/2 + offsetY);
    
}


- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    _waitingView.progress = progress;

}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    __weak SDBrowserImageView *imageViewWeak = self;
    
    [self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        //zi
        //
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // something
            if( _waitingView == nil ){
                SDWaitingView *waiting = [[SDWaitingView alloc] init];
                waiting.bounds = CGRectMake(0, 0, 100, 100);
                waiting.mode = SDWaitingViewProgressMode;
                _waitingView = waiting;
                [self addSubview:waiting];
            }
            imageViewWeak.progress = (CGFloat)receivedSize / expectedSize;
        });
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageViewWeak removeWaitingView];
            if (error) {
                
                UILabel *label = [[UILabel alloc] init];
                label.bounds = CGRectMake(0, 0, 160, 30);
                label.center = CGPointMake(imageViewWeak.bounds.size.width * 0.5, imageViewWeak.bounds.size.height * 0.5);
                label.text = @"图片加载失败";
                label.font = [UIFont systemFontOfSize:16];
                label.textColor = [UIColor whiteColor];
                label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
                label.layer.cornerRadius = 5;
                label.clipsToBounds = YES;
                label.textAlignment = NSTextAlignmentCenter;
                [imageViewWeak addSubview:label];
            }else{
                
                if( _scrollImageView != nil ){
                    
                    _scrollImageView.image  =  image;
                    
                    [self adjustFrame];
                }
            }
        });
        
        
    }];
}

#pragma mark 调整frame
- (void)adjustFrame
{
    if (_scrollImageView.image == nil) {
        return;
    }
    
    // 基本尺寸参数
    CGSize boundsSize = _scroll.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize imageSize = _scrollImageView.image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    
    // 设置伸缩比例
    CGFloat minScale = boundsWidth / imageWidth;
    if (minScale > 1) {
        minScale = 1.0;
    }
    CGFloat maxScale = 2.0;
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        maxScale = maxScale / [[UIScreen mainScreen] scale];
    }
    _scroll.maximumZoomScale = maxScale;
    _scroll.minimumZoomScale = minScale;
    _scroll.zoomScale = minScale;
    
    CGRect imageFrame = CGRectMake(0, 0, boundsWidth, imageHeight * boundsWidth / imageWidth);
    // 内容尺寸
    _scroll.contentSize = CGSizeMake(0, imageFrame.size.height);
    
    // y值
    if (imageFrame.size.height < boundsHeight) {
        imageFrame.origin.y = floorf((boundsHeight - imageFrame.size.height) / 2.0);
    } else {
        imageFrame.origin.y = 0;
    }
    
    _scrollImageView.frame = imageFrame;
    
}

- (void)removeWaitingView
{
    if( _waitingView != nil ){
        [_waitingView removeFromSuperview];
    }
    _waitingView  =  nil;
}

-(void)reset : (UIImage*)placeholder{
    
    self.image  =  nil;
    [self sd_cancelCurrentImageLoad];
    if( _scrollImageView != nil ){
        [_scrollImageView setImage:placeholder];
    }
    self.hasLoadedImage = NO;
    
    [self removeWaitingView];
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
