//
//  JGHTeamMembersViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@protocol JGHTeamMembersViewControllerDelegate <NSObject>

- (void)didSelectMembers:(NSMutableDictionary *)dict;

@end

@interface JGHTeamMembersViewController : ViewController

@property (nonatomic, weak)id <JGHTeamMembersViewControllerDelegate> delegate;

@property (nonatomic, strong)NSArray *teamGroupAllDataArray;

//组号
@property (nonatomic, assign)NSInteger groupIndex;

//排序索引
@property (nonatomic, assign)NSInteger sortIndex;

// 老的球队活动报名人timeKey
@property (nonatomic, assign)NSInteger oldSignUpKey;


@end
