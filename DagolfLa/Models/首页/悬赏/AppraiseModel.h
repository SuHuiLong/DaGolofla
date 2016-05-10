//
//  AppraiseModel.h
//  DagolfLa
//
//  Created by bhxx on 15/10/12.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface AppraiseModel : BaseModel



@property (copy, nonatomic) NSNumber* aId;
@property (copy, nonatomic) NSNumber* aboutBallReId;
@property (copy, nonatomic) NSNumber* appraiseState;
@property (copy, nonatomic) NSString* content;
@property (copy, nonatomic) NSString* createTime;
@property (copy, nonatomic) NSNumber* userId;
@property (copy, nonatomic) NSString* uPic;
@property (copy, nonatomic) NSString* userName;

@end
/*
 {
 "aId": 1,
 "aboutBallReId": 35,
 "appraiseState": 0,
 "content": "ceshixinxi",
 "createTime": "2015-10-11",
 "userId": 14
 },
 */