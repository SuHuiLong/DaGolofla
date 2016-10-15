//
//  JGLGroupClubTitleTableViewCell.m
//  DagolfLa
//
//  Created by Madridlee on 16/10/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLGroupClubTitleTableViewCell.h"

@implementation JGLGroupClubTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _backImgv = [[UIImageView alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 10*ProportionAdapter, screenWidth - 20*ProportionAdapter, 35*ProportionAdapter)];
        _backImgv.image = [UIImage imageNamed:@"vs_title"];
        [self.contentView addSubview:_backImgv];
        
        _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(5*ProportionAdapter, 10*ProportionAdapter, 130*ProportionAdapter, 20*ProportionAdapter)];
        _leftLabel.font = [UIFont systemFontOfSize:12*ProportionAdapter];
        [_backImgv addSubview:_leftLabel];
        _leftLabel.text = @"上海君高高尔夫俱乐部";
        _leftLabel.textColor = [UIColor whiteColor];
        _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 155*ProportionAdapter, 10*ProportionAdapter, 130*ProportionAdapter, 20*ProportionAdapter)];
        _rightLabel.font = [UIFont systemFontOfSize:12*ProportionAdapter];
        [_backImgv addSubview:_rightLabel];
        _rightLabel.textColor = [UIColor whiteColor];
        _rightLabel.text = @"上海樱桃高尔夫俱乐部";
        _lineImgv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 58*ProportionAdapter, screenWidth, 12*ProportionAdapter)];
        _lineImgv.image = [UIImage imageNamed:@"group_open"];
        [self.contentView addSubview:_lineImgv];

        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
