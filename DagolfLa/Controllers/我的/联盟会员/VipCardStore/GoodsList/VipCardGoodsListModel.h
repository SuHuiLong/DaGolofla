//
//  VipCardGoodsListModel.h
//  DagolfLa
//
//  Created by SHL on 2017/4/6.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VipCardGoodsListModel : NSObject


/**
 卡片id
 */
@property(nonatomic,copy)NSString *timeKey;

/**
 图片urlStr
 */
@property(nonatomic,copy)NSString *picURL;

/**
 会员卡名
 */
@property(nonatomic,copy)NSString *name;

/**
 价格
 */
@property(nonatomic,copy)NSString *price;

/**
 有效期
 */
@property(nonatomic,assign)NSInteger expiry;

/**
 权益
 */
@property(nonatomic,assign)NSInteger schemeMaxCount;
@end



