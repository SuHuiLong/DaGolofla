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




/*
 // App分享的MD5签名规则
 1. /team/getTeamActivitySignUpList?teamKey=1&activityKey=1&userKey=1 MD5加密
 2. /team/getTeamMemberList?teamKey=1&userKey=1  MD5加密
 3. /team/getAuditTeamMemberList?teamKey=1&userKey=1  MD5加密
 4. /team/getTeamMember?memberKey=1  MD5加密

 
 
 
 5. /score/scorePolenumberRanking?userKey=1&srcKey=1&srcType=1  MD5加密
 6. /score/getUserScore?userKey=1&srcKey=1&srcType=1  MD5加密
 7. /team/getTeamBillInfo?teamKey=1&userKey=1  MD5加密
 8. /team/getTeamBillYearInfo?teamKey=1&userKey=1 MD5加密
 9. /team/getTeamAccountInfo?teamKey=1&userKey=1 MD5加密
 */






@end
