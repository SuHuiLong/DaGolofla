//
//  UserDataInformation.h
//  CharmRiuJin
//
//  Created by bhxx on 15/6/18.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInformationModel.h"
#import <RongIMKit/RongIMKit.h>
@interface UserDataInformation : NSObject<RCIMUserInfoDataSource,RCIMGroupInfoDataSource,RCIMGroupUserInfoDataSource>

@property (nonatomic) UserInformationModel *userInfor;
+ (instancetype)sharedInstance;

//- (void)saveUserInformation:(NSDictionary*)dit;

/**
 *  本地缓存用户数据
 */
- (void)saveUserInformation:(UserInformationModel*)model;

/**
 *  同步用户信息到融云服务器
 */
- (void)synchronizeUserInfoRCIM;

/**
 *  获取同步用户信息数据模型
 */
- (RCUserInfo*)userInfoModel;

@end
