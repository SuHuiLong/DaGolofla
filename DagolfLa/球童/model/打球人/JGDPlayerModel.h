//
//  JGDPlayerModel.h
//  DagolfLa
//
//  Created by 東 on 16/8/12.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGDPlayerModel : BaseModel

@property (nonatomic, strong) NSNumber *scoreFinish;   // 1 是完成    0 未完成
@property (nonatomic, strong) NSNumber *scoreUserKey;
@property (nonatomic, copy) NSString *scoreUserName;
@property (nonatomic, strong) NSNumber *srcKey;
@property (nonatomic, strong) NSNumber *srcType;        // 1 是活动记分   
@property (nonatomic, strong) NSNumber *timeKey;

@end
