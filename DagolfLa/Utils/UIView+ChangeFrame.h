//
//  UIView+ChangeFrame.h
//  DoubanMovieSample
//
//  Created by lzhr on 15/3/13.
//  Copyright (c) 2015年 lzhr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ChangeFrame)

- (void)changeFrameX:(CGFloat)x;
- (void)changeFrameY:(CGFloat)y;
- (void)changeWidth:(CGFloat)width;
- (void)changeHeight:(CGFloat)height;

- (CGFloat)frameX;
- (CGFloat)frameY;
- (CGFloat)width;
- (CGFloat)height;

@end
