//
//  YueDetailModel.h
//  DaGolfla
//
//  Created by bhxx on 15/10/6.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface YueDetailModel : BaseModel


@property (copy, nonatomic) NSNumber* ballJoinId;
@property (copy, nonatomic) NSNumber* aboutBallId;
@property (copy, nonatomic) NSNumber* userId;
@property (copy, nonatomic) NSNumber* state;
@property (copy, nonatomic) NSString* createTimel;
@property (copy, nonatomic) NSString* pic;
@property (copy, nonatomic) NSString* userName;

@property (copy, nonatomic) NSString* birthday;
@property (copy, nonatomic) NSNumber* sex;
@property (copy, nonatomic) NSNumber* almost;
@property (copy, nonatomic) NSNumber* age;
@end
/*
 { 
    "rows":
        {
            "type1":
            [{
                "ballJoinId":5,
                "aboutBallId":2,
                "userId":16,
                "state":1,
                "createTime":"2015-10-05 12:24:00",
                "pic":"ceshi3",
                "userName":"1234"
            },
            {
                "ballJoinId":6,
                "aboutBallId":2,
                "userId":21,
                "state":1,
                "createTime":"2015-10-05 12:24:00",
                "pic":null,
                "userName":"123"
            }],
            "type0":
            [{
                "ballJoinId":3,
                "aboutBallId":2,
                "userId":51,
                "state":0,
                "createTime":"2015-10-05 12:24:00",
                "pic":null,
                "userName":null
            },
            {
                "ballJoinId":7,
                "aboutBallId":2,
                "userId":30,
                "state":0,
                "createTime":"2015-10-05 12:24:00",
                "pic":null,
                "userName":"清清浅浅"
            }]
        },
        "message":"查询成功",
        "success":true,
        "total":5,
        "flg":1
 }
 */