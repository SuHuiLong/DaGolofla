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
    
    
    
}

- (void)configPromptString:(NSString *)string{
    self.pamaptLabel.text = string;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
