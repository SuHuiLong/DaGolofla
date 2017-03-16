//
//  SearchWithMapModel.h
//  DagolfLa
//
//  Created by SHL on 2017/3/15.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchWithMapModel : NSObject
//球场id
@property(nonatomic, copy)NSString *parkId;
//球场名
@property(nonatomic, copy)NSString *parkName;
//坐标
@property(nonatomic, assign)CGFloat latitude;
@property(nonatomic, assign)CGFloat longtitude;
//价格
@property(nonatomic, copy)NSString *orderPrice;
//订单个数
@property(nonatomic, assign)NSInteger orderNum;
@end
