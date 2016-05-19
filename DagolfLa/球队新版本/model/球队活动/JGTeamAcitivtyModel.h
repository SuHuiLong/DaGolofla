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
@property (strong, nonatomic) NSString *name;
//活动是否结束 0 : 开始 , 1 : 已结束
@property (assign, nonatomic) NSInteger isClose;
//活动id －－
@property (assign, nonatomic) NSInteger teamActivityKey;//徐东东确认删除
//活动id
@property (assign, nonatomic) NSInteger timeKey;
//球队id
@property (assign, nonatomic) NSInteger teamKey;
//ts
@property (assign, nonatomic) NSInteger ts;
//用户id
@property (assign, nonatomic) NSInteger userKey;
//创建时间
@property (assign, nonatomic) NSInteger createTime;
//开始时间
@property (assign, nonatomic) NSInteger beginDate;
//结束时间
@property (assign, nonatomic) NSInteger endDate;
//地区
@property (strong, nonatomic) NSString *ballName;
//报名人数
@property (assign, nonatomic) NSInteger sumCount;
//会员价
@property (assign, nonatomic) NSInteger memberPrice;
//补贴价
@property (assign, nonatomic) NSInteger subsidyPrice;
//嘉宾价
@property (assign, nonatomic) NSInteger guestPrice;
//syncFlag
@property (assign, nonatomic) NSInteger syncFlag;
//rsyncFlag
@property (assign, nonatomic) NSInteger rsyncFlag;
//最大人数
@property (assign, nonatomic) NSInteger maxCount;
//活动介绍
@property (copy, nonatomic) NSString *info;

@end
