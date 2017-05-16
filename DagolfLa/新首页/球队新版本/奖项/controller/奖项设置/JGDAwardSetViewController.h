//
//  JGDAwardSetViewController.h
//  DagolfLa
//
//  Created by 東 on 2017/4/25.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "ViewController.h"
#import "JGTeamAcitivtyModel.h"

@interface JGDAwardSetViewController : ViewController

@property (nonatomic, assign)NSInteger activityKey;

@property (nonatomic, assign)NSInteger teamKey;

@property (nonatomic, strong)JGTeamAcitivtyModel *model;

@property (copy, nonatomic) void (^refreshBlock)();

@end
