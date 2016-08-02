//
//  JGLScoreRankModel.h
//  DagolfLa
//
//  Created by 黄达明 on 16/8/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGLScoreRankModel : BaseModel
/**
 *  almost = 0;
 netbar = 0;
 poleNumber = 0;
 scoreKey = 32310;
 userKey = 7965;
 userName = 2234;
 */
@property (strong, nonatomic) NSNumber* almost;

@property (strong, nonatomic) NSNumber* netbar;//净杆

@property (strong, nonatomic) NSNumber* poleNumber;//总

@property (strong, nonatomic) NSNumber* scoreKey;//

@property (strong, nonatomic) NSNumber* userKey;

@property (strong, nonatomic) NSString* userName;

@end
