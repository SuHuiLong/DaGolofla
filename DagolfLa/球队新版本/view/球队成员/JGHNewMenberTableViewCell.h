//
//  JGHNewMenberTableViewCell.h
//  DagolfLa
//
//  Created by 黄安 on 17/2/13.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGLTeamMemberModel;

@interface JGHNewMenberTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView* iconImgv;

@property (strong, nonatomic) UILabel* nameLabel;

@property (strong, nonatomic) UIImageView* sexImgv;

@property (strong, nonatomic) UILabel* almostLabel;

@property (strong, nonatomic) UILabel* poleLabel;

@property (strong, nonatomic) UIImageView* selectImgv;



- (void)showIntentionData:(JGLTeamMemberModel *)model;

@end
