//
//  DiscoveryActivitiesCollectionViewCell.h
//  DagolfLa
//
//  Created by SHL on 2017/5/15.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisCoveryActivityModel.h"
@interface DiscoveryActivitiesCollectionViewCell : UICollectionViewCell

/**
 已报名人数
 */
@property(nonatomic, strong)UILabel *applyLabel;
/**
 背景图片
 */
@property(nonatomic, strong)UIImageView *headerImageView;
/**
 球场名&距离
 */
@property(nonatomic, strong)UILabel *parkLabel;
/**
 球队名
 */
@property(nonatomic, strong)UILabel *teamnameLabel;
/**
 活动名
 */
@property(nonatomic, strong)UILabel *activityNameLabel;
/**
 状态&时间
 */
@property(nonatomic, strong)UILabel *statuLabel;
/**
 价格
 */
@property(nonatomic, strong)UILabel *priceLabel;

//配置数据
-(void)configModel:(DisCoveryActivityModel *)model;
@end
