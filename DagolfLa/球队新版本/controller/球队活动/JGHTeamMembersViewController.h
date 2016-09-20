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

@property (nonatomic, strong)NSMutableArray *teamGroupAllDataArray;

//组号
@property (nonatomic, assign)NSInteger groupIndex;

//排序索引
@property (nonatomic, assign)NSInteger sortIndex;


@property (nonatomic, assign)NSInteger oldSignUpKey;//老的球队活动报名人timeKey


//@property (nonatomic, assign)NSInteger isload;// 1- 需要下载数据

@property (nonatomic, assign)NSInteger activityKey;//活动key


@end
