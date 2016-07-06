//
//  JGDprizeTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/7/4.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDprizeTableViewCell.h"


@implementation JGDprizeTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(12 * ProportionAdapter, 12 * ProportionAdapter, 24 * ProportionAdapter, 24 * ProportionAdapter)];
        self.imageV.image = [UIImage imageNamed:@"jiangbei"];
        [self.contentView addSubview:self.imageV];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(48 * ProportionAdapter, 0, 100 * ProportionAdapter, 44 * ProportionAdapter)];
        self.nameLabel.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        [self.contentView addSubview:self.nameLabel];
        
        self.prizeLbel = [[UILabel alloc] initWithFrame:CGRectMake(170 * ProportionAdapter, 0, 150 * ProportionAdapter, 44 * ProportionAdapter)];
        self.prizeLbel.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        self.prizeLbel.textColor = [UIColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:self.prizeLbel];
        
        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(335 * ProportionAdapter, 0, 30 * ProportionAdapter, 44 * ProportionAdapter)];
        self.numberLabel.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        self.numberLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:self.numberLabel];
        
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
