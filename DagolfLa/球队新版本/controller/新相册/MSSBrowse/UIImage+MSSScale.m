//
//  UIImage+MSSScale.m
//  MSSBrowse
//
//  Created by 于威 on 15/12/6.
//  Copyright © 2015年 于威. All rights reserved.
//

#import "UIImage+MSSScale.h"

@implementation UIImage (MSSScale)

// 得到图像显示完整后的宽度和高度
- (CGRect)mss_getBigImageRectSizeWithScreenWidth:(CGFloat)screenwidth screenheight:(CGFloat)screenheight
{
    CGFloat widthRatio = screenwidth / self.size.width;
    CGFloat heightRatio = screenheight / self.size.height;
    CGFloat scale = MIN(widthRatio, heightRatio);
    CGFloat width = scale * self.size.width;
    CGFloat height = scale * self.size.height;
    return CGRectMake((screenwidth - width) / 2, (screenheight - height) / 2, width, height);
}

@end
