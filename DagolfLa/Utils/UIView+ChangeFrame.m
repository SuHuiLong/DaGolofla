//
//  UIView+ChangeFrame.m
//  DoubanMovieSample
//
//  Created by lzhr on 15/3/13.
//  Copyright (c) 2015年 lzhr. All rights reserved.
//

#import "UIView+ChangeFrame.h"

@implementation UIView (ChangeFrame)
- (void)changeFrameX:(CGFloat)x
{
    self.frame = CGRectMake(x, self.frameY, self.width, self.height);
}

- (void)changeFrameY:(CGFloat)y
{
    self.frame = CGRectMake(self.frameX, y, self.width, self.height);
}

- (void)changeWidth:(CGFloat)width
{
    self.frame = CGRectMake(self.frameX, self.frameY, width, self.height);
}

- (void)changeHeight:(CGFloat)height
{
    self.frame = CGRectMake(self.frameX, self.frameY, self.width, height);
}

- (CGFloat)frameX
{
    return self.frame.origin.x;
}

- (CGFloat)frameY
{
    return self.frame.origin.y;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

@end
