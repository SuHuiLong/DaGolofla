//
//  JGLGuestAddPlayerViewController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/8/4.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGLGuestAddPlayerViewController : ViewController


@property (copy, nonatomic) void (^blockRefresh)();

@property (strong, nonatomic) NSNumber* teamKey;

@property (strong, nonatomic) NSNumber* activityKey;
@end
