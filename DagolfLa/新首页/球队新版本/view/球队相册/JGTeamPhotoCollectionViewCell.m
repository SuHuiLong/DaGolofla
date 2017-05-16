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
    
    
    if (model.name==nil) {
        _manageBtn.hidden = YES;
        _timeLabel.text = @"";
        _numLabel.text = @"";
        _nameLabel.text = @"";
        _addLabel.text = @"点击『+』创建相册";
        _iconIngv.image = [UIImage imageNamed:@"teamPhotoGroupAdd"];
    }else{
        _addLabel.text = @"";
        [_iconIngv sd_setImageWithURL:[Helper setImageIconUrl:@"album/media" andTeamKey:[model.mediaKey integerValue]andIsSetWidth:NO andIsBackGround:NO] placeholderImage:[UIImage imageNamed:@"teamPhotoDefault"]];
        _iconIngv.layer.masksToBounds = YES;
        _iconIngv.contentMode = UIViewContentModeScaleAspectFill;
        
        _timeLabel.text = [Helper stringFromDateString:model.createTime withFormater:@"yyyy.MM.dd"];
        
        if (![Helper isBlankString:model.name]) {
            _nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
        }else{
            _nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
        }
        
        _numLabel.text = [NSString stringWithFormat:@"%@张",model.photoNums];
    }
    
        
}




@end
