//
//  JGTeamApplyViewController.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
#import "JGTeamAcitivtyModel.h"

@interface JGTeamApplyViewController : ViewController

@property (weak, nonatomic) IBOutlet UITableView *teamApplyTableView;

//activityKey
@property (nonatomic, strong)JGTeamAcitivtyModel *modelss;


@property (copy, nonatomic)NSString *invoiceKey;//发票key
@property (copy, nonatomic)NSString *invoiceName;//发票name
@property (copy, nonatomic)NSString *addressKey;//地址


@property (assign, nonatomic)NSInteger isTeamChannal;

//用户在球队的真实姓名
@property (nonatomic, strong)NSString *userName;

//当前登录用户是否已经报名 0 - 未报名  1 － 已报名
@property (nonatomic, assign)BOOL isApply;

@end
