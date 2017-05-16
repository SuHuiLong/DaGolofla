//
//  JGHAddPlaysCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHAddPlaysCell.h"

@implementation JGHAddPlaysCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    
    self.oneImageViewTop.constant = 16 *ProportionAdapter;
    self.oneImageViewLeft.constant = 40 *ProportionAdapter;
    self.oneImageViewRight.constant = 40 *ProportionAdapter;
    
    self.twoImageViewTop.constant = 16 *ProportionAdapter;
    self.twoImageViewLeft.constant = 40 *ProportionAdapter;
    self.twoImageViewRight.constant = 40 *ProportionAdapter;
    
    self.threeImageViewTop.constant = 16 *ProportionAdapter;
    self.threeImageViewLeft.constant = 40 *ProportionAdapter;
    self.threeImageViewLeftRight.constant = 40 *ProportionAdapter;
    
    self.oneLableTop.constant = 16 *ProportionAdapter;
    self.twoLableLeft.constant = 16 *ProportionAdapter;
    self.threeLableLeft.constant = 16 *ProportionAdapter;
    
    self.oneLable.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.twoLable.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.threeLable.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)oneBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectAddPlays:sender];
    }
}

- (IBAction)twoBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectAddBallPlays:sender];
    }
}

- (IBAction)threeBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectAddContactPlays:sender];
    }
}
@end
