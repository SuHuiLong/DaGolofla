//
//  JGTeamActivityViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/10.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGTeamActivityViewController : ViewController

@property (nonatomic, assign)NSInteger myActivityList;//我的球队活动传 －－ 1
@property (nonatomic, assign)NSInteger timeKey;//球队key

//发布活动权限
@property (nonatomic, copy)NSString *power;

//来自我的活动
@property (nonatomic, assign)NSInteger isMEActivity;


@end
