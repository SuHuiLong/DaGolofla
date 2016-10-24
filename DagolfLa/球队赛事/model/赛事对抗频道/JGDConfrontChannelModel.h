//
//  JGDConfrontChannelModel.h
//  DagolfLa
//
//  Created by 東 on 16/10/18.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGDConfrontChannelModel : BaseModel

@property (nonatomic, copy) NSString *ballName;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *userMobile;

@property (nonatomic, copy) NSString *matchName;

@property (nonatomic, copy) NSString *matchTypeName; // 比赛类型

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *beginDate;

@property (nonatomic, strong) NSNumber *timeKey;

//@property (nonatomic, strong) NSNumber *userKey;

// state
// 我的 1:邀请中，2:已加入，3：其他成员同意加入后为等待加入", defaultValue="0"
// 热门 10 是报名中 11 是比赛中 12 已结束
@property (nonatomic, strong) NSNumber *state;

@property (nonatomic, strong) NSNumber *delFlag;

@property (nonatomic, strong) NSNumber *teamKey;

@property (nonatomic, strong) NSNumber *matchKey;

@property (nonatomic, strong) NSNumber *rsyncFlag;

@property (nonatomic, strong) NSNumber *sumCount;

@end
