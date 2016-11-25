//
//  JGSearchNewFriendTableViewCell.h
//  DagolfLa
//
//  Created by 東 on 16/11/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NewFriendModel.h"

@interface JGSearchNewFriendTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, strong) UILabel *nameLB;

@property (nonatomic, strong) UILabel *signLB;

@property (nonatomic, strong) UIImageView *sexImage;

@property (nonatomic, strong) UIButton *addBtn;


- (void)showData:(NewFriendModel *)model;

@end
