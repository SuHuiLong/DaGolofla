//
//  SelectPhotoAsHeaderViewController.h
//  DagolfLa
//
//  Created by SHL on 2017/5/31.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "ViewController.h"
typedef void (^selectUrl)(NSInteger picTimeKey);

@interface SelectPhotoAsHeaderViewController : ViewController
@property (nonatomic,copy) NSNumber *albumKey;

@property (nonatomic,copy) selectUrl selectUrl;
@end
