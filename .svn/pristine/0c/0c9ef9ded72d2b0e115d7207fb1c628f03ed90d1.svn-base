//
//  YueMyBallTableViewCell.m
//  DaGolfla
//
//  Created by bhxx on 15/8/13.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "YueMyBallTableViewCell.h"

#import "UIImageView+WebCache.h"
#import "Helper.h"

@implementation YueMyBallTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)showData:(YueHallModel *)model
{
    [_iconImage sd_setImageWithURL:[Helper imageIconUrl:model.ballPic] placeholderImage:[UIImage imageNamed:@"zwt"]];
    if (![Helper isBlankString:model.ballName]) {
        _labelField.text = model.ballName;
    }else
    {
        _labelField.text = @"暂无球场";
    }
    
    if (![Helper isBlankString:model.address]) {
        _labelDaaress.text = [NSString stringWithFormat:@"地址:%@",model.address];
    }else
    {
        _labelDaaress.text = [NSString stringWithFormat:@"地址:暂无地址"];
    }
    
    if (![Helper isBlankString:model.playTimes]) {
        _labelTime.text = [NSString stringWithFormat:@"时间:%@",model.playTimes];
    }
    else
    {
        _labelTime.text = [NSString stringWithFormat:@"时间:暂无时间"];
    }
    
    if ([model.ballType integerValue] == 0) {
         _labelType.text = [NSString stringWithFormat:@"约球类型:公开约球"];
    }
    else
    {
         _labelType.text = [NSString stringWithFormat:@"约球类型:球友约球"];
    }
    
   
    
    if ([model.startState integerValue] == 1) {
        _labelState.backgroundColor = [UIColor colorWithRed:0.36f green:0.66f blue:0.31f alpha:1.00f];
        _labelState.text = @"正在进行";
    }
    else if ([model.startState integerValue] == 2)
    {
        _labelState.backgroundColor = [UIColor lightGrayColor];
        _labelState.text = @"已经结束";
    }
    else
    {
        _labelState.backgroundColor = [UIColor lightGrayColor];
        _labelState.text = @"已经取消";
    }
    
}

@end
