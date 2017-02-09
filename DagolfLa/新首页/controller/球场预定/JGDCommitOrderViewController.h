//
//  JGDCommitOrderViewController.h
//  DagolfLa
//
//  Created by 東 on 16/12/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGDCommitOrderViewController : ViewController


@property (nonatomic, strong) NSMutableDictionary *detailDic;


@property (nonatomic, retain)NSNumber *timeKey; // 球场key

@property (nonatomic, copy) NSString *selectMoney;          //  选择的线上支付价格
@property (nonatomic, copy) NSString *selectSceneMoney;     //  选择的线下支付价格
@property (nonatomic, copy) NSString *selectDate;           //  选择的时间


@end
