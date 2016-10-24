//
//  JGReturnMD5Str.m
//  DagolfLa
//
//  Created by 東 on 16/7/7.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGReturnMD5Str.h"

@implementation JGReturnMD5Str


+ (NSString *)getTeamActivitySignUpListWithTeamKey:(NSInteger)teamkey activityKey:(NSInteger)activityKey userKey:(NSInteger)uerKey{

    return [Helper md5HexDigest:[NSString stringWithFormat:@"teamKey=%td&activityKey=%td&userKey=%tddagolfla.com", teamkey, activityKey, uerKey]];
}

+ (NSString *)getTeamMemberListWithTeamKey:(NSInteger)teamKey userKey:(NSInteger)userKey{
    return [Helper md5HexDigest:[NSString stringWithFormat:@"teamKey=%td&userKey=%tddagolfla.com", teamKey, userKey]];
}

+ (NSString *)getAuditTeamMemberListWithTeamKey:(NSInteger)teamKey userKey:(NSInteger)userKey{
    return [Helper md5HexDigest:[NSString stringWithFormat:@"teamKey=%td&userKey=%tddagolfla.com",teamKey, userKey]];
}

+ (NSString *)getTeamMemberWithMemberKey:(NSInteger)memberKey{
    return [Helper md5HexDigest:[NSString stringWithFormat:@"memberKey=%tddagolfla.com",memberKey]];
}

+ (NSString *)scorePolenumberRankingWithUserKey:(NSInteger)userKey srcKey:(NSInteger)srcKey srcType:(NSInteger)srcType{
    return [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%td&srcKey=%td&srcType=%tddagolfla.com", userKey, srcKey, srcType]];
}


+ (NSString *)getUserScoreWithUserKey:(NSInteger)userKey srcKey:(NSInteger)srcKey srcType:(NSInteger)srcType {
    return [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%td&srcKey=%td&srcType=%tddagolfla.com", userKey, srcKey, srcType]];
}

+ (NSString *)getUserScoreWithTeamKey:(NSInteger)teamKey  userKey:(NSInteger)userKey srcKey:(NSInteger)srcKey srcType:(NSInteger)srcType {
    return [Helper md5HexDigest:[NSString stringWithFormat:@"teamKey=%td&userKey=%td&srcKey=%td&srcType=%tddagolfla.com",teamKey , userKey, srcKey, srcType]];
}


+ (NSString *)getTeamBillInfoWithTeamKey:(NSInteger)teamKey userKey:(NSInteger)userKey{
    return [Helper md5HexDigest:[NSString stringWithFormat:@"teamKey=%td&userKey=%tddagolfla.com",teamKey, userKey]];
}


+ (NSString *)getTeamBillYearInfoWithTeamKey:(NSInteger)teamKey userKey:(NSInteger)userKey{
    return [Helper md5HexDigest:[NSString stringWithFormat:@"teamKey=%td&userKey=%tddagolfla.com",teamKey, userKey]];
}


+ (NSString *)getTeamAccountInfoWithTeamKey:(NSInteger)teamKey userKey:(NSInteger)userKey{
    return [Helper md5HexDigest:[NSString stringWithFormat:@"teamKey=%td&userKey=%tddagolfla.com", teamKey, userKey]];
}


+ (NSString *)getTeamWithDrawListWithTeamKey:(NSInteger)teamKey userKey:(NSInteger)userKey {
    return [Helper md5HexDigest:[NSString stringWithFormat:@"teamKey=%td&userKey=%tddagolfla.com",teamKey, userKey]];
}

+ (NSString *)getTeamGroupNameListTeamKey:(NSInteger)teamKey activityKey:(NSInteger)activityKey userKey:(NSInteger)userKey{
    return [Helper md5HexDigest:[NSString stringWithFormat:@"teamKey=%td&activityKey=%td&userKey=%tddagolfla.com",teamKey, activityKey, userKey]];
}

+ (NSString *)getScoreListUserKey:(NSInteger)userKey andScoreKey:(NSInteger)scoreKey{
    return [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%td&scoreKey=%tddagolfla.com", userKey, scoreKey]];
}

+ (NSString *)getStandardleversBallKey:(NSInteger)ballKey andRegion1:(NSString *)region1 andRegion2:(NSString *)region2{
    return [Helper md5HexDigest:[NSString stringWithFormat:@"ballKey=%td&region1=%@&region2=%@dagolfla.com", ballKey, region1, region2]];
}

+ (NSString *)getCaddieAuthUserKey:(NSInteger)userKey{
    return [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%tddagolfla.com", userKey]];
}

+ (NSString *)getUserTransDetailOrderTypeListUserKey:(NSInteger)userKey andOrderType:(NSInteger)orderType{
    return [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%td&orderType=%tddagolfla.com", userKey, orderType]];
}

+ (NSString *)getTeamActivityCostListUserKey:(NSInteger)userKey andActivityKey:(NSInteger)activityKey{
    return [Helper md5HexDigest:[NSString stringWithFormat:@"activityKey=%td&userKey=%tddagolfla.com", activityKey, userKey]];
}
+ (NSString *)getHoleNameAndPolesBallKey:(NSInteger)ballKey andArea:(NSString *)area{
    return [Helper md5HexDigest:[NSString stringWithFormat:@"ballKey=%td&area=%@dagolfla.com", ballKey, area]];
}


+ (NSString *)getTeamCompeteSignUpListWithMatchKey:(NSInteger)matchKey userKey:(NSInteger)uerKey{
    
    return [Helper md5HexDigest:[NSString stringWithFormat:@"matchKey=%td&userKey=%tddagolfla.com", matchKey, uerKey]];
}

+ (NSString *)getTeamCompeteSignUpListWithMatchKey:(NSInteger)matchKey teamKey:(NSInteger)teamKey{
    return [Helper md5HexDigest:[NSString stringWithFormat:@"matchKey=%td&teamKey=%tddagolfla.com", matchKey, teamKey]];
}
+ (NSString *)getTeamCompeteSignUpListWithuserKey:(NSInteger)uerKey roundKey:(NSInteger)roundKey{
    return [Helper md5HexDigest:[NSString stringWithFormat:@"userKey=%td&roundKey=%tddagolfla.com", uerKey, roundKey]];
}

/*
 // App分享的MD5签名规则
 1. /team/getTeamActivitySignUpList?teamKey=1&activityKey=1&userKey=1 MD5加密
 2. /team/getTeamMemberList?teamKey=1&userKey=1  MD5加密
 3. /team/getAuditTeamMemberList?teamKey=1&userKey=1  MD5加密
 4. /team/getTeamMember?memberKey=1  MD5加密

 
 24./score/getCaddieAuth?userKey=11   
 
 5. /score/scorePolenumberRanking?userKey=1&srcKey=1&srcType=1  MD5加密
 6. /score/getUserScore?userKey=1&srcKey=1&srcType=1  MD5加密
 7. /team/getTeamBillInfo?teamKey=1&userKey=1  MD5加密
 8. /team/getTeamBillYearInfo?teamKey=1&userKey=1 MD5加密
 9. /team/getTeamAccountInfo?teamKey=1&userKey=1 MD5加密
 */






@end
