//
//  JGHTeamActivityImageCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/13.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHTeamActivityImageCell.h"
#import "JGHLaunchActivityModel.h"

@interface JGHTeamActivityImageCell ()<UITextViewDelegate>

@end

@implementation JGHTeamActivityImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
        
}
#pragma mark -- UITextViewDelegate代理
- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.placeholdertext.hidden = YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([self.teamNameText.text isEqualToString:@""]) {
        self.placeholdertext.hidden = NO;
    }else{
        self.placeholdertext.hidden = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
