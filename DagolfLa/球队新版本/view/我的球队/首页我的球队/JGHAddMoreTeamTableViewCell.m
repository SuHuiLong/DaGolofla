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
    
    self.allBtn = [[UIButton alloc]initWithFrame:CGRectMake(40 *ProportionAdapter, 0, screenWidth -80 *ProportionAdapter, self.frame.size.height)];
    [self bringSubviewToFront:self.allBtn];
    [self.allBtn addTarget:self action:@selector(addTeamBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.allBtn];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addTeamBtn:(UIButton *)allBtn{
    if ([self.delegate respondsToSelector:@selector(didSelectAddMoreBtn:)]) {
        [self.delegate didSelectAddMoreBtn:allBtn];
    }
}


@end
