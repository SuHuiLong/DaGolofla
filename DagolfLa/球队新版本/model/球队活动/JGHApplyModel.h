//
//  JGHApplyModel.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGHApplyModel : BaseModel

@property (assign, nonatomic)NSInteger teamKey;//球队key
@property (assign, nonatomic)NSInteger activityKey;//球队活动id
@property (assign, nonatomic)NSInteger userKey;//报名用户key , 没有则是嘉宾
@property (assign, nonatomic)NSInteger name;//姓名
@property (assign, nonatomic)NSInteger mobile;//手机号
@property (assign, nonatomic)NSInteger almost;//差点
@property (assign, nonatomic)NSInteger isOnlinePay;//是否线上 付款
@property (assign, nonatomic)NSInteger sex;//性别 0: 女 1: 男
@property (assign, nonatomic)NSInteger groupIndex;//组的索引   每组4 人
@property (assign, nonatomic)NSInteger sortIndex;//排序索引号
@property (assign, nonatomic)NSInteger payMoney;//实际付款金额
@property (assign, nonatomic)NSInteger payTime;//实际付款时间
@property (assign, nonatomic)NSInteger subsidyPrice;//补贴价
@property (assign, nonatomic)NSInteger money;//报名费
@property (assign, nonatomic)NSInteger createTime;//报名时间
@property (assign, nonatomic)NSInteger signUpInfoKey;//报名信息的timeKey
@property (assign, nonatomic)NSInteger select;//是否选择

@end
