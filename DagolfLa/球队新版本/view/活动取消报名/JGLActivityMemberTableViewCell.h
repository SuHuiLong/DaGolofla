//
//  JGLActivityMemberTableViewCell.h
//  DagolfLa
//
//  Created by 黄达明 on 16/6/27.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGHPlayersModel.h"
@interface JGLActivityMemberTableViewCell : UITableViewCell


@property (strong, nonatomic)  UIImageView *iconImg;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UILabel *phoneLabel;
@property (strong, nonatomic)  UILabel *moneyLabel;

-(void)showData:(JGHPlayersModel *)model;

@end
