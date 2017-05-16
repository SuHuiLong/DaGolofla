//
//  ActivityMyApplyTableViewCell.h
//  DagolfLa
//
//  Created by SHL on 2017/5/16.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityMyApplyViewModel.h"
@interface ActivityMyApplyTableViewCell : UITableViewCell
//图片
@property (nonatomic, strong) UIImageView *headerImageView;
//状态
@property (nonatomic, strong) UIButton *statuView;
//活动名
@property (nonatomic, strong) UILabel *nameLabel;
//时间
@property (nonatomic, strong) UILabel *timeLabel;
//球场
@property (nonatomic, strong) UILabel *parkLabel;
//已报名人数
@property (nonatomic, strong) UILabel *applyLabel;

//配置数据
-(void)configModel:(ActivityMyApplyViewModel *)model;
@end
