//
//  TeamJoinReasonViewController.h
//  DagolfLa
//
//  Created by bhxx on 16/1/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface TeamJoinReasonViewController : ViewController

@property (strong, nonatomic) NSNumber* teamId;
@property (strong, nonatomic) NSNumber* teamType;

@property (copy, nonatomic) void(^blockJoin)(NSString* , NSNumber *);

@end
