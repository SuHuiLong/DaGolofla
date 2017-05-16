//
//  VipCardOrderDetailViewController.h
//  DagolfLa
//
//  Created by SHL on 2017/4/12.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "BaseViewController.h"

@interface VipCardOrderDetailViewController : BaseViewController

/**
 订单key
 */
@property(nonatomic, copy)NSString *orderKey;

/**
 是否返回指定界面
 */
@property(nonatomic, assign)BOOL ispopAssign;

@end
