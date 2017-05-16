//
//  JGLableAndLableTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/5/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGLableAndLableTableViewCell.h"

@implementation JGLableAndLableTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
 
        
        self.promptLB = [[UILabel alloc] initWithFrame:CGRectMake(20 * screenWidth / 320, 15 * screenWidth / 320, 100 * screenWidth / 320, 15 * screenWidth / 320)];
        self.promptLB.font = [UIFont systemFontOfSize:15 * screenWidth / 320];
        [self.contentView addSubview:self.promptLB];
        
        self.contentLB = [[UILabel alloc] initWithFrame:CGRectMake(120  * screenWidth / 320, 15 * screenWidth / 320, screenWidth - 130  * screenWidth / 320, 15 * screenWidth / 320)];
        self.contentLB.font = [UIFont systemFontOfSize:15 * screenWidth / 320];
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
