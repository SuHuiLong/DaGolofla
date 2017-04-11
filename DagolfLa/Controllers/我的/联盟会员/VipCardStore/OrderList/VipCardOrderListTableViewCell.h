//
//  VipCardOrderListTableViewCell.h
//  DagolfLa
//
//  Created by SHL on 2017/4/10.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VipCardOrderListModel.h"
@interface VipCardOrderListTableViewCell : UITableViewCell
/**
 下单时间
 */
@property(nonatomic, strong)UILabel *timeLabel;
/**
 订单状态
 */
@property(nonatomic, strong)UILabel *statusLabel;
/**
 卡片图片
 */
@property(nonatomic, strong)UIImageView *cardImageView;
/**
 卡片名
 */
@property(nonatomic, strong)UILabel *cardNameLabel;
/**
 价格
 */
@property(nonatomic, strong)UILabel *singlePriceLabel;
/**
 商品数量
 */
@property(nonatomic, strong)UILabel *cardNumLabel;
/**
 总计价格
 */
@property(nonatomic, strong)UILabel *totalPriceLabel;

/**
 配置数据

 @param model 当前cell的数据
 */
-(void)configModel:(VipCardOrderListModel *)model;
@end
