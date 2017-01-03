//
//  JGHTimeViewListCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/1/3.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHTimeViewListCell.h"

@implementation JGHTimeViewListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _timeLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenWidth/2 -10*ProportionAdapter, 49 *ProportionAdapter)];
        _timeLable.font = [UIFont systemFontOfSize:20 *ProportionAdapter];
        _timeLable.textColor = [UIColor colorWithHexString:B31_Color];
        _timeLable.textAlignment = NSTextAlignmentRight;
        [self addSubview:_timeLable];
        
        _priceLable = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2 +10*ProportionAdapter, 0, screenWidth/2 -10*ProportionAdapter, 49 *ProportionAdapter)];
        _priceLable.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        _priceLable.textAlignment = NSTextAlignmentLeft;
        _priceLable.textColor = [UIColor colorWithHexString:@"#fc5a01"];
        [self addSubview:_priceLable];
        
        _line = [[UILabel alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 49 *ProportionAdapter, screenWidth -20*ProportionAdapter, 0.5)];
        _line.backgroundColor = [UIColor colorWithHexString:BG_color];
        [self addSubview:_line];
    }
    return self;
}

- (void)configJGHTimeViewListCell:(NSDictionary *)pircedict{
    _timeLable.text = [NSString stringWithFormat:@"%@", [pircedict objectForKey:@"halfHour"]];
    
    if ([pircedict objectForKey:@"money"]) {
        _priceLable.text = [NSString stringWithFormat:@"¥ %@", [pircedict objectForKey:@"money"]];
    }else{
        _priceLable.text = @"";
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
