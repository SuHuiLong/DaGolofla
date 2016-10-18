//
//  JGHPublishEventViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/9/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGHPublishEventViewController : ViewController

@property (nonatomic, retain) UIImageView *imgProfile;

@property (nonatomic, assign)NSInteger teamKey;//发布活动teamkey


@property (strong, nonatomic) void (^refreshBlock)();

@property (nonatomic, strong)NSMutableArray *costListArray;//费用列表

@end
