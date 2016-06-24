//
//  JGLSignPeoTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/6/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLSignPeoTableViewCell.h"

@implementation JGLSignPeoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)showData:(JGTeamAcitivtyModel *)model
{
    [_iconImg sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:model.userKey andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:TeamLogoImage]];
    if (![Helper isBlankString:model.userName]) {
        _nameLabel.text = [NSString stringWithFormat:@"%@",model.userName];
    }else{
        _nameLabel.text = [NSString stringWithFormat:@"暂无姓名"];
    }
    
    if (![Helper isBlankString:model.mobile]) {
        _mobileLabel.text = [NSString stringWithFormat:@"%@",model.mobile];
    }else{
        _mobileLabel.text = [NSString stringWithFormat:@"暂无手机号"];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
