//
//  JGHSpectatorSubCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/3/7.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHSpectatorSubCell.h"

@implementation JGHSpectatorSubCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(6*ProportionAdapter, 0, screenWidth -50*ProportionAdapter, 164*ProportionAdapter)];
        _headerImageView.image = [UIImage imageNamed:@"home_bg_comp"];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headerImageView.clipsToBounds = YES;
        [self addSubview:_headerImageView];
        
        _point = [[UILabel alloc]initWithFrame:CGRectMake(6*ProportionAdapter, 184*ProportionAdapter, 5*ProportionAdapter, 5*ProportionAdapter)];
        _point.backgroundColor = [UIColor colorWithHexString:@"#cc3c3c"];
        [self addSubview:_point];
        
        _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(18*ProportionAdapter, 176*ProportionAdapter, screenWidth -65*ProportionAdapter, 20*ProportionAdapter)];
        _titleLable.font = [UIFont systemFontOfSize:17*ProportionAdapter];
        _titleLable.textColor = [UIColor colorWithHexString:B31_Color];
        _titleLable.text = @"";
        [self addSubview:_titleLable];
        
        _detailLable = [[UILabel alloc]initWithFrame:CGRectMake(18*ProportionAdapter, 200*ProportionAdapter, screenWidth -65*ProportionAdapter, 40*ProportionAdapter)];
        _detailLable.font = [UIFont systemFontOfSize:15*ProportionAdapter];
        _detailLable.textColor = [UIColor colorWithHexString:@"#626262"];
        _detailLable.text = @"肌肤定史蒂夫史蒂夫史蒂夫弄死对方 i 少部分 i 上的封闭式福建省";
        _detailLable.numberOfLines = 2;
        [self addSubview:_detailLable];
    }
    return self;
}

- (void)configJGHSpectatorSubCell:(NSDictionary *)dict andImageW:(NSInteger)imageW andImageH:(NSInteger)imageH{
    _headerImageView.frame = CGRectMake(6*ProportionAdapter, 0, imageW, imageH);
    _point.frame = CGRectMake(6*ProportionAdapter, imageH +20*ProportionAdapter, 5*ProportionAdapter, 5*ProportionAdapter);
    _titleLable.frame = CGRectMake(18*ProportionAdapter, imageH +12*ProportionAdapter, imageW -12*ProportionAdapter, 20*ProportionAdapter);
    _detailLable.frame = CGRectMake(18*ProportionAdapter, imageH+36*ProportionAdapter, imageW -12*ProportionAdapter, 40*ProportionAdapter);
    
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"imgURL"]] placeholderImage:[UIImage imageNamed:@"home_bg_comp"]];
    //_headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    if ([dict objectForKey:@"title"]) {
        _titleLable.text = [dict objectForKey:@"title"];
    }
    
    if ([dict objectForKey:@"desc"]) {
        _detailLable.text = [dict objectForKey:@"desc"];
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
