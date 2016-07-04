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
    
    if (iPhone5) {
        self.top.constant = 5.0;
        self.down.constant = 5.0;
    }
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

- (void)configPassword:(NSInteger)editor{
    self.backgroundColor = [UIColor colorWithHexString:BG_color];
    [self.clickBtn setTitle:@"确认" forState:UIControlStateNormal];
    if (editor == 1) {
        self.clickBtn.backgroundColor = [UIColor colorWithHexString:Click_Color];
    }else{
        self.clickBtn.backgroundColor = [UIColor colorWithHexString:NoClick_Color];
    }
    
}

@end
