//
//  JGTeamActibityNameViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
@class JGTeamAcitivtyModel;

@interface JGTeamActibityNameViewController : ViewController

//yes-报名，no-未报名
@property (nonatomic, assign)BOOL isApply;

//发布页面过来的数据
@property (nonatomic, strong)JGTeamAcitivtyModel *model;

//活动id
@property (nonatomic, assign)NSInteger teamActivityKey;

@property (nonatomic, retain) UIImageView *imgProfile;//拉大图片

//发布页面过来的数据字典
@property (nonatomic, strong)NSMutableDictionary *activityDict;

@property (nonatomic, assign)NSInteger isAdmin;//活动创建 1

@end
