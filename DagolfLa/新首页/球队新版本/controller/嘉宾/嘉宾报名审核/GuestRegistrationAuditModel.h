//
//  GuestRegistrationAuditModel.h
//  DagolfLa
//
//  Created by SHL on 2017/5/24.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuestRegistrationAuditModel : NSObject

//球队key
@property (nonatomic, assign)NSInteger teamKey;
//球队活动id
@property (nonatomic, assign)NSInteger activityKey;
//报名用户key , 没有则是嘉宾
@property (nonatomic, assign)NSNumber *signupUserKey;
//报名用户 , 没有则是嘉宾
@property (nonatomic, assign)NSString *signupUserName;
//
@property (nonatomic,copy) NSString *timeKey;
//用户id
@property (nonatomic,copy) NSString *userKey;
//手机号
@property (nonatomic, copy)NSString *mobile;
//姓名
@property (nonatomic,copy) NSString *name;
//性别 0:女 1：男
@property (nonatomic,assign) NSInteger sex;
//差点
@property (nonatomic,assign) NSInteger almost;
//类型: 0:球队队员  1:嘉宾
@property (nonatomic, assign)NSInteger userType;
//创建时间
@property (nonatomic,copy) NSString *createTime;
//当前状态
@property (nonatomic,copy) NSString *stateButtonString;
//显示状态
@property (nonatomic,copy) NSString *stateShowString;

@end
