//
//  VipCardOrderListModel.h
//  DagolfLa
//
//  Created by SHL on 2017/4/10.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VipCardOrderListModel : NSObject

/**
 订单id
 */
@property(nonatomic, copy)NSString *timeKey;
/**
 卡片图
 */
@property(nonatomic, copy)NSString *bigPicURL;
/**
 卡片名
 */
@property(nonatomic, copy)NSString *cardName;
/**
 卡片类型id
 */
@property(nonatomic, copy)NSString *cardTypeKey;
/**
 创建时间
 */
@property(nonatomic, copy)NSString *createTime;
/**
 单张价格
 */
@property(nonatomic, copy)NSString *money;
/**
 总金额
 */
@property(nonatomic, copy)NSString *totalMoney;
/**
 订单状态
 */
@property(nonatomic, copy)NSString *stateShowString;
/**
 购买数量
 */
@property(nonatomic, assign)NSInteger buyNumber;


@end
