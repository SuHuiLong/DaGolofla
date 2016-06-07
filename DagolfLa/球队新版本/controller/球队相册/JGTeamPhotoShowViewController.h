//
//  JGTeamPhotoShowViewController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/6/7.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
//相册看大图
@interface JGTeamPhotoShowViewController : ViewController

- (instancetype)initWithIndex:(NSInteger)index;

@property (strong, nonatomic) NSMutableArray *selectImages;

@property (strong, nonatomic) NSString* power;

@property (copy, nonatomic) void(^deleteBlock)(NSInteger index);

@end
