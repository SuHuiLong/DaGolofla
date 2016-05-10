//
//  TeamJoinModel.h
//  DagolfLa
//
//  Created by bhxx on 15/11/22.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface TeamJoinModel : BaseModel


@property (strong, nonatomic) NSNumber* almost;
@property (strong, nonatomic) NSString* birthday;
@property (strong, nonatomic) NSNumber* teamApplyId;
@property (strong, nonatomic) NSNumber* sex;
@property (strong, nonatomic) NSNumber* userId;
@property (strong, nonatomic) NSString* userName;
@property (strong, nonatomic) NSString* teamcreateTime;
@property (strong, nonatomic) NSString* pic;
@property (strong, nonatomic) NSNumber* applyType;
@property (strong, nonatomic) NSNumber* teamApplyState;
@property (strong, nonatomic) NSNumber* teamId;
//理由
@property (strong, nonatomic) NSString* applyContext;

@property (strong, nonatomic) NSNumber * age;

@end


/*
 
 "almost": 0,
 "birthday": "2015-10-15 17:28:00",
 "sex": 0,
 "teamApplyId": 7,
 "userId": 26,
 "userName": "123全球",
 "teamcreateTime": "2015-11-21 09:50:00",
 "pic": "ssssss",
 "applyType": 10,
 "teamApplyState": 0,
 "teamId": 3
 */