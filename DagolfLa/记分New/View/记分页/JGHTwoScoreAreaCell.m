//
//  JGHTwoScoreAreaCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/9/7.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHTwoScoreAreaCell.h"

@implementation JGHTwoScoreAreaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.areaNameBtn.titleLabel.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.areaNameBtnLeft.constant = 10 *ProportionAdapter;
    
    self.areaImageViewLeft.constant = 13 *ProportionAdapter;
}
- (void)configArea:(NSString *)areaString andImageDirection:(NSInteger)direction{
    [self.areaNameBtn setTitle:areaString forState:UIControlStateNormal];
    if (direction == 0) {
        self.areaImageView.image = [UIImage imageNamed:@"arrowDown"];
    }else{
        self.areaImageView.image = [UIImage imageNamed:@"arrowTop"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)areaNameBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate twoAreaNameBtn:sender];
    }
}
@end
