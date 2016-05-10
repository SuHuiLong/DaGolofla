//
//  CommunityModel.h
//  DaGolfla
//
//  Created by bhxx on 15/9/24.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "BaseModel.h"
#import "UserAssistModel.h"
@interface CommunityModel : BaseModel


//动态id
@property (copy, nonatomic) NSNumber* userMoodId;
//心情内容
@property (copy, nonatomic) NSString* moodContent;
//用户id
@property (copy, nonatomic) NSNumber* uId;
//图片
@property (copy, nonatomic) NSString* pic;
//发布时间
@property (copy, nonatomic) NSDate* createTime;
//经纬度坐标
@property (copy, nonatomic) NSNumber* xIndex, *yIndex;
//位置id
@property (copy, nonatomic) NSNumber* placeId;
//动态类型 社区：0  足迹：1
@property (copy, nonatomic) NSNumber* moodType;
//杆数
@property (copy, nonatomic) NSNumber* poleNum;
//打球日期
@property (copy, nonatomic) NSDate* playTime;
//打球日期
@property (copy, nonatomic) NSString* playTimes;
//是否同步 否：0 是：1
@property (copy, nonatomic) NSNumber* isSync;
//查询状态： 全部：无  关注：0 附近：1
@property (copy, nonatomic) NSNumber* searchState;
//用户头衔
@property (copy, nonatomic) NSString* uPic;
//用户名称
@property (copy, nonatomic) NSString* userName;
//公里数
@property (copy, nonatomic) NSNumber* distance;
//球场名称
@property (copy, nonatomic) NSString* golfName;
//点赞数量
@property (copy, nonatomic) NSNumber* assistCount;
//评论数量
@property (copy, nonatomic) NSNumber* commentCount;
//是否收藏： 否：0 是：1
@property (copy, nonatomic) NSNumber* collectionState;
//是否点赞： 否：0 是：1
@property (copy, nonatomic) NSNumber* assistState;


@property (strong, nonatomic) NSNumber* almost;
@property (strong, nonatomic) NSNumber* sex;
@property (strong, nonatomic) NSNumber* age;

//附件动态图片列表
@property (copy, nonatomic) NSArray* pics;
//点赞列表
@property (copy, nonatomic) NSMutableArray* tUserAssists;



//用户背景图片
@property (copy, nonatomic) NSArray* backPic;

@property (copy, nonatomic) NSNumber* followState;


@end


/**
 *   {
 "userMoodId": 34,
 "moodContent": null,
 "pic": null,
 "uId": 0,
 "createTime": "2015-09-24 17:01:717",
 "xIndex": 0,
 "yIndex": 0,
 "placeId": 0,
 "moodType": 0,
 "poleNum": 0,
 "playTime": null,
 "playTimes": null,
 "isSync": 0,
 "searchState": 0,
 "uPic": null,
 "userName": null,
 "distance": 12897.4580078125,
 "golfName": "上海佘山高尔夫球场",
 "assistCount": 0,
 "commentCount": 0,
 "collectionState": 0,
 "assistState": 0,
 "pics": null,
 "tUserAssists": null
 }
 */