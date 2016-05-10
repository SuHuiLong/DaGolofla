//
//  ManageCreateEditTableViewCell.m
//  DagolfLa
//
//  Created by bhxx on 15/11/30.
//  Copyright © 2015年 bhxx. All rights reserved.
//

#import "ManageCreateEditTableViewCell.h"

@implementation ManageCreateEditTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8*ScreenWidth/375, 12*ScreenWidth/375, 100*ScreenWidth/375, 20*ScreenWidth/375)];
        [self.contentView addSubview:_titleLabel];
        _titleLabel.font = [UIFont systemFontOfSize:15*ScreenWidth/375];

        _textField = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth - 170*ScreenWidth/375, 12*ScreenWidth/375, 140*ScreenWidth/375, 20*ScreenWidth/375)];
        [self.contentView addSubview:_textField];
        _textField.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        _textField.textAlignment = NSTextAlignmentRight;
        
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 170*ScreenWidth/375, 12*ScreenWidth/375, 140*ScreenWidth/375, 20*ScreenWidth/375)];
        [self.contentView addSubview:_detailLabel];
        _detailLabel.font = [UIFont systemFontOfSize:14*ScreenWidth/375];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        
        _jtImage = [[UIImageView alloc]initWithFrame:CGRectMake(355*ScreenWidth/375, 14*ScreenWidth/375, 12*ScreenWidth/375, 16*ScreenWidth/375)];
        _jtImage.image = [UIImage imageNamed:@"left_jt"];
        [self.contentView addSubview:_jtImage];
        
        _view = [[UIView alloc]initWithFrame:CGRectMake(10*ScreenWidth/375, 44*ScreenWidth/375, ScreenWidth-20*ScreenWidth/375, 1*ScreenWidth/375)];
        [self.contentView addSubview:_view];
        _view.backgroundColor = [UIColor lightGrayColor];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
