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
        //卡片
        _imageView  = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth-kWvertical(267))/2, 20,kWvertical(267), self.height-kHvertical(40))];
        
        //背景照片
        UIImageView *backImageView = [Factory createImageViewWithFrame:CGRectMake(_imageView.x-kWvertical(10), _imageView.y-kHvertical(10.5), _imageView.width+kWvertical(20), _imageView.height+kWvertical(21)) Image:[UIImage imageNamed:@"icn_allianceBackView"]];
        [self.contentView addSubview:backImageView];
        [self.contentView addSubview:_imageView];
        //卡编号
        _cardNumberLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(18), _imageView.height-kHvertical(28), _imageView.width-kWvertical(40), kHvertical(12)) textColor:RGB(255,255,255) fontSize:kHorizontal(15) Title:nil];
        _cardNumberLabel.font = [UIFont boldSystemFontOfSize:kHorizontal(15)];
        [_imageView addSubview:_cardNumberLabel];
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
    if (model.cardNumber) {
        NSString *cardNumber = [NSString stringWithFormat:@"ID.%@",model.cardNumber];
        NSString *newNumber = [NSString string];
        NSInteger num = cardNumber.length/4;
        for (NSInteger i = 0; i<num; i++) {
            NSString *rangStr = [cardNumber substringWithRange:NSMakeRange(i*4, 4)];
            newNumber = [NSString stringWithFormat:@"%@%@ ",newNumber,rangStr];
        }
        _cardNumberLabel.text = newNumber;
    }
}
@end
