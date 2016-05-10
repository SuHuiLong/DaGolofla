//
//  MeTableViewCell.m
//  DaGolfla
//
//  Created by bhxx on 15/9/28.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "MeTableViewCell.h"
#import "AppDelegate.h"
@implementation MeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
