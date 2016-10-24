//
//  JGLGroupCombatModel.h
//  DagolfLa
//
//  Created by Madridlee on 16/10/17.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"
//对抗关系模型

@interface JGLGroupCombatModel : BaseModel

@property (strong, nonatomic) NSString* createTime;

@property (strong, nonatomic) NSNumber* groupWay;

@property (strong, nonatomic) NSNumber* matchKey;

@property (strong, nonatomic) NSNumber* roundKey;

@property (strong, nonatomic) NSNumber* teamKey1;

@property (strong, nonatomic) NSNumber* teamKey2;

@property (strong, nonatomic) NSString* teamName1;

@property (strong, nonatomic) NSString* teamName2;

@property (strong, nonatomic) NSNumber* teamScore1;

@property (strong, nonatomic) NSNumber* teamScore2;

@property (strong, nonatomic) NSNumber* timeKey;

@property (strong, nonatomic) NSMutableArray* signUpList1;

@property (strong, nonatomic) NSMutableArray* signUpList2;

@property (strong, nonatomic) NSNumber* maxGroupIndex;

@property (strong, nonatomic) NSMutableDictionary* dictState;
@end
/*
 "createTime":"1970-01-01 00:00:00",
 "delFlag":0,
 "douDef1":0,
 "douDef2":0,
 "groupWay":0,
 "matchKey":"122",
 "roundKey":"1212",
 "rsyncFlag":0,
 "syncFlag":0,
 "teamKey1":"0",
 "teamKey2":"4372",
 "teamName1":"的撒旦",
 "teamName2":"1111",
 "teamScore1":0,
 "teamScore2":0,
 "timeKey":"30250",
 "ts":"2016-10-17 12:56:39"
 */
