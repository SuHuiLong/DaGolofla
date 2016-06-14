//
//  JGLMyTeamTableViewCell.h
//  DagolfLa
//
//  Created by 黄达明 on 16/6/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGLMyTeamModel.h"
@interface JGLMyTeamTableViewCell : UITableViewCell


@property (nonatomic, strong)UIImageView *iconImageV;

@property (nonatomic, strong)UIImageView *iconState;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *adressLabel;
@property (nonatomic, strong)UILabel *describLabel;



-(void)showData:(JGLMyTeamModel *)model;


@end
