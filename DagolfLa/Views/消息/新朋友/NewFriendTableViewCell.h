//
//  NewFriendTableViewCell.h
//  DagolfLa
//
//  Created by bhxx on 16/3/15.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewFriendModel.h"
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface NewFriendTableViewCell : UITableViewCell


@property (strong, nonatomic) UIButton* btnIcon;
@property (strong, nonatomic) UILabel* nameLabel;
@property (strong, nonatomic) UIImageView* imgvSex;
@property (strong, nonatomic) UILabel* ageLabel;
@property (strong, nonatomic) UILabel* detailLabel;
@property (strong, nonatomic) UIButton* btnFocus;

-(void)showData:(NewFriendModel *)model;

@end
