//
//  GuestRegistrationAuditTableViewCell.h
//  DagolfLa
//
//  Created by SHL on 2017/5/24.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuestRegistrationAuditModel.h"
@interface GuestRegistrationAuditTableViewCell : UITableViewCell
//用户头像
@property (nonatomic , strong)UIImageView *headImageView;
//用户名
@property (nonatomic , strong)UILabel *nameLabel;
//性别
@property (nonatomic , strong)UIImageView *sexImageView;
//差点
@property (nonatomic , strong)UILabel *almostLabel;
//手机号
@property (nonatomic , strong)UILabel *phoneLabel;

//时间
@property (nonatomic,strong) UILabel *timeLabel;
//状态
@property (nonatomic,strong) UILabel *styleLabel;

//同意按钮
@property (nonatomic,strong) UIButton *sureBtn;
//拒绝按钮
@property (nonatomic,strong) UIButton *reguestBtn;


-(void)configModel:(GuestRegistrationAuditModel *)model;



@end
