//
//  JGDPaySuccessViewController.h
//  DagolfLa
//
//  Created by 東 on 16/12/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGDPaySuccessViewController : ViewController

@property (nonatomic, assign) NSInteger payORlaterPay; // 1 是 pay  2 laterPay
@property (nonatomic, strong) NSNumber *orderKey;

@end
