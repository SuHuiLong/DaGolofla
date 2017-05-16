//
//  JGLWinnerShareModel.h
//  DagolfLa
//
//  Created by 黄达明 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGLWinnerShareModel : BaseModel

@property (strong, nonatomic) NSNumber* teamKey;

@property (strong, nonatomic) NSNumber* index;

@property (strong, nonatomic) NSNumber* isDefault;//是否是默认的奖项 0: 不是  1: 是

@property (strong, nonatomic) NSString* name;

@property (strong, nonatomic) NSString* prizeName;

@property (strong, nonatomic) NSNumber* prizeSize;

@property (strong, nonatomic) NSNumber* teamActivityKey;

@property (strong, nonatomic) NSString* createTime;

@property (strong, nonatomic) NSString* ts;

@property (strong, nonatomic) NSString* userInfo;

@property (strong, nonatomic) NSString* signupKeyInfo;

@property (strong, nonatomic) NSNumber* isPublish;//是否该奖项已经发布 0: 未发布  1: 已发布

/*
 createTime = "2016-07-05 00:00:00";
 delFlag = 0;
 douDef1 = 0;
 douDef2 = 0;
 index = 0;
 isDefault = 0;
 name = "\U5fc3\U9178\U5956";
 prizeSize = 0;
 rsyncFlag = 0;
 syncFlag = 0;
 teamActivityKey = 587860;
 teamKey = 587857;
 timeKey = 2121;
 ts = "1970-01-01 00:00:00";
 */



@end
