//
//  JGHBtnCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHBtnCell.h"

@implementation JGHBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleBtn.layer.masksToBounds = YES;
    self.titleBtn.layer.cornerRadius = 8.0;
    
    self.titleBtnLeft.constant = 10 *ProportionAdapter;

    self.titleBtnRight.constant = 10 *ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)titleBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate commitCabbieCert:sender];
    }
}

- (void)configBtn{
    self.titleBtnTop.constant = 5 *ProportionAdapter;
    self.titleBtnDown.constant = 5 *ProportionAdapter;
    self.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.titleBtn.backgroundColor = [UIColor orangeColor];
    [self.titleBtn setTitle:@"提交" forState:UIControlStateNormal];
}

- (void)configSuccessBtn{
    self.titleBtnTop.constant = 0;
    self.titleBtnDown.constant = 0;
    self.backgroundColor = [UIColor whiteColor];
    self.titleBtn.backgroundColor = [UIColor orangeColor];
    [self.titleBtn setTitle:@"开始记分" forState:UIControlStateNormal];
}

@end
