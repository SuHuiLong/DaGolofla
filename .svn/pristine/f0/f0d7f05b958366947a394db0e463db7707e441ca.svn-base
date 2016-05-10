//
//  ManageSelfDetTableViewCell.h
//  DagolfLa
//
//  Created by bhxx on 16/1/20.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManageApplyModel.h"
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface ManageSelfDetTableViewCell : UITableViewCell

@property (strong, nonatomic)  UIImageView *iconImage;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UIImageView *sexImage;
@property (strong, nonatomic)  UILabel *ageLabel;
@property (strong, nonatomic)  UILabel *chadianLabel;
@property (strong, nonatomic)  UIButton *agreeBtn;
@property (strong, nonatomic)  UIButton *disMissBtn;

-(void)showManDetail:(ManageApplyModel *)model;

@property (strong, nonatomic) NSNumber* userId;
@property (strong, nonatomic) NSNumber* ballId;

@property (copy, nonatomic) void(^callBackData)();

@end
