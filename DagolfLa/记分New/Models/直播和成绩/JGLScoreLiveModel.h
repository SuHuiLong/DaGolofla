//
//  JGLScoreLiveModel.h
//  DagolfLa
//
//  Created by 黄达明 on 16/8/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGLScoreLiveModel : BaseModel


/**
 *  poleNumber = 0;
 poorBar = 0;
 scoreUserName = zhh;
 timeKey = 32310;
 tunnelNumber = 0;
 userName = 2234;
 
 poleNumber = 18;
 publish = 0;
 scoreKey = 33274;
 userKey = 0;
 */


@property (strong, nonatomic) NSNumber* poleNumber;

@property (strong, nonatomic) NSNumber* poorBar;

@property (strong, nonatomic) NSString* scoreUserName;

@property (strong, nonatomic) NSNumber* timeKey;

@property (strong, nonatomic) NSNumber* tunnelNumber;

@property (strong, nonatomic) NSString* userName;

@property (strong, nonatomic) NSNumber* publish;

@property (strong, nonatomic) NSNumber* scoreKey;

@property (strong, nonatomic) NSNumber* userKey;

@property (strong, nonatomic) NSNumber* almost;

@property (strong, nonatomic) NSNumber* netbar;//净杆

@property (nonatomic, assign) NSInteger select;// 0 1


@end
