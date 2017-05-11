//
//  MyAttentionViewCell.m
//  DaGolfla
//
//  Created by bhxx on 15/8/31.
//  Copyright (c) 2015年 bhxx. All rights reserved.
//

#import "MyAttentionViewCell.h"
@implementation MyAttentionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showData:(MyattenModel *)model
{
    [_iconImage sd_setImageWithURL:[Helper imageIconUrl:model.pic] placeholderImage:[UIImage imageNamed:DefaultHeaderImage]];
    if ([model.sex intValue] == 0) {
        _sexImage.image = [UIImage imageNamed:@"xb_n"];
    }
    else
    {
        _sexImage.image = [UIImage imageNamed:@"xb_nn"];
    }
    _nameLabel.text = model.userName;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];

    NSDate *destDate= [dateFormatter dateFromString:model.birthday];
    NSInteger age = [self ageWithDateOfBirth:destDate];
    _ageLabel.text = [NSString stringWithFormat:@"%ld",(long)age];
    
    _chadianLabel.text = [NSString stringWithFormat:@"%@",model.almost];
    _addressLabel.text = model.address;
    
}

- (NSInteger)ageWithDateOfBirth:(NSDate *)date;
{
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    
    return iAge;
}

@end
