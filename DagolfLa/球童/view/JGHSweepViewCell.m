//
//  JGHSweepViewCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHSweepViewCell.h"

@implementation JGHSweepViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.dividerLableTop.constant = 10 *ProportionAdapter;
    
    self.dividerLableDown.constant = 10 *ProportionAdapter;
    
    self.cabbieScore.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.cabbieScoreDown.constant = 25 *ProportionAdapter;
    
    self.myQrCodeLable.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    
    self.mtQrcodeDown.constant = 15 *ProportionAdapter;
    
    self.cabbieImageDown.constant = 15 *ProportionAdapter;
    
    self.myQrCodeLableDown.constant = 25 *ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)cabbieBtn:(UIButton *)sender {
}
- (IBAction)myQrBtn:(UIButton *)sender {
}
@end
