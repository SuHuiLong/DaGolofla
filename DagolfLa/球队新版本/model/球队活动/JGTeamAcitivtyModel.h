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
//报名
@property (strong, nonatomic) NSString *Apply;
//活动id
@property (assign, nonatomic) NSInteger *teamActivityKey;
//球队id
@property (assign, nonatomic) NSInteger *teamKey;
//用户id
@property (assign, nonatomic) NSInteger *userKey;
//创建时间
@property (assign, nonatomic) NSInteger *createTime;
//开始时间
@property (assign, nonatomic) NSInteger *beginDate;
//结束时间
@property (assign, nonatomic) NSInteger *endDate;
//活动地址
@property (strong, nonatomic) NSString *ballName;
//报名人数
@property (assign, nonatomic) NSInteger *sumCount;

@end
