//
//  JGHGolfPackageSubCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/3/7.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHGolfPackageSubCell.h"

@implementation JGHGolfPackageSubCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 0, screenWidth -50*ProportionAdapter, 164*ProportionAdapter)];
        _headerImageView.image = [UIImage imageNamed:@"home_bg_comp"];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headerImageView.layer.masksToBounds = YES;
        [self addSubview:_headerImageView];
        
        _golfImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 180*ProportionAdapter, 12*ProportionAdapter, 17*ProportionAdapter)];
        _golfImageView.image = [UIImage imageNamed:@"home_hot"];
        [self addSubview:_golfImageView];
        
        _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(27*ProportionAdapter, 180*ProportionAdapter, screenWidth -66*ProportionAdapter, 20*ProportionAdapter)];
        _titleLable.font = [UIFont systemFontOfSize:17*ProportionAdapter];
        _titleLable.textColor = [UIColor colorWithHexString:B31_Color];
        _titleLable.text = @"";
        [self addSubview:_titleLable];
        
        _price = [[UILabel alloc]initWithFrame:CGRectMake(27*ProportionAdapter, 212*ProportionAdapter, screenWidth -66*ProportionAdapter, 20*ProportionAdapter)];
        _price.font = [UIFont systemFontOfSize:16*ProportionAdapter];
        _price.textColor = [UIColor colorWithHexString:SY_PriceColor];
        _price.text = @"";
        [self addSubview:_price];
    }
    return self;
}

- (void)configJGHGolfPackageSubCell:(NSDictionary *)dict{
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"imgURL"]] placeholderImage:[UIImage imageNamed:@"home_bg_comp"]];
    //_headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    if ([dict objectForKey:@"title"]) {
        _titleLable.text = [dict objectForKey:@"title"];
    }
    
    if ([dict objectForKey:@"money"]) {
        _price.text = [NSString stringWithFormat:@"¥%@", [dict objectForKey:@"money"]];
    }
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
