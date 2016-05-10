//
//  ChatPeopleMessageModel.h
//  DagolfLa
//
//  Created by 张天宇 on 15/10/15.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface ChatPeopleMessageModel : BaseModel

@property (nonatomic, strong) NSNumber *mId;
@property (nonatomic, strong) NSNumber *sender;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *messType;
@property (nonatomic, strong) NSNumber *isSee;
@property (nonatomic, strong) NSNumber *ids;
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, strong) NSString *uName;
@property (nonatomic, strong) NSString *uPic;
@property (nonatomic, strong) NSNumber *isMy;
 
/*
 "mId": 25,
 "sender": 14,
 "createTime": "2015-10-14 14:37:990",
 "content": "ceshishifoukeyishuruxiaoxi",
 "userId": 21,
 "title": null,
 "messType": 7,
 "isSee": 0,
 "ids": 0,
 "pic": null,
 "uName": "11",
 "uPic": "ceshi6"
 */
@end
