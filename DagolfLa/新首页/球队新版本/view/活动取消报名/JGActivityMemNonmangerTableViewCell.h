//
//  JGActivityMemNonmangerTableViewCell.h
//  DagolfLa
//
//  Created by 東 on 16/6/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGActivityMemNonmangerTableViewCell : UITableViewCell
//头像
@property (nonatomic, strong) UIImageView *headIconV;
//昵称
@property (nonatomic, strong) UILabel *nameLB;
//性别
@property (nonatomic, strong) UIImageView *sexIconV;
//差点
@property (nonatomic, strong) UILabel *almostLabel;
//手机号
@property (nonatomic, strong) UILabel *phoneLB;
//球员类型
@property (nonatomic, strong) UILabel *typeLB;


@property (nonatomic, strong) UILabel *signLB; // 意向成员标识

@end
