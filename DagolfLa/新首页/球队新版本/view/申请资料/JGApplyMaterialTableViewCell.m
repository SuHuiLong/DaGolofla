//
//  JGApplyMaterialTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/5/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGApplyMaterialTableViewCell.h"

@implementation JGApplyMaterialTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.labell = [[UILabel alloc] initWithFrame:CGRectMake(20 * screenWidth / 320, 15 * screenWidth / 320, 110 * screenWidth / 320, 15 * screenWidth / 320)];
        self.labell.font = [UIFont systemFontOfSize:15 * screenWidth / 320];
        [self addSubview:self.labell];
        
        self.textFD = [[UITextField alloc] initWithFrame:CGRectMake(110 * screenWidth / 320, 15 * screenWidth / 320, screenWidth - 130 * screenWidth / 320, 15 * screenWidth / 320)];
        self.textFD.font = [UIFont systemFontOfSize:15 * screenWidth / 320];
        [self addSubview:self.textFD];
        self.textFD.textAlignment = 2;
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
