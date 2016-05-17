//
//  JGTeamActibityNameViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
@class JGHLaunchActivityModel;

@interface JGTeamActibityNameViewController : ViewController

//yes-报名，no-未报名
@property (nonatomic, assign)BOOL isApply;

//0－管理员  1-非管理员
@property (nonatomic, copy)NSString *isAdmin;

@property (nonatomic, strong)JGHLaunchActivityModel *model;

@end
