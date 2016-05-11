//
//  JGTeamAcitivtyModel.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/10.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGTeamAcitivtyModel : NSObject
//活动列表标题
@property (strong, nonatomic) NSString *activitytitle;
//报名
@property (strong, nonatomic) NSString *Apply;
//活动时间
@property (strong, nonatomic) NSString *activityName;
//活动地址
@property (strong, nonatomic) NSString *activityAddress;
//报名人数
@property (strong, nonatomic) NSString *applyNumber;

@end
