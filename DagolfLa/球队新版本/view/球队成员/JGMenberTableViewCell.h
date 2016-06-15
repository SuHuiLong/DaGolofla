//
//  JGMenberTableViewCell.h
//  DagolfLa
//
//  Created by 黄达明 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGLTeamMemberModel.h"
#import "JGHPlayersModel.h"

@protocol JGMenberPhoneCellDelegate <NSObject>

- (void)makePhoneClick:(NSString *)phone;

@end

@interface JGMenberTableViewCell : UITableViewCell


@property (strong, nonatomic) UIImageView* iconImgv;

@property (strong, nonatomic) UILabel* nameLabel;

@property (strong, nonatomic) UIImageView* sexImgv;

@property (strong, nonatomic) UILabel* almostLabel;

@property (strong, nonatomic) UILabel* poleLabel;

@property (strong, nonatomic) UILabel *moneyLabel;


//-(void) showData:(JGLTeamMemberModel *)model;

- (void)showData:(JGLTeamMemberModel *)model andPower:(NSString *)power;

- (void)configJGHPlayersModel:(JGHPlayersModel *)model;

@property (weak, nonatomic)id <JGMenberPhoneCellDelegate> delegate;

@end
