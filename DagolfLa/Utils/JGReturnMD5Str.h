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

@end
