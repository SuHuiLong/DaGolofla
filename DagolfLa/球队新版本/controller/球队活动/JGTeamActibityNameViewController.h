//
//  JGTeamActibityNameViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

typedef void (^LoadData)(void);

@interface JGTeamActibityNameViewController : ViewController

@property (nonatomic, copy) LoadData loadData;

- (void)reloadData:(LoadData)block;

@property (nonatomic, retain) UIImageView *imgProfile;//拉大图片

@property (nonatomic, assign)NSInteger teamKey;//发布活动teamkey

@end
