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
@property (nonatomic, strong) UILabel *sumPole;

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
        self.numberLB.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.numberLB];
        
        self.iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(40 * ProportionAdapter, 8 * ProportionAdapter, 30 * ProportionAdapter, 30 * ProportionAdapter)];
        self.iconImageV.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:self.iconImageV];
        
        self.ballNameLB = [[UILabel alloc] initWithFrame:CGRectMake(80 * ProportionAdapter, 10 * ProportionAdapter, 170 * ProportionAdapter, 30 * ProportionAdapter)];
        self.ballNameLB.text = @"上海哈哈哈哈哈哈球队";
        self.ballNameLB.textColor = [UIColor colorWithHexString:@"#313131"];
        self.ballNameLB.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
        [self.contentView addSubview:self.ballNameLB];
        
        self.sumPole = [[UILabel alloc] initWithFrame:CGRectMake(250 * ProportionAdapter, 10 * ProportionAdapter, 20 * ProportionAdapter, 30 * ProportionAdapter)];
        self.sumPole.text = @"--";
        self.sumPole.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
        [self.contentView addSubview:self.sumPole];
        
        self.scoreLB = [[UILabel alloc] initWithFrame:CGRectMake(300 * ProportionAdapter, 10 * ProportionAdapter, 50 * ProportionAdapter, 30 * ProportionAdapter)];
        self.scoreLB.text = @"+188";
        self.scoreLB.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
        [self.contentView addSubview:self.scoreLB];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
