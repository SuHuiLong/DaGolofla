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
    self.backgroundColor = [UIColor whiteColor];
}

-(void)showData:(JGLPhotoAlbumModel *)model
{
    [_iconIngv sd_setImageWithURL:[Helper setImageIconUrl:@"album/media" andTeamKey:[model.mediaKey integerValue]andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:@"xcback"]];
    _iconIngv.layer.masksToBounds = YES;
    _iconIngv.contentMode = UIViewContentModeScaleAspectFill;
    
    _timeLabel.text = [Helper stringFromDateString:model.createTime withFormater:@"yyyy.MM.dd"];

//    NSArray* array1 = [model.createTime componentsSeparatedByString:@" "];
//    _timeLabel.text = [NSString stringWithFormat:@"%@",array1[0]];
    if (![Helper isBlankString:model.name]) {

        _nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    }
    else
    {
        _nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    }
    
    _numLabel.text = [NSString stringWithFormat:@"%@张",model.photoNums];

        
}


@end
