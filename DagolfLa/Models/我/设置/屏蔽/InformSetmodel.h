//
//  InformSetmodel.h
//  DagolfLa
//
//  Created by 東 on 16/3/21.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InformSetmodel : NSObject


@property (assign, nonatomic)int sysMessAll;            // 拒绝所有
@property (assign, nonatomic)int sysMessaboutball;      // 约球
@property (assign, nonatomic)int sysMessball;           // 球队
@property (assign, nonatomic)int sysMessaboutballre;    // 悬赏
@property (assign, nonatomic)int sysMessevent;          // 赛事
@property (assign, nonatomic)long userId;

- (NSArray *) allPropertyNames;

@end
