//
//  JGButtonTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/5/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGButtonTableViewCell.h"

@implementation JGButtonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.labell = [[UILabel alloc] initWithFrame:CGRectMake(10 * screenWidth / 320, 0, 110 * screenWidth / 320, self.frame.size.height)];
        [self addSubview:self.labell];
        
        self.button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        [self.button setFrame:CGRectMake(screenWidth - 110 * screenWidth / 320, 0, 110 * screenWidth / 320, self.frame.size.height)];
        [self.button setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
        [self.button setTitle:@"请选择" forState:(UIControlStateNormal)];
        [self addSubview:self.button];
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
