//
//  JGHEventRulesHeaderCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHEventRulesHeaderCell.h"

@implementation JGHEventRulesHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLable.font = [UIFont systemFontOfSize:18 *ProportionAdapter];
    self.saveAndDeleteBtn.titleLabel.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.saveAndDeleteBtnRight.constant = 15 *ProportionAdapter;
}

- (void)configJGHEventRulesHeaderCell:(NSInteger)roundId andSelect:(NSInteger)select{
    self.titleLable.text = [NSString stringWithFormat:@"第%ld轮", (long)roundId];
    if (select == 0) {
        //保存
        [self.saveAndDeleteBtn setTitle:@"保存" forState:UIControlStateNormal];
    }else{
        //删除
        [self.saveAndDeleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    }
}

- (IBAction)saveAndDeleteBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate didSelectSaveOrDeleteBtn:sender];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
