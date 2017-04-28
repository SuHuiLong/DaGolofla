//
//  JGHChooseAwardViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGHChooseAwardViewController : ViewController

@property (copy, nonatomic) void (^refreshBlock)(NSMutableArray *);


@property (nonatomic, assign)NSInteger activityKey;

@property (nonatomic, assign)NSInteger teamKey;

@property (nonatomic, strong)NSMutableArray *selectChooseArray;

@end
