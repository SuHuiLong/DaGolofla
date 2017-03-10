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

    self.name.font = [UIFont systemFontOfSize:18 *ProportionAdapter];
    self.nameLeft.constant = 10 *ProportionAdapter;
    
    self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:14 *ProportionAdapter];
    
    self.moreClickW.constant = 60*ProportionAdapter;
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
        self.moreClick.hidden = YES;
        self.moreImageView.hidden = YES;
    }else{
        self.moreBtn.hidden = NO;
        self.moreClick.hidden = NO;
        self.moreImageView.hidden = NO;
    }
}

- (IBAction)moreBtn:(UIButton *)sender {
    /*
    sender.enabled = NO;
    
    if (self.delegate) {
        [self.delegate didSelectMoreBtn:sender];
    }
    
    sender.enabled = YES;
     */
}

- (IBAction)moreClick:(UIButton *)sender {
    sender.enabled = NO;
    
    if (self.delegate) {
        [self.delegate didSelectMoreBtn:sender];
    }
    
    sender.enabled = YES;
    
}
@end
