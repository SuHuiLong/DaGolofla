//
//  JGHSaveAndSubmitBtnCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHSaveAndSubmitBtnCell.h"

@implementation JGHSaveAndSubmitBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 8.0;
    
    [self.saveBtn setBackgroundColor:[UIColor colorWithHexString:@"#f39800"]];
    [self.submitBtn setBackgroundColor:[UIColor colorWithHexString:@"#eb6100"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)saveBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate SaveBtnClick:sender];
    }
}
- (IBAction)submitBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate SubmitBtnClick:sender];
    }
}
@end
