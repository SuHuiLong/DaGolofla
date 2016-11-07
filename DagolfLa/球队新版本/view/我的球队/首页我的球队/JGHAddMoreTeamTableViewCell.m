//
//  JGHAddMoreTeamTableViewCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/10/27.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGHAddMoreTeamTableViewCell.h"

@implementation JGHAddMoreTeamTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.addTeamBtn.titleLabel.font = [UIFont systemFontOfSize:16 *ProportionAdapter];
    
    UILabel *addLB = [[UILabel alloc] initWithFrame:CGRectMake(- 32 * ProportionAdapter, self.addTeamBtn.frame.origin.y - 2 * ProportionAdapter, 30 * ProportionAdapter, 20 * ProportionAdapter)];
        addLB.text = @"+";
    addLB.textColor = [UIColor orangeColor];
    addLB.textAlignment = NSTextAlignmentRight;
    addLB.font = [UIFont systemFontOfSize:28 * ProportionAdapter];
    [self.addTeamBtn addSubview:addLB];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addTeamBtn:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(didSelectAddMoreBtn:)]) {
        [self.delegate didSelectAddMoreBtn:sender];
    }
    
}
@end
