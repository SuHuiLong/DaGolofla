//
//  JGDHistoryScoreModel.h
//  DagolfLa
//
//  Created by 東 on 16/7/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGDHistoryScoreModel : BaseModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *ballName;
@property (nonatomic, strong) NSString *createtime;
@property (nonatomic, strong) NSNumber *poleNumber;
@property (nonatomic, strong) NSNumber *timeKey;
@property (nonatomic, strong) NSNumber *srcType; // 1 是活动记分     0 是个人
@property (nonatomic, strong) NSNumber *scoreFinish; // 0 是未完成

@end
