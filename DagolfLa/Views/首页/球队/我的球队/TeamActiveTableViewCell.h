//
//  TeamActiveTableViewCell.h
//  DagolfLa
//
//  Created by bhxx on 15/11/24.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

#import "TeamActiveModel.h"
@interface TeamActiveTableViewCell : UITableViewCell



@property (strong, nonatomic) UIImageView* iconImage;
@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) UILabel* nameLabel;
@property (strong, nonatomic) UILabel* timeLabel;
@property (strong, nonatomic) UILabel* areaLabel;

@property (strong, nonatomic) UILabel* createTime;
@property (strong, nonatomic) UILabel* stateLabel;
@property (strong, nonatomic) UIImageView* jtImage;


-(void)showData:(TeamActiveModel *)model;

@end
