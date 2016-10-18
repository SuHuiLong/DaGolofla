//
//  JGLFriendAddViewController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/7/18.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGLFriendAddViewController : ViewController

//球友列表
@property (copy, nonatomic) void (^blockFriendDict)(NSMutableDictionary *);
@property (strong, nonatomic) NSMutableDictionary* dictFinish;

@property (assign, nonatomic) NSInteger lastIndex;//还剩多少个

@end
