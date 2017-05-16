//
//  JGHCustomAwardViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
@class JGHAwardModel;

@interface JGHCustomAwardViewController : ViewController

@property (nonatomic, assign)NSInteger activityKey;

@property (nonatomic, assign)NSInteger teamKey;

//@property (nonatomic, assign)NSInteger prizeKey;

@property (nonatomic, strong)JGHAwardModel *model;

@end
