//
//  UserDataInformation.m
//  CharmRiuJin
//
//  Created by bhxx on 15/6/18.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "UserDataInformation.h"
#import <RongIMLib/RongIMLib.h>
#import "Helper.h"
#import "PostDataRequest.h"
#import "AppDelegate.h"

#import "NoteModel.h"
#import "NoteHandlle.h"

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
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    if ([user objectForKey:@"chatDict"]) {
        NSDictionary *dict0=[user objectForKey:@"chatDict"];
        dict=[[NSMutableDictionary alloc] initWithDictionary:dict0];
    }
    [dict setObject:@"1" forKey:userId];
    [user setObject:dict forKey:@"chatDict"];
    [user synchronize];
    //NSLog(@"%@   %@",[user objectForKey:@"userId"],userId);
    [[PostDataRequest sharedInstance] postDataRequest:@"user/getUserNameandPic.do" parameter:@{@"uid":[user objectForKey:@"userId"],@"orderUserId":userId} success:^(id respondsData) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:respondsData options:NSJSONReadingAllowFragments error:nil];
        if ([[dict objectForKey:@"success"] boolValue]) {
            RCUserInfo *userInfo = [[RCUserInfo alloc] init];
            userInfo.userId = userId;
            if ([[dict objectForKey:@"rows"] objectForKey:@"other"] != [NSNull null]) {
                if (![Helper isBlankString:[[[dict objectForKey:@"rows"] objectForKey:@"other"]objectForKey:@"userName"]]) {
                    
                    NoteModel *model = [NoteHandlle selectNoteWithUID:[[[dict objectForKey:@"rows"] objectForKey:@"other"]objectForKey:@"userId"]];
                    if ([model.userremarks isEqualToString:@"(null)"] || [model.userremarks isEqualToString:@""] || model.userremarks == nil) {
                        userInfo.name = [[[dict objectForKey:@"rows"] objectForKey:@"other"]objectForKey:@"userName"];
                    }else{
                        userInfo.name = model.userremarks;
                    }
                    
//                    userInfo.name = [[[dict objectForKey:@"rows"] objectForKey:@"other"]objectForKey:@"userName"];
                }
                if(![Helper isBlankString:[[[dict objectForKey:@"rows"] objectForKey:@"other"]objectForKey:@"pic"]])
                    userInfo.portraitUri = [NSString stringWithFormat:@"http://www.dagolfla.com:8081/small_%@",[[[dict objectForKey:@"rows"] objectForKey:@"other"]objectForKey:@"pic"]];
            }
            
            
            completion(userInfo);
        }else {
            completion(nil);
        }
    } failed:^(NSError *error) {
        completion(nil);
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
-(void)getUserInfoWithUserId:(NSString *)userId inGroup:(NSString *)groupId completion:(void (^)(RCUserInfo *))completion{
    
}
- (void)synchronizeUserInfoRCIM {
    [[RCIM sharedRCIM] refreshUserInfoCache:[self userInfoModel] withUserId:[self userInfoModel].userId];
}

- (RCUserInfo*)userInfoModel {
    RCUserInfo *userInfo = [[RCUserInfo alloc] init];
    userInfo.userId = [[UserDataInformation sharedInstance].userInfor.userId stringValue];
    userInfo.name = [UserDataInformation sharedInstance].userInfor.userName;
    userInfo.portraitUri = [NSString stringWithFormat:@"%@",[Helper imageUrl:[UserDataInformation sharedInstance].userInfor.pic]];
    return userInfo;
}
@end
