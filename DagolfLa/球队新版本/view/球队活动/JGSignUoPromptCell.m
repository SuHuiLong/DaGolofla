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
    self.backgroundColor = [UIColor colorWithHexString:BG_color];
}

- (void)configPromptPasswordString:(NSString *)string{
    self.pamaptLabel.text = string;
    self.pamaptLabel.textAlignment = NSTextAlignmentRight;
    self.backgroundColor = [UIColor colorWithHexString:BG_color];
}

- (void)configPromptSetPasswordString:(NSString *)string{
    self.pamaptLabel.text = string;
    self.pamaptLabel.textAlignment = NSTextAlignmentLeft;
    self.backgroundColor = [UIColor colorWithHexString:BG_color];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
