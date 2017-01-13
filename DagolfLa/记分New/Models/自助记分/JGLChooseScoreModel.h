//
//  JGLChooseScoreModel.h
//  DagolfLa
//
//  Created by 黄达明 on 16/7/19.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGLChooseScoreModel : BaseModel



@property (strong, nonatomic) NSNumber* teamKey;//球队key

@property (strong, nonatomic) NSNumber* userKey;//创建用户key

@property (strong, nonatomic) NSString* userName;

@property (strong, nonatomic) NSString* userMobile;

@property (strong, nonatomic) NSString* name;//活动名字

@property (strong, nonatomic) NSString* signUpEndTime;//活动报名截止时间

@property (strong, nonatomic) NSString* beginDate;//活动开始时间

@property (strong, nonatomic) NSString* endDate;

@property (strong, nonatomic) NSString* ballKey;

@property (strong, nonatomic) NSString* ballName;

@property (strong, nonatomic) NSString* ballGeohash;//球场坐标

@property (strong, nonatomic) NSString* info;//活动简介

@property (strong, nonatomic) NSString* costInfo;//费用说明

@property (strong, nonatomic) NSString* timeKey;

@property (strong, nonatomic) NSString* choiceName;

@property (strong, nonatomic) NSString* srcKey;

@property (assign, nonatomic) NSInteger sex;

@property (assign, nonatomic) NSInteger srcType;

@end
