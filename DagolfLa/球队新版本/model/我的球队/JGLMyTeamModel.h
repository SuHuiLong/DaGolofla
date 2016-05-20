//
//  JGLMyTeamModel.h
//  DagolfLa
//
//  Created by 黄达明 on 16/5/19.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGLMyTeamModel : BaseModel

/**
 *
 createUserKey = 244;
 crtyName = AAA;
 info = AAA;
 name = LB;
 rsyncFlag = 0;
 state = 0;
 syncFlag = 0;
 teamKey = 189911222513049600;
 timeKey = 189911222529826816;
 ts = 1463571187000;
 userKey = 244;
 */

@property (strong, nonatomic) NSNumber* createUserKey;
@property (strong, nonatomic) NSString* crtyName;
@property (strong, nonatomic) NSString* info;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSNumber* rsyncFlag;
@property (strong, nonatomic) NSNumber* state;
@property (strong, nonatomic) NSNumber* syncFlag;
@property (strong, nonatomic) NSNumber* teamKey;
@property (strong, nonatomic) NSNumber* timeKey;
@property (strong, nonatomic) NSNumber* ts;
@property (strong, nonatomic) NSNumber* userKey;



@end
