//
//  JGLPresentAwardViewController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
@class JGTeamAcitivtyModel;

@interface JGLPresentAwardViewController : ViewController

@property (nonatomic, assign)NSInteger activityKey;

@property (nonatomic, assign)NSInteger teamKey;

@property (nonatomic, strong)JGTeamAcitivtyModel *model;

@end
