//
//  JGHApplyCatoryPromCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHApplyCatoryPromCell.h"

@implementation JGHApplyCatoryPromCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    
    self.titleLable.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.titleLableLeft.constant = 10 *ProportionAdapter;
    
    self.commitBtnTop.constant = 10 *ProportionAdapter;
    self.commitBtnRight.constant = 10 *ProportionAdapter;
    self.commitBtnDown.constant = 10 *ProportionAdapter;
    
    [self.commitBtn setTitleColor:[UIColor colorWithHexString:Bar_Color] forState:UIControlStateNormal];
    self.commitBtn.layer.cornerRadius = 5.0 *ProportionAdapter;
    [self.commitBtn.layer setBorderWidth:1.0];
    [self.commitBtn.layer setBorderColor:[UIColor colorWithHexString:Bar_Color].CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)commitBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate applyCatoryPromCellCommitBtn:sender];
    }
}


@end
