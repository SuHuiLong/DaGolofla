//
//  SelectRedPacketTableViewCell.h
//  DagolfLa
//
//  Created by SHL on 2017/6/8.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedPacketModel.h"
@interface SelectRedPacketTableViewCell : UITableViewCell
//浅色头部view
@property (nonatomic,strong) UIView *grayView;
//title
@property (nonatomic, strong) UILabel *titleLabel;
//描述
@property (nonatomic, strong) UILabel *descLabel;
//箭头符号
@property (nonatomic,strong) UIImageView *arrowImageView;
//浅色顶部view
@property (nonatomic,assign) BOOL hidenGrayTitle;
//配置未选择数据
-(void)configData:(NSInteger)canUseNum;
//配置已选择数据
-(void)configSelectData:(RedPacketModel *)model;
//隐藏浅色头部
-(void)hidenGrayView;
@end
