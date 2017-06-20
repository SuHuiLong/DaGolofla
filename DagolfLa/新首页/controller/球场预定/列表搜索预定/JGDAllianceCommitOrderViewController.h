//
//  JGDAllianceCommitOrderViewController.h
//  DagolfLa
//
//  Created by 東 on 17/3/7.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "ViewController.h"

@interface JGDAllianceCommitOrderViewController : ViewController

@property (nonatomic, strong) NSMutableDictionary *detailDic;


@property (nonatomic, retain)NSNumber *timeKey; // 球场key

@property (nonatomic, copy) NSString *selectMoney;          //  选择的线上支付价格 // 联盟会员价格
@property (nonatomic, copy) NSString *selectSceneMoney;     //  选择的线下支付价格
@property (nonatomic, copy) NSString *selectDate;           //  选择的时间

@property (nonatomic,copy) NSString *normolPrice;           //  普通用户价格

//本球场可使用红包列表
@property (nonatomic, strong) NSMutableArray *myCouponList;

@end
