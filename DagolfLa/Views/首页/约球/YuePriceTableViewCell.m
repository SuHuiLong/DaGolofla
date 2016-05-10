//
//  YuePriceTableViewCell.m
//  DagolfLa
//
//  Created by bhxx on 16/1/12.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "YuePriceTableViewCell.h"
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
@implementation YuePriceTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

//8  6 142  21
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8*ScreenWidth/375, 6*ScreenWidth/375, 142*ScreenWidth/375, 21*ScreenWidth/375)];
        _titleLabel.text = @"价格";
        _titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        [self.contentView addSubview:_titleLabel];
        
        
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(190*ScreenWidth/375, 4*ScreenWidth/375, 132*ScreenWidth/375, 25*ScreenWidth/375)];
        _textField.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        _textField.placeholder = @"请输入价格";
        _textField.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_textField];
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(322*ScreenWidth/375, 4*ScreenWidth/375, 15*ScreenWidth/375, 25*ScreenWidth/375)];
        _label.text = @"元";
        _label.font = [UIFont systemFontOfSize:15*ScreenWidth/375];
        _label.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_label];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
