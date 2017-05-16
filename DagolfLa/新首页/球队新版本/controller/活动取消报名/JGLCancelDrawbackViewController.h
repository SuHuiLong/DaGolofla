//
//  JGLCancelDrawbackViewController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/8/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
@class JGTeamAcitivtyModel;

@interface JGLCancelDrawbackViewController : ViewController

@property (nonatomic, assign)NSInteger activityKey;//活动key

@property (nonatomic, strong)JGTeamAcitivtyModel *model;

@property (nonatomic, strong)NSMutableArray *dataArray;
@end
