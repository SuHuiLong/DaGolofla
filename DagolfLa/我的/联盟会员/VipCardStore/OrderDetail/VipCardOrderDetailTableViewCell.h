//
//  VipCardOrderDetailTableViewCell.h
//  DagolfLa
//
//  Created by SHL on 2017/4/12.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VipCardOrderDetailModel.h"
@interface VipCardOrderDetailTableViewCell : UITableViewCell

/**
 标题
 */
@property(nonatomic, strong)UILabel *titleLabel;
/**
 描述
 */
@property(nonatomic, strong)UILabel *descLabel;

/**
 配置数据

 @param model 数据源
 */
-(void)configModel:(VipCardOrderDetailModel *)model;
@end
