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

@property (copy, nonatomic) void (^refreshBlock)();

//@property (nonatomic, assign) NSInteger isManager; //1- 管理员，0-非管理员

@end
