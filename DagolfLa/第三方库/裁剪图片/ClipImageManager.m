
//
//  ClipImageManager.m
//  DagolfLa
//
//  Created by SHL on 2017/5/31.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "ClipImageManager.h"

@implementation ClipImageManager

-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(UIImage *)clipImage:(UIImage *)image WithSize:(CGSize )size{
    UIImage *clipImage = image;
    CGSize imageSize = clipImage.size;//图片的size
    CGFloat imageWidth = imageSize.width;//图片宽度
    CGFloat imageHeight = imageSize.height;//图片高度
    
    CGSize clipSize = size;//裁剪的size
    CGFloat clipWidth = clipSize.width;//裁剪成的宽
    CGFloat clipHeight = clipSize.height;//裁剪成的高
    
    CGFloat y_set = imageHeight/2 - imageWidth*clipHeight/(clipWidth*2);
    CGFloat x_set = imageWidth/2 - imageHeight*clipWidth/(clipHeight*2);
    
    
    CGRect clipRect = CGRectMake(0, y_set, imageWidth, imageWidth*clipHeight/clipWidth);
    if (imageWidth/imageHeight>clipWidth/clipHeight) {
        clipRect = CGRectMake(x_set, 0, imageHeight*clipWidth/clipHeight, imageHeight);
    }
    clipImage = [self getSubImage:clipImage rect:clipRect];
    return clipImage;

}


//截取部分图像
-(UIImage*)getSubImage:(UIImage *)image rect:(CGRect)rect{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
    return smallImage;
}


@end
