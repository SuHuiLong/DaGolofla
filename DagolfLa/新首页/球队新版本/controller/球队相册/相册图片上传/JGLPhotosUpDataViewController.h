//
//  JGLPhotosUpDataViewController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/9/18.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
/**
 *  相册多张图片上传
 */
@interface JGLPhotosUpDataViewController : ViewController

@property (nonatomic, retain)NSString *albumName;

@property (strong, nonatomic) NSNumber* albumKey;

@property (copy, nonatomic) void(^blockRefresh)();

@end
