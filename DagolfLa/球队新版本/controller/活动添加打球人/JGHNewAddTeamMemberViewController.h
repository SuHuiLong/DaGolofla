//
//  JGHAddTeamMemberViewController.h
//  DagolfLa
//
//  Created by 黄安 on 17/2/13.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "ViewController.h"
@class MyattenModel;

@interface JGHNewAddTeamMemberViewController : ViewController

@property (copy, nonatomic) void (^blockPalyFriendArray)(NSMutableArray *listArray);
@property (strong, nonatomic) NSMutableDictionary* dictFinish;

@property (assign, nonatomic) NSInteger lastIndex;

@property (nonatomic, strong)NSMutableArray *userKeyArray;

@property (strong, nonatomic)NSMutableArray *allListArray;


@end
