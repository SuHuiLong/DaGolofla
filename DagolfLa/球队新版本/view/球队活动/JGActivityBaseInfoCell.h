//
//  JGActivityBaseInfoCell.h
//  DagolfLa
//
//  Created by 黄安 on 16/5/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGTeamAcitivtyModel;

@interface JGActivityBaseInfoCell : UITableViewCell

//活动名称
@property (weak, nonatomic) IBOutlet UILabel *name;

//活动地址
@property (weak, nonatomic) IBOutlet UILabel *address;

//活动日期
@property (weak, nonatomic) IBOutlet UILabel *time;

//活动费用
@property (weak, nonatomic) IBOutlet UILabel *member;

//嘉宾费用
@property (weak, nonatomic) IBOutlet UILabel *guest;

- (void)configJGTeamAcitivtyModel:(JGTeamAcitivtyModel *)model;

@end
