//
//  CommunMessageViewCell.m
//  DagolfLa
//
//  Created by bhxx on 15/10/23.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "CommunMessageViewCell.h"
#import "Helper.h"
#import "UIImageView+WebCache.h"
@implementation CommunMessageViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
    ////NSLog(@"%f", self.frame.size.height);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    ////NSLog(@"%f", _iconImage.frame.size.height);
    //
    //    [self.headImage changeHeight:100];
    _iconImage.backgroundColor = [UIColor blackColor];
    //    self.he.constant *= ScreenWidth/375;
    
    //    self.headImageHeight.constant = self.headImageHeight.constant + 100;
    
}
-(void)showData:(NewsDetailModel *)model{
    [_iconImage sd_setImageWithURL:[Helper imageIconUrl:model.pic] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    
    _nameLabel.text = [NSString stringWithFormat:@"%@", model.sender];
    _timeLabel.text = model.createTime;
    _detailLabel.text = model.content;
}

@end
