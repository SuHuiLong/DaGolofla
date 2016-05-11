//
//  JGMemDataTableViewCell.m
//  DagolfLa
//
//  Created by 黄达明 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGMemDataTableViewCell.h"

@implementation JGMemDataTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(30*screenWidth/375, 0, 50*screenWidth/375, 45*screenWidth/375)];
        _firstLabel.font = [UIFont systemFontOfSize:15*screenWidth/375];
        _firstLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:_firstLabel];
        
        
        _secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(90*screenWidth/375, 0, 100*screenWidth/375, 45*screenWidth/375)];
        _secondLabel.font = [UIFont systemFontOfSize:15*screenWidth/375];
        _secondLabel.textColor = [UIColor blackColor];
        [self addSubview:_secondLabel];
        
        
        _thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2, 0, 50*screenWidth/375, 45*screenWidth/375)];
        _thirdLabel.font = [UIFont systemFontOfSize:15*screenWidth/375];
        _thirdLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:_thirdLabel];
        
        
        _fourthLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2 + 50 *screenWidth/375, 0, screenWidth/2 - 60*screenWidth/375, 45*screenWidth/375)];
        _fourthLabel.font = [UIFont systemFontOfSize:15*screenWidth/375];
        _fourthLabel.textColor = [UIColor blackColor];
        [self addSubview:_fourthLabel];
        
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
