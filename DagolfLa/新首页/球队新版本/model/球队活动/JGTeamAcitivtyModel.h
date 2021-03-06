//
//  JGTeamAcitivtyModel.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/10.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGTeamAcitivtyModel : BaseModel

//活动列表标题
@property (copy, nonatomic) NSString *name;
//活动是否结束 0 : 开始 , 1 : 已结束
@property (assign, nonatomic) NSInteger isClose;
//活动id
@property (copy, nonatomic) NSString *timeKey;
//球队id
@property (assign, nonatomic) NSInteger teamKey;
//ts
@property (copy, nonatomic) NSString *ts;
//用户id
@property (assign, nonatomic) NSInteger userKey;
//创建时间
@property (copy, nonatomic) NSString *createTime;
//开始时间
@property (copy, nonatomic) NSString *beginDate;
//结束时间
@property (copy, nonatomic) NSString *endDate;
//报名截止时间
@property (copy, nonatomic) NSString *signUpEndTime;
//球场名称
@property (copy, nonatomic) NSString *ballName;
//报名人数
@property (assign, nonatomic) NSInteger sumCount;
//会员价
@property (strong, nonatomic) NSNumber* memberPrice;
//补贴价
@property (strong, nonatomic) NSNumber* subsidyPrice;
//嘉宾补贴价
@property (strong, nonatomic) NSNumber* guestSubsidyPrice;
//嘉宾价
@property (strong, nonatomic) NSNumber* guestPrice;
//球队会员记名价
@property (strong, nonatomic) NSNumber* billNamePrice;
//球队会员不记名价
@property (strong, nonatomic) NSNumber* billPrice;
//syncFlag
@property (assign, nonatomic) NSInteger syncFlag;
//rsyncFlag
@property (assign, nonatomic) NSInteger rsyncFlag;
//最大人数
@property (assign, nonatomic) NSInteger maxCount;
//活动介绍
@property (copy, nonatomic) NSString *info;
//球场id
@property (assign, nonatomic) NSInteger ballKey;
//联系人
@property (copy, nonatomic) NSString *userName;
//联系人电话
@property (copy, nonatomic) NSString *userMobile;
//联系人电话
@property (copy, nonatomic) NSString *mobile;
//活动id
@property (assign, nonatomic) NSInteger teamActivityKey;

//活动头像
@property (nonatomic, strong) UIImage *headerImage;

//活动背景
@property (nonatomic, strong) UIImage *bgImage;

//活动详情
@property (nonatomic, strong) NSString *details;

//活动地址
@property (nonatomic, copy) NSString *ballAddress;
//类型
@property (assign, nonatomic) NSInteger type;

//取消原因canSignUpReason
@property (nonatomic, strong)NSString *canSignUpReason;
//退款原因refoundReason
@property (nonatomic, strong)NSNumber *payMoney;

@property (nonatomic, strong)NSNumber *money;
//用来记录是否选中
@property (nonatomic, assign) BOOL isClick;

@property (nonatomic, strong) NSString* awardedInfo;

@property (nonatomic, strong) NSString* costName;

@property (nonatomic, strong)NSNumber *matchKey;

@property (nonatomic, copy) NSString* teamName;

//是否允许嘉宾报名
@property (nonatomic,strong) NSNumber *allowGuestsSignup;


@end
