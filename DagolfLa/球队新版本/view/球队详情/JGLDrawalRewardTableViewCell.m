//
//  JGLDrawalRewardTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/7/7.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLDrawalRewardTableViewCell.h"

@implementation JGLDrawalRewardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _labelName = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/320, 10*screenWidth/320, 160*screenWidth/320, 20*screenWidth/320)];
        _labelName.font = [UIFont systemFontOfSize:15*screenWidth/320];
        [self addSubview:_labelName];
        
        _labelTime = [[UILabel alloc]initWithFrame:CGRectMake(170*screenWidth/320, 10*screenWidth/320, 140*screenWidth/320, 20*screenWidth/320)];
        _labelTime.font = [UIFont systemFontOfSize:13*screenWidth/320];
        _labelTime.textColor = [UIColor lightGrayColor];
        _labelTime.textAlignment = NSTextAlignmentRight;
        [self addSubview:_labelTime];
        
        
        _labelAccept = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/320, 30*screenWidth/320, 160*screenWidth/320, 20*screenWidth/320)];
        _labelAccept.font = [UIFont systemFontOfSize:15*screenWidth/320];
        _labelAccept.textColor = [UIColor lightGrayColor];
        [self addSubview:_labelAccept];
        
        _labelMoney = [[UILabel alloc]initWithFrame:CGRectMake(170*screenWidth/320, 30*screenWidth/320, 140*screenWidth/320, 20*screenWidth/320)];
        _labelMoney.font = [UIFont systemFontOfSize:13*screenWidth/320];
        _labelMoney.textColor = [UIColor redColor];
        _labelMoney.textAlignment = NSTextAlignmentRight;
        [self addSubview:_labelMoney];
        
        
        _labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(10*screenWidth/320, 50*screenWidth/320, screenWidth-20*screenWidth/320, 20*screenWidth/320)];
        [self addSubview:_labelDetail];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
