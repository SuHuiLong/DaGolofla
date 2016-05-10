//
//  MyTeamsTableViewCell.m
//  DaGolfla
//
//  Created by bhxx on 15/9/2.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "MyTeamsTableViewCell.h"
#import "Helper.h"
#import "UIImageView+WebCache.h"
@implementation MyTeamsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showData:(TeamModel *)model
{
//    iconImage;
//    titleLabel;
//    areaLabel;
//    *detailLabel;
    _iconImage.layer.masksToBounds = YES;
    _iconImage.layer.cornerRadius = 8*ScreenWidth/375;
    [_iconImage sd_setImageWithURL:[Helper imageIconUrl:model.tramPic] placeholderImage:[UIImage imageNamed:@"zwt"]];
    if (![Helper isBlankString:model.teamName]) {
        _titleLabel.text = [NSString stringWithFormat:@"%@(%@人)", model.teamName,model.joinCount];
    }
    
    if (![Helper isBlankString:model.teamCrtyName]) {
        _areaLabel.text = [NSString stringWithFormat:@"地区:%@",model.teamCrtyName];
    }
   
    if (![Helper isBlankString:model.teamSign]) {
        _detailLabel.text = model.teamSign;
    }
//
    
}

@end
