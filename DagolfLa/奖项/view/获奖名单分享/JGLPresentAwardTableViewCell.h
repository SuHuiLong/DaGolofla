//
//  JGLPresentAwardTableViewCell.h
//  DagolfLa
//
//  Created by 黄达明 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGHAwardModel;


@interface JGLPresentAwardTableViewCell : UITableViewCell


@property (strong, nonatomic) UIImageView* iconImgv;

@property (strong, nonatomic) UILabel*     titleLabel;

@property (strong, nonatomic) UILabel*     awardLabel;

@property (strong, nonatomic) UIView*      viewLine;

@property (strong, nonatomic) UILabel*     nameLabel;

@property (strong, nonatomic) UIButton*    chooseBtn;


- (void)configJGHAwardModel:(JGHAwardModel *)model;


@end
