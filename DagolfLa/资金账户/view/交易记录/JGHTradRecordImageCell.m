//
//  JGHTradRecordImageCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/29.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHTradRecordImageCell.h"
#import "JGLBankModel.h"

@implementation JGHTradRecordImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.imageLeft.constant = 20 * ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//
//- (IBAction)blankCatoryBtn:(UIButton *)sender {
//    if (self.delegate) {
//        [self.delegate selectBlankCatoryBtn:sender];
//    }
//}

- (void)configJGLBankModel:(JGLBankModel *)model{
    self.blankImageView.image = nil;
    
    if ([model.cardType integerValue] == 1) {
        self.blankImageView.image = [UIImage imageNamed:@"zhonghang_color"];
    }else if ([model.cardType integerValue] == 2){
        self.blankImageView.image = [UIImage imageNamed:@"nonghang_color"];
    }else if ([model.cardType integerValue] == 3){
        self.blankImageView.image = [UIImage imageNamed:@"jianhang_color"];
    }else if ([model.cardType integerValue] == 4){
        self.blankImageView.image = [UIImage imageNamed:@"gonghang_color"];
    }else if ([model.cardType integerValue] == 5){
        self.blankImageView.image = [UIImage imageNamed:@"jiaohang_color"];
    }else if ([model.cardType integerValue] == 6){
        self.blankImageView.image = [UIImage imageNamed:@"youzheng_color"];
    }else if ([model.cardType integerValue] == 7){
        self.blankImageView.image = [UIImage imageNamed:@"zhaohang_color"];
    }else if ([model.cardType integerValue] == 8){
        self.blankImageView.image = [UIImage imageNamed:@"zhongxin_color"];
    }else if ([model.cardType integerValue] == 9){
        self.blankImageView.image = [UIImage imageNamed:@"minsheng_color"];
    }else{
        self.blankImageView.image = [UIImage imageNamed:@"xingye_color"];
    }
    
    self.titles.text = model.backName;
    NSString *cardNumber = [NSString stringWithFormat:@"%@", model.cardNumber];
    
    self.values.text = [NSString stringWithFormat:@"储蓄卡  尾号%@", [cardNumber substringWithRange:NSMakeRange(3, 4)]];
    
}

@end
