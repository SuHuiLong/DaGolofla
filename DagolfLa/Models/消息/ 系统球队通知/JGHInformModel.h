//
//  JGHInformModel.h
//  DagolfLa
//
//  Created by 黄安 on 16/11/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface JGHInformModel : BaseModel

@property (nonatomic, retain)NSNumber *sendUserkey;//发送者用户key  如果为 0 则为平台系统消息
@property (nonatomic, retain)NSString *sendUserName;//发送者用户名

@property (nonatomic, retain)NSNumber *receiveUserkey;//接收者用户key

@property (nonatomic, retain)NSNumber *receiveUserName;//接收者用户名

@property (nonatomic, assign)NSInteger nSrc;//消息来源  0 : 系统 , 1 : 球队

@property (nonatomic, retain)NSString *title;//消息标题

@property (nonatomic, retain)NSString *content;//消息内容

@property (nonatomic, retain)NSString *linkURL;//跳转linkURL  url 按照规范中 urlscheme 协议

@property (nonatomic, assign)NSInteger nType;//消息类型  0 : 系统 , 1 : 球队

@property (nonatomic, retain)NSString *createTime;//消息创建时间

@property (nonatomic, assign)NSInteger state;//消息状态 0 : 未查看 , 1 : 已查看

@property (nonatomic, retain)NSNumber *timeKey;

@property (nonatomic, retain)NSString *nSrcName;//球队名称

@property (nonatomic, retain)NSString *pushLogKey;//存在值调用统计接口

@end
