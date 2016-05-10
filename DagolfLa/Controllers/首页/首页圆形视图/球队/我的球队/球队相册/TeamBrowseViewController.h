//
//  TeamBrowseViewController.h
//  DagolfLa
//
//  Created by bhxx on 15/11/27.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface TeamBrowseViewController : ViewController
@property (copy, nonatomic) void(^deleteBlock)(NSInteger index);

- (instancetype)initWithIndex:(NSInteger)index selectImages:(NSMutableArray *)selectImages;

@end