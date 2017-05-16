//
//  JGHAddApplyTeamPlaysViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
@class JGLTeamMemberModel;

@interface JGHAddApplyTeamPlaysViewController : ViewController

@property (copy, nonatomic) void (^blockFriendDict)(JGLTeamMemberModel *model);
@property (strong, nonatomic) NSMutableDictionary* dictFinish;

@property (assign, nonatomic) NSInteger lastIndex;

@property (nonatomic, assign)NSInteger activityKey;//活动Key

@property (nonatomic, assign)NSInteger teamKey;//球队Key

@property (nonatomic, strong)NSMutableArray *userKeyArray;

@end
