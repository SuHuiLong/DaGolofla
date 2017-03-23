//
//  JGHNewActivityCell.m
//  DagolfLa
//
//  Created by 黄安 on 17/1/6.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGHNewActivityCell.h"
#import "JGTeamAcitivtyModel.h"

@implementation JGHNewActivityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _oneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 11 *ProportionAdapter, 22 *ProportionAdapter, 22 *ProportionAdapter)];
        _oneImageView.image = [UIImage imageNamed:@"icn_time"];
        [self addSubview:_oneImageView];
        
        _teeTime = [[UILabel alloc]initWithFrame:CGRectMake(40 *ProportionAdapter, 10 *ProportionAdapter, screenWidth - 50*ProportionAdapter, 24 *ProportionAdapter)];
        _teeTime.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        [self addSubview:_teeTime];
        
        _oneline = [[UILabel alloc]initWithFrame:CGRectMake(0, 44 *ProportionAdapter -0.5, screenWidth, 0.5)];
        _oneline.backgroundColor = [UIColor colorWithHexString:BG_color];
        [self addSubview:_oneline];
        
        
        _twoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 55 *ProportionAdapter, 22 *ProportionAdapter, 22 *ProportionAdapter)];
        _twoImageView.image = [UIImage imageNamed:@"icn_registration"];
        [self addSubview:_twoImageView];
        
        _registration = [[UILabel alloc]initWithFrame:CGRectMake(40 *ProportionAdapter, 54 *ProportionAdapter, screenWidth - 50*ProportionAdapter, 24 *ProportionAdapter)];
        _registration.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        [self addSubview:_registration];
        
        _twoline = [[UILabel alloc]initWithFrame:CGRectMake(0, 88 *ProportionAdapter -0.5, screenWidth, 0.5)];
        _twoline.backgroundColor = [UIColor colorWithHexString:BG_color];
        [self addSubview:_twoline];
        
        
        _threeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 *ProportionAdapter, 99 *ProportionAdapter, 22 *ProportionAdapter, 22 *ProportionAdapter)];
        _threeImageView.image = [UIImage imageNamed:@"icn_address"];
        [self addSubview:_threeImageView];
        
        _address = [[UILabel alloc]initWithFrame:CGRectMake(40 *ProportionAdapter, _twoline.y_height, screenWidth - 50*ProportionAdapter, kHvertical(43))];
        _address.font = [UIFont systemFontOfSize:15 *ProportionAdapter];
        [self addSubview:_address];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)configJGTeamAcitivtyModel:(JGTeamAcitivtyModel *)model{
    
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
        
        _teeTime.text = [NSString stringWithFormat:@"开球时间：%@%@", [Helper returnDateformatString:[[model.beginDate componentsSeparatedByString:@" "] objectAtIndex:0]], string];
    }
    
    if (model.signUpEndTime) {
        //截止
        _registration.text = [NSString stringWithFormat:@"报名截止：%@",  [Helper returnDateformatString:model.signUpEndTime]];
    }
    
    if (model.ballAddress) {
        _address.text = [NSString stringWithFormat:@"活动地址：%@", model.ballAddress];
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
