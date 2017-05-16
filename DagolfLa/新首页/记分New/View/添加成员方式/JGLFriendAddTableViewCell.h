//
//  JGLFriendAddTableViewCell.h
//  DagolfLa
//
//  Created by 黄达明 on 16/7/18.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyattenModel.h"
@interface JGLFriendAddTableViewCell : UITableViewCell



@property (strong, nonatomic) UIImageView* imgvState;

@property (strong, nonatomic) UIImageView* imgvIcon;

@property (strong, nonatomic) UILabel*     labelTitle;

@property (strong, nonatomic) UIImageView* imgvSex;

@property (strong, nonatomic)MyattenModel *myModel;

@property (strong, nonatomic) UIImageView* selectImgv;

- (void)configJGLFriendAddTableViewCell:(MyattenModel *)model;

@end
