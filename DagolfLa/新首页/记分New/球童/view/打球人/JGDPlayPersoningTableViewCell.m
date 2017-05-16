//
//  JGDPlayPersoningTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/8/9.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDPlayPersoningTableViewCell.h"

@interface JGDPlayPersoningTableViewCell ()


@end


@implementation JGDPlayPersoningTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * ProportionAdapter, 0, 300 * ProportionAdapter, 50 * ProportionAdapter)];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#313131"];
        self.titleLabel.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        [self.contentView addSubview:self.titleLabel];
        
        self.checkBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.checkBtn.frame = CGRectMake(300 * ProportionAdapter, 10 * ProportionAdapter, 70 * ProportionAdapter, 30 * ProportionAdapter);
        self.checkBtn.layer.borderWidth = 1.0 * ProportionAdapter;
        self.checkBtn.layer.masksToBounds = YES;
        self.checkBtn.layer.cornerRadius = 5 * ProportionAdapter;
        self.checkBtn.layer.borderColor = [UIColor colorWithHexString:@"#32b14d"].CGColor;
        [self.checkBtn setTitle:@"查看记分" forState:(UIControlStateNormal)];
        [self.checkBtn setTitleColor:[UIColor colorWithHexString:@"#32b14d"] forState:(UIControlStateNormal)];
        self.checkBtn.titleLabel.font = [UIFont systemFontOfSize:12 * ProportionAdapter];
        [self.contentView addSubview:self.checkBtn];
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
