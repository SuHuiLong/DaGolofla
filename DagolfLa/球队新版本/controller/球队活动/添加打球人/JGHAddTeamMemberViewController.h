//
//  JGHAddTeamMemberViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGHAddTeamMemberViewController : ViewController

@property (copy, nonatomic) void (^blockFriendDict)(NSMutableDictionary *);
@property (strong, nonatomic) NSMutableDictionary* dictFinish;

@property (assign, nonatomic) NSInteger lastIndex;

@end
