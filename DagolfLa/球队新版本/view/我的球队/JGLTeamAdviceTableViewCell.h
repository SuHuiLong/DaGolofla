//
//  JGLTeamAdviceTableViewCell.h
//  DagolfLa
//
//  Created by 黄达明 on 16/5/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGLTeamMemberModel.h"

@interface JGLTeamAdviceTableViewCell : UITableViewCell




@property (strong, nonatomic)  UIImageView *iconImage;
@property (strong, nonatomic)  UILabel     *nameLabel;
@property (strong, nonatomic)  UILabel     *ageLabel;
@property (strong, nonatomic)  UIImageView *sexImage;

@property (strong, nonatomic)  UILabel     *chadianLabel;
@property (strong, nonatomic)  UILabel     *mobileLabel;
@property (strong, nonatomic)  UIButton    *agreeBtn;
@property (strong, nonatomic)  UIButton    *disMissBtn;

@property (strong, nonatomic)  UILabel     *stateLabel;
@property (strong, nonatomic)  UILabel     *timeLabel;

-(void)showData:(JGLTeamMemberModel *)model;


@end
