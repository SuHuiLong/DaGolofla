//
//  JGHScoresHoleCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHScoresHoleCell.h"

@implementation JGHScoresHoleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.name.font = [UIFont systemFontOfSize:13.0*ProportionAdapter];
    NSLayoutConstraint *sConstraint = [NSLayoutConstraint constraintWithItem:self.name attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:55.5*ProportionAdapter];
    NSArray *array2 = [NSArray arrayWithObjects:sConstraint, nil];
    [self addConstraints: array2];
    
    self.one.titleLabel.font = [UIFont systemFontOfSize:13.0*ProportionAdapter];
    self.two.titleLabel.font = [UIFont systemFontOfSize:13.0*ProportionAdapter];
    self.three.titleLabel.font = [UIFont systemFontOfSize:13.0*ProportionAdapter];
    self.four.titleLabel.font = [UIFont systemFontOfSize:13.0*ProportionAdapter];
    self.five.titleLabel.font = [UIFont systemFontOfSize:13.0*ProportionAdapter];
    self.six.titleLabel.font = [UIFont systemFontOfSize:13.0*ProportionAdapter];
    self.seven.titleLabel.font = [UIFont systemFontOfSize:13.0*ProportionAdapter];
    self.eight.titleLabel.font = [UIFont systemFontOfSize:13.0*ProportionAdapter];
    self.nine.titleLabel.font = [UIFont systemFontOfSize:13.0*ProportionAdapter];
    
}

- (void)configAllViewBgColor:(NSString *)colorString{
    self.name.backgroundColor = [UIColor colorWithHexString:colorString];
    self.one.backgroundColor = [UIColor colorWithHexString:colorString];
    self.two.backgroundColor = [UIColor colorWithHexString:colorString];
    self.three.backgroundColor = [UIColor colorWithHexString:colorString];
    self.four.backgroundColor = [UIColor colorWithHexString:colorString];
    self.five.backgroundColor = [UIColor colorWithHexString:colorString];
    self.six.backgroundColor = [UIColor colorWithHexString:colorString];
    self.seven.backgroundColor = [UIColor colorWithHexString:colorString];
    self.eight.backgroundColor = [UIColor colorWithHexString:colorString];
    self.nine.backgroundColor = [UIColor colorWithHexString:colorString];
}

- (void)configArray:(NSArray *)array{
    self.name.text = @"HOLE";
    [self.one setTitle:array[0] forState:UIControlStateNormal];
    [self.two setTitle:array[1] forState:UIControlStateNormal];
    [self.three setTitle:array[2] forState:UIControlStateNormal];
    [self.four setTitle:array[3] forState:UIControlStateNormal];
    [self.five setTitle:array[4] forState:UIControlStateNormal];
    [self.six setTitle:array[5] forState:UIControlStateNormal];
    [self.seven setTitle:array[6] forState:UIControlStateNormal];
    [self.eight setTitle:array[7] forState:UIControlStateNormal];
    [self.nine setTitle:array[8] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)oneBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectHoleCoresBtnTag:sender.tag andCellTag:self.tag];
    }
}
- (IBAction)twoBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectHoleCoresBtnTag:sender.tag andCellTag:self.tag];
    }
}
- (IBAction)threeBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectHoleCoresBtnTag:sender.tag andCellTag:self.tag];
    }
}
- (IBAction)fourBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectHoleCoresBtnTag:sender.tag andCellTag:self.tag];
    }
}
- (IBAction)fiveBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectHoleCoresBtnTag:sender.tag andCellTag:self.tag];
    }
}
- (IBAction)sixBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectHoleCoresBtnTag:sender.tag andCellTag:self.tag];
    }
}
- (IBAction)sevenBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectHoleCoresBtnTag:sender.tag andCellTag:self.tag];
    }
}
- (IBAction)eightBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectHoleCoresBtnTag:sender.tag andCellTag:self.tag];
    }
}
- (IBAction)nineBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectHoleCoresBtnTag:sender.tag andCellTag:self.tag];
    }
}
@end
