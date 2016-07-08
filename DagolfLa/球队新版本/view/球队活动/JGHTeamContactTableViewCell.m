//
//  JGHTeamContactTableViewCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHTeamContactTableViewCell.h"

//@interface JGHTeamContactTableViewCell ()<UITextViewDelegate>
//
//@end

@implementation JGHTeamContactTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//
//- (void)textViewDidEndEditing:(UITextView *)textView{
//    
//    if (self.delegate) {
//        [self.delegate inputTextString:textView.text];
//    }
//}
//
//- (void)textViewDidBeginEditing:(UITextView *)textView{
//    NSLog(@"qqqq");
//}

- (void)configConstraint{
    self.contactLabelLeft.constant = 10.0;
}

@end
