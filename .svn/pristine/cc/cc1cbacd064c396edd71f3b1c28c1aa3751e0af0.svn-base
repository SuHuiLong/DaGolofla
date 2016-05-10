//
//  RewardArravelTableViewCell.h
//  DagolfLa
//
//  Created by bhxx on 15/12/14.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RewordCheckModel.h"
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface RewardArravelTableViewCell : UITableViewCell

@property (strong, nonatomic)  UIImageView *iconImage;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UIImageView *sexImage;
@property (strong, nonatomic)  UILabel *ageLabel;
@property (strong, nonatomic)  UILabel *chadianLabel;
@property (strong, nonatomic)  UIButton *agreeBtn;
@property (strong, nonatomic)  UIButton *disMissBtn;

-(void)showRewardDetail:(RewordCheckModel *)model;

@property (strong, nonatomic) NSNumber* userId;
@property (strong, nonatomic) NSNumber* ballId;

@property (copy, nonatomic) void(^callBackData)();

@end
