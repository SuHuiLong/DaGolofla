//
//  BookCourtPriceTableViewCell.m
//  DagolfLa
//
//  Created by SHL on 2017/6/19.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "BookCourtPriceTableViewCell.h"

@implementation BookCourtPriceTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

#pragma mark - CreateView
-(void)createUI{
    UILabel *titleLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(10), 0, screenWidth/2, kWvertical(50)) textColor:RGB(160,160,160) fontSize:kHorizontal(16) Title:@""];
    _titleLabel = titleLabel;
    [self.contentView addSubview:_titleLabel];

    UILabel *priceLabel = [Factory createLabelWithFrame:CGRectMake(0, 0, screenWidth - kWvertical(10), kWvertical(50)) textColor:RGB(98,98,98) fontSize:kHorizontal(16) Title:@""];
    _priceLabel = priceLabel;
    priceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_priceLabel];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 50 * ProportionAdapter, screenWidth - 10 * ProportionAdapter, 1 )];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [self.contentView addSubview:lineView];

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
