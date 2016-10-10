//
//  JGHPublishEventSaveViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
@class JGTeamAcitivtyModel;

@interface JGHPublishEventSaveViewController : ViewController

@property (nonatomic, retain) UIImageView *imgProfile;

@property (nonatomic, assign)NSInteger teamKey;//发布活动teamkey

@property (nonatomic, strong)JGTeamAcitivtyModel *model;

@property (strong, nonatomic) void (^refreshBlock)();

@property (nonatomic, strong)NSMutableArray *costListArray;//费用列表


@end
