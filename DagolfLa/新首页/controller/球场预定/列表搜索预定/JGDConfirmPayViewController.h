//
//  JGDConfirmPayViewController.h
//  DagolfLa
//
//  Created by 東 on 16/12/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGDConfirmPayViewController : ViewController

@property (nonatomic, assign) CGFloat payMoney;

@property (nonatomic, strong) NSNumber *srcKey;

@property (nonatomic, strong) NSMutableArray *playerArray;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *remoark;

@property (nonatomic, strong) NSNumber *orderKey;

@property (nonatomic, assign) NSInteger fromWitchVC; // 1 VIP

@end
