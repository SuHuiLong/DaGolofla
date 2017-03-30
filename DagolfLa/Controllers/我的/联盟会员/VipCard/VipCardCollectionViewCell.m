//
//  VipCardCollectionViewCell.m
//  DagolfLa
//
//  Created by SHL on 2017/3/6.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "VipCardCollectionViewCell.h"

@implementation VipCardCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        572 388  532 346  40 42 20 21
        //卡片
        _imageView  = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth-kWvertical(267))/2, 20,kWvertical(267), self.height-kHvertical(40))];
        
        //背景照片
        UIImageView *backImageView = [Factory createImageViewWithFrame:CGRectMake(_imageView.x-kWvertical(10), _imageView.y-kHvertical(10.5), _imageView.width+kWvertical(20), _imageView.height+kWvertical(21)) Image:[UIImage imageNamed:@"icn_allianceBackView"]];
        [self.contentView addSubview:backImageView];
        
        [self.contentView addSubview:_imageView];
        //蒙版
        _maskingView = [Factory createImageViewWithFrame:CGRectMake(_imageView.x-kWvertical(11), _imageView.y - kHvertical(12), _imageView.width+kWvertical(24), _imageView.height+kHvertical(24)) Image:[UIImage imageNamed:@"icn_allianceUnuse"]];
        _maskingView.hidden = YES;
        [self.contentView addSubview:_maskingView];
        //提示文字
        _alertLabel = [Factory createLabelWithFrame:_maskingView.frame textColor:RGBA(0, 0, 0, 0.6) fontSize:kHorizontal(18) Title:nil];
        _alertLabel.hidden = YES;
        [self.contentView addSubview:_alertLabel];
        
    }
    
    return self;
}

-(void)configModel:(VipCardModel *)model{
    _maskingView.hidden = YES;
    _alertLabel.hidden = YES;
    NSString *picUrl = model.imagePicUrl;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"moren"]];
    NSInteger cardState = model.cardState;
    NSString *cardStr = model.cardStr;
    if (!cardStr) {
        cardStr = @"未知状态";
    }
    if (cardState==0) {
        NSString *stateStr = cardStr;
        _maskingView.hidden = NO;
        _alertLabel.hidden = NO;
        _alertLabel.text = stateStr;
        [_alertLabel setTextAlignment:NSTextAlignmentCenter];
    }
}
@end
