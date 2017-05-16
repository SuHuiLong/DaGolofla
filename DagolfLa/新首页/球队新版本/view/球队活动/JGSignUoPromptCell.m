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
    
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
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

- (void)configAllPromptString:(NSString *)str andLeftCon:(NSInteger)leftCon andRightCon:(NSInteger)rightCon{
    self.pamapLabelLeft.constant = leftCon * ProportionAdapter;
    self.pamapLabelRight.constant = rightCon * ProportionAdapter;
    
    self.pamaptLabel.text = str;
    self.pamaptLabel.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
    self.pamaptLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    self.backgroundColor = [UIColor colorWithHexString:BG_color];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
