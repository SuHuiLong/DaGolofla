//
//  JGLBankModel.h
//  DagolfLa
//
//  Created by 黄达明 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGLBankModel : BaseModel


/**
 *  backName = "\U519c\U4e1a\U94f6\U884c";
 cardNumber = 654654365436543543;
 cardType = 2;
 createTime = "2016-06-28 19:37:37";
 delFlag = 0;
 douDef1 = 0;
 douDef2 = 0;
 name = 65432;
 rsyncFlag = 0;
 syncFlag = 0;
 timeKey = 4998;
 ts = "2016-06-28 19:37:37";
 userKey = 244;
 */


@property (strong, nonatomic) NSString* backName;

@property (strong, nonatomic) NSNumber* cardNumber;

@property (strong, nonatomic) NSNumber* cardType;

@property (strong, nonatomic) NSString* createTime;

@property (strong, nonatomic) NSString* name;

@property (strong, nonatomic) NSNumber* timeKey;

@property (strong, nonatomic) NSString* ts;

@property (strong, nonatomic) NSNumber* userKey;



@end
