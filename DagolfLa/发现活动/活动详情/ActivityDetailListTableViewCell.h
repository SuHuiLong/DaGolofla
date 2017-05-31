//
//  ActivityDetailListTableViewCell.h
//  DagolfLa
//
//  Created by SHL on 2017/5/18.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityDetailModel.h"
@interface ActivityDetailListTableViewCell : UITableViewCell
//用户头像
@property (nonatomic , strong)UIImageView *headImageView;
//用户名
@property (nonatomic , strong)UILabel *nameLabel;
//性别
@property (nonatomic , strong)UIImageView *sexImageView;
//差点
@property (nonatomic , strong)UILabel *almostLabel;
//嘉宾&队员
@property (nonatomic , strong)UILabel *playerType;
//手机号
@property (nonatomic , strong)UILabel *phoneLabel;



//发现活动&&非管理员配置数据
-(void)configModel:(ActivityDetailModel *)model;
//活动成员管理员
-(void)playerManagerConfigModel:(ActivityDetailModel *)model;



@end
