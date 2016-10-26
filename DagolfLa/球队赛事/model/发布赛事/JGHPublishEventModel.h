//
//  JGHPublishEventModel.h
//  DagolfLa
//
//  Created by 黄安 on 16/9/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGHPublishEventModel : BaseModel

@property (assign, nonatomic) NSInteger timeKey;//赛事timeKey
@property (strong, nonatomic) NSNumber* userKey;//创建用户key
@property (strong, nonatomic) NSString* userName;//联系人名字
@property (strong, nonatomic) NSString* userMobile;//联系人电话
@property (strong, nonatomic) NSString* matchName;//"赛事名字
@property (strong, nonatomic) NSString* signUpEndTime;//赛事报名截止时间
@property (strong, nonatomic) NSString* canSignUpEndTime;//取消赛事报名截止时间
@property (strong, nonatomic) NSString* beginDate;//赛事开始时间
@property (strong, nonatomic) NSString* endDate;//赛事结束时间
@property (strong, nonatomic) NSNumber* ballKey;//球场id
@property (strong, nonatomic) NSString* ballName;//球场名称
@property (strong, nonatomic) NSString* ballGeohash;//球场坐标
@property (strong, nonatomic) NSString* info;//赛事简介
@property (strong, nonatomic) NSString* costInfo;//费用说明
@property (strong, nonatomic) NSNumber* billNamePrice;//球队会员记名价
@property (strong, nonatomic) NSNumber* billPrice;//球队会员不记名价
@property (strong, nonatomic) NSString* subsidyBeginTime;//补贴开始时间
@property (strong, nonatomic) NSString* subsidyEndTime;//补贴结束时间
@property (strong, nonatomic) NSNumber* subsidyPrice;//队员补贴价
@property (strong, nonatomic) NSNumber* guestSubsidyPrice;//非队员补贴价
@property (strong, nonatomic) NSString* costJson;//所有费用详情json ActivityCost对象列表
@property (assign, nonatomic) NSInteger invitationTeamKeys;//邀请的球队keys  格式  1,2,3
@property (assign, nonatomic) NSInteger openType;//赛事是否结束 0 : 对所有人开放 , 1 : 对所有球队及其球队成员公开   , 2 :对邀请球队成员公开
@property (assign, nonatomic) NSInteger isClose;//赛事是否结束 0 : 开始 , 1 : 已结束
@property (assign, nonatomic) NSInteger sumCount;//赛事报名总人数
@property (strong, nonatomic) NSNumber* sumMoney;//赛事总金额
@property (strong, nonatomic) NSString* details;//赛事详情
@property (strong, nonatomic) NSString* matchTypeName;//赛事详情
@property (strong, nonatomic) NSString* matchTypeKey;

@property (nonatomic, strong) UIImage *bgImage;//背景图
/*
	@FieldType(type = Types.TIMESTAMP , explain = "赛事创建时间" , indexType = Indexs.NORMAL_INDEX, Null=false)
	public Date createTime;
 */



// 近期活动进入   活动名称 ＝＝ 赛事名
@property (strong, nonatomic) NSString* name;//联系人名字



@end
