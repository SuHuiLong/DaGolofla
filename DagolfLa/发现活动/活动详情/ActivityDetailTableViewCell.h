//
//  ActivityDetailTableViewCell.h
//  DagolfLa
//
//  Created by SHL on 2017/5/17.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityDetailModel.h"

@interface ActivityDetailTableViewCell : UITableViewCell
//图标
@property (nonatomic, strong) UIImageView *iconImageView;
//描述
@property (nonatomic, strong) UILabel *descLabel;
//查看分组按钮
@property (nonatomic, strong) UIButton *viewGroup;
//活动说明右箭头
@property (nonatomic, strong) UIImageView *arrowImageView;
//分割线
@property (nonatomic, strong) UIView *line;
//配置数据
-(void)configModel:(ActivityDetailModel *)model;
@end
