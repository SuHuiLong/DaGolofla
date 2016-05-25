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

@property (nonatomic, strong)JGTeamAcitivtyModel *model;

//活动id
@property (nonatomic, assign)NSInteger teamActivityKey;

@property (nonatomic, retain) UIImageView *imgProfile;//拉大图片


@end
