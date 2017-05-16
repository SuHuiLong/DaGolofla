//
//  VipCardOrderDetailFormatData.h
//  DagolfLa
//
//  Created by SHL on 2017/4/13.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VipCardOrderDetailFormatData : NSObject

/**
 格式化订单详情

 @param data 后台返回数据
 @return 格式数据
 */
-(NSMutableArray *)formatData:(id)data;


/**
 订单实际状态 只有未付款显示支付按钮
 */
@property(nonatomic, copy)NSString *stateButtonString;
@end
