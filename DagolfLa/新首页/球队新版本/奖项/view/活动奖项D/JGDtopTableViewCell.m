//
//  JGDtopTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDtopTableViewCell.h"

@implementation JGDtopTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(8 * ProportionAdapter, 8 * ProportionAdapter, 64 * ProportionAdapter, 64 * ProportionAdapter)];
    self.iconImage.image = [UIImage imageNamed:@"jiangbei"];
    self.iconImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.iconImage];
    
    self.activityLB = [[UILabel alloc] initWithFrame:CGRectMake(80 * ProportionAdapter, 8 * ProportionAdapter, 290 * ProportionAdapter, 20 * ProportionAdapter)];
    self.activityLB.text = @"寂寞的人总是会用心地记住在他生命中出现过的每一个人";
    self.activityLB.font = [UIFont systemFontOfSize:18 * ProportionAdapter];
    [self.contentView addSubview:self.activityLB];
    
    self.timeImage = [[UIImageView alloc] initWithFrame:CGRectMake(84 * ProportionAdapter, 34 * ProportionAdapter, 13 * ProportionAdapter, 14 * ProportionAdapter)];
    self.timeImage.image = [UIImage imageNamed:@"time"];
    self.timeImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.timeImage];
    
    self.adressImage = [[UIImageView alloc] initWithFrame:CGRectMake(84 * ProportionAdapter, 52 * ProportionAdapter, 11 * ProportionAdapter, 16 * ProportionAdapter)];
    self.adressImage.image = [UIImage imageNamed:@"address"];
    self.adressImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.adressImage];
    
    self.timeLB = [[UILabel alloc] initWithFrame:CGRectMake(108 * ProportionAdapter, 30 * ProportionAdapter, 200 * ProportionAdapter, 18 * ProportionAdapter)];
    self.timeLB.text = @"一遍一遍，数我的寂寞。";
    self.timeLB.textColor = [UIColor colorWithHexString:@"#626262"];
    self.timeLB.font = [UIFont systemFontOfSize:10 * ProportionAdapter];
    [self.contentView addSubview:self.timeLB];
    
    self.adressLB = [[UILabel alloc] initWithFrame:CGRectMake(108 * ProportionAdapter, 50 * ProportionAdapter, 200 * ProportionAdapter, 18 * ProportionAdapter)];
    self.adressLB.text = @"在每个星光坠落的晚上";
    self.adressLB.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
    self.adressLB.textColor = [UIColor colorWithHexString:@"#313131"];
    [self.contentView addSubview:self.adressLB];
    
    return self;
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
