//
//  JGHNewAddTeamPlaysViewController.h
//  DagolfLa
//
//  Created by 黄安 on 17/1/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGHNewAddTeamPlaysViewController : ViewController

@property (nonatomic, strong)NSMutableArray *costListArray;//资费类型

@property (nonatomic, strong)NSMutableArray *playListArray;//打球人

@property (nonatomic, assign)NSInteger activityKey;//活动Key

@property (nonatomic, assign)NSInteger teamKey;//球队Key

@property (copy, nonatomic) void (^blockPlayListArray)(NSMutableArray *listArray);

// true：返回到替朋友报名界面 flash：返回上一页
@property (nonatomic,assign) BOOL isPushToDetail;
@end
