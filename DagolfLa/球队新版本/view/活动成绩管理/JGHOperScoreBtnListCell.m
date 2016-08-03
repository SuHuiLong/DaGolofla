//
//  JGHOperScoreBtnListCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/2.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHOperScoreBtnListCell.h"

@implementation JGHOperScoreBtnListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.oneBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    
    self.twoBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    
    self.threeBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    
    self.fourBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)oneBtnClick:(UIButton *)sender {
}
- (IBAction)twoBtnClick:(UIButton *)sender {
}
- (IBAction)threeBtnClick:(UIButton *)sender {
}
- (IBAction)fourBtnClick:(UIButton *)sender {
}
@end
