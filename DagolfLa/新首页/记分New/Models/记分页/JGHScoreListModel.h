//
//  JGHScoreListModel.h
//  DagolfLa
//
//  Created by 黄安 on 16/7/19.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGHScoreListModel : BaseModel


// 邀请码
@property (nonatomic, strong)NSString *invitationCode;

// 用户Key
@property (nonatomic, strong)NSNumber *userKey;

// 用户名称
@property (nonatomic, strong)NSString *userName;

// 手机号
@property (nonatomic, strong)NSString *userMobile;

// 差点
@property (nonatomic, strong)NSNumber *almost;

// T台
@property (nonatomic, strong)NSString *tTaiwan;

// 球队杆数
@property (nonatomic, strong)NSArray *poleNumber;

// 标准杆树
@property (nonatomic, strong)NSArray *standardlever;

// 推杆
@property (nonatomic, strong)NSArray *pushrod;

// 是否上球道
@property (nonatomic, strong)NSArray *onthefairway;

//球洞mingc
@property (nonatomic, strong)NSArray *poleNameList;

//所有区域
@property (nonatomic, strong)NSArray *areaArray;

// timeKey
@property (nonatomic, strong)NSNumber *timeKey;

@property (nonatomic, copy)NSString *region1;

@property (nonatomic, copy)NSString *region2;

@property (nonatomic, strong)NSDictionary *score;

@property (nonatomic, strong)NSArray *ballAreas;

@property (nonatomic, strong)NSNumber *interval;//定时器间隔时间

@property (nonatomic, copy)NSString *finish;//是否完成

@property (nonatomic, assign)NSInteger switchMode;

@end
