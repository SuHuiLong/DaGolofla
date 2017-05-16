//
//  JGAddFriendViewController.h
//  DagolfLa
//
//  Created by 東 on 16/11/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGAddFriendViewController : ViewController

@property (nonatomic, strong) NSNumber *otherUserKey;

@property (nonatomic, copy) void (^popToVC)(NSInteger num);  // 1 请求发出  0 请求失败（列表不删除）


@end
