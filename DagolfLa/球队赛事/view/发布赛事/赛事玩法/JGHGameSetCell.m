//
//  JGHGameSetCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/8.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHGameSetCell.h"

@implementation JGHGameSetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.gameSet.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
    self.gameSetLeft.constant = 25 *ProportionAdapter;
    
    self.imageW.constant = 35 *ProportionAdapter;
    
    self.downImageViewRight.constant = 15 *ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)gameSetCellBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate didSelectJGHGameSetCellBtn:sender];
    }
}

- (void)configJGHGameSetCellTitleString:(NSString *)titleString andSelect:(NSInteger)select{
    self.gameSet.text = titleString;
    
    if (select == 0) {
        self.statusImageView.image = [UIImage imageNamed:@"gameSetNoSelect"];
    }else{
        self.statusImageView.image = [UIImage imageNamed:@"gameSetSelect"];
    }
}


@end
