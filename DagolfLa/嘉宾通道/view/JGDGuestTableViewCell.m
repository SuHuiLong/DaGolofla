//
//  JGDGuestTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/8/24.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDGuestTableViewCell.h"

@interface JGDGuestTableViewCell ()


@end

@implementation JGDGuestTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.titleLB = [[UILabel alloc] initWithFrame:CGRectMake(30 * ProportionAdapter, 0, 183 * ProportionAdapter, 50 * ProportionAdapter)];
        self.titleLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        self.priceLB = [[UILabel alloc] initWithFrame:CGRectMake(210 * ProportionAdapter, 0, 100 * ProportionAdapter, 50 * ProportionAdapter)];
        self.priceLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        self.selectView = [[UIImageView alloc] initWithFrame:CGRectMake(330 * ProportionAdapter, 15 *ProportionAdapter, 20 * ProportionAdapter, 20 * ProportionAdapter)];
        [self.contentView addSubview:self.titleLB];
        [self.contentView addSubview:self.priceLB];
        [self.contentView addSubview:self.selectView];
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
