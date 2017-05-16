//
//  VipCardCollectionViewCell.h
//  DagolfLa
//
//  Created by SHL on 2017/3/6.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VipCardModel.h"
@interface VipCardCollectionViewCell : UICollectionViewCell
//卡片图片
@property(nonatomic,copy)UIImageView *imageView;
//不可用图片蒙版
@property(nonatomic,copy) UIImageView *maskingView;
//不可用的提示
@property(nonatomic,copy) UILabel *alertLabel;
/**
 卡片编号
 */
@property(nonatomic,copy) UILabel *cardNumberLabel;

-(void)configModel:(VipCardModel *)model;
@end
