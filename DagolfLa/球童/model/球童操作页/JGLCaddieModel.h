//
//  JGLCaddieModel.h
//  DagolfLa
//
//  Created by 黄达明 on 16/8/12.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGLCaddieModel : BaseModel

/**
 *  scoreFinish = 2;
 scoreUserKey = 191;
 srcKey = 0;
 srcType = 0;
 timeKey = 33140;
 userName = "\U987e\U65ed\U8c6a";
 */


@property (strong, nonatomic) NSNumber* scoreFinish;//  是否完成记分 0:未完成，1:已完成 , 2 代替计分

@property (strong, nonatomic) NSNumber* scoreUserKey;//  球童用户Key

@property (strong, nonatomic) NSString* scoreUserName;//  球童用户名

@property (strong, nonatomic) NSNumber* srcKey;

@property (strong, nonatomic) NSNumber* srcType;

@property (strong, nonatomic) NSNumber* timeKey;//  记分卡Key

@property (strong, nonatomic) NSNumber* userName;

@property (strong, nonatomic) NSString* createtime;



@end
