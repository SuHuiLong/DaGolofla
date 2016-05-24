//
//  JGTeamDetail.h
//  DagolfLa
//
//  Created by 東 on 16/5/18.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"
#import "JGTeamDetail.h"

@interface JGTeamDetail : BaseModel

@property (nonatomic, copy) NSString *name; // 球队名称
@property (nonatomic, copy) NSDate *createtime;
@property (nonatomic, copy) NSString *crtyName;
@property (nonatomic, copy) NSString *info; // 球队介绍
@property (nonatomic, copy) NSString *notice; // 球队公告
@property (nonatomic, copy) NSString *money; //球队会费
@property (nonatomic, assign) NSInteger check; // 是否需要管理员审核 off ＝ 0  on ＝ 1
@property (nonatomic, copy) NSString *userName; // 申请人姓名
@property (nonatomic, copy) NSString *userMobile;
@property (nonatomic, copy) NSString *createUserKey; // 球队创建人id
@property (nonatomic, copy) NSString *createUserName;
@property (nonatomic, copy) NSString *establishTime; // 球队创建时间
@property (nonatomic, assign) NSInteger userNum; // 球队总人数
@property (nonatomic, assign) NSInteger clickNum; // 点击量
@property (nonatomic, copy) NSString *geohash; // 坐标信息
@property (nonatomic, copy) NSString *answerName; // 回答咨询人姓名
@property (nonatomic, assign) NSInteger answerKey; // 回答咨询人用户key



@property (nonatomic, strong)JGTeamDetail *detailModel;
@end
