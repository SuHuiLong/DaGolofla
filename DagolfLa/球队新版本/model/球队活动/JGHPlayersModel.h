//
//  JGHPlayersModel.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGHPlayersModel : BaseModel

@property (nonatomic, assign)NSInteger teamKey;//球队key

@property (nonatomic, assign)NSInteger activityKey;//球队活动id

@property (nonatomic, assign)NSInteger userKey;//报名用户key , 没有则是嘉宾

@property (nonatomic, copy)NSString *name;//姓名

@property (nonatomic, copy)NSString *mobile;//手机号

@property (nonatomic, assign)NSInteger almost;//差点

@property (nonatomic, assign)NSInteger isOnlinePay;//是否线上 付款 0-否，是－1

@property (nonatomic, assign)NSInteger sex;//性别 0: 女 1: 男

@property (nonatomic, assign)NSInteger groupIndex;//组的索引   每组4 人

@property (nonatomic, assign)NSInteger sortIndex;//排序索引号，默认－1（未排序）

@property (nonatomic, assign)NSInteger payMoney;//实际付款金额

@property (nonatomic, copy)NSString *payTime;//实际付款时间

@property (nonatomic, assign)NSInteger subsidyPrice;//补贴价

@property (nonatomic, assign)NSInteger money;//报名费

@property (nonatomic, copy)NSString *createTime;//报名时间

@property (nonatomic, assign)NSInteger signUpInfoKey;//报名信息的timeKey

@property (nonatomic, assign)NSInteger type;//类型: 0:嘉宾  1:球队队员


@end
