//
//  RedPacketModel.h
//  DagolfLa
//
//  Created by SHL on 2017/6/7.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedPacketModel : NSObject
//用户手机号
@property (nonatomic,copy) NSString *mobile;
//名称
@property (nonatomic,copy) NSString *name;
//有效期截止时间
@property (nonatomic,copy) NSString *expiryEnd;
//最低消费可使用
@property (nonatomic,assign) NSInteger minSellMoney;
//使用范围
@property (nonatomic,assign) NSInteger useRange;
//抵扣金额
@property (nonatomic,assign) NSInteger money;
//状态
@property (nonatomic,assign) NSInteger state;
//使用订单号
@property (nonatomic,assign) NSInteger orderKey;
//timeKey
@property (nonatomic,copy) NSString *timeKey;
//红包key
@property (nonatomic,assign) NSInteger redPackKey;
//领取时间
@property (nonatomic,copy) NSString *createTime;
//使用时间
@property (nonatomic,copy) NSString *usedTime;
//剩余天数
@property (nonatomic,assign) NSInteger remainingtime;
//优惠券状态显示字符串
@property (nonatomic,copy) NSString *stateShowString;
//订单状态按钮字符串
@property (nonatomic,copy) NSString *stateButtonString;
//是否可用 no为可用 yes为不可用
@property (nonatomic,assign) BOOL unusable;

@end
