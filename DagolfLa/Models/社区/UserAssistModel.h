//
//  UserAssistModel.h
//  DaGolfla
//
//  Created by bhxx on 15/9/25.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface UserAssistModel : BaseModel


@property (copy, nonatomic) NSNumber* almost;
@property (copy, nonatomic) NSString* birthday;
@property (copy, nonatomic) NSString* createTime;
@property (copy, nonatomic) NSNumber* mId;
@property (copy, nonatomic) NSNumber* sex;
@property (copy, nonatomic) NSNumber* uId;
@property (copy, nonatomic) NSNumber* userAssistId;
@property (copy, nonatomic) NSString* userName;
@property (copy, nonatomic) NSString* userPic;
@property (copy, nonatomic) NSNumber* age;


- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
- (id)valueForUndefinedKey:(NSString *)key;

@end
/*
 {
 "userAssistId": 9,
 "mId": 8,
 "uId": 17,
 "createTime": null,
 "userName": "1234",
 "userPic": null,
 "birthday": "2005-09-24",
 "almost": 15,
 "sex": 15
 },
 */