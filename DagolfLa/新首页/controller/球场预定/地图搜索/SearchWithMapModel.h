//
//  SearchWithMapModel.h
//  DagolfLa
//
//  Created by SHL on 2017/3/15.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchWithMapModel : NSObject

/**
 0：订场的数据  1：活动的数据
 */
@property (nonatomic,assign) NSInteger dataType;
//球场id
@property(nonatomic, copy)NSString *parkId;
//球场名
@property(nonatomic, copy)NSString *parkName;
//完整球场名
@property(nonatomic, copy)NSString *parkFullName;
//坐标
@property(nonatomic, assign)CGFloat latitude;
@property(nonatomic, assign)CGFloat longtitude;
//订场
@property(nonatomic, assign)NSInteger orderNum;
//订场的key
@property(nonatomic, copy)NSString *bookballKey;
//省份名
@property (nonatomic,copy) NSString *name;
//数量||活动个数
@property (nonatomic,assign) NSInteger count;
//价格
@property(nonatomic, copy)NSString *orderPrice;
//是否是联盟会员
@property(nonatomic, assign)NSInteger isLeague;
//活动球场key
@property(nonatomic, copy)NSString *ballKey;
//活动key
@property (nonatomic,copy) NSString *activityKey;
//可报名活动个数
@property (nonatomic,assign) NSInteger canSignupCount;

@end
