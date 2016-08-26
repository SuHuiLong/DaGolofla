//
//  JGActivityNameBaseCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGActivityNameBaseCell.h"

@implementation JGActivityNameBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCostSubInstructionPriceFloat:(CGFloat)price{
    self.topValue.constant = 0.0;
    self.downValue.constant = 0.0;
    self.baseLabel.textAlignment = NSTextAlignmentRight;
    self.baseLabel.text = [NSString stringWithFormat:@"用户本人线上支付-%.2f", price];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.baseLabel.text];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#F19725"] range:NSMakeRange(8, self.baseLabel.text.length-8)]; // 0为起始位置 length是从起始位置开始 设置指定颜色的长度
    self.baseLabel.attributedText = attributedString;
}

- (void)configActivityRefundRulesString:(NSString *)string{
    self.topValue.constant = 0.0;
    self.downValue.constant = 0.0;
    self.baseLabel.text = string;
    self.baseLabel.font = [UIFont systemFontOfSize:13.0];
    self.backgroundColor = [UIColor colorWithHexString:BG_color];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.baseLabel.text];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#F19725"] range:NSMakeRange(23, 29)]; // 0为起始位置 length是从起始位置开始 设置指定颜色的长度
    self.baseLabel.attributedText = attributedString;
}

-(void)configCancelDrawback:(NSString* )str
{
    self.topValue.constant = 0.0;
    self.downValue.constant = 0.0;
    self.baseLabel.text = str;
    self.baseLabel.font = [UIFont systemFontOfSize:13.0];
    self.backgroundColor = [UIColor colorWithHexString:BG_color];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.baseLabel.text];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#7fc1ff"] range:NSMakeRange(23, 29)]; // 0为起始位置 length是从起始位置开始 设置指定颜色的长度
    self.baseLabel.attributedText = attributedString;
}


@end
