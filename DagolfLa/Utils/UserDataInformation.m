//
//  UserDataInformation.m
//  CharmRiuJin
//
//  Created by bhxx on 15/6/18.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "UserDataInformation.h"
#import <RongIMLib/RongIMLib.h>
#import "AppDelegate.h"

@implementation UserDataInformation

- (instancetype)init
{
    self = [super init];
    if (self) {
        //设置信息提供者
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static UserDataInformation *s_engine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_engine = [[UserDataInformation alloc] init];
    });
    return s_engine;
}

- (void)saveUserInformation:(UserInformationModel *)model {
    
    self.userInfor  = model;
    
    //刷新Kit层用户数据
}

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [dataDic setObject:DEFAULF_USERID forKey:@"userKey"];
    [dataDic setObject:userId forKey:@"seeUserKey"];
    [dataDic setObject:[NSString stringWithFormat:@"userKey=%@&seeUserKey=%@dagolfla.com",DEFAULF_USERID, userId] forKey:@"md5"];
    
    [[JsonHttp jsonHttp]httpRequest:@"user/getUserMainInfo" JsonKey:nil withData:dataDic requestMethod:@"GET" failedBlock:^(id errType) {
        
    } completionBlock:^(id data) {
        
        if ([[data objectForKey:@"packSuccess"] integerValue] == 1) {            
            RCUserInfo *userInfo = [[RCUserInfo alloc] init];
            userInfo.userId = userId;
            
            if ([data objectForKey:@"userFriend"]) {
                
                userInfo.name = [[data objectForKey:@"userFriend"] objectForKey:@"remark"] ? [[data objectForKey:@"userFriend"] objectForKey:@"remark"] : [[data objectForKey:@"userFriend"] objectForKey:@"userName"];
                
                if ([data objectForKey:@"handImgUrl"]) {
                    userInfo.portraitUri = [data objectForKey:@"handImgUrl"];
                }
                
                [[RCIM sharedRCIM] refreshUserInfoCache:userInfo  withUserId:userId];
                
                completion(userInfo);
            }else{
                if ([data objectForKey:@"user"]) {
                    if ([[data objectForKey:@"user"] objectForKey:UserName]) {
                        userInfo.name = [[data objectForKey:@"user"] objectForKey:UserName];
                    }
                    
                    if ([data objectForKey:@"handImgUrl"]) {
                        userInfo.portraitUri = [data objectForKey:@"handImgUrl"];
                    }
                    
                    [[RCIM sharedRCIM] refreshUserInfoCache:userInfo  withUserId:userId];
                    
                    completion(userInfo);
                }
            }
        }
    }];
    
}

- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion {
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    if ([user objectForKey:@"chatDict"]) {
        NSDictionary *dict0=[user objectForKey:@"chatDict"];
        dict=[[NSMutableDictionary alloc] initWithDictionary:dict0];
    }
    [dict setObject:@"3" forKey:groupId];
    [user setObject:dict forKey:@"chatDict"];
    [user synchronize];
    [[PostDataRequest sharedInstance] postDataRequest:@"Tchat/queryByChat.do" parameter:@{@"chatId":groupId,@"uId":[user objectForKey:@"userId"]} success:^(id respondsData) {
        
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dict objectForKey:@"success"] boolValue]) {
            RCGroup *groupInfo = [[RCGroup alloc] init];
            groupInfo.groupId = groupId;
            if(![Helper isBlankString:[[dict objectForKey:@"rows"] objectForKey:@"chatName"]])groupInfo.groupName = [[dict objectForKey:@"rows"] objectForKey:@"chatName"];
            if(![Helper isBlankString:[[dict objectForKey:@"rows"] objectForKey:@"pic"]])groupInfo.portraitUri = [NSString stringWithFormat:@"http://wf-1990.6655.la:16649/%@",[[dict objectForKey:@"rows"] objectForKey:@"pic"]];
            completion(groupInfo);
        }else {
            completion(nil);
        }
    } failed:^(NSError *error) {
        completion(nil);
    }];
}

- (void)synchronizeUserInfoRCIM {
    [[RCIM sharedRCIM] refreshUserInfoCache:[self userInfoModel] withUserId:[self userInfoModel].userId];
}

- (RCUserInfo*)userInfoModel {
    RCUserInfo *userInfo = [[RCUserInfo alloc] init];
    userInfo.userId = [NSString stringWithFormat:@"%@", [UserDataInformation sharedInstance].userInfor.userId];
    userInfo.name = [UserDataInformation sharedInstance].userInfor.userName;
    userInfo.portraitUri = [NSString stringWithFormat:@"%@",[Helper imageUrl:[UserDataInformation sharedInstance].userInfor.pic]];
    return userInfo;
}
@end
