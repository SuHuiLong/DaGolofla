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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configJGLBankModel:(JGLBankModel *)model andSelectBlank:(NSInteger)selectBlank andCurrentSelect:(NSInteger)currentSelect{
    
    if (selectBlank == currentSelect) {
        self.selectImageView.image = [UIImage imageNamed:@"kuangwx"];
    }else{
        self.selectImageView.image = [UIImage imageNamed:@"kuang"];
    }
    
    
    self.name.text = model.name;
}

- (void)configAddBlankCatory{
    self.selectImageView.hidden = YES;
    self.blankImageView.image = [UIImage imageNamed:@"plussign"];
    self.name.text = @"添加银行卡";
}

@end
