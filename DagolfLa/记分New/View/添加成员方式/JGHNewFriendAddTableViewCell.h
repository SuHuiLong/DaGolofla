//
//  JGHNewFriendAddTableViewCell.h
//  DagolfLa
//
//  Created by 黄安 on 17/2/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyattenModel.h"

@interface JGHNewFriendAddTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView* imgvIcon;

@property (strong, nonatomic) UILabel*     labelTitle;

@property (strong, nonatomic) UIImageView* imgvSex;

@property (strong, nonatomic)MyattenModel *myModel;

@property (strong, nonatomic) UIImageView* selectImgv;

@end
