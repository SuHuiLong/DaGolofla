//
//  RewordModel.h
//  DagolfLa
//
//  Created by bhxx on 15/10/11.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface RewordModel : BaseModel


@property (copy, nonatomic) NSNumber* aboutBallReId;
@property (copy, nonatomic) NSNumber* golfCourse;
@property (copy, nonatomic) NSString* playTimes;
@property (copy, nonatomic) NSNumber* sex;
@property (copy, nonatomic) NSString* ballYear;
@property (copy, nonatomic) NSString* almost;
@property (copy, nonatomic) NSString* reTitle;
@property (copy, nonatomic) NSNumber* reMoney;
@property (copy, nonatomic) NSString* reInfo;
@property (copy, nonatomic) NSString* createTime;
@property (copy, nonatomic) NSNumber* ballState;
@property (copy, nonatomic) NSNumber* userId;
@property (copy, nonatomic) NSString* userName;
@property (copy, nonatomic) NSString* uPic;
@property (copy, nonatomic) NSString* ballName;
@property (copy, nonatomic) NSString* address;
@property (copy, nonatomic) NSNumber* distance;
@property (copy, nonatomic) NSNumber* joinCount,* states,* xIndex,* yIndex, * moneyUp,* moneyDown, *seeCount;
@property (copy, nonatomic) NSString* ballNmae;

@end
/*
{
    "aboutBallReId": 15,
    "golfCourse": 3,
    "playTimes": "2015-09-10 10:20:00",
    "sex": 0,
    "ballYear": "10",
    "almost": "100",
    "reTitle": "ceshiasodao",
    "reMoney": 20,
    "reInfo": "asdasd;lsf,s313s1d35sd1531s35d3as",
    "createTime": "2015-10-10",
    "ballState": 2,
    "userId": 14,
    "userName": "11",
    "uPic": "ceshi6",
    "ballName": "安徽合肥紫蓬湾国际高尔夫俱乐部",
    "address": "安徽省合肥市肥西县国家森林公园紫蓬山",
    "distance": 500.54449462890625,
    "joinCount": 0,
    "states": 0,
    "xIndex": 0,
    "yIndex": 0,
    "ballNmae": null,
    "moneyUp": 0,
    "moneyDown": 0
}
*/