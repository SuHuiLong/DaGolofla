//
//  JGLTeamMemberModel.h
//  DagolfLa
//
//  Created by 黄达明 on 16/5/20.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"
#import "ChineseString.h"
@interface JGLTeamMemberModel : BaseModel



/*
 address = "\U9ed1\U9f99\U6c5f\U7701 \U4f0a\U6625\U5e02";
 almost = 0;
 ballage = 1;
 createTime = "2016-05-23 19:53:05";
 delFlag = 0;
 douDef1 = 0;
 douDef2 = 0;
 hand = 0;
 identity = 0;
 mobile = 12345678901;
 power = "1003,1001,1004,1002,1005";
 rsyncFlag = 0;
 sex = 0;
 state = 1;
 syncFlag = 0;
 teamKey = 192;
 timeKey = 193;
 ts = "2016-05-23 19:53:05";
 userKey = 244;
 userName = IIIIIIIIIIIIIIIIIII;
 */
@property (strong, nonatomic) NSString* createTime;

@property (strong, nonatomic) NSNumber* teamKey;

@property (strong, nonatomic) NSNumber* ballage;

@property (strong, nonatomic) NSNumber* userKey;

@property (strong, nonatomic) NSString* userName;
//0保密  1男  2女
@property (strong, nonatomic) NSNumber* sex;

@property (strong, nonatomic) NSNumber* almost;

@property (strong, nonatomic) NSString* mobile;

@property (strong, nonatomic) NSString* address;

@property (strong, nonatomic) NSString* size;
//惯用手 0左手   1右手
@property (strong, nonatomic) NSNumber* hand;
//权限   格式0， 1 ，2
@property (strong, nonatomic) NSString* power;
//申请状态 0申请中  1 已通过  2未通过
@property (strong, nonatomic) NSNumber* state;
@property (strong, nonatomic) NSNumber* joinState;

@property (assign, nonatomic) NSInteger identity;

@property (strong, nonatomic) NSNumber* rsyncFlag;

@property (strong, nonatomic) NSNumber* timeKey;

@property (strong, nonatomic) NSString* ts;

@property (strong, nonatomic) NSNumber* accountUserKey;

@property (strong, nonatomic) NSString* accountUserName;

@property (strong, nonatomic) NSString* accountUserMobile;

@property (strong, nonatomic) ChineseString *chineseString;

@property (copy, nonatomic)NSString *company;//公司

@property (copy, nonatomic)NSString *occupation;//职位

@property (copy, nonatomic)NSString *industry;//行业


@end
