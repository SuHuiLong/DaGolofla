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
    
    _iconImg.layer.masksToBounds = YES;
    _iconImg.layer.cornerRadius = _iconImg.frame.size.height/2;

    _titleLabel.font  = [UIFont systemFontOfSize:14*ScreenWidth/320];
    _nameLabel.font   = [UIFont systemFontOfSize:13*ScreenWidth/320];
    _mobileLabel.font = [UIFont systemFontOfSize:13*ScreenWidth/320];
}

-(void)showData:(NSDictionary *)dict showModel:(JGTeamAcitivtyModel *)model
{
    [_iconImg sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:[[dict objectForKey:@"userKey"] integerValue] andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:TeamLogoImage]];
    if (![Helper isBlankString:[dict objectForKey:@"userName"]]) {
        _nameLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"userName"]];
    }else{
        _nameLabel.text = [NSString stringWithFormat:@"暂无姓名"];
    }
    
    if (![Helper isBlankString:[dict objectForKey:@"mobile"]]) {
        _mobileLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"mobile"]];
    }else{
        _mobileLabel.text = [NSString stringWithFormat:@"暂无手机号"];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
