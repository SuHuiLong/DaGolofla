//
//  JGHActivityBaseInfoCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/22.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHActivityBaseInfoCell.h"

@implementation JGHActivityBaseInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configBaseInfo:(NSString *)string andIndexRow:(NSInteger)index{
    NSArray *array = [string componentsSeparatedByString:@"-"];
    self.titles.text = [array objectAtIndex:1];
    if (index > 2) {
        self.value.text = [NSString stringWithFormat:@"%@元/人", [array objectAtIndex:0]];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.value.text];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, self.value.text.length-3)]; // 0为起始位置 length是从起始位置开始 设置指定颜色的长度
        self.value.attributedText = attributedString;
    }else{
        self.value.text = [NSString stringWithFormat:@"%@", [array objectAtIndex:0]];
    }    
}

@end
