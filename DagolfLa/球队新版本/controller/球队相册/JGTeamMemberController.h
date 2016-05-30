//
//  JGTeamMemberController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"


@interface JGTeamMemberController : ViewController


@property (strong, nonatomic) NSNumber* teamKey;

@property (assign, nonatomic) BOOL isEdit;

@property (assign, nonatomic) BOOL isManager;

@property (copy ,nonatomic) NSString *power;

@property(nonatomic,copy)void(^block)(NSInteger str,NSString *str1,NSString *str2);

@end
