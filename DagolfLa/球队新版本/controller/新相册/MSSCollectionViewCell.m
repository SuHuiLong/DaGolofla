//
//  MSSCollectionViewCell.m
//  MSSBrowse
//
//  Created by 于威 on 15/12/6.
//  Copyright © 2015年 于威. All rights reserved.
//

#import "MSSCollectionViewCell.h"

@implementation MSSCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createCell];
    }
    return self;
}

- (void)createCell
{
    _imageView = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:_imageView];
    //蒙板
    _coverView = [Factory createViewWithBackgroundColor:RGBA(227,227,227, 0.3) frame:self.contentView.bounds];
    UIImageView *iconView = [Factory createImageViewWithFrame:CGRectMake(_coverView.width - kWvertical(28), _coverView.height - kWvertical(23) - kHvertical(5), kWvertical(23), kWvertical(23)) Image:[UIImage imageNamed:@"teamPhotoChoice"]];
    _coverView.hidden = YES;
    [_coverView addSubview:iconView];
    [self.contentView addSubview:_coverView];
}

-(void)configModel:(JGPhotoListModel *)model{

    NSInteger timeKey = [model.timeKey integerValue];
    if (model.timeKey!=nil) {
        [self.imageView sd_setImageWithURL:[Helper setImageIconUrl:@"album/media" andTeamKey:timeKey andIsSetWidth:NO andIsBackGround:NO] placeholderImage:[UIImage imageNamed:@"teamPhotoGroupDefault"]];
    }else{
        [self.imageView setImage:[UIImage imageNamed:@"teamPhotoAdd"]];
    }
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;

    _coverView.hidden = YES;
    if (model.isSelect) {
        _coverView.hidden = false;
    }
    
}

-(void)configSelectModel:(JGPhotoListModel *)model{

}



@end
