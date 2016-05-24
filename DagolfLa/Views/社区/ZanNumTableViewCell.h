//
//  ZanNumTableViewCell.h
//  DaGolfla
//
//  Created by bhxx on 15/8/5.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TeamPeopleModel.h"

#import "CommunityModel.h"

#import "UserAssistModel.h"

@interface ZanNumTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *chadianLabel;

@property (nonatomic,strong) UserAssistModel * userAssisModel;

-(void)showTeamPeopleData:(TeamPeopleModel *)model;


@end
