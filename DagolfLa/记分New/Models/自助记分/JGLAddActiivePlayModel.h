//
//  JGLAddActiivePlayModel.h
//  DagolfLa
//
//  Created by 黄达明 on 16/7/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"
#import "ChineseString.h"
@interface JGLAddActiivePlayModel : BaseModel

@property (strong, nonatomic) NSNumber* activityKey;

@property (strong, nonatomic) NSNumber* userKey;

//@property (strong, nonatomic) NSNumber* otherUserId;

@property (strong, nonatomic) NSString* name;

@property (strong, nonatomic) NSString* userName;
//
@property (strong, nonatomic) NSNumber* timeKey;
//
@property (strong, nonatomic) ChineseString* chineseString;
//
@property (strong, nonatomic) NSString* mobile;

@property (strong, nonatomic) NSNumber* almost;

@property (strong, nonatomic) NSNumber* signUpInfoKey;//-1 意向成员

@property (strong, nonatomic) NSNumber* payMoney;

/**
 *  activityKey = 5456;
 almost = 0;
 canSignUpReason = 0;
 createTime = "2016-07-06 11:21:46";
 delFlag = 0;
 douDef1 = 0;
 douDef2 = 0;
 groupIndex = 0;
 isOnlinePay = 0;
 money = 20000;
 name = e;
 payMoney = 0;
 payTime = "1970-01-01 00:00:00";
 refoundReason = 0;
 rsyncFlag = 0;
 sex = 1;
 signUpInfoKey = 5777;
 sortIndex = 2;
 state = 0;
 subState = 0;
 subsidyPrice = 0;
 syncFlag = 0;
 teamKey = 5415;
 timeKey = 5781;
 ts = "1970-01-01 08:00:00";
 type = 0;
 userKey = 0;
 */




@end
