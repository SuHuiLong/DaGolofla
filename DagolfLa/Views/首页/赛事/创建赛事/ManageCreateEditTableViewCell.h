//
//  ManageCreateEditTableViewCell.h
//  DagolfLa
//
//  Created by bhxx on 15/11/30.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface ManageCreateEditTableViewCell : UITableViewCell


@property (strong, nonatomic) UILabel* titleLabel;

@property (strong, nonatomic) UITextField* textField;

@property (strong, nonatomic) UILabel* detailLabel;

@property (strong, nonatomic) UIImageView* jtImage;

@property (strong, nonatomic) UIView* view;

@end
