//
//  JGHPlayBaseInfoCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHPlayBaseInfoCell.h"

@implementation JGHPlayBaseInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    
    self.name.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.nameTop.constant = 16 *ProportionAdapter;
    self.nameLeft.constant = 35 *ProportionAdapter;
    self.nameW.constant = 100 *ProportionAdapter;
    
    self.nameText.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.nameTextLeft.constant = 10 *ProportionAdapter;
    
    self.almost.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.almostTop.constant = 30 *ProportionAdapter;
    
    self.almostFext.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.almostFextLeft.constant = 10 *ProportionAdapter;
    
    self.phoneNumber.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.phoneNumberLeft.constant = 35 *ProportionAdapter;
    
    self.phoneNumberText.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.phoneNumberTextLeft.constant = 10 *ProportionAdapter;
    
    self.man.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    
    self.woman.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.womanLeft.constant = 20 *ProportionAdapter;
    
    self.phoneNumberText.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)manBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectManBtn:sender];
    }
}
- (IBAction)womanBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectWoManBtn:sender];
    }
}

- (void)configJGHPlayBaseInfoCell:(NSMutableDictionary *)dict{
    if ([dict objectForKey:@"name"]) {
        self.nameText.text = [dict objectForKey:@"name"];
    }else{
        self.nameText.text = @"";
    }
    
    if ([dict objectForKey:@"mobile"]) {
        self.phoneNumberText.text = [dict objectForKey:@"mobile"];
    }else{
        self.phoneNumberText.text = @"";
    }
    
    if ([dict objectForKey:@"almost"]) {
        self.almostFext.text = [NSString stringWithFormat:@"%@", ([[dict objectForKey:@"almost"] integerValue] == -10000)?@"":[dict objectForKey:@"almost"]];
    }else{
        self.almostFext.text = @"";
    }
    
    if ([[dict objectForKey:@"sex"] integerValue] == 0) {
        [self.womanBtn setImage:[UIImage imageNamed:@"xuan_z"] forState:UIControlStateNormal];
        [self.manBtn setImage:[UIImage imageNamed:@"xuan_w"] forState:UIControlStateNormal];
    }else{
        [self.womanBtn setImage:[UIImage imageNamed:@"xuan_w"] forState:UIControlStateNormal];
        [self.manBtn setImage:[UIImage imageNamed:@"xuan_z"] forState:UIControlStateNormal];
    }
}

@end
