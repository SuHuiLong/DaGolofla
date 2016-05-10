//
//  JobModel.h
//  DaGolfla
//
//  Created by bhxx on 15/10/4.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JobModel : BaseModel

@property (copy, nonatomic) NSNumber* workId;
@property (copy, nonatomic) NSString* desction;
@property (copy, nonatomic) NSString* img;
@property (copy, nonatomic) NSNumber* isDelete;


@end
/*
 {"rows":
    [
    {
        "workId":1,
        "desction":"金融",
        "img":null,
        "isDelete":0
    },
    {
        "workId":2, 
        "desction":"贸易",
        "img":null,
        "isDelete":0
    },
   ],
    "message":"查询成功",
    "success":true,
    "total":6,
    "flg":0
 }
 */