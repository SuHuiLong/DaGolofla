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
    self.backgroundColor = [UIColor whiteColor];
    self.applyforTime.font = [UIFont systemFontOfSize:12.0 * ProportionAdapter];
    self.dealwithTime.font = [UIFont systemFontOfSize:12.0 * ProportionAdapter];
    self.seccessful.font = [UIFont systemFontOfSize:12.0 * ProportionAdapter];
    
    self.withdrawful.font = [UIFont systemFontOfSize:17.0 * ProportionAdapter];
    self.balnkful.font = [UIFont systemFontOfSize:17.0 * ProportionAdapter];
    self.tradSuf.font = [UIFont systemFontOfSize:17.0 * ProportionAdapter];
    
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
    
//    if ([dealwithTime containsString:@"1970"]) {
//        self.dealwithTimeImageView.image = [UIImage imageNamed:@"dealWithFail"];
//    }else{
    if (seccessful.length > 0 && ![seccessful containsString:@"1970"]) {
        
        NSArray *arrayDealwith = [NSArray array];
        arrayDealwith = [seccessful componentsSeparatedByString:@" "];
        self.dealwithTime.text = [NSString stringWithFormat:@"%@\n%@", [arrayDealwith objectAtIndex:0], [arrayDealwith objectAtIndex:1]];
    }else{
        if (dealwithTime.length == 0) {
            self.dealwithTime.text = @"";
            self.dealwithTimeImageView.image = [UIImage imageNamed:@"dealWithFail"];
            self.balnkful.textColor = [UIColor lightGrayColor];
        }else{
            NSArray *arrayDealwith = [NSArray array];
            arrayDealwith = [dealwithTime componentsSeparatedByString:@" "];
            self.dealwithTime.text = [NSString stringWithFormat:@"%@\n%@", [arrayDealwith objectAtIndex:0], [arrayDealwith objectAtIndex:1]];
        }
    }
//    }
    
    if ([seccessful containsString:@"1970"] || seccessful.length == 0) {
        self.seccessfulImageView.image = [UIImage imageNamed:@"successfulFail"];
        self.tradSuf.textColor = [UIColor lightGrayColor];
    }else{
        NSArray *arraySeccessful = [NSArray array];
        arraySeccessful = [seccessful componentsSeparatedByString:@" "];
        self.seccessful.text = [NSString stringWithFormat:@"%@\n%@", [arraySeccessful objectAtIndex:0], [arraySeccessful objectAtIndex:1]];
    }
}

@end
