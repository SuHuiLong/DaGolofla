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
@property (nonatomic, copy) NSString *scoreUserName; // 代记分人
@property (nonatomic, copy) NSString *teamActivityKey; //

@property (nonatomic, strong) NSNumber *scoreSum; // 

@property (nonatomic, strong) NSNumber *userType; //  1 球童记分
@property (nonatomic, strong) NSNumber *srcKey; //  userKey   如果相同是球童
@property (nonatomic, copy) NSString *userName; // 被记分人
@property (nonatomic, copy) NSString *scoreUserKey; //
@property (nonatomic, copy) NSString *userKey; //
@property (nonatomic, copy) NSString *userNames;

@end
