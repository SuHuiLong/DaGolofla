//
//  MeselfModel.h
//  DaGolfla
//
//  Created by bhxx on 15/9/29.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface MeselfModel : BaseModel

@property (strong, nonatomic) NSNumber* userId;
@property (strong, nonatomic) NSString* mobile;
@property (strong, nonatomic) NSString* userName;
@property (strong, nonatomic) NSString* passWord;
//@property (copy, nonatomic) NSString* createTime;
@property (strong, nonatomic) NSNumber* sex;
@property (strong, nonatomic) NSString* pic;
@property (strong, nonatomic) NSString* birthday;
@property (strong, nonatomic) NSString* address; //主场
@property (strong, nonatomic) NSString* userSign;//个性签名
@property (strong, nonatomic) NSNumber* almost;//差点，平均成绩
@property (strong, nonatomic) NSNumber* infoState;//资料查看状态 0对所有人开放 1对球队成员开放 2仅自己可见 3 对部分好友开放
@property (strong, nonatomic) NSNumber* workId,*isDelete,*isPlayBall;
@property (strong, nonatomic) NSString* workName;
//经纬度坐标
@property (strong, nonatomic) NSNumber *yIndex;
@property (strong, nonatomic) NSNumber* ballage;

@property (assign, nonatomic) NSNumber* xIndex;




@property (strong, nonatomic) NSNumber* otherUserId;
@property (strong, nonatomic) NSString* backPic;
@property (strong, nonatomic) NSNumber* age;
//签名
@property (strong, nonatomic) NSNumber* ballYear;
//球龄
@property (strong, nonatomic) NSNumber* followState;
@property (strong, nonatomic) NSNumber* lookstate;


@end
/**
 *  {
 "rows": {
 "userId": 14,
 "mobile": "15200000000",
 "userName": "11",
 "passWord": "81dc9bdb52d04dc20036dbd8313ed055",
 "createTime": "2015-09-21",
 "sex": 0,
 "pic": "ceshi6",
 "birthday": "1973-09-24 13:49:00.0",
 "address": null,
 "userSign": null,
 "money": 0,
 "ballYear": 0,
 "almost": 40,
 "workId": 0,
 "infoState": 0,
 "isDelete": 0,
 "isPlayBall": 0,
 "xIndex": 0,
 "yIndex": 0
 },
 "message": "查询成功",
 "success": true,
 "total": 0,
 "flg": 0
 }
 */
