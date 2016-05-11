//
//  JGTeamChannelTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamChannelTableViewCell.h"

@implementation JGTeamChannelTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 40)];
        self.iconImageV.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:self.iconImageV];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, screenWidth - 45, 20)];
        self.nameLabel.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:self.nameLabel];
        self.adressLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 30, screenWidth - 45, 10)];
        self.adressLabel.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:self.adressLabel];
        self.describLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 45, screenWidth - 45, 10)];
        self.describLabel.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:self.describLabel];
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
