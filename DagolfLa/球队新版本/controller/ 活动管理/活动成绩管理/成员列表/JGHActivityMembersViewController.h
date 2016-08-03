//
//  JGHActivityMembersViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/1.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
@class JGTeamAcitivtyModel;

@interface JGHActivityMembersViewController : ViewController

@property (assign, nonatomic) NSInteger activityKey;//活动key

@property (assign, nonatomic) NSInteger teamKey;//球队key

@property (nonatomic, strong)JGTeamAcitivtyModel *activityModel;

@end
