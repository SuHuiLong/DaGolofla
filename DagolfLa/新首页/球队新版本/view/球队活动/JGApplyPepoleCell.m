//
//  JGApplyPepoleCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGApplyPepoleCell.h"

@implementation JGApplyPepoleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark -- 添加嘉宾
- (IBAction)addApplyBtnClick:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate addApplyPeopleClick];
    }
}

- (void)configCancelApplyTitles:(NSString *)string{
    self.addApplyBtn.hidden = YES;
    self.directionImageView.hidden = YES;
    
    self.titles.text = string;
}

@end
