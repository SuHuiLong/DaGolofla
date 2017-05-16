//
//  JGHNewActivityTextCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/3/16.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHNewActivityTextCell.h"

@implementation JGHNewActivityTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 10*ProportionAdapter, 22*ProportionAdapter, 22*ProportionAdapter)];
        [self addSubview:_iconImageView];
        
        _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(40*ProportionAdapter, 10*ProportionAdapter, 70*ProportionAdapter, 22*ProportionAdapter)];
        _titleLable.text = @"";
        _titleLable.textAlignment = NSTextAlignmentLeft;
        _titleLable.font = [UIFont systemFontOfSize:15*ProportionAdapter];
        [self addSubview:_titleLable];
        
        _contentText = [[UITextField alloc]initWithFrame:CGRectMake(122*ProportionAdapter, 10*ProportionAdapter, screenWidth -152*ProportionAdapter, 22*ProportionAdapter)];
        _contentText.text = @"";
        //_contentText.clearButtonMode = UITextFieldViewModeAlways;
        _contentText.textAlignment = NSTextAlignmentRight;
        _contentText.font = [UIFont systemFontOfSize:15*ProportionAdapter];
        _contentText.textColor = [UIColor colorWithHexString:Ba0_Color];
        [self addSubview:_contentText];
        
        _line = [[UILabel alloc]initWithFrame:CGRectMake(0, 45*ProportionAdapter -0.5, screenWidth, 0.5)];
        _line.backgroundColor = [UIColor colorWithHexString:BG_color];
        [self addSubview:_line];
    }
    
    return self;
}

- (void)configJGHNewActivityTextCellTitle:(NSString *)title andImageName:(NSString *)imageName andContent:(NSString *)content{
    _iconImageView.image = [UIImage imageNamed:imageName];
    
    _titleLable.text = title;
    
    _contentText.text = content;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
