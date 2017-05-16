//
//  JGHNewActivityDetailViewController.h
//  DagolfLa
//
//  Created by 黄安 on 17/1/6.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGHNewActivityDetailViewController : ViewController

typedef void (^LoadData)(void);

@property (nonatomic, copy) LoadData loadData;

- (void)reloadData:(LoadData)block;

@property (nonatomic, retain) UIImageView *imgProfile;//拉大图片

@property (nonatomic, assign)NSInteger teamKey;//发布活动teamkey

@end
