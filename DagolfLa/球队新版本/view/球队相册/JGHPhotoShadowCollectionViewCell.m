//
//  JGHPhotoShadowCollectionViewCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/3/9.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHPhotoShadowCollectionViewCell.h"
#import "JGLPhotoAlbumModel.h"

@implementation JGHPhotoShadowCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        _shadowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth/2 -9*ProportionAdapter, kHvertical(108))];
        _shadowImageView.image = [UIImage imageNamed:@"xcback"];
        _shadowImageView.contentMode = UIViewContentModeScaleAspectFill;
        _shadowImageView.clipsToBounds = YES;
        _shadowImageView.image = [UIImage imageNamed:@"xcback"];
        [self addSubview:_shadowImageView];
        
        _title = [[UILabel alloc]initWithFrame:CGRectMake(_shadowImageView.bounds.origin.x, _shadowImageView.bounds.size.height +kWvertical(5), _shadowImageView.bounds.size.width, kHvertical(20))];
        _title.font = [UIFont systemFontOfSize:kHorizontal(15)];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.text = @"减肥的咖啡店";
        [self addSubview:_title];
    }
    return self;
}

-(void)configData:(JGLPhotoAlbumModel *)model{
    [_shadowImageView sd_setImageWithURL:[Helper setImageIconUrl:@"album/media" andTeamKey:[model.mediaKey integerValue]andIsSetWidth:YES andIsBackGround:NO] placeholderImage:[UIImage imageNamed:@"xcback"]];
    
    if (![Helper isBlankString:model.name]) {
        
        _title.text = [NSString stringWithFormat:@"%@",model.name];
    }
    else
    {
        _title.text = [NSString stringWithFormat:@"%@",model.name];
    }
}

@end
