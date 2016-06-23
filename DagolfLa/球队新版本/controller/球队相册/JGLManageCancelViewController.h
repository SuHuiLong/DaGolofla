//
//  JGLManageCancelViewController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/6/20.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
#import "JGLTeamMemberModel.h"
/**
 *  资金管理----取消管理页面
 */

@interface JGLManageCancelViewController : ViewController


@property (strong, nonatomic) JGLTeamMemberModel* model;

@property (strong, nonatomic) NSNumber* teamKey;

@property (assign, nonatomic) BOOL isCancel;


@property (copy, nonatomic) void (^blockCancel)();

@property (copy, nonatomic) void (^blockSetting)();

@end
