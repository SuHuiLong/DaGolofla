//
//  JGImageAndLabelAndLabelTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/5/28.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGImageAndLabelAndLabelTableViewCell.h"

@implementation JGImageAndLabelAndLabelTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10 * screenWidth / 320, 11 * screenWidth / 320, 18 * screenWidth / 320, 18 * screenWidth / 320)];
        self.imageV.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.imageV];
        
        self.promptLB = [[UILabel alloc] initWithFrame:CGRectMake(40 * screenWidth / 320, 5 * screenWidth / 320, 100 * screenWidth / 320, 30 * screenWidth / 320)];
        
        self.promptLB.font = [UIFont systemFontOfSize:15 * screenWidth / 320];
        [self.contentView addSubview:self.promptLB];
        
        self.contentLB = [[UILabel alloc] initWithFrame:CGRectMake(120  * screenWidth / 320, 5 * screenWidth / 320, screenWidth - 130  * screenWidth / 320, 30 * screenWidth / 320)];
        self.contentLB.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.contentLB];
        
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
