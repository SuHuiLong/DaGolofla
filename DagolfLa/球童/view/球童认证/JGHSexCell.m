//
//  JGHSexCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHSexCell.h"

@implementation JGHSexCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLable.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.titleLableLeft.constant = 20 *ProportionAdapter;
    self.titleLableW.constant = 60 *ProportionAdapter;
    
    self.manBtn.titleLabel.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    
    self.womanBtn.titleLabel.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.manBtnLeft.constant = 40 *ProportionAdapter;
    self.womanLeft.constant = 30 *ProportionAdapter;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)manBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectSexBtn:sender];
    }
}
- (IBAction)womanBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectSexBtn:sender];
    }
}

- (void)configSex:(NSInteger)sex{
    self.titleLable.text = @"性别";
    if (sex == 0) {
        [self.manBtn setImage:[UIImage imageNamed:@"xuan_w"] forState:UIControlStateNormal];
        [self.womanBtn setImage:[UIImage imageNamed:@"xuan_z"] forState:UIControlStateNormal];
    }else{
        [self.manBtn setImage:[UIImage imageNamed:@"xuan_z"] forState:UIControlStateNormal];
        [self.womanBtn setImage:[UIImage imageNamed:@"xuan_w"] forState:UIControlStateNormal];
    }
}


@end
