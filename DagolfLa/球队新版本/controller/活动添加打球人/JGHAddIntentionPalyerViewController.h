//
//  JGHAddIntentionPalyerViewController.h
//  DagolfLa
//
//  Created by 黄安 on 17/2/9.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGHAddIntentionPalyerViewController : ViewController

@property (nonatomic, strong)NSMutableArray *costListArray;//资费类型

@property (nonatomic, strong)NSMutableArray *playListArray;//打球人

@property (nonatomic, assign)NSInteger activityKey;//活动Key

@property (nonatomic, assign)NSInteger teamKey;//球队Key

@property (copy, nonatomic) void (^blockRefresh)();


@end
