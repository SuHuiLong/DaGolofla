//
//  MyattenModel.h
//  DagolfLa
//
//  Created by bhxx on 15/10/14.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "BaseModel.h"
#import "ChineseString.h"

@interface MyattenModel : BaseModel

@property (copy, nonatomic) NSNumber* userFollowId;
@property (copy, nonatomic) NSNumber* userId;
@property (copy, nonatomic) NSNumber* otherUserId;
@property (copy, nonatomic) NSString* createTime;
@property (copy, nonatomic) NSNumber* sex;
@property (copy, nonatomic) NSString* userName;
@property (copy, nonatomic) NSString* pic;
@property (copy, nonatomic) NSString* birthday;
@property (copy, nonatomic) NSNumber* almost;
@property (copy, nonatomic) NSString* address;
@property (copy, nonatomic) NSNumber* friendUserKey;

@property (strong,nonatomic) ChineseString *chineseString;


@end
/*
 
 
 {
 "rows": [
 {
 "userFollowId": null,
 "userId": null,
 "otherUserId": 16,
 "createTime": null,
 "sex": 0,
 "userName": "1234",
 "pic": "ceshi3",
 "birthday": "1989-09-24",
 "almost": 10,
 "address": null
 }, ],
 "message": "查询成功",
 "success": true,
 "total": 3,
 "flg": 0
 }
 
 
 */
