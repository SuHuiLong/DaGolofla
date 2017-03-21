//
//  JGHNewPublistActivityViewController.h
//  DagolfLa
//
//  Created by 黄安 on 17/3/16.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "ViewController.h"
@class JGTeamAcitivtyModel;

@interface JGHNewPublistActivityViewController : ViewController

@property (nonatomic, assign)NSInteger teamKey;//发布活动teamkey

@property (strong, nonatomic) void (^refreshBlock)();

@property (nonatomic, copy)NSString *teamName;

@property (nonatomic, strong)JGTeamAcitivtyModel *model;

@property (nonatomic, strong)NSMutableArray *costListArray;//费用列表

@end
