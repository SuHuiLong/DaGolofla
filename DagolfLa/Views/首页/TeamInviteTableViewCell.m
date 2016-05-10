//
//  TeamInviteTableViewCell.m
//  DaGolfla
//
//  Created by bhxx on 15/9/8.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "TeamInviteTableViewCell.h"
#import "Helper.h"
#import "UIImageView+WebCache.h"
@implementation TeamInviteTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)showFriendData:(FriendModel *)model
{
    _nameLabel.text = model.userName;
    _detailLabel.text = model.userSign;
    [_iconImage sd_setImageWithURL:[Helper imageUrl:model.pic] placeholderImage:[UIImage imageNamed:@"tx4"]];
}


@end
