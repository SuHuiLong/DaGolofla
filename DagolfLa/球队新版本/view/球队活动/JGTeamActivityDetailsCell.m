//
//  JGTeamActivityDetailsCell.m
//  DagolfLa
//
//  Created by 黄安 on 16/5/11.
//  Copyright © 2016年 bhxx. All rights reserved.
//

#import "JGTeamActivityDetailsCell.h"

@implementation JGTeamActivityDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configDetailsText:(NSString *)details AndActivityDetailsText:(NSString *)activityDetails{
    self.details.text = details;
    self.activityDetails.text = activityDetails;
}

- (void)configDetailsText:(NSString *)details andActivityDetailsText:(NSString *)activityDetails andName:(NSString *)name andNumber:(NSString *)number{
    self.details.text = details;
    self.activityDetails.text = activityDetails;
    self.name.text = name;
    self.number.text = number;
}

@end
