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


- (void)configJGLBankModel:(JGLBankModel *)model{
    
}

@end
