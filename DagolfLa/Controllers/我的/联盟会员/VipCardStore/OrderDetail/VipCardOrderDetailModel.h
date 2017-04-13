//
//  VipCardOrderDetailModel.h
//  DagolfLa
//
//  Created by SHL on 2017/4/13.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VipCardOrderDetailModel : NSObject

/**
 标题
 */
@property(nonatomic, copy)NSString *title;
/**
 内容
 */
@property(nonatomic, copy)NSString *content;

/**
 状态
 1：红色字体
 2：权益协议
 */
@property(nonatomic, assign)NSInteger status;

@end
