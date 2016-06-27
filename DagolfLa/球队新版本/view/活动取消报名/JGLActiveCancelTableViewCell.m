//
//  JGLActiveCancelTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/6/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLActiveCancelTableViewCell.h"

@implementation JGLActiveCancelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
    
}


-(void)showData:(JGHPlayersModel *)model
{
    [_iconImg sd_setImageWithURL:[Helper setImageIconUrl:@"user" andTeamKey:model.userKey andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:TeamLogoImage]];
    
    _iconImg.layer.cornerRadius = 20;
    _iconImg.clipsToBounds = YES;
    
    if (![Helper isBlankString:model.name]) {
        _nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    }else
    {
        _nameLabel.text = [NSString stringWithFormat:@"未填写姓名"];
    }
    
    if (![Helper isBlankString:model.mobile]) {
        _phoneLabel.text = [NSString stringWithFormat:@"%@",model.mobile];
    }
    else
    {
        _phoneLabel.text = [NSString stringWithFormat:@"未填写手机号"];
    }
    
    if (model.payMoney != nil) {
        NSString* strMoney = [NSString stringWithFormat:@"已付费: %.2f",[model.payMoney floatValue]];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strMoney];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,4)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4,str.length - 4)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0*ScreenWidth/320] range:NSMakeRange(0, 4)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0*ScreenWidth/320] range:NSMakeRange(4,str.length - 4)];
        _moneyLabel.attributedText = str;
    }
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
