//
//  JGLDrawalRecordModel.h
//  DagolfLa
//
//  Created by 黄达明 on 16/7/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGLDrawalRecordModel : BaseModel


@property (strong, nonatomic) NSString* serialNumber;//叫易流水号

@property (strong, nonatomic) NSNumber* userKey;

@property (strong, nonatomic) NSNumber* orderKey;

@property (strong, nonatomic) NSString* ordersn;//订单号字符串

@property (strong, nonatomic) NSNumber* srcKey;//来源Key

@property (strong, nonatomic) NSNumber* orderType;//业务类型

@property (strong, nonatomic) NSString* name;//交易名称

@property (strong, nonatomic) NSString* exchangeTime;//提交时间

@property (strong, nonatomic) NSString* handleTime;//处理开始时间

@property (strong, nonatomic) NSString* endchangeTime;//最终操作时间

@property (strong, nonatomic) NSString* remark;

@property (strong, nonatomic) NSNumber* amount;//金额

@property (strong, nonatomic) NSNumber* balance;//余额

@property (strong, nonatomic) NSNumber* transType;//交易类型

@property (strong, nonatomic) NSNumber* transSrc;//交易来源

@property (strong, nonatomic) NSNumber* state;//交易状态

@property (strong, nonatomic) NSNumber* transMRethod;//支付方式

@property (strong, nonatomic) NSString* wrongReason;//错误原因

@property (strong, nonatomic) NSNumber* thirdagree;// 第三方账单是否一致 0: 没对账  1: 对账一致  2: 对账不一致

@property (strong, nonatomic) NSString* userName;


@end
