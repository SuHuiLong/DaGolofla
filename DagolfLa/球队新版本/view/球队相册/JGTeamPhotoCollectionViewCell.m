//
//  JGTeamPhotoCollectionViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/12.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamPhotoCollectionViewCell.h"

@implementation JGTeamPhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)showData:(JGLPhotoAlbumModel *)model
{
    [_iconIngv sd_setImageWithURL:[Helper setImageIconUrl:@"album/media" andTeamKey:[model.mediaKey integerValue]andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:@"xcback"]];
    _iconIngv.layer.masksToBounds = YES;
    _iconIngv.contentMode = UIViewContentModeScaleAspectFill;
    _timeLabel.text = [NSString stringWithFormat:@"%@",model.createTime];
    if (![Helper isBlankString:model.name]) {
        _nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    }
    else
    {
        _nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    }
    
        
}


@end
