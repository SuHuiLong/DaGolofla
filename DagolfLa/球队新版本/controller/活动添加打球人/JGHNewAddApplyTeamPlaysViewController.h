//
//  JGHNewAddApplyTeamPlaysViewController.h
//  DagolfLa
//
//  Created by 黄安 on 17/2/13.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "ViewController.h"
@class JGLTeamMemberModel;

@interface JGHNewAddApplyTeamPlaysViewController : ViewController

@property (copy, nonatomic) void (^blockFriendArray)(NSMutableArray *listArray);
@property (strong, nonatomic) NSMutableDictionary* dictFinish;

@property (assign, nonatomic) NSInteger lastIndex;

@property (nonatomic, assign)NSInteger activityKey;//活动Key

@property (nonatomic, assign)NSInteger teamKey;//球队Key

@property (nonatomic, strong)NSMutableArray *userKeyArray;

@property (strong, nonatomic)NSMutableArray *allListArray;


@end
