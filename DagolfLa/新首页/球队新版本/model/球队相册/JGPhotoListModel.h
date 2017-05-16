//
//  JGPhotoListModel.h
//  DagolfLa
//
//  Created by 黄达明 on 16/6/7.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGPhotoListModel : BaseModel

/**
 * 
 albumKey = 2401;
 createTime = "2016-06-07 16:55:12";
 delFlag = 0;
 douDef1 = 0;
 douDef2 = 0;
 height = 0;
 mediaType = 1;
 rsyncFlag = 0;
 syncFlag = 0;
 timeKey = 2431;
 ts = "2016-06-07 16:55:12";
 userKey = 191;
 width = 0;
 */

@property (strong, nonatomic) NSNumber* albumKey;
@property (strong, nonatomic) NSString* createTime;
@property (strong, nonatomic) NSNumber* delFlag;
@property (strong, nonatomic) NSNumber* douDef1;
@property (strong, nonatomic) NSNumber* douDef2;
@property (strong, nonatomic) NSNumber* height;
@property (strong, nonatomic) NSNumber* mediaType;
@property (strong, nonatomic) NSNumber* rsyncFlag;
@property (strong, nonatomic) NSNumber* syncFlag;
@property (strong, nonatomic) NSNumber* timeKey;
@property (strong, nonatomic) NSString* ts;
@property (strong, nonatomic) NSNumber* userKey;
@property (strong, nonatomic) NSNumber* width;
@property (strong, nonatomic) NSString* teamName;

//照片是否被选中
@property (assign, nonatomic) BOOL isSelect;

@end
