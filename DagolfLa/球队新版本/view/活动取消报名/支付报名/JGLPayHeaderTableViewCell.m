//
//  JGLPayHeaderTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/6/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLPayHeaderTableViewCell.h"

@implementation JGLPayHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconImgv = [[UIImageView alloc]initWithFrame:CGRectMake(10*screenWidth/320, 7*screenWidth/320, 61*screenWidth/320, 61*screenWidth/320)];
        [self addSubview:_iconImgv];
        _iconImgv.image = [UIImage imageNamed:@"tu1"];
        _iconImgv.layer.masksToBounds = YES;
        _iconImgv.layer.cornerRadius = 6*screenWidth/320;
        
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(80*screenWidth/320, 7*screenWidth/320, 120*screenWidth/320, 20*screenWidth/320)];
        _titleLabel.text = @"上海球队活动";
        _titleLabel.font = [UIFont systemFontOfSize:14*screenWidth/320];
        [self addSubview:_titleLabel];
        
        
        _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 80*screenWidth/320, 7*screenWidth/320, 70*screenWidth/320, 20*screenWidth/320)];
        _stateLabel.text = @"正在报名";
        _stateLabel.textAlignment = NSTextAlignmentRight;
        _stateLabel.font = [UIFont systemFontOfSize:13*screenWidth/320];
        [self addSubview:_stateLabel];
        
        _timeImag = [[UIImageView alloc]initWithFrame:CGRectMake(80*screenWidth/320, 30*screenWidth/320, 15*screenWidth/320, 15*screenWidth/320)];
        [self addSubview:_timeImag];
        _timeImag.image = [UIImage imageNamed:@"yueqiu_time"];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(100*screenWidth/320, 28*screenWidth/320, 80*screenWidth/320, 20*screenWidth/320)];
        [self addSubview:_timeLabel];
        _timeLabel.text = @"6月1日";
        _timeLabel.font = [UIFont systemFontOfSize:13*screenWidth/320];
        
        
        _peopleLabel = [[UILabel alloc]initWithFrame:CGRectMake(180*screenWidth/320, 28*screenWidth/320, 130*screenWidth/320, 20*screenWidth/320)];
        _peopleLabel.text = @"已报名人数(5/30人)";
        _peopleLabel.textAlignment = NSTextAlignmentRight;
        _peopleLabel.font = [UIFont systemFontOfSize:13*screenWidth/320];
        [self addSubview:_peopleLabel];
        
        _addressImag = [[UIImageView alloc]initWithFrame:CGRectMake(81*screenWidth/320, 50*screenWidth/320, 12*screenWidth/320, 15*screenWidth/320)];
        [self addSubview:_addressImag];
        _addressImag.image = [UIImage imageNamed:@"juli"];

        _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(100*screenWidth/320, 48*screenWidth/320, screenWidth - 110*screenWidth/320, 20*screenWidth/320)];
        _addressLabel.text = @"上海佘山高尔夫俱乐部";
        _addressLabel.font = [UIFont systemFontOfSize:13*screenWidth/320];
        [self addSubview:_addressLabel];
        
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
