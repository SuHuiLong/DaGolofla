//
//  JGHAwardCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/7/4.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHAwardCell.h"
#import "JGHAwardModel.h"

@implementation JGHAwardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.jiangbeiLeft.constant = 10*ProportionAdapter;
    self.jiangbeiTop.constant = 20*ProportionAdapter;
    
    self.name.font = [UIFont systemFontOfSize:20 *ProportionAdapter];
    self.nameLeft.constant = 20*ProportionAdapter;
    
    
    self.deleBtnRight.constant = 30*ProportionAdapter;

    self.editorBtnRight.constant = 20*ProportionAdapter;
    
    self.bluequanTop.constant = 20*ProportionAdapter;
    self.bluequanLeft.constant = 10*ProportionAdapter;
    
    self.award.font = [UIFont systemFontOfSize:17.0 *ProportionAdapter];
    self.awardLeft.constant = 5*ProportionAdapter;
    
    
    self.awardNumberLeft.constant = 10*ProportionAdapter;
    self.awardNumberRight.constant = 5*ProportionAdapter;
    self.awardNumber.font = [UIFont systemFontOfSize:17.0 *ProportionAdapter];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectAwardDeleBtn:sender];
    }
}
- (IBAction)editorBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate selectAwardEditorBtn:sender];
    }
}

- (void)configJGHAwardModel:(JGHAwardModel *)model{
    
}

@end
