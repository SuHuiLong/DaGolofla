//
//  JGTeamChannelTableViewCell.h
//  DagolfLa
//
//  Created by 東 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGTeamDetail.h"

#import "JGLMyTeamModel.h"
@interface JGTeamChannelTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *iconImageV;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *adressLabel;
@property (nonatomic, strong)UILabel *describLabel;
@property (nonatomic, strong)JGTeamDetail *teamModel;

-(void)showData:(JGLMyTeamModel *)model;

@end
