//
//  JGHAddTeamPlaysViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/8/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGHAddTeamPlaysViewController : ViewController

@property (nonatomic, strong)NSMutableArray *costListArray;//资费类型

@property (nonatomic, strong)NSMutableArray *playListArray;//打球人

@property (nonatomic, assign)NSInteger activityKey;//活动Key

@property (nonatomic, assign)NSInteger teamKey;//球队Key

@property (copy, nonatomic) void (^blockPlayListArray)(NSMutableArray *listArray);

@end
