//
//  JGHWithDrawModel.h
//  DagolfLa
//
//  Created by 黄安 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGHWithDrawModel : BaseModel

// 订单key
@property (nonatomic, assign)NSInteger orderKey;

//订单号
@property (nonatomic, strong)NSString *ordersn;

// 来源Key
@property (nonatomic, assign)NSInteger srcKey;

// 业务类型
// 请参照 IOrderType
@property (nonatomic, assign)NSInteger orderType;

// 交易名称
@property (nonatomic, strong)NSString *name;

// 提交时间
@property (nonatomic, strong)NSString *exchangeTime;

// 处理开始时间
@property (nonatomic, strong)NSString *handleTime;

// 最终操作时间
@property (nonatomic, strong)NSString *endchangeTime;

// 备注
@property (nonatomic, strong)NSString *remark;

// 金额
@property (nonatomic, strong)NSNumber *amount;

// 当前账户余额
@property (nonatomic, strong)NSNumber *balance;

// 交易类型
// 请参照 ITransType
@property (nonatomic, assign)NSInteger transType;

// 交易来源
@property (nonatomic, assign)NSInteger transSrc;

// 交易状态
// 请参考 ITransStatus
@property (nonatomic, assign)NSInteger state;

// 支付方式
// 请参考 ITransMethod
@property (nonatomic, assign)NSInteger transMRethod;

// 流水号
@property (nonatomic, strong)NSString *serialNumber;

@end
