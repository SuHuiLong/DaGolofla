//
//  JGHUserModel.h
//  DagolfLa
//
//  Created by 黄安 on 16/11/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGHUserModel : BaseModel

@property (nonatomic, retain)NSNumber *userId;//用户id

@property (nonatomic, retain)NSString *mobile;//用户绑定手机号

@property (nonatomic, retain)NSString *passWord;//密码

@property (nonatomic, retain)NSString *userName;//用户昵称

@property (nonatomic, retain)NSString *createTime;//用户注册时间

@property (nonatomic, assign)NSInteger sex;//性别,0:女 ,1:男 ,-1:其他

@property (nonatomic, assign)NSInteger ballage;//球龄

@property (nonatomic, retain)NSString *backPic;//用户背景图片

@property (nonatomic, retain)NSString *pic;//头像地址

@property (nonatomic, retain)NSString *birthday;//用户生日

@property (nonatomic, retain)NSString *address;//用户地址

@property (nonatomic, retain)NSString *userSign;//用户个性签名

@property (nonatomic, retain)NSNumber *almost;//差点

@property (nonatomic, assign)NSInteger infoState;//资料查看状态,0:对所有人开放 ,1:对球队成员开放, 2:仅自己可见, 3:对部分好友开放

@property (nonatomic, assign)NSInteger isDelete;//是否删除 ,0:未删除,1:删除

@property (nonatomic, assign)NSInteger isPlayBall;//是否接受约球 ,0:否,1:是

@property (nonatomic, retain)NSNumber *xIndex;//坐标经度
@property (nonatomic, retain)NSNumber *yIndex;//坐标纬度

@property (nonatomic, retain)NSString *code;//用户邀请码

@property (nonatomic, retain)NSString *wxopenid;//微信openid
@property (nonatomic, retain)NSString *rongTk;//融云唯一标识,用于融云及时聊天
@property (nonatomic, retain)NSString *jgpush;//极光推送唯一标识



@end
