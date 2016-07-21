//
//  JGReturnMD5Str.h
//  DagolfLa
//
//  Created by 東 on 16/7/7.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGReturnMD5Str : NSObject


+ (NSString *)getTeamMemberListWithTeamKey:(NSInteger)teamKey userKey:(NSInteger)userKey;

+ (NSString *)getTeamWithDrawListWithTeamKey:(NSInteger)teamKey userKey:(NSInteger)userKey;

+ (NSString *)getTeamActivitySignUpListWithTeamKey:(NSInteger)teamkey activityKey:(NSInteger)activityKey userKey:(NSInteger)uerKey;

+ (NSString *)getAuditTeamMemberListWithTeamKey:(NSInteger)teamKey userKey:(NSInteger)userKey;

+ (NSString *)getTeamMemberWithMemberKey:(NSInteger)memberKey;

+ (NSString *)scorePolenumberRankingWithUserKey:(NSInteger)userKey srcKey:(NSInteger)srcKey srcType:(NSInteger)srcType;

+ (NSString *)getUserScoreWithTeamKey:(NSInteger)teamKey  userKey:(NSInteger)userKey srcKey:(NSInteger)srcKey srcType:(NSInteger)srcType;

+ (NSString *)getUserScoreWithUserKey:(NSInteger)userKey srcKey:(NSInteger)srcKey srcType:(NSInteger)srcType;

+ (NSString *)getTeamBillInfoWithTeamKey:(NSInteger)teamKey userKey:(NSInteger)userKey;

+ (NSString *)getTeamBillYearInfoWithTeamKey:(NSInteger)teamKey userKey:(NSInteger)userKey;

+ (NSString *)getTeamAccountInfoWithTeamKey:(NSInteger)teamKey userKey:(NSInteger)userKey;

+ (NSString *)getTeamGroupNameListTeamKey:(NSInteger)teamKey activityKey:(NSInteger)activityKey userKey:(NSInteger)userKey;

+ (NSString *)getScoreListUserKey:(NSInteger)userKey andScoreKey:(NSInteger)scoreKey;

@end
