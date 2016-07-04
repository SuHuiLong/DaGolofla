//
//  TeamPhotoAlbumViewCell.m
//  DagolfLa
//
//  Created by bhxx on 15/11/26.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "TeamPhotoAlbumViewCell.h"

#import "UIImageView+WebCache.h"
#import "Helper.h"
@implementation TeamPhotoAlbumViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(8*ScreenWidth/375, 5*ScreenWidth/375, 70*ScreenWidth/375, 70*ScreenWidth/375)];
        _iconImage.image = [UIImage imageNamed:@"moren.jpg"];
        [self.contentView addSubview:_iconImage];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(86*ScreenWidth/375, 8*ScreenWidth/375, 262*ScreenWidth/375, 21*ScreenWidth/375)];
        _titleLabel.text = @"阳光下的球场";
        _titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        [self.contentView addSubview:_titleLabel];
        
        _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(86*ScreenWidth/375, 50*ScreenWidth/375, 147*ScreenWidth/375, 21*ScreenWidth/375)];
        _numLabel.text = @"共7张";
        _numLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        [self.contentView addSubview:_numLabel];
        
        _jtImage = [[UIImageView alloc]initWithFrame:CGRectMake(355*ScreenWidth/375, 32*ScreenWidth/375, 12*ScreenWidth/375, 16*ScreenWidth/375)];
        _jtImage.image = [UIImage imageNamed:@"left_jt"];
        [self.contentView addSubview:_jtImage];
        
    }
    return self;
}


-(void)showData:(TeamPhotoModel *)model
{
    [_iconImage sd_setImageWithURL:[Helper imageIconUrl:model.photoGroupsHomePic] placeholderImage:[UIImage imageNamed:@"zwt"]];
    _titleLabel.text = model.photoGroupsName;
    _numLabel.text = [NSString stringWithFormat:@"共%d张",[model.photoNums intValue]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
