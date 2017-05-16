//
//  JGHNewEditorActivityViewController.h
//  DagolfLa
//
//  Created by 黄安 on 17/3/17.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "ViewController.h"
@class JGTeamAcitivtyModel;

@interface JGHNewEditorActivityViewController : ViewController

@property (nonatomic, retain) UIImageView *imgProfile;

//@property (nonatomic, assign)NSInteger teamKey;//发布活动teamkey

@property (nonatomic, strong)JGTeamAcitivtyModel *model;

@property (strong, nonatomic) void (^refreshBlock)();




@end
