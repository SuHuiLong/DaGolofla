//
//  JGHSetAwardViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/7/4.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
@class JGTeamAcitivtyModel;

@interface JGHSetAwardViewController : ViewController

@property (nonatomic, assign)NSInteger activityKey;

@property (nonatomic, assign)NSInteger teamKey;

@property (nonatomic, strong)JGTeamAcitivtyModel *model;

@end
