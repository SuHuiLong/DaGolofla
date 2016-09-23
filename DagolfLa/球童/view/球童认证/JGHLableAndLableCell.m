//
//  JGHLableAndLableCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/8/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHLableAndLableCell.h"

@implementation JGHLableAndLableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.titleLable.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    self.titleLableLeft.constant = 20 *ProportionAdapter;
    self.titleLableW.constant = 70 *ProportionAdapter;
    
    self.valueLable.font = [UIFont systemFontOfSize:15*ProportionAdapter];
    self.valueLableLeft.constant = 40 *ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configBallName:(NSString *)ballName{
    self.titleLable.text = @"所属球场";
    if ([ballName isEqualToString:@"1"]) {
        self.valueLable.text = @"请选择球场（必填）";
        self.valueLable.textColor = [UIColor lightGrayColor];
    }else{
        self.valueLable.text = ballName;
        self.valueLable.textColor = [UIColor blackColor];
    }
}

@end
