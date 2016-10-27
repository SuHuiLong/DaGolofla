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

+ (NSString *)getStandardleversBallKey:(NSInteger)ballKey andRegion1:(NSString *)region1 andRegion2:(NSString *)region2;

+ (NSString *)getCaddieAuthUserKey:(NSInteger)userKey;

+ (NSString *)getUserTransDetailOrderTypeListUserKey:(NSInteger)userKey andOrderType:(NSInteger)orderType;

+ (NSString *)getTeamActivityCostListUserKey:(NSInteger)userKey andActivityKey:(NSInteger)activityKey;

+ (NSString *)getHoleNameAndPolesBallKey:(NSInteger)ballKey andArea:(NSString *)area;


+ (NSString *)getTeamCompeteSignUpListWithMatchKey:(NSInteger)matchKey userKey:(NSInteger)uerKey;

+ (NSString *)getTeamCompeteSignUpListWithMatchKey:(NSInteger)matchKey teamKey:(NSInteger)teamKey;
+ (NSString *)getTeamCompeteSignUpListWithuserKey:(NSInteger)uerKey roundKey:(NSInteger)roundKey;
+ (NSString *)getTeamCompeteSignUpListWithAlbumKey:(NSInteger)albumKey userKey:(NSInteger)userKey;
@end
