//
//  GameModel.h
//  DagolfLa
//
//  Created by bhxx on 15/11/28.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "BaseModel.h"

@interface GameModel : BaseModel


@property (strong, nonatomic) NSNumber* eventId;
@property (strong, nonatomic) NSNumber* eventCreateUserId;
@property (strong, nonatomic) NSString* eventTite;
@property (strong, nonatomic) NSString* eventPic;
@property (strong, nonatomic) NSString* eventdate;
@property (strong, nonatomic) NSString* eventTime;
@property (strong, nonatomic) NSString* eventendDate;
@property (strong, nonatomic) NSNumber* eventballId;
@property (strong, nonatomic) NSString* eventBallName;
@property (strong, nonatomic) NSNumber* eventBallxIndex;
@property (strong, nonatomic) NSNumber* eventBallyIndex;
@property (strong, nonatomic) NSString* eventCreateTime;
@property (strong, nonatomic) NSNumber* eventIsPrivate;
//y邀请码
@property (strong, nonatomic) NSString* eventCompetitionNums;
//观赛吗
@property (strong, nonatomic) NSString* eventWatchNums;
@property (strong, nonatomic) NSNumber* eventIsdelete;
@property (strong, nonatomic) NSNumber* eventisEndStart;
@property (strong, nonatomic) NSString* elapseDate;
@property (strong ,nonatomic) NSString* userName;
@property (strong ,nonatomic) NSNumber* userId;
@property (strong ,nonatomic) NSString* userPic;
@property (strong ,nonatomic) NSNumber* distance;
@property (strong ,nonatomic) NSNumber* forrelevant;
@property (strong, nonatomic) NSString* evnntWeek;
@property (strong, nonatomic) NSString* eventendWeek;
@property (strong, nonatomic) NSString* eventContext;
@property (strong, nonatomic) NSNumber* eventClickNums;
@property (strong, nonatomic) NSNumber* eventNums;

@property (strong, nonatomic) NSNumber* isjf;
@end


/*
 "eventId": 3,
 "eventCreateUserId": 40,
 "eventTite": "xiaoa",
 "eventPic": null,
 "eventdate": "2012-12-12",
 "eventTime": "12:00:00",
 "eventendDate": null,
 "eventballId": 0,
 "eventBallName": null,
 "eventBallxIndex": 0,
 "eventBallyIndex": 0,
 "eventCreateTime": null,
 "eventIsPrivate": 2,
 "eventCompetitionNums": "679804",
 "eventWatchNums": "438291",
 "eventIsdelete": 0,
 "eventisEndStart": 3,
 "elapseDate": null,
 "userName": null,
 "userPic": null,
 "distance": 0,
 "forrelevant": 3
 
 */