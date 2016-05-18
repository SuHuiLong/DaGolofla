//
//  JGTeamPhotoModel.h
//  DagolfLa
//
//  Created by 黄达明 on 16/5/18.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGTeamPhotoModel : BaseModel


@property (strong, nonatomic) NSNumber* teamKey;

@property (strong, nonatomic) NSString* groupsName;

@property (strong, nonatomic) NSString* groupInfo;

@property (strong, nonatomic) NSNumber* userKey;

@property (strong, nonatomic) NSString* pic;

@property (strong, nonatomic) NSDate*   createTime;

@property (strong, nonatomic) NSNumber* photoNums;


@end
