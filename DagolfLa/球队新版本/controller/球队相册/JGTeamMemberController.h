//
//  JGTeamMemberController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
#import "JGLTeamMemberModel.h"

@interface JGTeamMemberController : ViewController


@property (strong, nonatomic) NSNumber* teamKey;

@property (assign, nonatomic) BOOL isEdit;

@property (assign, nonatomic) BOOL isManager;

@property (assign, nonatomic) BOOL isGest;//判断是否是嘉宾，嘉宾不需要标记
@property (copy, nonatomic) void (^blockTMemberPeople)(JGLTeamMemberModel*);//嘉宾的回调方法

@property (copy ,nonatomic) NSString *power;

@property(nonatomic,copy)void(^block)(NSInteger str,NSString *str1,NSString *str2);

//球队成员 -1
@property (nonatomic, assign) NSInteger teamMembers;

//队员管理 -1
@property (nonatomic, assign) NSInteger teamManagement;

@end
