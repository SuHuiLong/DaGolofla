//
//  ScoreCardModel.h
//  DagolfLa
//
//  Created by bhxx on 15/12/18.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface ScoreCardModel : BaseModel

//是否认领
@property (strong, nonatomic) NSNumber* scoreIsClaim;
@property (strong, nonatomic) NSNumber* scoreIsSimple;
@property (strong, nonatomic) NSNumber* scorePolenumbers;
@property (strong, nonatomic) NSNumber* scorePushrod;
@property (strong, nonatomic) NSNumber* scoreisend;
@property (strong, nonatomic) NSNumber* scoreType;

@property (strong, nonatomic) NSString* scoreObjectTitle;
@property (strong, nonatomic) NSString* scoreCreateTime;
@property (strong, nonatomic) NSString* scoreUserName;
@property (strong, nonatomic) NSString* userName;
//判断记分是谁记分
@property (strong, nonatomic) NSNumber* scoreWhoScoreUserId;
@property (strong, nonatomic) NSNumber* scorePoors;
@property (strong, nonatomic) NSNumber* scoreId;
@property (strong, nonatomic) NSNumber* scoreStandardleverNums;

@property (strong, nonatomic) NSString* scoreballName;
@property (strong, nonatomic) NSNumber* scoreObjectId;

@property (strong, nonatomic) NSNumber* scoreballId;
@property (strong, nonatomic) NSString* scoreSite0;
@property (strong, nonatomic) NSString* scoreSite1;
@property (strong, nonatomic) NSString* scoreTTaiwan;
@end
/*
 
 "scoreIsClaim": 0,
 "scorePolenumbers": 58,
 "scorePushrod": 0,
 "
 ": 0,
 "scoreType": 1,
 "scoreIsSimple": 1,
 "scoreObjectTitle": "咯\n",
 "scoreCreateTime": "2016-01-27 10:51",
 "scoreUserName": "你的",
 "userName": "互译选",
 "scoreWhoScoreUserId": 205,
 "scorePoors": 0,
 "scoreId": 1008
 
 private int	scoreId;  //专业计分  id
 private String	scoreObjectTitle;//计分对象标题
 private int scoreIsSimple; //是否是简单计分   1 简单计分  2 专业计分
 private int	scoreIsClaim;//是否认领  0 未认领  1 认领
 private int	scoreType;//记分卡属性  1 个人计分  2 赛事计分   3 活动计分
 //附加
 private  int  scorePolenumbers;//总杆数
 private int scorePoors;//总杆数减去标杆
 private int  scorePushrod;//推杆
 private int scoreStandardleverNums;//标杆数量
 private int scoreisend;//是否完成 0未完成  1已完成
 
 
 private int scoreWhoScoreUserId;//计分者id
	private int scoreObjectId;//计分对象
	private int scoreType;//计分类型
 private int scoreballId;//球场id
 private String scoreballName;//球场名字
 private String scoreSite0;//第一九洞地区名字
 private String scoreSite1;//第二九洞地区名字
 private String scoreTTaiwan;//T台
 private int scoreIsSimple;//是否简单计分
 */

