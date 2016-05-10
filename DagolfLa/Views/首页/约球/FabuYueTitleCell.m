//
//  FabuYueTitleCell.m
//  DagolfLa
//
//  Created by bhxx on 15/10/22.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "FabuYueTitleCell.h"

@implementation FabuYueTitleCell

- (void)awakeFromNib {
    // Initialization code
    _jtImage.transform = CGAffineTransformMakeRotation(M_PI_2);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
