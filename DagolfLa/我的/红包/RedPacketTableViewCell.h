//
//  RedPacketTableViewCell.h
//  DagolfLa
//
//  Created by SHL on 2017/6/6.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedPacketModel.h"
@interface RedPacketTableViewCell : UITableViewCell

//左图片背景
@property(nonatomic, strong)UIImageView *leftImageView;
//右图片背景
@property(nonatomic, strong)UIImageView *rightImageView;
//圆形背景
@property (nonatomic,strong) UIView *circleView;
//选中按钮
@property(nonatomic, strong)UIImageView *selectImageView;
//红包金额
@property(nonatomic, strong)UILabel *moneyLabel;
//满减条件
@property(nonatomic, strong)UILabel *conditionLabel;
//剩余可用天数（三天之内显示）
@property(nonatomic, strong)UILabel *residueLabel;
//使用条件
@property(nonatomic, strong)UILabel *serviceLabel;
//有效期
@property(nonatomic, strong)UILabel *endTimeLabel;

//配置数据
-(void)configModel:(RedPacketModel *)model;
//查看历史红包
-(void)configHistoryModel:(RedPacketModel *)model;
//选择红包
-(void)configSelectModel:(RedPacketModel *)model selectModel:(RedPacketModel *)selectModel;
@end
