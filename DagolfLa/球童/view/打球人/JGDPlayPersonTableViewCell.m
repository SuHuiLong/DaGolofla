//
//  JGDPlayPersonTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/8/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDPlayPersonTableViewCell.h"

@implementation JGDPlayPersonTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLB = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 0, screenWidth - 20 * ProportionAdapter, 50 * ProportionAdapter)];
        self.textLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        [self.contentView addSubview:self.textLB];
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
