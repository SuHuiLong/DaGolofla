//
//  JGActivityMemNonmangerTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/6/23.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGActivityMemNonmangerTableViewCell.h"

@implementation JGActivityMemNonmangerTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.headIconV = [[UIImageView alloc] initWithFrame:CGRectMake(10 * screenWidth / 375, 5 * screenWidth / 375, 40 * screenWidth / 375, 40 * screenWidth / 375)];
        self.headIconV.layer.cornerRadius = 20 * screenWidth / 375;
        self.headIconV.clipsToBounds = YES;
        [self.contentView addSubview:self.headIconV];
        
        self.nameLB = [[UILabel alloc] initWithFrame:CGRectMake(60 * screenWidth / 375, 0, 80 * screenWidth / 375, 50 * screenWidth / 375)];
        self.nameLB.font = [UIFont systemFontOfSize:16 * screenWidth / 375];
        [self.contentView addSubview:self.nameLB];
        
        self.phoneLB = [[UILabel alloc] initWithFrame:CGRectMake(150 * screenWidth / 375, 0, 120 * screenWidth / 375, 50 * screenWidth / 375l)];
        self.phoneLB.font = [UIFont systemFontOfSize:16 * screenWidth / 375];
        [self.contentView addSubview:self.phoneLB];
        
        self.signLB = [[UILabel alloc] initWithFrame:CGRectMake(280 * ProportionAdapter, 0, 70, 50 * ProportionAdapter)];
        self.signLB.font = [UIFont systemFontOfSize:16 * screenWidth / 375];
        [self.contentView addSubview:self.signLB];
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
