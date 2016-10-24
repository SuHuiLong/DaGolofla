//
//  JGHPublishEventSaveViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/10/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
@class JGHPublishEventModel;

@interface JGHPublishEventSaveViewController : ViewController

@property (nonatomic, retain) UIImageView *imgProfile;

@property (nonatomic, assign)NSInteger teamKey;//发布活动teamkey

@property (nonatomic, strong)JGHPublishEventModel *model;

@property (strong, nonatomic) void (^refreshBlock)();

@property (nonatomic, strong)NSMutableArray *costListArray;//费用列表

@property (nonatomic, strong)NSMutableArray *rulesArray;//规则信息

@property (nonatomic, strong)NSString *rulesTimeKey;

@end
