//
//  JGHSetBallBaseCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHSetBallBaseCell.h"

@implementation JGHSetBallBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgTop.constant = 5 *ProportionAdapter;
    self.bgLeft.constant = 20 *ProportionAdapter;
    self.bgRight.constant = 20 *ProportionAdapter;
    
    self.headerImageView.image = [UIImage imageNamed:DefaultHeaderImage];
    self.headerImageViewTop.constant = 30 *ProportionAdapter;
    self.headerImageViewLeft.constant = 35 *ProportionAdapter;
    self.headerImageViewWith.constant = 40 *ProportionAdapter;
    
    self.ballName.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    self.ballNameLeft.constant = 10 *ProportionAdapter;

    self.lineLeft.constant = 30 *ProportionAdapter;
    self.lineRight.constant = 30 *ProportionAdapter;

    self.oneBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    
    self.oneBtnTop.constant = 25 *ProportionAdapter;
    self.oneBtnLeft.constant = 15 *ProportionAdapter;
    self.oneBtnRight.constant = 30 *ProportionAdapter;

    self.twoBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
 
    self.startBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)oneBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate oneAndNineBtn];
    }
}
- (IBAction)twoBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate twoAndNineBtn];
    }
}
- (IBAction)startBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate startScoreBtn];
    }
}

- (void)configRegist1:(NSString *)regist1 andRegist2:(NSString *)regist2{
    [self.oneBtn setTitle:[NSString stringWithFormat:@" %@", regist1] forState:UIControlStateNormal];
    
    [self.twoBtn setTitle:[NSString stringWithFormat:@" %@", regist2] forState:UIControlStateNormal];
}


@end
