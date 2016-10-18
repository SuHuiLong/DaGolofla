//
//  JGHGameBaseHeaderSubCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/14.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHGameBaseHeaderSubCell.h"

@implementation JGHGameBaseHeaderSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.name.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
    self.nameLeft.constant = 40 *ProportionAdapter;
    
    self.slectImageViewRight.constant = 25 *ProportionAdapter;
    
    self.slectImageViewW.constant = 10 *ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configJGHGameBaseHeaderSubCell:(NSString *)rulesName andSelect:(NSInteger)select{
    
    if ([rulesName containsString:@"regular"]) {
        //top
        self.name.text = [[rulesName componentsSeparatedByString:@"<"] objectAtIndex:0];
    }else{
        self.name.text = rulesName;
    }
    
    if (select == 0) {
        self.slectImageView.image = nil;
    }else{
        self.slectImageView.image = [UIImage imageNamed:@"duihao"];
    }
}

@end
