//
//  JGHActicityDetailsViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/6/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
@class JGTeamAcitivtyModel;

@interface JGHActicityDetailsViewController : ViewController

@property (nonatomic, assign)NSInteger activityKey;//我的活动key

@property (nonatomic, retain) UIImageView *imgProfile;//拉大图片

@property (nonatomic, strong)JGTeamAcitivtyModel *model;

@property (copy, nonatomic) void (^refreshBlock)();

@end
