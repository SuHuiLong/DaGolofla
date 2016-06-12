//
//  JGLPhotoAlbumModel.h
//  DagolfLa
//
//  Created by 黄达明 on 16/5/19.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGLPhotoAlbumModel : BaseModel

/**
 *  相册列表的model
 */


/**
 {
 createTime = "2016-06-12 16:16:24";
 delFlag = 0;
 douDef1 = 0;
 douDef2 = 0;
 mediaKey = 0;
 name = Qwer;
 photoNums = 0;
 power = 0;
 teamKey = 2852;
 timeKey = 2859;
 ts = "2016-06-12 16:16:24";
 userKey = 244;
 */


@property (strong, nonatomic) NSNumber* createTime;

@property (strong, nonatomic) NSNumber* delFlag;

@property (strong, nonatomic) NSNumber* douDef1;
@property (strong, nonatomic) NSNumber* douDef2;

@property (strong, nonatomic) NSNumber* mediaKey;

@property (strong, nonatomic) NSString* name;

@property (strong, nonatomic) NSNumber* photoNums;

//0：所有人可见     1：球队成员可见
@property (strong, nonatomic) NSNumber* power;

@property (strong, nonatomic) NSNumber* rsyncFlag;

@property (strong, nonatomic) NSNumber* syncFlag;

@property (strong, nonatomic) NSNumber* teamKey;

@property (strong, nonatomic) NSNumber* timeKey;

@property (strong, nonatomic) NSNumber* ts;

@property (strong, nonatomic) NSNumber* userKey;
@end
