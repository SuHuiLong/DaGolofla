//
//  JGDServiceTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/12/16.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDServiceTableViewCell.h"

@interface JGDServiceTableViewCell()

@end


@implementation JGDServiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.iconV = [[UIImageView alloc] initWithFrame:CGRectMake(15 * ProportionAdapter, 30 * ProportionAdapter, 20 * ProportionAdapter, 20 * ProportionAdapter)];
        [self.contentView addSubview:self.iconV];
        
        
        
        self.detailLB = [[UILabel alloc] initWithFrame:CGRectMake(40 * ProportionAdapter, 30 * ProportionAdapter, 250 * ProportionAdapter, 20 * ProportionAdapter)];
        self.detailLB.font = [UIFont systemFontOfSize:14 * ProportionAdapter];
        self.detailLB.textColor = [UIColor colorWithHexString:@"#313131"];
        [self.contentView addSubview:self.detailLB];
        
        
        self.contactBtn = [[UIButton alloc] initWithFrame:CGRectMake(275 * ProportionAdapter, 25 * ProportionAdapter, 90 * ProportionAdapter, 30 * ProportionAdapter)];
        self.contactBtn.layer.cornerRadius = 15 * ProportionAdapter;
        self.contactBtn.clipsToBounds = YES;
        self.contactBtn.backgroundColor = [UIColor orangeColor];
        self.contactBtn.titleLabel.font = [UIFont systemFontOfSize:13 * ProportionAdapter];
        [self.contactBtn setImage:[UIImage imageNamed:@"icn_serve_phone"] forState:(UIControlStateNormal)];
        [self.contentView addSubview:self.contactBtn];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(15 * ProportionAdapter, 79.5 * ProportionAdapter, screenWidth - 30 * ProportionAdapter, 0.5 * ProportionAdapter)];
        self.lineView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        
        [self.contentView addSubview:self.lineView];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
