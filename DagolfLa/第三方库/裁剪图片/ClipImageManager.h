//
//  ClipImageManager.h
//  DagolfLa
//
//  Created by SHL on 2017/5/31.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClipImageManager : NSObject

/**
 裁剪图片

 @param image 被裁剪照片
 @param size 需要的尺寸
 @return 裁剪之后的图片
 */
-(UIImage *)clipImage:(UIImage *)image WithSize:(CGSize)size;

@end
