//
//  ActivityDetailModel.h
//  DagolfLa
//
//  Created by SHL on 2017/5/17.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityDetailModel : NSObject
//icon
@property (nonatomic,copy) NSString *iconStr;
//用户timekey
@property (nonatomic,copy) NSString *timeKey;
//描述
@property (nonatomic,copy) NSString *desc;
//是否为空model
@property (nonatomic,assign) BOOL isEmpty;
//价格
@property (nonatomic,copy) NSString *price;
//活动成员
@property (nonatomic,copy) NSString *activityPlayer;
//球队key
@property (nonatomic, assign)NSInteger teamKey;
//球队活动id
@property (nonatomic, assign)NSInteger activityKey;
//报名用户key , 没有则是嘉宾
@property (nonatomic, assign)NSNumber *signupUserKey;
//报名用户 , 没有则是嘉宾
@property (nonatomic, copy)NSString *signupUserName;
@property (nonatomic, copy)NSString *signupUame;
//手机号
@property (nonatomic, copy)NSString *mobile;
//姓名
@property (nonatomic,copy) NSString *name;
//用户id
@property (nonatomic,copy) NSString *userKey;
//性别 0:女 1：男
@property (nonatomic,assign) NSInteger sex;
//差点
@property (nonatomic,assign) NSInteger almost;
//类型: 0:球队队员  1:嘉宾
@property (nonatomic, assign)NSInteger userType;
//显示的球员类型
@property (nonatomic,copy) NSString *showName;
//来源 1-队员，2-球友
@property (nonatomic,assign) NSInteger selectID;
@end
