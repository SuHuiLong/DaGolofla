//
//  JGTeamDeatilWKwebViewController.h
//  DagolfLa
//
//  Created by 東 on 16/5/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGTeamDeatilWKwebViewController : ViewController

@property (nonatomic, copy) NSString *teamName;
@property (nonatomic, copy) NSString *detailString;
@property (nonatomic, assign) NSInteger teamKey;






@property (assign, nonatomic) BOOL isManage;//账户管理


@property (assign, nonatomic) BOOL isScore;
@property (assign, nonatomic) NSInteger activeTimeKey;//分享成绩的活动timekey
@property (assign, nonatomic) NSInteger teamTimeKey;//分享成绩的球队timekey
@property (strong, nonatomic) NSString* activeName;
@property (nonatomic, assign)NSInteger isShareBtn;//是否创建分享按钮 1-创建


@end
