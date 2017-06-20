//
//  SelectRedPacketTableViewCell.m
//  DagolfLa
//
//  Created by SHL on 2017/6/8.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "SelectRedPacketTableViewCell.h"

@implementation SelectRedPacketTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

#pragma mark - CreateView
-(void)createView{
    UIView *grayView = [Factory createViewWithBackgroundColor:Back_Color frame:CGRectMake(0, 0, screenWidth, kHvertical(10))];
    [self.contentView addSubview:grayView];
    _grayView = grayView;
    
    _titleLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(10), kHvertical(10), screenWidth, kHvertical(51)) textColor:RGB(160,160,160) fontSize:kHorizontal(16) Title:@"红包优惠"];
    [self.contentView addSubview:_titleLabel];
    
    _descLabel = [Factory createLabelWithFrame:CGRectMake(0, kHvertical(10), screenWidth - kWvertical(24), kHvertical(51)) textColor:RGB(160,160,160) fontSize:kHorizontal(15) Title:@"无可用红包"];
    [_descLabel setTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:_descLabel];
    
    UIImageView *arrowImageView = [Factory createImageViewWithFrame:CGRectMake(screenWidth - kWvertical(20), kHvertical(29), kWvertical(8), kHvertical(13)) Image:[UIImage imageNamed:@"darkArrow"]];
    arrowImageView.tintColor = RGB(160,160,160);
    [self.contentView addSubview:arrowImageView];
    _arrowImageView = arrowImageView;
}
#pragma mark - InitData
-(void)configData:(NSInteger)canUseNum{
    NSString *textStr = @"无可用红包";
    if (canUseNum==0) {
        _descLabel.text = textStr;
        [_descLabel setTextColor:RGB(160,160,160)];
    }else{
        textStr= [NSString stringWithFormat:@"%ld个可用",(long)canUseNum];
        _descLabel.text = textStr;
        [_descLabel setTextColor:RGB(252,90,1)];
    }
}
-(void)configSelectData:(RedPacketModel *)model{
    NSInteger price = model.money;
    NSString *textStr= [NSString stringWithFormat:@"-¥%ld",(long)price];
    _descLabel.text = textStr;
    [_descLabel setTextColor:RGB(252,90,1)];
}

-(void)hidenGrayView{
    _grayView.backgroundColor = ClearColor;
    _titleLabel.y = 0;
    _descLabel.y = 0;
    _arrowImageView.y = kHvertical(19);
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
