//
//  JGDActvityPriziSetTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/7/5.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDActvityPriziSetTableViewCell.h"

@interface JGDActvityPriziSetTableViewCell ()


@end



@implementation JGDActvityPriziSetTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        UIImageView *iconImageV = [Factory createImageViewWithFrame:CGRectMake(kWvertical(10), kHvertical(14), kWvertical(22), kHvertical(22)) Image:[UIImage imageNamed:@"add_awards"]];
        [self.contentView addSubview:iconImageV];
        
        UILabel *actvivityTiltleLB = [Helper lableRect:CGRectMake(kWvertical(42), 0, 70 * ProportionAdapter, kHvertical(50)) labelColor:[UIColor colorWithHexString:@"#313131"] labelFont:kHorizontal(17) text:@"活动奖项" textAlignment:(NSTextAlignmentLeft)];
        [self.contentView addSubview:actvivityTiltleLB];

        
        self.titleLB = [Helper lableRect:CGRectMake(kWvertical(112), 0, 100 * ProportionAdapter, kHvertical(50)) labelColor:[UIColor colorWithHexString:@"#A0A0A0"] labelFont:kHorizontal(15) text:@"" textAlignment:(NSTextAlignmentLeft)];
        [self.contentView addSubview:self.titleLB];



        self.presentationBtn = [Helper lableRect:CGRectMake(kWvertical(285), 0, 70 * ProportionAdapter, kHvertical(50)) labelColor:[UIColor colorWithHexString:@"#F39800"] labelFont:kHorizontal(16) text:@"奖项设置" textAlignment:(NSTextAlignmentLeft)];
        [self.contentView addSubview:self.presentationBtn];
        
        self.chooseImageV = [Factory createImageViewWithFrame:CGRectMake(kWvertical(356), kHvertical(19), kWvertical(8), kHvertical(13)) Image:[UIImage imageNamed:@")"]];
        
        
        [self.contentView addSubview:self.chooseImageV];

    }
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
