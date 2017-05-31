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

//添加打球人
-(void)addApplyerBtn;
// true：返回到替朋友报名界面 flash：返回上一页
@property (nonatomic,assign) BOOL isPushToDetail;

@end
