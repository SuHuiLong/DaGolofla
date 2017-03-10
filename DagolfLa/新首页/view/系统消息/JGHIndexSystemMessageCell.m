//
//  JGHIndexSystemMessageCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/3/6.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHIndexSystemMessageCell.h"

@implementation JGHIndexSystemMessageCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        _systemImageBtn = [[UIButton alloc]initWithFrame:CGRectMake(10*ProportionAdapter, 25*ProportionAdapter, 30*ProportionAdapter, 30*ProportionAdapter)];
        [_systemImageBtn setImage:[UIImage imageNamed:@"home_icn_message"] forState:UIControlStateNormal];
        [self addSubview:_systemImageBtn];
        
        _line = [[UILabel alloc]initWithFrame:CGRectMake(50*ProportionAdapter, 21*ProportionAdapter, 0.5, 35*ProportionAdapter)];
        _line.backgroundColor = [UIColor colorWithHexString:BG_color];
        [self addSubview:_line];
        
        _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(60 *ProportionAdapter, 18*ProportionAdapter, screenWidth -76*ProportionAdapter, 20*ProportionAdapter)];
        _titleLable.font = [UIFont systemFontOfSize:15*ProportionAdapter];
        _titleLable.textColor = [UIColor colorWithHexString:B31_Color];
        _titleLable.text = @"暂无消息";
        [self addSubview:_titleLable];
        
        _directionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _directionBtn.frame = CGRectMake(screenWidth -18*ProportionAdapter, 20*ProportionAdapter, 8*ProportionAdapter, 16*ProportionAdapter);
        [_directionBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        [_directionBtn setTintColor:[UIColor colorWithHexString:Ba0_Color]];
        [self addSubview:_directionBtn];
        
        _detailLable = [[UILabel alloc]initWithFrame:CGRectMake(60*ProportionAdapter, 44*ProportionAdapter, screenWidth -60*ProportionAdapter, 15*ProportionAdapter)];
        _detailLable.textColor = [UIColor colorWithHexString:Ba0_Color];
        _detailLable.font = [UIFont systemFontOfSize:14*ProportionAdapter];
        _detailLable.text = @"";
        [self addSubview:_detailLable];
        
    }
    return self;
}

- (void)configJGHIndexSystemMessageCell:(NSDictionary *)dict{
    if ([dict objectForKey:@"nSrcName"]) {
        _titleLable.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"nSrcName"]];
    }
    
    if ([dict objectForKey:@"title"]) {
        _detailLable.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"title"]];
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
