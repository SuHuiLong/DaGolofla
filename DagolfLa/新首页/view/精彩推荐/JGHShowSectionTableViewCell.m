//
//  JGHShowSectionTableViewCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/25.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHShowSectionTableViewCell.h"

@implementation JGHShowSectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    
    self.bgLable.backgroundColor = [UIColor colorWithHexString:BG_color];
    self.bgLableLeft.constant = 10 *ProportionAdapter;
    self.bgLableH.constant = 20 *ProportionAdapter;

    self.name.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
    self.nameLeft.constant = 10 *ProportionAdapter;
    
    self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:11 *ProportionAdapter];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)congfigJGHShowSectionTableViewCell:(NSString *)name andHiden:(NSInteger)hide
{
    self.name.text = name;
    if (hide == 0) {
        self.moreBtn.hidden = YES;
        self.moreImageView.hidden = YES;
    }else{
        self.moreBtn.hidden = NO;
        self.moreImageView.hidden = NO;
    }
}

- (IBAction)moreBtn:(UIButton *)sender {
    sender.enabled = NO;
    if (self.delegate) {
        [self.delegate didSelectMoreBtn:sender];
    }
    
    sender.enabled = YES;
}
@end
