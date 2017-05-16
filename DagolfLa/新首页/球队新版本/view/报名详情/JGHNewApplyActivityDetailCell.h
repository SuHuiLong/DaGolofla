//
//  JGHNewApplyActivityDetailCell.h
//  DagolfLa
//
//  Created by 黄安 on 17/1/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGTeamAcitivtyModel;

@interface JGHNewApplyActivityDetailCell : UITableViewCell

@property (nonatomic, retain)UIImageView *oneImageView;

@property (nonatomic, retain)UILabel *teeTime;

@property (nonatomic, retain)UILabel *oneline;


@property (nonatomic, retain)UIImageView *twoImageView;

@property (nonatomic, retain)UILabel *registration;

@property (nonatomic, retain)UILabel *twoline;


@property (nonatomic, retain)UIImageView *threeImageView;

@property (nonatomic, retain)UILabel *address;


- (void)configJGTeamAcitivtyModel:(JGTeamAcitivtyModel *)model;

@end
