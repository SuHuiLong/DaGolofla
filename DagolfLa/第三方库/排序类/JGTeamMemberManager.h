//
//  JGTeamMemberManager.h
//  DagolfLa
//
//  Created by 黄达明 on 16/6/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGTeamMemberManager : NSObject

+(NSArray *)archiveNumbers:(NSArray *)originalArray;

//活动报名人排序
+(NSArray *)activityArchiveNumbers:(NSArray *)originalArray;

@end
