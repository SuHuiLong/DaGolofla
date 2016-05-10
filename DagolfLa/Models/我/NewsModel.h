//
//  NewsModel.h
//  DaGolfla
//
//  Created by bhxx on 15/10/2.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface NewsModel : BaseModel

@property (copy, nonatomic) NSNumber* mId;    //id
@property (copy, nonatomic) NSString* sender;  // 发送人
@property (copy, nonatomic) NSString* createTime; //
@property (copy, nonatomic) NSString* content;   //介绍
@property (copy, nonatomic) NSNumber* userId; //接收人
@property (copy, nonatomic) NSString* title; //标题
@property (copy, nonatomic) NSNumber* messObjid; //邀请的id
@property (copy, nonatomic) NSNumber *messType; //消息类型
@property (copy, nonatomic) NSNumber* isSee; // 是否看过
@property (copy, nonatomic) NSNumber* ids;  //没用
//
@property (strong, nonatomic) NSString* pic;
@property (strong, nonatomic) NSNumber* seeCount;
@property (strong, nonatomic) NSString* uName; //用户名
//用户图片
@property (strong, nonatomic) NSString* uPic;

@end

/*
 
 "mId":178,
 "sender":0,
 "createTime":"2015-12-17 17:01:00",
 "content":"123帮您记录了一条简单记分。",
 "userId":14,
 "title":"yg",
 "messObjid":0,
 "messType":0,
 "isSee":0,
 "ids":0,
 "pic":null,
 "seeCount":70,
 "uName":null,
 "uPic":null
 
 */