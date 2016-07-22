//
//  JGDHistoryScoreShowModel.h
//  DagolfLa
//
//  Created by 東 on 16/7/15.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGDHistoryScoreShowModel : BaseModel

@property (nonatomic, strong) NSArray *onthefairway;    // 是否上球道
@property (nonatomic, strong) NSArray *poleNumber;      // 球队杆数
@property (nonatomic, strong) NSArray *pushrod;         // 推杆
@property (nonatomic, strong) NSArray *standardlever; 	// 标准杆树
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, strong) NSNumber *userMobile;
@property (nonatomic, strong) NSNumber *userKey;
@property (nonatomic, strong) NSString *ts;
@property (nonatomic, strong) NSNumber *timeKey;
@property (nonatomic, strong) NSNumber *syncFlag;
@property (nonatomic, strong) NSNumber *rsyncFlag;
@property (nonatomic, strong) NSNumber *poles;          // 总杆数
@property (nonatomic, copy) NSString *tTaiwan;          // T 台
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *ballName;
@property (nonatomic, strong) NSNumber *invitationCode;   // 密钥


@end

