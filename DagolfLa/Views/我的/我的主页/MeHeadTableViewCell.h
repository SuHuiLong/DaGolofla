//
//  MeHeadTableViewCell.h
//  DagolfLa
//
//  Created by bhxx on 16/4/7.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface MeHeadTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView* iconImgv;

@property (strong, nonatomic) UIImageView* imgvSex;

@property (strong, nonatomic) UILabel* nameLabel;

@property (strong, nonatomic) UILabel* detailLabel;

@property (strong, nonatomic) UIImageView* imgvJt;


@end
