//
//  JGTeamChannelActivityTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamChannelActivityTableViewCell.h"

@implementation JGTeamChannelActivityTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, screenWidth, 20)];
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.nameLabel];
        
        self.adressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, screenWidth, 20)];
        self.adressLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.adressLabel];
        
        self.describLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, screenWidth, 20)];
        self.describLabel.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:self.describLabel];
        
        UIView *lightGrayView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, screenWidth, 3)];
        lightGrayView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
        [self.contentView addSubview:lightGrayView];
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
