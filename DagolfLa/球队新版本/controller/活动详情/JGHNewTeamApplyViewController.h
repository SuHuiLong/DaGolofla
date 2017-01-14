//
//  JGHNewTeamApplyViewController.h
//  DagolfLa
//
//  Created by 黄安 on 17/1/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "ViewController.h"
@class JGTeamAcitivtyModel;

@interface JGHNewTeamApplyViewController : ViewController


//activityKey
@property (nonatomic, strong)JGTeamAcitivtyModel *modelss;


@property (copy, nonatomic)NSString *invoiceKey;//发票key
@property (copy, nonatomic)NSString *invoiceName;//发票name
@property (copy, nonatomic)NSString *addressKey;//地址


@property (assign, nonatomic)NSInteger canSubsidy;//是否可以补贴0-不，1-补贴

//用户在球队的真实姓名
@property (nonatomic, strong)NSString *userName;

//当前登录用户是否已经报名 0 - 未报名  1 － 已报名
@property (nonatomic, assign)BOOL isApply;

@property (nonatomic, strong)NSDictionary *teamMember;

@property (nonatomic, strong)NSMutableArray *costListArray;//报名资费列表

@end
