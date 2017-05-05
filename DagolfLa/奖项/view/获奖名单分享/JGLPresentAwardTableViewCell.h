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

@property (strong, nonatomic) UILabel *nameTitleLB;


@property (strong, nonatomic) UIImageView* iconImgv;

@property (strong, nonatomic) UILabel*     titleLabel;

@property (strong, nonatomic) UILabel*     awardLabel;

@property (strong, nonatomic) UILabel*     countLabel;

@property (strong, nonatomic) UIView*      viewLine;

@property (strong, nonatomic) UILabel*     nameLabel;

@property (strong, nonatomic) UIButton*    chooseBtn;

@property (strong, nonatomic) UIImageView *chooseImageV;

@property (nonatomic, assign) NSInteger isManager;

- (void)configJGHAwardModel:(JGHAwardModel *)model;


@end
