//
//  JGDPrizeViewController.h
//  DagolfLa
//
//  Created by 東 on 16/7/4.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
#import "JGTeamAcitivtyModel.h"

@interface JGDPrizeViewController : ViewController

@property (nonatomic, assign) NSInteger activityKey;

@property (nonatomic, assign) NSInteger teamKey;

@property (nonatomic, assign) NSInteger isManager;

@property (nonatomic, strong) JGTeamAcitivtyModel *model;

@end
