//
//  JGSignUoPromptCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGSignUoPromptCell.h"

@implementation JGSignUoPromptCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    self.pamaptLabel.text = @"提示：未勾选系统默认为现场支付\n           仅当前报名人[在线支付]享受平台补贴";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
