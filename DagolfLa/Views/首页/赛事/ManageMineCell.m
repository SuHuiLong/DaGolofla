//
//  ManageMineCell.m
//  DaGolfla
//
//  Created by bhxx on 15/9/1.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "ManageMineCell.h"

@implementation ManageMineCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)showData:(GameModel *)model
{
    _titleLabel.text = model.eventTite;
    _addLabel.text = [NSString stringWithFormat:@"地址:%@",model.eventBallName];
    if ([model.eventIsPrivate integerValue] == 1) {
        _timeLabel.text = [NSString stringWithFormat:@"%@  %@",model.eventdate,model.eventTime];
    }
    else
    {
        _timeLabel.text = [NSString stringWithFormat:@"观赛码:%@    参赛码:%@",model.eventWatchNums,model.eventCompetitionNums];
    }
    
    _numberLabel.text = [NSString stringWithFormat:@"%@人参赛",model.eventNums];
    if ([model.eventisEndStart integerValue] == 2) {
        _stateLabel.text = @"即将开始";
        _stateLabel.backgroundColor = [UIColor colorWithRed:0.32f green:0.67f blue:0.12f alpha:1.00f];
    }
    else if ([model.eventisEndStart integerValue] == 1)
    {
        _stateLabel.text = @"正在进行";
        _stateLabel.backgroundColor = [UIColor orangeColor];
    }
    else
    {
        _stateLabel.text = @"已经结束";
        _stateLabel.backgroundColor = [UIColor redColor];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
