//
//  JGMemManageController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
#import "JGLTeamMemberModel.h"
@interface JGMemManageController : ViewController


@property (strong, nonatomic) JGLTeamMemberModel* model;

@property (strong, nonatomic) NSString* power;
//球队的timekey
@property (strong, nonatomic) NSNumber* teamKey;


@property (copy, nonatomic) void(^deleteBlock)();

@end
