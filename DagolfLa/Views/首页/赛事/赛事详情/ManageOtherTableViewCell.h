//
//  ManageOtherTableViewCell.h
//  DagolfLa
//
//  Created by bhxx on 16/1/20.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManageApplyModel.h"
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width


@interface ManageOtherTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *iconImage;
@property (strong, nonatomic) UILabel *nameLabel;


-(void)showData:(ManageApplyModel *)model;



@end
