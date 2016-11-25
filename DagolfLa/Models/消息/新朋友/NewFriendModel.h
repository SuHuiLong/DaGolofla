//
//  NewFriendModel.h
//  DagolfLa
//
//  Created by bhxx on 16/3/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface NewFriendModel : BaseModel


@property (strong, nonatomic) NSNumber* userFollowId;
@property (strong, nonatomic) NSNumber* userId;
@property (strong, nonatomic) NSNumber* otherUserId;
@property (strong, nonatomic) NSString* createTime;
@property (strong, nonatomic) NSNumber* sex;
@property (strong, nonatomic) NSString* userName;
@property (strong, nonatomic) NSString* pic;
@property (strong, nonatomic) NSString* userSign;
@property (strong, nonatomic) NSString* birthday;
@property (strong, nonatomic) NSNumber* almost;
@property (strong, nonatomic) NSString* address;
@property (strong, nonatomic) NSNumber* isFollow;
@property (strong, nonatomic) NSNumber* age;


@end



/*
 // 关注表id
	private Integer userFollowId;
	// 用户id
	private Integer userId;
	// 被关注的人id
	private Integer otherUserId;
	// 创建时间
	private Date createTime;
	private int sex;// 性别
	private String userName;// 姓名
	private String pic;// 头像
 private String userSign;//签名
	private Date birthday;// 生日
	private double almost;// 差点
	private String address;// 地址
	private int isFollow;//是否关注  0 未关注  1 关注
	private int age;//年龄
 */
