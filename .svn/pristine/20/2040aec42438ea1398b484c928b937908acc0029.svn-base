//
//  MineTeamManCell.m
//  DaGolfla
//
//  Created by bhxx on 15/9/6.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "MineTeamManCell.h"
#import "Helper.h"
#import "UIImageView+WebCache.h"
@implementation MineTeamManCell

- (void)awakeFromNib {
    // Initialization code
    _stateLabel.backgroundColor = [UIColor clearColor];
}
-(void)showData:(TeamModel *)model
{
    [_iconImage sd_setImageWithURL:[Helper imageIconUrl:model.tramPic] placeholderImage:[UIImage imageNamed:@"zwt"]];
    _titleLabel.text = [NSString stringWithFormat:@"%@(%@人)",model.teamName,model.joinCount];
//    _stateLabel.text =
    if ([model.forrelevant integerValue] == 1) {
        _stateLabel.text = @"我创建的";
        _stateLabel.textColor  = [UIColor redColor];
    }
    else
    {
        _stateLabel.textColor = [UIColor orangeColor];
        _stateLabel.text = @"我参与的";
    }
    _introLabel.text = model.teamSign;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
