//
//  JGDSortTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/10/10.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDSortTableViewCell.h"

@interface JGDSortTableViewCell ()

@property (nonatomic ,strong) UIImageView *iconImageV;
@property (nonatomic, strong) UILabel *ballNameLB;
@property (nonatomic, strong) UILabel *scoreLB;

@end

@implementation JGDSortTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.numberLB = [[UILabel alloc] initWithFrame:CGRectMake(13 * ProportionAdapter, 15 * ProportionAdapter, 14 * ProportionAdapter, 14 * ProportionAdapter)];
        self.numberLB.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
        [self.contentView addSubview:self.numberLB];
        
        self.iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(40 * ProportionAdapter, 8 * ProportionAdapter, 30 * ProportionAdapter, 30 * ProportionAdapter)];
        self.iconImageV.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:self.iconImageV];
        
        self.ballNameLB = [[UILabel alloc] initWithFrame:CGRectMake(80 * ProportionAdapter, 10 * ProportionAdapter, 200 * ProportionAdapter, 30 * ProportionAdapter)];
        self.ballNameLB.text = @"上海球队哈哈哈哈哈哈哈哈哈哈";
        self.ballNameLB.textColor = [UIColor colorWithHexString:@"#313131"];
        self.ballNameLB.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
        [self.contentView addSubview:self.ballNameLB];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
