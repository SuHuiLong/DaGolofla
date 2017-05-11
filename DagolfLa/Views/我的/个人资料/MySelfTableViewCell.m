//
//  MySelfTableViewCell.m
//  DaGolfla
//
//  Created by bhxx on 15/9/28.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "MySelfTableViewCell.h"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
@implementation MySelfTableViewCell

- (void)awakeFromNib {
    // Initialization code
//    _iconImage.backgroundColor = [UIColor redColor];
    _iconImage.layer.cornerRadius = (70*ScreenWidth/375)/2;
    _iconImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//-(void)showData:(MeselfModel *)model
//{
//    [_iconImage sd_setImageWithURL:[Helper imageUrl:model.pic] placeholderImage:nil];
//}

@end
