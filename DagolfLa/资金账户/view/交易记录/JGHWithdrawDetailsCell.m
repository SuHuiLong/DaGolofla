//
//  JGHWithdrawDetailsCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/6/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHWithdrawDetailsCell.h"

@implementation JGHWithdrawDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.lineTop.constant = 40*ProportionAdapter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configApplyforTime:(NSString *)applyforTime andDealwithTime:(NSString *)dealwithTime andSeccessful:(NSString *)seccessful{
    
    if (applyforTime.length > 0) {
        NSArray *arrayApply = [NSArray array];
        arrayApply = [applyforTime componentsSeparatedByString:@" "];
        self.applyforTime.text = [NSString stringWithFormat:@"%@\n%@", [arrayApply objectAtIndex:0], [arrayApply objectAtIndex:1]];
    }
    
    if (dealwithTime.length > 0) {
        NSArray *arrayDealwith = [NSArray array];
        arrayDealwith = [dealwithTime componentsSeparatedByString:@" "];
        self.dealwithTime.text = [NSString stringWithFormat:@"%@\n%@", [arrayDealwith objectAtIndex:0], [arrayDealwith objectAtIndex:1]];
    }
    
    if (seccessful.length > 0) {
        NSArray *arraySeccessful = [NSArray array];
        arraySeccessful = [seccessful componentsSeparatedByString:@" "];
        self.seccessful.text = [NSString stringWithFormat:@"%@\n%@", [arraySeccessful objectAtIndex:0], [arraySeccessful objectAtIndex:1]];
    }
}

@end
