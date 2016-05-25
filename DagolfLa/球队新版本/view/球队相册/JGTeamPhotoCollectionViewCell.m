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
    //图片规则未定
    _timeLabel.text = [NSString stringWithFormat:@"%@",model.createTime];
    
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
}


@end
