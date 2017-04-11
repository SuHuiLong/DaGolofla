//
//  VipCardGoodsListCollectionViewCell.h
//  DagolfLa
//
//  Created by SHL on 2017/4/6.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VipCardGoodsListModel.h"
@interface VipCardGoodsListCollectionViewCell : UICollectionViewCell

/**
 卡片图片
 */
@property(nonatomic, copy)UIImageView *cardImageView;

/**
 卡片名和价格
 */
@property(nonatomic, copy)UILabel *nameAndPrice;

/**
 权益
 */
@property(nonatomic, copy)UILabel *equity;

/**
 配置数据

 @param model 数据model
 */
-(void)configModel:(VipCardGoodsListModel *)model;

@end
