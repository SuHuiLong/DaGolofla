//
//  JGHButtonCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHButtonCell.h"

@implementation JGHButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.clickBtn.layer.masksToBounds = YES;
    self.clickBtn.layer.cornerRadius = 8.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectCommitBtnClick:sender];
    }
}


@end
