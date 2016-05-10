//
//  TeamDeMessViewController.h
//  DaGolfla
//
//  Created by bhxx on 15/9/6.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ViewController.h"
#import "TeamModel.h"
@interface TeamDeMessViewController : ViewController

@property (strong, nonatomic) TeamModel* modelMian;
//球队ID
@property (strong, nonatomic) NSNumber* teamId;
//管理权限
@property (strong, nonatomic) NSNumber* forrelvant;

@property (strong, nonatomic) NSNumber* typeNews;

@property (assign, nonatomic) NSInteger indexNum;

@property (copy, nonatomic) void(^forBlock)(NSNumber *,NSInteger);

@property (assign, nonatomic) BOOL isBack;
@end
