//
//  VipCardGoodDetailViewModel.h
//  DagolfLa
//
//  Created by SHL on 2017/4/11.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VipCardGoodDetailViewModel : NSObject

/**
 当前卡片的id
 */
@property(nonatomic, copy)NSString *cardId;
/**
 图片
 */
@property(nonatomic, copy)NSString *picURL;
/**
 卡名
 */
@property(nonatomic, copy)NSString *name;
/**
 价格
 */
@property(nonatomic, copy)NSString *price;
/**
 特殊权限
 */
@property(nonatomic, copy)NSString *enjoyService;
//@property(nonatomic, copy)NSString *
/**
 可击球数
 */
@property(nonatomic, assign)NSInteger schemeMaxCount;
/**
 有效期
 */
@property(nonatomic, assign)NSInteger expiry;

/**
 卡片数默认一个
 */
@property(nonatomic, assign)NSInteger cardNum;
@end
