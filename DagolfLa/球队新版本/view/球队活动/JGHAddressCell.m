//
//  JGHAddressCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/26.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHAddressCell.h"

@implementation JGHAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)selectBtn:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate didSelectBtn:sender];
    }
}


@end
