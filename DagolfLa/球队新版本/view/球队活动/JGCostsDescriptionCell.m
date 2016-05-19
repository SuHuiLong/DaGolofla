//
//  JGCostsDescriptionCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGCostsDescriptionCell.h"
#import "JGTeamAcitivtyModel.h"

@implementation JGCostsDescriptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configModel:(JGTeamAcitivtyModel *)model{
    //人均车费
    self.perCost.text = [NSString stringWithFormat:@"120元", nil];
//    @property (weak, nonatomic) IBOutlet UILabel *perCost;
    //场地费用
    self.arddessCost.text = [NSString stringWithFormat:@"450元", nil];
//    @property (weak, nonatomic) IBOutlet UILabel *arddessCost;
    //其他
    self.others.text = [NSString stringWithFormat:@"60元", nil];
//    @property (weak, nonatomic) IBOutlet UILabel *others;
    //合集人均总费用
    self.totalPerCost.text = [NSString stringWithFormat:@"1450元", nil];
//    @property (weak, nonatomic) IBOutlet UILabel *totalPerCost;
}

@end
