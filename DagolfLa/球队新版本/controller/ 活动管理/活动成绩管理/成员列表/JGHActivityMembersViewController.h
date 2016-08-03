//
//  JGHActivityMembersViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/1.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGHActivityMembersViewController : ViewController

@property (copy, nonatomic) void (^blockFriendDict)(NSMutableDictionary *);
@property (strong, nonatomic) NSMutableDictionary* dictFinish;

@property (assign, nonatomic) NSInteger lastIndex;

@property (assign, nonatomic) NSInteger activityKey;//活动key

@property (assign, nonatomic) NSInteger teamKey;//球队key

@end
