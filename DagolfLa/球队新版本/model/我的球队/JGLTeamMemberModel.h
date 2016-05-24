//
//  JGLTeamMemberModel.h
//  DagolfLa
//
//  Created by 黄达明 on 16/5/20.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGLTeamMemberModel : BaseModel


@property (strong, nonatomic) NSNumber* teamKey;

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
@property (strong, nonatomic) NSNumber* power;
//申请状态 0申请中  1 已通过  2未通过
@property (strong, nonatomic) NSNumber* state;



@end
