//
//  JGHSelectBlankCatoryCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/29.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHSelectBlankCatoryCell.h"
#import "JGLBankModel.h"

@implementation JGHSelectBlankCatoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.name.font = [UIFont systemFontOfSize:17 * ProportionAdapter];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configJGLBankModel:(JGLBankModel *)model andSelectBlank:(NSInteger)selectBlank andCurrentSelect:(NSInteger)currentSelect{
    
    self.selectImageView.hidden = NO;
    self.blankImageView.image = nil;
    /**
     public  static  final   Integer   OTHER                  =    0;  //  其他银行
     public  static  final   Integer   BOC                    =    1;  //  中国银行
     public  static  final   Integer   ABC                    =    2;  //  农业银行
     public  static  final   Integer   CCB                    =    3;  //  建设银行
     public  static  final   Integer   ICBC                   =    4;  //  工商银行
     public  static  final   Integer   BCM                    =    5;  //  交通银行
     public  static  final   Integer   PSBC                   =    6;  //  邮政银行
     public  static  final   Integer   CMB                    =    7;  //  招商银行
     public  static  final   Integer   CHINACITICBANK         =    8;  //  中信银行
     public  static  final   Integer   CMBC                   =    9;  //  民生银行
     public  static  final   Integer   CIB                    =    10; //  兴业银行
     
     */
    
    if ([model.cardType integerValue] == 1) {
        self.blankImageView.image = [UIImage imageNamed:@"zhonghang_color"];
    }
    
    if ([model.cardType integerValue] == 2){
        self.blankImageView.image = [UIImage imageNamed:@"nonghang_color"];
    }
    
    if ([model.cardType integerValue] == 3){
        self.blankImageView.image = [UIImage imageNamed:@"jianhang_color"];
    }
    
    if ([model.cardType integerValue] == 4){
        self.blankImageView.image = [UIImage imageNamed:@"gonghang_color"];
    }
    
    if ([model.cardType integerValue] == 5){
        self.blankImageView.image = [UIImage imageNamed:@"jiaohang_color"];
    }
    
    if ([model.cardType integerValue] == 6){
        self.blankImageView.image = [UIImage imageNamed:@"youzheng_color"];
    }
    
    if ([model.cardType integerValue] == 7){
        self.blankImageView.image = [UIImage imageNamed:@"zhaohang_color"];
    }
    
    if ([model.cardType integerValue] == 8){
        self.blankImageView.image = [UIImage imageNamed:@"zhongxin_color"];
    }
    
    if ([model.cardType integerValue] == 9){
        self.blankImageView.image = [UIImage imageNamed:@"minsheng_color"];
    }
    
    if ([model.cardType integerValue] == 10){
        self.blankImageView.image = [UIImage imageNamed:@"xingye_color"];
    }
    
    if (selectBlank == currentSelect) {
        self.selectImageView.image = [UIImage imageNamed:@"kuang_xz"];
    }else{
        self.selectImageView.image = [UIImage imageNamed:@"kuang"];
    }
    
    self.name.text = @"";
    NSString *cardNumber = [NSString stringWithFormat:@"%@", model.cardNumber];
    if (cardNumber.length >= 4) {
        self.name.text = [NSString stringWithFormat:@"%@（%@）", model.backName, [cardNumber substringWithRange:NSMakeRange(cardNumber.length - 4, 4)]];
    }else{
        self.name.text = [NSString stringWithFormat:@"%@（%@）", model.backName, cardNumber];
    }
}

- (void)configAddBlankCatory{
    self.selectImageView.image = nil;
    self.selectImageView.hidden = YES;
    self.blankImageView.image = nil;
    self.blankImageView.image = [UIImage imageNamed:@"plussign"];
    self.name.text = @"添加银行卡";
}

@end
