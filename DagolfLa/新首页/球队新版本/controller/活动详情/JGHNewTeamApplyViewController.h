//
//  JGHNewTeamApplyViewController.h
//  DagolfLa
//
//  Created by 黄安 on 17/1/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "ViewController.h"
@class JGTeamAcitivtyModel;

@interface JGHNewTeamApplyViewController : ViewController

//activityKey
@property (nonatomic, strong)JGTeamAcitivtyModel *modelss;

//用户在球队的真实姓名
@property (nonatomic, strong)NSString *userName;

//当前登录用户是否已经报名 0 - 未报名  1 － 已报名
@property (nonatomic, assign)BOOL isApply;

@property (nonatomic, strong)NSDictionary *teamMember;

@end
