//
//  BallParkModel.h
//  DaGolfla
//
//  Created by bhxx on 15/10/4.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface BallParkModel : BaseModel
@property (strong, nonatomic) NSNumber* ballId;
@property (strong, nonatomic) NSString* address;
@property (strong, nonatomic) NSString* ballName;
@property (strong, nonatomic) NSString* country;
@property (strong, nonatomic) NSNumber* delFlag;
@property (strong, nonatomic) NSNumber* douDef1;
@property (strong, nonatomic) NSNumber* douDef2;
@property (strong, nonatomic) NSNumber* geohash;
@property (strong, nonatomic) NSNumber* province;
@property (strong, nonatomic) NSNumber* rsyncFlag;
@property (strong, nonatomic) NSNumber* syncFlag;
@property (strong, nonatomic) NSNumber* timeKey;
@property (strong, nonatomic) NSString* ts;

@end
