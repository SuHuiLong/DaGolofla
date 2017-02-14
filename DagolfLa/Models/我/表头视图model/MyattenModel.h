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
@property (strong, nonatomic) NSNumber* userId;
@property (strong, nonatomic) NSNumber* otherUserId;
@property (copy, nonatomic) NSString* createTime;
@property (copy, nonatomic) NSNumber* sex;
@property (copy, nonatomic) NSString* userName;
@property (copy, nonatomic) NSString* pic;
@property (copy, nonatomic) NSString* birthday;
@property (copy, nonatomic) NSNumber* almost;
@property (copy, nonatomic) NSString* address;
@property (strong, nonatomic) NSNumber* friendUserKey;
@property (copy, nonatomic) NSString* remark; // 备注

@property (copy, nonatomic) NSString* fMobile;

@property (assign, nonatomic)NSInteger select;

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
