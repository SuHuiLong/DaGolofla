//
//  TeamInviteViewController.h
//  DaGolfla
//
//  Created by bhxx on 15/9/8.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//
#import "ViewController.h"

@interface TeamInviteViewController : ViewController
@property(nonatomic,copy)void(^block)(NSMutableArray *arr1,NSMutableArray *arr2,NSMutableArray *arr3);


@property (copy, nonatomic) NSMutableArray* arrayData;
@property (copy, nonatomic) NSMutableArray* arrayIndex;

@end