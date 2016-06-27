//
//  JGLPaySignUpViewController.h
//  DagolfLa
//
//  Created by 黄达明 on 16/6/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"
@class JGTeamAcitivtyModel;

@interface JGLPaySignUpViewController : ViewController

@property (nonatomic, strong) JGTeamAcitivtyModel *model;

@property (nonatomic, assign)NSInteger activityKey;

//用户在球队的真实姓名
@property (nonatomic, strong)NSString *userName;
//用户真实信息保存的数据
@property (nonatomic, strong)NSMutableDictionary* dictRealDetail;

//当前登录用户是否已经报名 0 - 未报名  1 － 已报名
@property (nonatomic, assign)BOOL isApply;

@property (copy, nonatomic)NSString *invoiceKey;//发票key
@property (copy, nonatomic)NSString *invoiceName;//发票name
@property (copy, nonatomic)NSString *addressKey;//地址

@end
