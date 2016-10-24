//
//  JGLGroupRoundModel.h
//  DagolfLa
//
//  Created by Madridlee on 16/10/17.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"
//轮次模型
@interface JGLGroupRoundModel : BaseModel

@property (strong, nonatomic) NSNumber* ballKey;

@property (strong, nonatomic) NSString* createTime;

@property (strong, nonatomic) NSNumber* isSetUp;

@property (strong, nonatomic) NSString* kickOffTime;

@property (strong, nonatomic) NSNumber* matchKey;

@property (strong, nonatomic) NSNumber* matchTypeKey;

@property (strong, nonatomic) NSNumber* matchformatKey;

@property (strong, nonatomic) NSNumber* matchformatPeopleConut;

@property (strong, nonatomic) NSNumber* round;

@property (strong, nonatomic) NSString* ruleType;

@property (strong, nonatomic) NSNumber* timeKey;

@property (strong, nonatomic) NSNumber* sumGroup;

@property (strong, nonatomic) NSString* matchformatName;//赛制名

@property (strong, nonatomic) NSNumber* groupType;


@end
/*
 "ballKey":"0"
 "createTime":"1970-01-01 00:00:00",
 "delFlag":0,
 "douDef1":0,
 "douDef2":0,
 "isSetUp":0,
 "kickOffTime":"1970-01-01 00:00:00",
 "matchKey":"122",
 "matchTypeKey":"11505531298097",
 "matchformatKey":"7453214066410",
 "matchformatPeopleConut":0,
 "round":1,
 "rsyncFlag":0,
 "ruleType":"1212发生的发",
 "syncFlag":0,
 "timeKey":"1212",
 "ts":"1970-01-01 00:00:00"
 
 */
