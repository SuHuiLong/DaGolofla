//
//  JGDInviteTableViewCell.m
//  DagolfLa
//
//  Created by 東 on 16/10/21.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGDInviteTableViewCell.h"

@implementation JGDInviteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.teamNameLB = [[UILabel alloc] initWithFrame:CGRectMake(20 * ProportionAdapter, 0, 300 * ProportionAdapter, 45 * ProportionAdapter)];
        self.teamNameLB.font = [UIFont systemFontOfSize:15 * ProportionAdapter];
        self.teamNameLB.textColor = [UIColor colorWithHexString:@"#313131"];
        [self.contentView addSubview:self.teamNameLB];
        
        
        self.removeButton = [[UIButton alloc] initWithFrame:CGRectMake(340 * ProportionAdapter, 10 * ProportionAdapter, 30 *ProportionAdapter, 30 * ProportionAdapter)];
        [self.removeButton setImage:[UIImage imageNamed:@"deleteplay"] forState:(UIControlStateNormal)];
        [self.contentView addSubview:self.removeButton];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
