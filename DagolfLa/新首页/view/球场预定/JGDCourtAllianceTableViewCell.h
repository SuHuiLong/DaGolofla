//
//  JGDCourtAllianceTableViewCell.h
//  DagolfLa
//
//  Created by 東 on 17/3/7.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGDCourtAllianceTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *courtNameLB;

@property (nonatomic, strong) UILabel *serviceLB;


@property (nonatomic, strong) UILabel *vipPriceLB;

@property (nonatomic, strong) UILabel *sellPriceLB;
@property (nonatomic, strong) UILabel *originalPriceLB;    // 原价


@property (nonatomic, strong) UIButton *vipBtn;

@property (nonatomic, strong) UIButton *normalBtn;
@property (nonatomic, strong) UILabel *normalLB;

@property (nonatomic, strong) UILabel *remainderBallLB;

@property (nonatomic, strong) NSMutableDictionary *dataDic;


@property (nonatomic, copy) NSString *leagueMoney;          // 联盟会员价
@property (nonatomic, copy) NSString *unitPrice;            //  总价
@property (nonatomic, copy) NSString *payMoney;             //  线上
@property (nonatomic, copy) NSString *deductionMoney;       // 立减价格
@property (nonatomic, assign) NSInteger payType;            //






@end
