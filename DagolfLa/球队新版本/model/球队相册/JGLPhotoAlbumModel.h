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
 *  createTime = 1463625281000;
 groupsName = Cccaa;
 rsyncFlag = 0;
 syncFlag = 0;
 teamKey = 189911222513049600;
 timeKey = 190138107805310976;
 ts = 1463625281000;
 */


@property (strong, nonatomic) NSNumber* createTime;

@property (strong, nonatomic) NSString* groupsName;

@property (strong, nonatomic) NSNumber* photoNums;

//0：所有人可见     1：球队成员可见
@property (strong, nonatomic) NSNumber* power;

@property (strong, nonatomic) NSNumber* rsyncFlag;

@property (strong, nonatomic) NSNumber* syncFlag;

@property (strong, nonatomic) NSNumber* teamKey;

@property (strong, nonatomic) NSNumber* timeKey;

@property (strong, nonatomic) NSNumber* ts;
@end
