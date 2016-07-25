//
//  JGHScoreBallBaseModel.h
//  DagolfLa
//
//  Created by 黄安 on 16/7/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGHScoreBallBaseModel : BaseModel

/**
 ballKey = 350;
 ballName = "\U4e0a\U6d77\U534e\U51ef\U4e61\U6751\U9ad8\U5c14\U592b\U4ff1\U4e50\U90e8";
 createtime = "2016-07-25 00:00:00";
 rsyncFlag = 0;
 srcKey = 0;
 srcType = 0;
 syncFlag = 0;
 ts = "2016-07-25 13:44:39";
 */

@property (nonatomic, strong)NSString *ballName;

@property (nonatomic, strong)NSString *ballKey;

@property (nonatomic, strong)NSString *createtime;

@end
