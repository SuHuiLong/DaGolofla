//
//  JGHPublicLevelCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/17.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHPublicLevelCell.h"

@implementation JGHPublicLevelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLable.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.titleLableLeft.constant = 40 *ProportionAdapter;
    self.titleLableLeftRight.constant = 10 *ProportionAdapter;
    
    self.gouImageViewW.constant = 15 *ProportionAdapter;
}

- (void)configJGHPublicLevelCell:(NSString *)titleString andSelect:(NSInteger)select{
    self.titleLable.text = titleString;
    if (select == 0) {
        self.gouImageView.image = [UIImage imageNamed:@"gou_w"];
    }else{
        self.gouImageView.image = [UIImage imageNamed:@"gou_x"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
