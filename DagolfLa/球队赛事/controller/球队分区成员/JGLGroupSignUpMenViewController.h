//
//  JGLGroupSignUpMenViewController.h
//  DagolfLa
//
//  Created by Madridlee on 16/10/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
//单个球队的成员列表
#import "JGLGroupPeopleDetileTableViewCell.h"
@interface JGLGroupSignUpMenViewController : ViewController


@property (strong, nonatomic) NSNumber* teamKey;

@property (strong, nonatomic) NSNumber* userKey;

@property (strong, nonatomic) NSMutableArray* dataArrayAll;

@property (assign, nonatomic) void(^blockCon)(NSMutableArray *);//返回刷新array数据

@end
