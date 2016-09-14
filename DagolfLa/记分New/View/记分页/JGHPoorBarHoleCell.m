//
//  JGHPoorBarHoleCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/9/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHPoorBarHoleCell.h"

@implementation JGHPoorBarHoleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameBtn.titleLabel.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    self.nameBtnLeft.constant = 10 *ProportionAdapter;
    
    self.nameBtnImageViewLeft.constant = 8 *ProportionAdapter;
    
    self.oneK.backgroundColor = [UIColor colorWithHexString:Par_Eagle];
    self.oneKW.constant = 10 *ProportionAdapter;
    self.oneKRight.constant = 6 *ProportionAdapter;
    
    self.eagleLable.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
    self.eagleLableRight.constant = 10 *ProportionAdapter;
    
    self.twoK.backgroundColor = [UIColor colorWithHexString:Par_Birdie];
    self.twoKW.constant = 10 *ProportionAdapter;
    self.twoKRight.constant = 6 *ProportionAdapter;

    self.birdleLable.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
    self.birdleLableRight.constant = 10 *ProportionAdapter;

    self.three.backgroundColor = [UIColor colorWithHexString:Par_Par];
    self.threeW.constant = 10 *ProportionAdapter;
    self.threeRight.constant = 6 *ProportionAdapter;

    self.parLable.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
    self.parLableRight.constant = 10 *ProportionAdapter;
    
    self.fourK.backgroundColor = [UIColor colorWithHexString:Par_Bogey];
    self.fourKW.constant = 10 *ProportionAdapter;
    self.fourKRight.constant = 6 *ProportionAdapter;

    self.BogeyLable.font = [UIFont systemFontOfSize:13 *ProportionAdapter];
    self.BogeyLableRight.constant = 10 *ProportionAdapter;
}

- (void)configJGHPoorBarHoleCell:(NSString *)areaString andImageDirection:(NSInteger)direction;{
    [self.nameBtn setTitle:areaString forState:UIControlStateNormal];

    if (direction == 0) {
        self.nameBtnImageView.image = [UIImage imageNamed:@"arrowDown"];
    }else{
        self.nameBtnImageView.image = [UIImage imageNamed:@"arrowTop"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)nameBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate jGHPoorBarHoleCellDelegate:sender];
    }
}
@end
