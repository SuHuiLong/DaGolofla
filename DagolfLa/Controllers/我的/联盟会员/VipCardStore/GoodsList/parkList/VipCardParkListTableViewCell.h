//
//  VipCardParkListTableViewCell.h
//  DagolfLa
//
//  Created by SHL on 2017/4/7.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VipCardParkListTableViewCell : UITableViewCell
/**
 球场图片
 */
@property(nonatomic, strong) UIImageView *iconImageView;
/**
 球场名
 */
@property(nonatomic, strong) UILabel *courtBallname;
/**
 位置
 */
@property(nonatomic, strong)UILabel *addressLabel;
/**
 距离
 */
@property(nonatomic, strong)UILabel *distanceLabel;

//-(void)configModel:(NSObject *)model;
@end
