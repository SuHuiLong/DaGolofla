//
//  JGTeamActivityWithAddressCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamActivityWithAddressCell.h"
#import "JGTeamAcitivtyModel.h"

@implementation JGTeamActivityWithAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configModel:(JGTeamAcitivtyModel *)model{
    //开始
//    self.reamName.text = model.beginDate;
    if (model.beginDate) {
//        [[model.beginDate componentsSeparatedByString:@" "] objectAtIndex:0];
        NSString *timeString =[[model.beginDate componentsSeparatedByString:@" "] objectAtIndex:1];
        NSString *string;
        NSArray *array = [timeString componentsSeparatedByString:@":"];
        for (int i=0; i< 2; i++) {
            if (i == 0) {
                string = [NSString stringWithFormat:@"%@时", array[i]];
            }else {
                string = [string stringByAppendingString:[NSString stringWithFormat:@"%@分", array[i]]];
            }
        }
        
        self.reamName.text = [NSString stringWithFormat:@"%@%@", [Helper returnDateformatString:[[model.beginDate componentsSeparatedByString:@" "] objectAtIndex:0]], string];
    }
    
    //截止
    self.activityTime.text = [Helper returnDateformatString:model.signUpEndTime];
    //地址
    self.limits.text = model.ballAddress;
}

@end
