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
@property (assign, nonatomic) NSInteger createTime;
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
//嘉宾价
@property (strong, nonatomic) NSNumber* guestPrice;
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

@property (assign, nonatomic) NSInteger teamActivityKey;

//活动头像
@property (nonatomic, strong) UIImage *headerImage;

//活动背景
@property (nonatomic, strong) UIImage *bgImage;

//活动详情
@property (nonatomic, strong) NSString *details;


@end
