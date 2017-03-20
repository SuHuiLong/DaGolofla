//
//  JGDCreatTeamTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 17/3/14.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import "JGDCreatTeamTableViewCell.h"

@implementation JGDCreatTeamTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14 * ProportionAdapter, 12 * ProportionAdapter, 22 * ProportionAdapter, 22 * ProportionAdapter)];
        [self.contentView addSubview:self.iconImageView];
        
        self.titleLB = [Helper lableRect:CGRectMake(44 * ProportionAdapter, 0, 100 * ProportionAdapter, 45 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#000000"] labelFont:15 * ProportionAdapter text:@"" textAlignment:(NSTextAlignmentLeft)];
        [self.contentView addSubview:self.titleLB];
        
        self.detailLB = [Helper lableRect:CGRectMake(150 * ProportionAdapter, 0, 190 * ProportionAdapter, 45 * ProportionAdapter) labelColor:[UIColor colorWithHexString:@"#a0a0a0"] labelFont:15 * ProportionAdapter text:@"" textAlignment:(NSTextAlignmentRight)];
        [self.contentView addSubview:self.detailLB];
        
        //
        self.teamNameTF = [[UITextField alloc] initWithFrame:CGRectMake(150 * ProportionAdapter, 0, 190 * ProportionAdapter, 45 * ProportionAdapter)];
        self.teamNameTF.textAlignment = NSTextAlignmentRight;
        self.teamNameTF.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        self.teamNameTF.placeholder = @"请输入";
        [self.contentView addSubview:self.teamNameTF];
        
        UILabel *lineLB = [Helper lableRect:CGRectMake(0, 44.5 * ProportionAdapter, screenWidth, 0.5 * ProportionAdapter) labelColor:[UIColor whiteColor] labelFont:1 text:@"" textAlignment:(NSTextAlignmentCenter)];
        lineLB.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [self.contentView addSubview:lineLB];

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
