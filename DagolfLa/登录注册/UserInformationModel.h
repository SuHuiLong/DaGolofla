//
//  UserInformationModel.h
//  CharmRiuJin
//
//  Created by bhxx on 24/6/18.
//  Copyright (c) 2024年 bhxx. All rights reserved.
//

#import "BaseModel.h"
/*
 {
 "userId": 14,
 "mobile": "15200000000",
 "userName": "11",
 "passWord": null,
 "createTime": "2015-09-21",
 "sex": 1,
 "pic": "ceshi6",
 "birthday": "1973-09-24 13:49:00.0",
 "address": null,
 "userSign": null,
 "money": 0,
 "ballYear": 0,
 "almost": 40,
 "workId": 0,
 "infoState": 1,
 "isDelete": 0,
 "isPlayBall": 0,
 "xIndex": 0,
 "yIndex": 0
 },
 //年龄
	private int age;
	private int ballage;//球龄
	private String backPic;
 private String  workName;// 行业名称
 private String pcpic;
	private int codeState;//推荐码状态0未填写1填写
	private String code;//推荐码
	private int codeNum;//推荐人数量
 
	//附加1
 private String rongTk;//融云tk(唯一标示)
 
	//距离  单位 KM
	private double distance;
 
 
 // 用户id
	private int userId;
	// 手机号
	private String mobile;
	// 用户名
	private String userName;
	// 密码
	private String passWord;
	// 创建时间
	private Date createTime;
	// 性别0表示女1男2其他
	private int sex;
	//年龄
	private int age;
	private int ballage;//球龄
	private String backPic;
	// 图片
	private String pic;// 头像
	private Date birthday;// 生日
	private String address;// 地址
	private String userSign;// 签名
	private double money;// 金额
	private double ballYear;// 球龄
	private double almost;// 差点
	private int workId;// 行业id
	private String  workName;// 行业名称
	private int infoState;// 资料查看状态 0对所有人开放 1对球队成员开放 2仅自己可见 3 对部分好友开放
	private int isDelete;// 是否删除0未删除1已删除
	private int isPlayBall;// 是否接受 0否 1是
	private double xIndex;// 位置经坐标
	private double yIndex;// 位置纬坐标
	private String pcpic;
	private int codeState;//推荐码状态0未填写1填写
	private String code;//推荐码
	private int codeNum;//推荐人数量

	//附加1
 private String rongTk;//融云tk(唯一标示)

	//距离  单位 KM
	private double distance;
 */
@interface UserInformationModel : BaseModel
@property (nonatomic,strong) NSNumber* userId;
@property (nonatomic,copy) NSString* mobile;
@property (nonatomic,copy) NSString* userName;
@property (nonatomic,copy) NSString* passWord;
@property (nonatomic, copy) NSString* createTime;
@property (nonatomic,strong) NSNumber* sex;
@property (nonatomic,copy) NSString* pic;
@property (nonatomic,copy) NSString* birthday;
@property (nonatomic,copy) NSString* address;
@property (copy, nonatomic) NSString* userSign;
@property (copy, nonatomic) NSNumber* money;
@property (copy, nonatomic) NSNumber* ballYear;
@property (copy, nonatomic) NSNumber* almost;
@property (copy, nonatomic) NSNumber* workId;
@property (copy, nonatomic) NSNumber* infoState;
@property (copy, nonatomic) NSNumber* isDelete;
@property (copy, nonatomic) NSNumber* isPlayBall;
@property (copy, nonatomic) NSNumber* xIndex;
@property (copy, nonatomic) NSNumber* yIndex;
@property (copy, nonatomic) NSNumber* age;
@property (copy, nonatomic) NSNumber* ballage;
@property (copy, nonatomic) NSString* backPic;
@property (copy, nonatomic) NSString* workName;
@property (copy, nonatomic) NSString* pcpic;
@property (copy, nonatomic) NSNumber* codeState;
@property (copy, nonatomic) NSString* code;
@property (copy, nonatomic) NSString* rongTk;
@property (copy, nonatomic) NSNumber* distance;
/*
 
 private int age;
	private int ballage;//球龄
	private String backPic;
 private String  workName;// 行业名称
 private String pcpic;
	private int codeState;//推荐码状态0未填写1填写
	private String code;//推荐码
	private int codeNum;//推荐人数量
 
	//附加1
 private String rongTk;//融云tk(唯一标示)
 
	//距离  单位 KM
	private double distance;
 */

@end
